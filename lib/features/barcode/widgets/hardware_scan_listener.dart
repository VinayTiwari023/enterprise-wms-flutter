import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/audio_haptic_service.dart';
import '../../../core/services/hardware_scanner_service.dart';

/// Global Wrapper Widget that listens for Hardware Barcode Scans
/// and triggers audio/haptic feedback & floating notifications.
class HardwareScanListener extends ConsumerStatefulWidget {
  final Widget child;
  final Function(BarcodeScanResult)? onScan;

  const HardwareScanListener({super.key, required this.child, this.onScan});

  @override
  ConsumerState<HardwareScanListener> createState() =>
      _HardwareScanListenerState();
}

class _HardwareScanListenerState extends ConsumerState<HardwareScanListener> {
  StreamSubscription<BarcodeScanResult>? _subscription;

  @override
  void initState() {
    super.initState();
    final scannerService = ref.read(hardwareScannerServiceProvider);
    _subscription = scannerService.scanStream.listen(_handleScan);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleScan(BarcodeScanResult scan) {
    if (!mounted) return;

    // Trigger audio & haptic feedback
    ref.read(audioHapticServiceProvider).playSuccessFeedback();

    // Update state provider
    ref.read(lastBarcodeScanProvider.notifier).state = scan;

    // Invoke optional callback
    if (widget.onScan != null) {
      widget.onScan!(scan);
    }

    // Display Toast / Banner
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.black,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        scan.barcode,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          scan.source,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Symbology: ${scan.symbology}",
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E1E28),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.greenAccent, width: 1.5),
        ),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
