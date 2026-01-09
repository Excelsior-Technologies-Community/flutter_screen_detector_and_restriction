import 'package:flutter/material.dart';
import 'package:flutter_screen_detector_and_restriction/src/detectors/screenshot_detector.dart';
import 'package:flutter_screen_detector_and_restriction/src/widgets/restriction_scaffold.dart';

class SecureScreen extends StatefulWidget {
  const SecureScreen({super.key});

  @override
  State<SecureScreen> createState() => _SecureScreenState();
}

class _SecureScreenState extends State<SecureScreen> {
  final ScreenshotDetector _screenshotDetector = ScreenshotDetector();
  int _screenshotCount = 0;
  bool isRecording = false;
  bool _preventScreenshots = true;

  @override
  void initState() {
    super.initState();
    _initializeDetector();
  }

  Future<void> _initializeDetector() async {
    await _screenshotDetector.initialize();
    _screenshotDetector.notifier.addListener(_updateScreenshotCount);
  }

  void _updateScreenshotCount() {
    setState(() {
      _screenshotCount = _screenshotDetector.notifier.screenshotCount;
    });

    // Show alert when screenshot is detected
    _showScreenshotAlert();
  }

  void _showScreenshotAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Security Alert'),
        content: const Text('A screenshot was detected and logged.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _toggleScreenshotPrevention() async {
    setState(() {
      _preventScreenshots = !_preventScreenshots;
    });

    await _screenshotDetector.preventScreenshots(_preventScreenshots);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _preventScreenshots
              ? 'Screenshots disabled'
              : 'Screenshots enabled',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _screenshotDetector.notifier.removeListener(_updateScreenshotCount);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RestrictionScaffold(
      appBar: AppBar(
        title: const Text('Secure Content'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _toggleScreenshotPrevention,
            icon: Icon(
              _preventScreenshots
                  ? Icons.security
                  : Icons.security_outlined,
            ),
            tooltip: _preventScreenshots
                ? 'Screenshots prevented'
                : 'Screenshots allowed',
          ),
        ],
      ),
      onViolationDetected: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Security violation detected!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      },
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security Status Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Security Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          _preventScreenshots
                              ? Icons.check_circle
                              : Icons.error,
                          color: _preventScreenshots
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _preventScreenshots
                              ? 'Screenshots: Blocked'
                              : 'Screenshots: Allowed',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.screenshot_monitor, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Detected Screenshots: $_screenshotCount',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sensitive Content
            const Text(
              'Confidential Information',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              color: Colors.blue[50],
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Project Alpha Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '• Budget: \$2,500,000',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '• Timeline: 12 months',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '• Team Size: 45 members',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '• Status: In Progress',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              color: Colors.green[50],
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Client Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '• Name: TechCorp Solutions',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '• Contact: john@techcorp.com',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '• Agreement: NDA Signed',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Instructions
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚠️ Security Notice',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This screen is protected against screenshots and screen recording. '
                          'Any attempt to capture this screen will trigger security alerts '
                          'and will be logged for review.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Test Buttons
            Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _screenshotCount = 0;
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Counter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Try taking a screenshot or screen recording to test detection',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}