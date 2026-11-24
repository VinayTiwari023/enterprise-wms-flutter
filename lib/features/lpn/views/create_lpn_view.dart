import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../authentication/viewmodels/user_view_model.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../models/lpn_item_model.dart';
import '../viewmodels/lpn_view_model.dart';
import '../widgets/lpn_widgets.dart';
import '../../../shared/widgets/searchable_dropdown.dart';

class CreateLpnView extends ConsumerStatefulWidget {
  const CreateLpnView({super.key});

  @override
  ConsumerState<CreateLpnView> createState() => _CreateLpnViewState();
}

class _CreateLpnViewState extends ConsumerState<CreateLpnView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _lpnCodeController;
  late TextEditingController _locationController;
  late TextEditingController _maxWeightController;

  String _selectedContainerType = "Standard Wooden Pallet";
  final List<String> _containerTypes = [
    "Standard Wooden Pallet",
    "Heavy Wire Tote Container",
    "Gaylord Box",
    "Wooden Crate",
    "Plastic Tote Bin",
  ];

  final List<LpnItemModel> _initialItems = [];

  @override
  void initState() {
    super.initState();
    _lpnCodeController = TextEditingController(text: _generateLpnNumber());
    _locationController = TextEditingController(text: "STAGING-BAY-01");
    _maxWeightController = TextEditingController(text: "1000");
  }

  @override
  void dispose() {
    _lpnCodeController.dispose();
    _locationController.dispose();
    _maxWeightController.dispose();
    super.dispose();
  }

  String _generateLpnNumber() {
    final random = Random();
    final num = random.nextInt(900000) + 100000;
    return "LPN-MH-$num";
  }

  void _addItem() {
    final skuController = TextEditingController();
    final nameController = TextEditingController();
    final qtyController = TextEditingController(text: "50");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Initial Item SKU"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: skuController,
              decoration: const InputDecoration(
                labelText: "SKU Code (e.g. SKU-1003)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Item Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Quantity",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (skuController.text.isNotEmpty &&
                  nameController.text.isNotEmpty) {
                setState(() {
                  _initialItems.add(
                    LpnItemModel(
                      sku: skuController.text.trim().toUpperCase(),
                      itemName: nameController.text.trim(),
                      quantity: int.tryParse(qtyController.text) ?? 10,
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text("Add Item"),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final userName = ref.read(userViewModelProvider).user?.name ?? "Operator";

      ref
          .read(lpnViewModelProvider.notifier)
          .createLpn(
            lpnNumber: _lpnCodeController.text.trim().toUpperCase(),
            location: _locationController.text.trim().toUpperCase(),
            containerType: _selectedContainerType,
            maxWeightKg: double.tryParse(_maxWeightController.text) ?? 1000.0,
            createdBy: userName,
            initialItems: _initialItems,
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Pallet Container ${_lpnCodeController.text} Created Successfully!",
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Build New Pallet (LPN)"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LPN Barcode Field with regenerate button
              TextFormField(
                controller: _lpnCodeController,
                decoration: InputDecoration(
                  labelText: "License Plate Number (LPN Code)",
                  prefixIcon: const Icon(Icons.qr_code_rounded),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.autorenew_rounded),
                    tooltip: "Generate New Code",
                    onPressed: () {
                      setState(() {
                        _lpnCodeController.text = _generateLpnNumber();
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Please enter LPN barcode";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Container Type Searchable Dropdown
              SearchableDropdown<String>(
                value: _selectedContainerType,
                labelText: "Container / Pallet Type",
                hintText: "Select or search container type...",
                modalTitle: "Select Container Type",
                prefixIcon: const Icon(Icons.widgets_rounded),
                items: _containerTypes,
                itemLabel: (type) => type,
                itemIcon: (type) =>
                    const Icon(Icons.inventory_2_outlined, size: 20),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedContainerType = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Initial Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Initial Bin Location / Zone",
                  prefixIcon: Icon(Icons.location_on_rounded),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Please enter location";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Max Weight Capacity
              TextFormField(
                controller: _maxWeightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Max Weight Capacity (kg)",
                  prefixIcon: Icon(Icons.fitness_center_rounded),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || double.tryParse(val) == null) {
                    return "Please enter a valid weight capacity";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Initial Items Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Initial Loaded SKUs",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: _addItem,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text("Add SKU"),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (_initialItems.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Center(
                    child: Text(
                      "No initial SKUs added. (You can load SKUs later).",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                Column(
                  children: _initialItems.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    return LpnItemTile(
                      item: item,
                      onDelete: () {
                        setState(() {
                          _initialItems.removeAt(idx);
                        });
                      },
                    );
                  }).toList(),
                ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitForm,
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text(
                    "Build & Save Pallet (LPN)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
