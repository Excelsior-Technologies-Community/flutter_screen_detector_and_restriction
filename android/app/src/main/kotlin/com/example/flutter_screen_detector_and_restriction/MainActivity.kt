package com.example.flutter_screen_detector_and_restriction

import android.os.Bundle
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val SCREENSHOT_CHANNEL = "com.example.detector/screenshot"
    private val RECORDING_CHANNEL = "com.example.detector/recording"
    private val NATIVE_CHANNEL = "com.example.detector/native"

    private var screenshotEventSink: EventChannel.EventSink? = null
    private var recordingEventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Method Channel for controlling features
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NATIVE_CHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
                "initializeDetection" -> {
                    // Initialize detection listeners
                    result.success(true)
                }
                "disableScreenshot" -> {
                    // Prevent screenshots
                    window.setFlags(
                        WindowManager.LayoutParams.FLAG_SECURE,
                        WindowManager.LayoutParams.FLAG_SECURE
                    )
                    result.success(null)
                }
                "enableScreenshot" -> {
                    // Allow screenshots
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Event Channel for screenshot detection
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SCREENSHOT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    screenshotEventSink = events
                    // Set up screenshot detection listener here
                    // This requires ContentObserver or MediaStore monitoring
                }

                override fun onCancel(arguments: Any?) {
                    screenshotEventSink = null
                }
            }
        )

        // Event Channel for screen recording detection
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, RECORDING_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    recordingEventSink = events
                    // Set up MediaProjection detection here
                }

                override fun onCancel(arguments: Any?) {
                    recordingEventSink = null
                }
            }
        )
    }
}