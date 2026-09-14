import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/inventory_view_model.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../../../shared/widgets/barcode_scanner_view.dart';

class AddItemView extends ConsumerStatefulWidget {
  const AddItemView({super.key});

  @override
  ConsumerState<AddItemView> createState() => _AddItemViewState();
}

class _AddItemViewState extends ConsumerState<AddItemView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _locationController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _locationController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(inventoryViewModelProvider.notifier)
          .addOrUpdateStock(
            _skuController.text.trim(),
            _nameController.text.trim(),
            _locationController.text.trim(),
            int.parse(_quantityController.text.trim()),
          );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Item added successfully")));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Item"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _nameController,
                label: "Item Name",
                icon: Icons.inventory_2_outlined,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter item name" : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _skuController,
                label: "SKU / Barcode",
                icon: Icons.qr_code_scanner_rounded,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: () async {
                    final String? scannedCode = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const BarcodeScannerView(title: "Scan Item SKU"),
                      ),
                    );
                    if (scannedCode != null) {
                      setState(() {
                        _skuController.text = scannedCode;
                      });
                    }
                  },
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter SKU" : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _locationController,
                label: "Storage Location (Bin)",
                icon: Icons.location_on_outlined,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter location" : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _quantityController,
                label: "Initial Quantity",
                icon: Icons.add_chart_rounded,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter quantity";
                  }
                  if (int.tryParse(value) == null) {
                    return "Enter a valid number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Item",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
