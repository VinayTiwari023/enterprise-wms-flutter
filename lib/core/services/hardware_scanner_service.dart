import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BarcodeScanResult {
  final String barcode;
  final String symbology;
  final String source;
  final DateTime timestamp;

  BarcodeScanResult({
    required this.barcode,
    this.symbology = 'UNKNOWN',
    this.source = 'Hardware Scanner',
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() =>
      'BarcodeScanResult(barcode: $barcode, symbology: $symbology, source: $source, timestamp: $timestamp)';
}

class HardwareScannerService {
  static const EventChannel _eventChannel = EventChannel(
    'com.wms.scanner/events',
  );
  static const MethodChannel _methodChannel = MethodChannel(
    'com.wms.scanner/methods',
  );

  final StreamController<BarcodeScanResult> _scanStreamController =
      StreamController<BarcodeScanResult>.broadcast();

  StreamSubscription? _eventSubscription;
  final StringBuffer _keyboardBuffer = StringBuffer();
  Timer? _keyboardResetTimer;

  Stream<BarcodeScanResult> get scanStream => _scanStreamController.stream;

  HardwareScannerService() {
    _initNativeScannerListener();
    _initKeyboardScannerListener();
  }

  /// Listen to Android Native EventChannel (DataWedge / Honeywell Intents)
  void _initNativeScannerListener() {
    try {
      _eventSubscription = _eventChannel.receiveBroadcastStream().listen(
        (dynamic event) {
          if (event is Map) {
            final barcode = event['barcode']?.toString() ?? '';
            final symbology = event['symbology']?.toString() ?? 'UNKNOWN';
            final source = event['source']?.toString() ?? 'Hardware Intent';

            if (barcode.isNotEmpty) {
              final result = BarcodeScanResult(
                barcode: barcode,
                symbology: symbology,
                source: source,
              );
              _scanStreamController.add(result);
            }
          }
        },
        onError: (dynamic error) {
          // Native scanner channel error or fallback
        },
      );
    } catch (e) {
      // Intent listening not supported on current platform
    }
  }

  /// Listen to KeyEvents for USB / Bluetooth HID Wedge Scanners
  void _initKeyboardScannerListener() {
    HardwareKeyboard.instance.addHandler((KeyEvent event) {
      if (event is KeyDownEvent) {
        final character = event.character;

        // If Enter key is pressed, dispatch the accumulated buffer as barcode scan
        if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.numpadEnter) {
          if (_keyboardBuffer.isNotEmpty) {
            final barcode = _keyboardBuffer.toString().trim();
            _keyboardBuffer.clear();

            if (barcode.length >= 3) {
              final result = BarcodeScanResult(
                barcode: barcode,
                symbology: 'HID Wedge',
                source: 'USB/BT Scanner',
              );
              _scanStreamController.add(result);
              return true;
            }
          }
        } else if (character != null && character.isNotEmpty) {
          _keyboardBuffer.write(character);

          // Reset buffer if delay between characters > 150ms (typing manually vs barcode scan)
          _keyboardResetTimer?.cancel();
          _keyboardResetTimer = Timer(const Duration(milliseconds: 150), () {
            _keyboardBuffer.clear();
          });
        }
      }
      return false;
    });
  }

  /// Send Command to Zebra DataWedge API
  Future<void> sendDataWedgeCommand(String command, String parameter) async {
    try {
      await _methodChannel.invokeMethod('sendDataWedgeCommand', {
        'command': command,
        'parameter': parameter,
      });
    } catch (e) {
      // Ignored if platform does not support DataWedge
    }
  }

  /// Soft trigger scanner laser via DataWedge
  Future<void> triggerSoftScan() async {
    try {
      await _methodChannel.invokeMethod('triggerSoftScan');
    } catch (e) {
      // Ignored
    }
  }

  /// Manually dispatch scan event for testing or camera scanner fallbacks
  void dispatchScan(String barcode, {String source = 'Camera/Manual'}) {
    if (barcode.isNotEmpty) {
      final result = BarcodeScanResult(
        barcode: barcode.trim(),
        symbology: 'GENERIC',
        source: source,
      );
      _scanStreamController.add(result);
    }
  }

  void dispose() {
    _eventSubscription?.cancel();
    _scanStreamController.close();
    _keyboardResetTimer?.cancel();
  }
}

final hardwareScannerServiceProvider = Provider<HardwareScannerService>((ref) {
  final service = HardwareScannerService();
  ref.onDispose(() => service.dispose());
  return service;
});

final lastBarcodeScanProvider = StateProvider<BarcodeScanResult?>((ref) {
  return null;
});
