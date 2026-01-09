import 'package:flutter/foundation.dart';

class DetectionNotifier extends ChangeNotifier {
  bool _isRecording = false;
  int _screenshotCount = 0;
  DateTime? _lastScreenshotTime;

  bool get isRecording => _isRecording;
  int get screenshotCount => _screenshotCount;
  DateTime? get lastScreenshotTime => _lastScreenshotTime;

  void onScreenshotDetected() {
    _screenshotCount++;
    _lastScreenshotTime = DateTime.now();
    notifyListeners();
  }

  void onRecordingStarted() {
    _isRecording = true;
    notifyListeners();
  }

  void onRecordingStopped() {
    _isRecording = false;
    notifyListeners();
  }

  void resetScreenshotCount() {
    _screenshotCount = 0;
    notifyListeners();
  }
}