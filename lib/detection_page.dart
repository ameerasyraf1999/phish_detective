import 'dart:async'; // Added import for StreamSubscription

import 'package:flutter/material.dart';
import 'package:hive/hive.dart'; // Added import for Hive
import 'package:phish_detective/sms_model.dart'; // Added import for SmsModel
import 'package:another_telephony/telephony.dart'; // Changed import to another_telephony

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<DetectionPage> {
  bool _isScanning = false;
  final Telephony telephony = Telephony.instance;
  late Box<SmsModel> smsBox;

  @override
  void initState() {
    super.initState();
    smsBox = Hive.box<SmsModel>('smsBox');
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted == null || !permissionsGranted) {
      print("SMS Permissions not granted");
      // Optionally, show a dialog to the user or disable functionality
    }
  }

  void _toggleScan() {
    setState(() {
      _isScanning = !_isScanning;
      if (_isScanning) {
        _startListeningSms();
      } else {
        print("SMS listening stopping (managed by plugin/OS or on dispose).");
      }
    });
  }

  void _startListeningSms() {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        print("New SMS from ${message.address}: ${message.body}");
        final sms = SmsModel(
          sender: message.address,
          body: message.body,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            message.date ?? DateTime.now().millisecondsSinceEpoch,
          ),
        );
        smsBox.add(sms);
        // Add your phishing detection logic here
      },
      listenInBackground: false, // Keep false for now to simplify lifecycle
    );
    print("SMS listening started with another_telephony.");
  }

  @override
  void dispose() {
    print(
      "DetectionPage disposed. SMS listening might stop if plugin handles it.",
    );
    super.dispose();
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
