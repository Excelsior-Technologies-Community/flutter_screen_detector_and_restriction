import 'package:flutter/material.dart';
import 'package:screen_restriction/screen_restriction.dart';

class DetectionOverlay extends StatefulWidget {
  final Widget child;
  final bool showWarning;
  final Color warningColor;
  final Duration warningDuration;
  final VoidCallback? onScreenshotDetected;
  final VoidCallback? onRecordingStarted;
  final VoidCallback? onRecordingStopped;

  const DetectionOverlay({
    super.key,
    required this.child,
    this.showWarning = true,
    this.warningColor = Colors.red,
    this.warningDuration = const Duration(seconds: 2),
    this.onScreenshotDetected,
    this.onRecordingStarted,
    this.onRecordingStopped,
  });

  @override
  State<DetectionOverlay> createState() => _DetectionOverlayState();
}

class _DetectionOverlayState extends State<DetectionOverlay> {
  final ScreenshotDetector _screenshotDetector = ScreenshotDetector();
  final RecordingDetector _recordingDetector = RecordingDetector();
  bool _showScreenshotWarning = false;
  bool _showRecordingWarning = false;

  @override
  void initState() {
    super.initState();
    _initializeDetectors();
  }

  Future<void> _initializeDetectors() async {
    await _screenshotDetector.initialize();
    await _recordingDetector.initialize();

    _screenshotDetector.notifier.addListener(_onScreenshotDetected);
    _recordingDetector.notifier.addListener(_onRecordingChanged);
  }

  void _onScreenshotDetected() {
    if (widget.showWarning) {
      setState(() {
        _showScreenshotWarning = true;
      });

      Future.delayed(widget.warningDuration, () {
        if (mounted) {
          setState(() {
            _showScreenshotWarning = false;
          });
        }
      });
    }

    widget.onScreenshotDetected?.call();
  }

  void _onRecordingChanged() {
    final isRecording = _recordingDetector.isRecording;

    if (widget.showWarning) {
      setState(() {
        _showRecordingWarning = isRecording;
      });
    }

    if (isRecording) {
      widget.onRecordingStarted?.call();
    } else {
      widget.onRecordingStopped?.call();
    }
  }

  @override
  void dispose() {
    _screenshotDetector.notifier.removeListener(_onScreenshotDetected);
    _recordingDetector.notifier.removeListener(_onRecordingChanged);
    _screenshotDetector.dispose();
    _recordingDetector.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showScreenshotWarning)
          Positioned.fill(
            child: _buildWarningOverlay('Screenshot Detected!'),
          ),
        if (_showRecordingWarning)
          Positioned.fill(
            child: _buildWarningOverlay('Screen Recording Active!'),
          ),
      ],
    );
  }

  Widget _buildWarningOverlay(String message) {
    return Container(
      color: widget.warningColor.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: widget.warningColor,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.warningColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This action has been logged',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}