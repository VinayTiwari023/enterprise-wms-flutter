import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/viewmodels/theme_view_model.dart';
import '../viewmodels/returns_view_model.dart';
import '../models/return_item_model.dart';

class CreateRMAView extends ConsumerStatefulWidget {
  const CreateRMAView({super.key});

  @override
  ConsumerState<CreateRMAView> createState() => _CreateRMAViewState();
}

class _CreateRMAViewState extends ConsumerState<CreateRMAView> {
  final _formKey = GlobalKey<FormState>();
  final _orderController = TextEditingController();
  final _customerController = TextEditingController();
  String _selectedReason = "Defective Item";

  final List<String> _reasons = [
    "Defective Item",
    "Wrong Item Shipped",
    "Customer Changed Mind",
    "Carrier Damage",
    "Expired Stock",
  ];

  final List<ReturnItemModel> _itemsToReturn = [
    const ReturnItemModel(
      sku: "SKU-9011",
      name: "Industrial Barcode Scanner",
      quantity: 1,
      unitPrice: 299.99,
    ),
  ];

  @override
  void dispose() {
    _orderController.dispose();
    _customerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    return Scaffold(
      appBar: AppBar(title: const Text("Create RMA Return"), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _orderController,
              decoration: const InputDecoration(
                labelText: "Original Sales Order #",
                hintText: "e.g. ORD-1008",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.receipt_long_rounded),
              ),
              validator: (val) =>
                  val == null || val.isEmpty ? "Please enter Order #" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _customerController,
              decoration: const InputDecoration(
                labelText: "Customer Name",
                hintText: "e.g. Acme Corporation",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (val) => val == null || val.isEmpty
                  ? "Please enter Customer Name"
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedReason,
              decoration: const InputDecoration(
                labelText: "Primary Return Reason",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.help_outline_rounded),
              ),
              items: _reasons.map((r) {
                return DropdownMenuItem(value: r, child: Text(r));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedReason = val);
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Return Line Items",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _itemsToReturn.add(
                        ReturnItemModel(
                          sku: "SKU-90${15 + _itemsToReturn.length}",
                          name:
                              "Returned Warehouse Item ${_itemsToReturn.length + 1}",
                          quantity: 1,
                          unitPrice: 50.0,
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Item"),
                ),
              ],
            ),
            const Divider(),
            ..._itemsToReturn.asMap().entries.map((entry) {
              int idx = entry.key;
              ReturnItemModel item = entry.value;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "SKU: ${item.sku} • \$${item.unitPrice}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        if (_itemsToReturn.length > 1) {
                          setState(() => _itemsToReturn.removeAt(idx));
                        }
                      },
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 30),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ref
                        .read(returnsViewModelProvider.notifier)
                        .createRMA(
                          originalOrderNumber: _orderController.text,
                          customerName: _customerController.text,
                          returnReason: _selectedReason,
                          items: _itemsToReturn,
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("RMA Return Created Successfully!"),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Submit & Generate RMA Request",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
