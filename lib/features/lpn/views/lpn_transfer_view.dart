import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../authentication/viewmodels/user_view_model.dart';
import '../../barcode/views/gs1_scanner_modal.dart';
import '../../settings/viewmodels/theme_view_model.dart';
import '../models/lpn_model.dart';
import '../viewmodels/lpn_view_model.dart';

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
    final lpns = ref.read(lpnViewModelProvider).lpns;
    try {
      final found = lpns.firstWhere(
        (l) => l.lpnNumber.toLowerCase() == lpnNumber.trim().toLowerCase(),
      );
      setState(() {
        _selectedLpn = found;
      });
    } catch (_) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a valid LPN Pallet first")),
      );
      return;
    }

    final targetBin = _targetBinController.text.trim().toUpperCase();
    if (targetBin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter or scan target Bin Location"),
        ),
      );
      return;
    }

    if (targetBin == _selectedLpn!.location) {
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
        controller.text = parsedModel.sku.isNotEmpty
            ? parsedModel.sku
            : parsedModel.rawBarcode;
        if (controller == _lpnController) {
          _lookupLpn(controller.text);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeVM = ref.watch(themeViewModelProvider);
    final primaryColor = themeVM.currentThemeColor;
    final allLpns = ref.watch(lpnViewModelProvider.select((s) => s.lpns));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pallet / LPN Transfer"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STEP 1: Select or Scan LPN
            const Text(
              "Step 1: Scan or Select LPN Pallet",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lpnController,
                    decoration: InputDecoration(
                      hintText: "Scan LPN Barcode (e.g. LPN-MH-884920)",
                      prefixIcon: const Icon(Icons.qr_code_scanner_rounded),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward_rounded),
                        onPressed: () => _lookupLpn(_lpnController.text),
                      ),
                    ),
                    onSubmitted: (val) => _lookupLpn(val),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  icon: const Icon(Icons.camera_alt_rounded),
                  onPressed: () => _openBarcodeScanner(_lpnController),
                  tooltip: "Camera Scan",
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Quick Select Dropdown for testing ease
            DropdownButtonFormField<String>(
              hint: const Text("Or select from active pallets list"),
              items: allLpns.map((lpn) {
                return DropdownMenuItem(
                  value: lpn.lpnNumber,
                  child: Text(
                    "${lpn.lpnNumber} (${lpn.location}) - ${lpn.containerType}",
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  _lpnController.text = val;
                  _lookupLpn(val);
                }
              },
            ),
            const SizedBox(height: 24),

            // STEP 2: Selected LPN Summary Box
            if (_selectedLpn != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.08),
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
                        Text(
                          _selectedLpn!.lpnNumber,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Chip(
                          label: Text(_selectedLpn!.status),
                          backgroundColor: Colors.blue.withValues(alpha: 0.15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Current Location: ${_selectedLpn!.location}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    Text(
                      "Container Type: ${_selectedLpn!.containerType}",
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Contains: ${_selectedLpn!.totalItemCount} units across ${_selectedLpn!.uniqueSkuCount} SKUs",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // STEP 3: Scan / Select Target Bin
            const Text(
              "Step 2: Enter / Scan Destination Bin Location",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _targetBinController,
                    decoration: const InputDecoration(
                      hintText: "Destination Bin (e.g. BIN-B02-R04)",
                      prefixIcon: Icon(Icons.location_on_rounded),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  icon: const Icon(Icons.camera_alt_rounded),
                  onPressed: () => _openBarcodeScanner(_targetBinController),
                  tooltip: "Scan Bin Barcode",
                ),
              ],
            ),

            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: const Text("BIN-A02-R01"),
                  onPressed: () => _targetBinController.text = "BIN-A02-R01",
                ),
                ActionChip(
                  label: const Text("BIN-B03-R05"),
                  onPressed: () => _targetBinController.text = "BIN-B03-R05",
                ),
                ActionChip(
                  label: const Text("STAGING-BAY-02"),
                  onPressed: () => _targetBinController.text = "STAGING-BAY-02",
                ),
                ActionChip(
                  label: const Text("QUARANTINE-ZONE-A"),
                  onPressed: () =>
                      _targetBinController.text = "QUARANTINE-ZONE-A",
                ),
              ],
            ),
            const SizedBox(height: 36),

            // Confirm Move Button
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
                onPressed: _executeMove,
                icon: const Icon(Icons.swap_horiz_rounded, size: 24),
                label: const Text(
                  "Confirm LPN Relocation",
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
