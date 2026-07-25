import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../viewmodels/inbound_view_model.dart';

class DamageReportView extends ConsumerStatefulWidget {
  final String poNumber;
  final String sku;
  final String itemName;

  const DamageReportView({
    super.key,
    required this.poNumber,
    required this.sku,
    required this.itemName,
  });

  @override
  ConsumerState<DamageReportView> createState() => _DamageReportViewState();
}

class _DamageReportViewState extends ConsumerState<DamageReportView> {
  final _qtyController = TextEditingController();
  String _selectedType = "Crushed";
  final List<String> _damageTypes = ["Crushed", "Wet", "Torn", "Expired", "Other"];

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Damage"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.itemName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("SKU: ${widget.sku}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text("Damaged Quantity", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter number of damaged units",
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Damage Type", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _damageTypes.map((type) {
                bool isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (val) => setState(() => _selectedType = type),
                  selectedColor: primaryColor.withValues(alpha: 0.2),
                  labelStyle: TextStyle(color: isSelected ? primaryColor : Colors.grey),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text("Add Photo (Optional)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.3), style: BorderStyle.solid),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text("Tap to capture evidence", style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  final qty = int.tryParse(_qtyController.text) ?? 0;
                  if (qty > 0) {
                    ref.read(inboundViewModelProvider.notifier).updateItemQuantity(
                      widget.poNumber,
                      widget.sku,
                      damaged: qty,
                      reason: _selectedType,
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Submit Damage Report", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
