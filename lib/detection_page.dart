import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:another_telephony/telephony.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<DetectionPage> {
  bool _isScanning = false;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadScanState();
    _initNotifications();
  }

  Future<void> _loadScanState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isScanning = prefs.getBool('isScanning') ?? false;
    });
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showPersistentNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'persistent_channel',
      'Persistent Notification',
      channelDescription: 'Keeps the app running in background',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _notificationsPlugin.show(
      0,
      'PhishDetective Running',
      'Detection is active',
      platformChannelSpecifics,
    );
  }

  Future<void> _cancelPersistentNotification() async {
    await _notificationsPlugin.cancel(0);
  }

  Future<void> _requestPermissions() async {
    // Request all necessary SMS permissions using another_telephony
    await Telephony.instance.requestSmsPermissions;
    await Permission.notification.request();
  }

  Future<void> _toggleScan() async {
    await _requestPermissions();
    setState(() {
      _isScanning = !_isScanning;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isScanning', _isScanning);
    if (_isScanning) {
      await _showPersistentNotification();
      // TODO: Start SMS listening and saving to history
    } else {
      await _cancelPersistentNotification();
      // TODO: Stop SMS listening
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
                onPressed: () => _toggleScan(),
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
