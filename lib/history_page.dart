//history_page.dart
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'db_helper.dart';

class HistoryItem {
  final String body;
  final DateTime date;
  final bool isSafe;

  HistoryItem(this.body, this.date, this.isSafe);
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryItem> _historyItems = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final db = DBHelper();
    final data = await db.getHistory();
    setState(() {
      _historyItems =
          data
              .map(
                (e) => HistoryItem(
                  e['body'] ?? '',
                  DateTime.fromMillisecondsSinceEpoch(e['date'] ?? 0),
                  (e['isSafe'] ?? 1) == 1,
                ),
              )
              .toList();
    });
  }

  @override
=======
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phish_detective/sms_model.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
>>>>>>> a036c8c8002b42703c7d6f9092bf6ab0ed2e2593
  Widget build(BuildContext context) {
    final smsBox = Hive.box<SmsModel>('smsBox');

    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(
        title: const Text('Scan History'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _showClearConfirmation(context),
          ),
        ],
      ),
      body:
          _historyItems.isEmpty
              ? const Center(child: Text('No scan history yet'))
              : ListView.builder(
                itemCount: _historyItems.length,
                itemBuilder: (context, index) {
                  final item = _historyItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: ListTile(
                      leading: Icon(
                        item.isSafe ? Icons.check_circle : Icons.warning,
                        color: item.isSafe ? Colors.green : Colors.orange,
                      ),
                      title: Text(
                        item.body,
                        style: TextStyle(
                          decoration:
                              item.isSafe ? null : TextDecoration.lineThrough,
                        ),
                      ),
                      subtitle: Text(
                        'Scanned on ${item.date.toString().split(' ')[0]}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showDetails(context, item),
                    ),
                  );
                },
              ),
    );
  }

  void _showDetails(BuildContext context, HistoryItem item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(item.isSafe ? 'Safe SMS' : 'Phishing Detected'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Message: ${item.body}'),
                const SizedBox(height: 10),
                Text('Date: ${item.date.toString()}'),
                const SizedBox(height: 20),
                Text(
                  item.isSafe
                      ? 'This SMS has been verified as safe'
                      : 'Warning: Potential phishing SMS detected',
                  style: TextStyle(
                    color: item.isSafe ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear History?'),
            content: const Text(
              'This will permanently delete all scan history.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final db = DBHelper();
                  await db.clearHistory();
                  setState(() => _historyItems.clear());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('History cleared')),
                  );
                },
                child: const Text('Clear', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
=======
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
>>>>>>> a036c8c8002b42703c7d6f9092bf6ab0ed2e2593
    );
  }
}
