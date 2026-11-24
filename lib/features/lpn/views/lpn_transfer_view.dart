import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/audio_haptic_service.dart';
import '../../authentication/viewmodels/user_view_model.dart';
import '../../barcode/views/gs1_scanner_modal.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../models/lpn_model.dart';
import '../viewmodels/lpn_view_model.dart';
import '../../../shared/widgets/searchable_dropdown.dart';

class LpnTransferView extends ConsumerStatefulWidget {
  final String? initialLpnNumber;

  const LpnTransferView({super.key, this.initialLpnNumber});

  @override
  ConsumerState<LpnTransferView> createState() => _LpnTransferViewState();
}

class _LpnTransferViewState extends ConsumerState<LpnTransferView> {
  final _lpnController = TextEditingController();
  final _targetBinController = TextEditingController();
  LpnModel? _selectedLpn;

  @override
  void initState() {
    super.initState();
    if (widget.initialLpnNumber != null &&
        widget.initialLpnNumber!.isNotEmpty) {
      _lpnController.text = widget.initialLpnNumber!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _lookupLpn(widget.initialLpnNumber!);
      });
    }
  }

  @override
  void dispose() {
    _lpnController.dispose();
    _targetBinController.dispose();
    super.dispose();
  }

  void _lookupLpn(String lpnNumber) {
    if (lpnNumber.trim().isEmpty) return;
    final lpns = ref.read(lpnViewModelProvider).lpns;
    try {
      final found = lpns.firstWhere(
        (l) => l.lpnNumber.toLowerCase() == lpnNumber.trim().toLowerCase(),
      );
      ref.read(audioHapticServiceProvider).playSuccessFeedback();
      setState(() {
        _selectedLpn = found;
      });
    } catch (_) {
      ref.read(audioHapticServiceProvider).playErrorFeedback();
      setState(() {
        _selectedLpn = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Pallet LPN '$lpnNumber' not found"),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _executeMove() {
    if (_selectedLpn == null) {
      ref.read(audioHapticServiceProvider).playErrorFeedback();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a valid LPN Pallet first")),
      );
      return;
    }

    final targetBin = _targetBinController.text.trim().toUpperCase();
    if (targetBin.isEmpty) {
      ref.read(audioHapticServiceProvider).playErrorFeedback();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter or scan target Bin Location"),
        ),
      );
      return;
    }

    if (targetBin == _selectedLpn!.location) {
      ref.read(audioHapticServiceProvider).playWarningFeedback();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Target Bin is identical to current location"),
        ),
      );
      return;
    }

    final operatorName =
        ref.read(userViewModelProvider).user?.name ?? "Operator";

    final success = ref
        .read(lpnViewModelProvider.notifier)
        .moveLpn(
          lpnNumber: _selectedLpn!.lpnNumber,
          toLocation: targetBin,
          operatorName: operatorName,
        );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Pallet ${_selectedLpn!.lpnNumber} successfully moved to $targetBin!",
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _openBarcodeScanner(TextEditingController controller) {
    GS1ScannerModal.show(
      context,
      onBarcodeParsed: (parsedModel) {
        final code = parsedModel.sku.isNotEmpty
            ? parsedModel.sku
            : parsedModel.rawBarcode;
        controller.text = code;
        if (controller == _lpnController) {
          _lookupLpn(code);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;
    final isDark = themeVM.isDarkMode;
    final allLpns = ref.watch(lpnViewModelProvider.select((s) => s.lpns));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pallet / LPN Transfer"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STEP 1 CARD
            _buildStepHeader(
              stepNumber: "1",
              title: "Scan or Select LPN Pallet",
              primaryColor: primaryColor,
              isDark: isDark,
            ),
            const SizedBox(height: 12),

            // Barcode Input Field with integrated camera scanner icon
            TextField(
              controller: _lpnController,
              decoration: InputDecoration(
                labelText: "LPN Barcode / Code",
                hintText: "Scan LPN Barcode (e.g. LPN-MH-884920)",
                prefixIcon: const Icon(Icons.qr_code_scanner_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera_alt_rounded, color: primaryColor),
                      onPressed: () => _openBarcodeScanner(_lpnController),
                      tooltip: "Camera Scan",
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_rounded),
                      onPressed: () => _lookupLpn(_lpnController.text),
                      tooltip: "Lookup Pallet",
                    ),
                  ],
                ),
              ),
              onSubmitted: (val) => _lookupLpn(val),
            ),
            const SizedBox(height: 12),

            // Quick Select Searchable Dropdown for active pallets
            SearchableDropdown<LpnModel>(
              items: allLpns,
              labelText: "Active Pallets",
              hintText: "Or search & select active pallet...",
              modalTitle: "Select Active LPN Container",
              prefixIcon: const Icon(Icons.inventory_2_rounded),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              itemLabel: (lpn) => lpn.lpnNumber,
              itemSubtitle: (lpn) =>
                  "Bin: ${lpn.location} • Type: ${lpn.containerType} • Status: ${lpn.status}",
              itemIcon: (lpn) => Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.inventory_2_rounded,
                  size: 18,
                  color: primaryColor,
                ),
              ),
              onChanged: (lpn) {
                if (lpn != null) {
                  _lpnController.text = lpn.lpnNumber;
                  _lookupLpn(lpn.lpnNumber);
                }
              },
            ),
            const SizedBox(height: 20),

            // STEP 2: Selected LPN Summary Box (if selected)
            if (_selectedLpn != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: isDark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.widgets_rounded,
                              color: primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedLpn!.lpnNumber,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _selectedLpn!.status,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Current Bin: ${_selectedLpn!.location}",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.category_rounded,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _selectedLpn!.containerType,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Contains ${_selectedLpn!.totalItemCount} units across ${_selectedLpn!.uniqueSkuCount} SKUs",
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // STEP 2 CARD: Target Bin Location
            _buildStepHeader(
              stepNumber: "2",
              title: "Enter / Scan Destination Bin Location",
              primaryColor: primaryColor,
              isDark: isDark,
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _targetBinController,
              decoration: InputDecoration(
                labelText: "Destination Bin",
                hintText: "Destination Bin (e.g. BIN-B02-R04)",
                prefixIcon: const Icon(Icons.location_on_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.camera_alt_rounded, color: primaryColor),
                  onPressed: () => _openBarcodeScanner(_targetBinController),
                  tooltip: "Scan Bin Barcode",
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Suggested Quick Bins
            const Text(
              "Suggested Destination Bins:",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildBinChip("BIN-A02-R01", primaryColor, isDark),
                _buildBinChip("BIN-B03-R05", primaryColor, isDark),
                _buildBinChip("STAGING-BAY-02", primaryColor, isDark),
                _buildBinChip("QUARANTINE-ZONE-A", primaryColor, isDark),
              ],
            ),
            const SizedBox(height: 32),

            // Confirm Move Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _executeMove,
                icon: const Icon(Icons.swap_horiz_rounded, size: 24),
                label: const Text(
                  "Confirm LPN Relocation",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader({
    required String stepNumber,
    required String title,
    required Color primaryColor,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBinChip(String binCode, Color primaryColor, bool isDark) {
    return ActionChip(
      avatar: Icon(Icons.location_on_outlined, size: 16, color: primaryColor),
      label: Text(
        binCode,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      backgroundColor: isDark
          ? const Color(0xFF2A2A3D)
          : primaryColor.withValues(alpha: 0.06),
      side: BorderSide(color: primaryColor.withValues(alpha: 0.25)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onPressed: () {
        _targetBinController.text = binCode;
      },
    );
  }
}
