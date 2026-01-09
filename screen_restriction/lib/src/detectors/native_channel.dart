import 'package:flutter/services.dart';

class NativeChannel {
  static const platform = MethodChannel('com.example.detector/native');

  static Future<bool> initializeDetection() async {
    try {
      final bool result = await platform.invokeMethod('initializeDetection');
      return result;
    } on PlatformException catch (e) {
      print("Failed to initialize detection: ${e.message}");
      return false;
    }
  }

  static Future<void> disableScreenshot() async {
    try {
      await platform.invokeMethod('disableScreenshot');
    } on PlatformException catch (e) {
      print("Failed to disable screenshot: ${e.message}");
    }
  }

  static Future<void> enableScreenshot() async {
    try {
      await platform.invokeMethod('enableScreenshot');
    } on PlatformException catch (e) {
      print("Failed to enable screenshot: ${e.message}");
    }
  }
}