//history_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phish_detective/sms_model.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final smsBox = Hive.box<SmsModel>('smsBox');

    return Scaffold(
      appBar: AppBar(title: const Text('SMS History')),
      body: ValueListenableBuilder(
        valueListenable: smsBox.listenable(),
        builder: (context, Box<SmsModel> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text('No SMS messages yet.'));
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final sms = box.getAt(index) as SmsModel;
              return ListTile(
                title: Text(sms.sender ?? 'Unknown Sender'),
                subtitle: Text(sms.body ?? 'No content'),
                trailing: Text(sms.timestamp?.toString() ?? 'No date'),
                // You can add an icon or color based on sms.isPhishing
              );
            },
          );
        },
      ),
    );
  }
}
