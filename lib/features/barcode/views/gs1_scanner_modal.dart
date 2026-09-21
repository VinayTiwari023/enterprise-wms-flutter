import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/gs1_barcode_model.dart';
import '../../settings/viewmodels/theme_view_model.dart';

class GS1ScannerModal extends ConsumerStatefulWidget {
  final ValueChanged<GS1BarcodeModel>? onBarcodeParsed;

  const GS1ScannerModal({super.key, this.onBarcodeParsed});

  static void show(
    BuildContext context, {
    ValueChanged<GS1BarcodeModel>? onBarcodeParsed,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GS1ScannerModal(onBarcodeParsed: onBarcodeParsed),
    );
  }

  @override
  ConsumerState<GS1ScannerModal> createState() => _GS1ScannerModalState();
}

class _GS1ScannerModalState extends ConsumerState<GS1ScannerModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  GS1BarcodeModel? _parsedResult;

  static const List<String> _sampleGS1Barcodes = [
    "(01)89010001000(10)LOT-MH2025(17)261231(30)50",
    "(01)89010001001(10)LOT-DL8821(17)251130(30)24",
    "(01)89010001002(10)LOT-KA5512(17)270630(30)100",
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Auto-parse first sample
    _parsedResult = GS1BarcodeModel.parse(_sampleGS1Barcodes[0]);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;
    final isDark = themeVM.isDarkMode;
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      color: primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "GS1-128 Barcode Scanner",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Animated Laser Scanner Viewfinder
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? Colors.black : Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.barcode_reader,
                          color: Colors.white.withValues(alpha: 0.3),
                          size: 48,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Position GS1-128 Barcode in Viewfinder",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Animated Red Laser Line
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      return Positioned(
                        top: 20 + (_animController.value * 100),
                        left: 20,
                        right: 20,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withValues(alpha: 0.8),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              "Sample Barcode Simulation:",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),

            // Sample Selector Chips
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _sampleGS1Barcodes.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final code = _sampleGS1Barcodes[index];
                  final isSelected = _parsedResult?.rawBarcode == code;
                  return ChoiceChip(
                    label: Text("Barcode #${index + 1}"),
                    selected: isSelected,
                    selectedColor: primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _parsedResult = GS1BarcodeModel.parse(code);
                        });
                      }
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Parsed GS1 AI Data Card
            if (_parsedResult != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          color: primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Parsed GS1 AI Data Extracted",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    _buildDataRow(
                      "(01) GTIN / SKU",
                      _parsedResult!.sku,
                      primaryColor,
                    ),
                    _buildDataRow(
                      "(10) Lot / Batch Number",
                      _parsedResult!.lotNumber,
                      Colors.orange,
                    ),
                    _buildDataRow(
                      "(17) Expiry Date",
                      dateFormat.format(_parsedResult!.expiryDate!),
                      Colors.blue,
                    ),
                    _buildDataRow(
                      "(30) Pack Quantity",
                      "${_parsedResult!.quantity} Units",
                      Colors.green,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    widget.onBarcodeParsed?.call(_parsedResult!);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Applied GS1 Data: ${_parsedResult!.sku} (Lot: ${_parsedResult!.lotNumber})",
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Apply Parsed GS1 Barcode",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
