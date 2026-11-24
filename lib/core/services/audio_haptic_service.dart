import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Audio and Haptic Feedback Service for Barcode Scanning and Warehouse Actions.
class AudioHapticService extends ChangeNotifier {
  bool _isAudioEnabled = true;
  bool _isHapticEnabled = true;

  bool get isAudioEnabled => _isAudioEnabled;
  bool get isHapticEnabled => _isHapticEnabled;

  set isAudioEnabled(bool value) {
    _isAudioEnabled = value;
    notifyListeners();
  }

  set isHapticEnabled(bool value) {
    _isHapticEnabled = value;
    notifyListeners();
  }

  AudioHapticService();

  /// Play success feedback for valid scan or operation completion
  Future<void> playSuccessFeedback() async {
    if (_isHapticEnabled) {
      await HapticFeedback.lightImpact();
    }
    if (_isAudioEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  /// Play error feedback for invalid barcode, wrong SKU, or failed action
  Future<void> playErrorFeedback() async {
    if (_isHapticEnabled) {
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 120));
      await HapticFeedback.heavyImpact();
    }
    if (_isAudioEnabled) {
      await SystemSound.play(SystemSoundType.alert);
    }
  }

  /// Play warning feedback for scan duplicate, partial count, or alert
  Future<void> playWarningFeedback() async {
    if (_isHapticEnabled) {
      await HapticFeedback.mediumImpact();
    }
    if (_isAudioEnabled) {
      await SystemSound.play(SystemSoundType.alert);
    }
  }
}

final audioHapticServiceProvider = ChangeNotifierProvider<AudioHapticService>((
  ref,
) {
  return AudioHapticService();
});
