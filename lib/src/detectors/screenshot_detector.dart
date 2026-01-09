import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_detector_and_restriction/src/detectors/native_channel.dart';
import 'package:flutter_screen_detector_and_restriction/src/utils/detection_notifier.dart';

class ScreenshotDetector {
  static final ScreenshotDetector _instance = ScreenshotDetector._internal();
  factory ScreenshotDetector() => _instance;
  ScreenshotDetector._internal();

  final DetectionNotifier _notifier = DetectionNotifier();
  StreamSubscription? _subscription;
  bool _isInitialized = false;

  DetectionNotifier get notifier => _notifier;

  Future<void> initialize() async {
    if (_isInitialized) return;

    if (Platform.isAndroid || Platform.isIOS) {
      await NativeChannel.initializeDetection();
      _setupListeners();
    } else {
      // For web/desktop - use simulated detection
      _setupSimulatedListeners();
    }

    _isInitialized = true;
  }

  void _setupListeners() {
    if (Platform.isAndroid || Platform.isIOS) {
      const channel = EventChannel('com.example.detector/screenshot');
      _subscription = channel.receiveBroadcastStream().listen((event) {
        if (event == 'screenshot_taken') {
          _notifier.onScreenshotDetected();
        }
      }, onError: (error) {
        debugPrint('Screenshot detection error: $error');
      });
    }
  }

  void _setupSimulatedListeners() {
    // For platforms without native support
    debugPrint('Screenshot detection running in simulated mode');
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _isInitialized = false;
  }

  Future<void> preventScreenshots(bool prevent) async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (prevent) {
        await NativeChannel.disableScreenshot();
      } else {
        await NativeChannel.enableScreenshot();
      }
    }
  }
}