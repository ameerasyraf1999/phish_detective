import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : Colors.black87;

    return Scaffold(
      appBar: AppBar(title: const Text('About Us'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Header
            Center(
              child: Text(
                "PhishDetective",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "AI-Powered SMS Phishing Detection",
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            ),
            const SizedBox(height: 30),

            // Mission
            Text(
              "Our Mission",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "To empower individuals with real-time protection against phishing threats through advanced machine learning and simple, accessible technology.",
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 25),

            // About the App
            Text(
              "About the App",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "PhishDetective is a mobile application that detects phishing SMS messages in real-time. Using logistic regression-based machine learning, it scans incoming messages for suspicious keywords and URLs. If a threat is detected, the user is immediately notified with a detailed warning. The app also logs phishing messages in a local database so users can review their message history safely.",
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 25),

            // Features
            Text(
              "Key Features",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            _featureItem("✅ Real-time SMS monitoring"),
            _featureItem("✅ Machine Learning-based phishing detection"),
            _featureItem("✅ Warning notifications for suspicious content"),
            _featureItem("✅ SMS history and scan reports"),
            _featureItem("✅ Easy-to-use and lightweight interface"),

            const SizedBox(height: 30),

            // Team or Credits
            Text(
              "Developed By",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "This app was developed by a passionate team of cybersecurity enthusiasts as a final year project with the goal to make mobile communications safer for everyone.",
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 50),
            Center(
              child: Text(
                "Stay Safe. Stay Aware. 🚫📱",
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.teal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 20, color: Colors.teal),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
