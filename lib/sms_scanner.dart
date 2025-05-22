import 'package:another_telephony/telephony.dart';
import 'db_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SmsScanner {
  final DBHelper _dbHelper = DBHelper();
  final Telephony telephony = Telephony.instance;

  Future<void> scanAndStoreAllSms() async {
    // Request SMS permissions before accessing SMS
    final bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted != true) {
      // Optionally, handle permission denial (e.g., show a message)
      return;
    }
    final List<SmsMessage> messages = await telephony.getInboxSms();
    for (var msg in messages) {
      if (msg.body == null) continue;
      bool isSafe = await _checkPhishing(msg.body!);
      await _dbHelper.insertHistory(
        msg.body!,
        msg.date != null ? msg.date! : DateTime.now().millisecondsSinceEpoch,
        isSafe ? 1 : 0,
      );
    }
  }

  Future<bool> _checkPhishing(String text) async {
    // Replace with your actual Heroku model endpoint
    final url = Uri.parse('https://phish-detective.herokuapp.com/predict');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isSafe'] == true;
      }
    } catch (e) {
      // On error, treat as safe (or handle as needed)
      return true;
    }
    return true;
  }
}
