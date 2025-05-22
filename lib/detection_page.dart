import 'package:flutter/material.dart';
import 'sms_scanner.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<DetectionPage> {
  bool _isScanning = false;
  final SmsScanner _scanner = SmsScanner();

  void _toggleScan() async {
    setState(() {
      _isScanning = !_isScanning;
    });
    if (_isScanning) {
      await _scanner.scanAndStoreAllSms();
      setState(() {
        _isScanning = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('SMS scan complete!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phishing Detection'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status indicator
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _isScanning ? Colors.red.shade100 : Colors.green.shade100,
                border: Border.all(
                  color: _isScanning ? Colors.red : Colors.green,
                  width: 3,
                ),
              ),
              child: Icon(
                _isScanning ? Icons.security : Icons.verified_user,
                size: 50,
                color: _isScanning ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              _isScanning ? 'Detection Active' : 'Ready to Detect',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _isScanning ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _isScanning
                  ? 'Scanning for phishing attempts'
                  : 'Tap below to start detection',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            // Toggle button
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: _toggleScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isScanning ? Colors.red : Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_isScanning ? Icons.stop : Icons.play_arrow, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      _isScanning ? 'STOP' : 'START',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
