# 📵 Screen Restriction
A Flutter plugin to **detect & restrict screenshots and screen recording** on both Android and iOS.  
Provides:
✔ Real-time detection  
✔ Automatic UI overlays  
✔ Screenshot blocking (FLAG_SECURE)  
✔ Simple API for developers  

---

## 🚀 Features
| Feature | Android | iOS |
|--------|:-------:|:---:|
| Screenshot detection | ✅ | ⚠ Requires setup |
| Screen recording detection | ✅ | ⚠ Requires setup |
| Screenshot blocking | ✔ FLAG_SECURE | ❌ Not supported |
| Detection overlay | ✔ | ✔ |
| Restriction Scaffold | ✔ | ✔ |

---

## 📦 Installation
### Add in **pubspec.yaml**:
```yaml
dependencies:
  screen_restriction:
    path: '.../flutter_screen_detector_and_restriction/screen_restriction'
```

### Using GitHub (Recommended during development) :
```yaml
dependencies:
  screen_restriction:
    git:
      url: https://github.com/<your-github>/flutter_screen_detector_and_restriction.git
```
### 🧩 Import
```dart
import 'package:screen_restriction/screen_restriction.dart';
```


---

## 🛡 Quick Usage (Default Restriction UI)
```dart
import 'package:flutter/material.dart';
import 'package:screen_restriction/screen_restriction.dart';

class SecurePage extends StatelessWidget {
  const SecurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RestrictionScaffold(
      appBar: AppBar(title: const Text('Secure Page')),
      onViolationDetected: () {
        debugPrint('⚠ Security violation detected');
      },
      body: const Center(
        child: Text('This content is protected'),
      ),
    );
  }
}
```

---

## 🎛 Overlay Usage
Want only detection + overlay?
```dart
DetectionOverlay(
  child: Scaffold(...),
  onScreenshotDetected: () => debugPrint('Screenshot!'),
  onRecordingStarted: () => debugPrint('Recording started!'),
  onRecordingStopped: () => debugPrint('Recording stopped!'),
);
```
---

## 🧠 Manual Control API
```dart
final screenshot = ScreenshotDetector();
await screenshot.initialize();
await screenshot.preventScreenshots(true); // disable screenshots
await screenshot.preventScreenshots(false); // enable screenshots
```

---

## 📌 Required Android Setup (IMPORTANT)
### 1️⃣ Edit `android/app/src/main/.../MainActivity.kt`
Replace or update:
```kotlin
package com.example.app

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val SCREENSHOT_CHANNEL = "com.screen.restriction/screenshot"
    private val RECORDING_CHANNEL = "com.screen.restriction/recording"
    private val NATIVE_CHANNEL = "com.screen.restriction/native"

    private var screenshotEventSink: EventChannel.EventSink? = null
    private var recordingEventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NATIVE_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "initializeDetection" -> result.success(true)
                    "disableScreenshot" -> {
                        window.setFlags(
                            WindowManager.LayoutParams.FLAG_SECURE,
                            WindowManager.LayoutParams.FLAG_SECURE
                        )
                        result.success(null)
                    }
                    "enableScreenshot" -> {
                        window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SCREENSHOT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    screenshotEventSink = events
                }
                override fun onCancel(arguments: Any?) {
                    screenshotEventSink = null
                }
            })

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, RECORDING_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    recordingEventSink = events
                }
                override fun onCancel(arguments: Any?) {
                    recordingEventSink = null
                }
            })
    }
}
```
⚠ COPY - PASTE AS IS

---

## 📁 Folder Structure
```text
screen_restriction/
 ├── lib/
 │   ├── src/
 │   │   ├── detectors/
 │   │   ├── utils/
 │   │   └── widgets/
 │   └── screen_restriction.dart  <-- exports everything

```
 
---

## 📜 License
```text
Copyright (c) 2026 Excelsior Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED **"AS IS"**, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```
