import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_detector_and_restriction/src/utils/detection_notifier.dart';

class RecordingDetector {
  static final RecordingDetector _instance = RecordingDetector._internal();
  factory RecordingDetector() => _instance;
  RecordingDetector._internal();

  final DetectionNotifier _notifier = DetectionNotifier();
  StreamSubscription? _subscription;
  bool _isInitialized = false;

  DetectionNotifier get notifier => _notifier;

  Future<void> initialize() async {
    if (_isInitialized) return;

    if (Platform.isAndroid || Platform.isIOS) {
      _setupNativeListeners();
    } else {
      _setupSimulatedListeners();
    }

    _isInitialized = true;
  }

  void _setupNativeListeners() {
    if (Platform.isAndroid) {
      const channel = EventChannel('com.example.detector/recording');
      _subscription = channel.receiveBroadcastStream().listen((event) {
        if (event == 'recording_started') {
          _notifier.onRecordingStarted();
        } else if (event == 'recording_stopped') {
          _notifier.onRecordingStopped();
        }
      }, onError: (error) {
        debugPrint('Recording detection error: $error');
      });
    } else if (Platform.isIOS) {
      // iOS uses different approach
      _setupIOSListeners();
    }
  }

  void _setupIOSListeners() {
    // iOS screen recording detection
    const channel = EventChannel('com.example.detector/ios_recording');
    _subscription = channel.receiveBroadcastStream().listen((event) {
      final isRecording = event == 'true';
      if (isRecording) {
        _notifier.onRecordingStarted();
      } else {
        _notifier.onRecordingStopped();
      }
    });
  }

  void _setupSimulatedListeners() {
    debugPrint('Recording detection running in simulated mode');
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _isInitialized = false;
  }

  bool get isRecording => _notifier.isRecording;
}