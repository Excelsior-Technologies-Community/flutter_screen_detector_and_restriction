import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let screenshotChannel = FlutterMethodChannel(name: "com.example.detector/native",
                                                  binaryMessenger: controller.binaryMessenger)
    screenshotChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
      if call.method == "disableScreenshot" {
        // Prevent screenshots on iOS
        self?.preventScreenshots()
        result(nil)
      } else if call.method == "enableScreenshot" {
        // Allow screenshots
        self?.allowScreenshots()
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func preventScreenshots() {
    // iOS screenshot prevention logic
  }

  private func allowScreenshots() {
    // iOS screenshot allowance logic
  }
}