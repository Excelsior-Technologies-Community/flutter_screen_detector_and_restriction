import 'package:flutter/material.dart';
import 'package:flutter_screen_detector_and_restriction/src/widgets/detection_overlay.dart';

class RestrictionScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color backgroundColor;
  final bool restrictScreenshots;
  final bool restrictRecording;
  final VoidCallback? onViolationDetected;

  const RestrictionScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor = Colors.white,
    this.restrictScreenshots = true,
    this.restrictRecording = true,
    this.onViolationDetected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      body: DetectionOverlay(
        child: body,
        onScreenshotDetected: restrictScreenshots ? onViolationDetected : null,
        onRecordingStarted: restrictRecording ? onViolationDetected : null,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}