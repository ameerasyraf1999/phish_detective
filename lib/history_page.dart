//history_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:another_telephony/telephony.dart';

class HistoryItem {
  final String url;
  final DateTime date;
  final bool isSafe;

  HistoryItem(this.url, this.date, this.isSafe);
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with RouteAware {
  List<HistoryItem> _historyItems = [];
  bool _isDetectionOn = false;
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    _loadDetectionState();
    _loadSmsHistory();
  }

  Future<void> _loadSmsHistory() async {
    if (!_isDetectionOn) return;
    final List<SmsMessage> messages = await telephony.getInboxSms(
      columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
    );
    setState(() {
      _historyItems = messages
          .map((msg) => HistoryItem(
                msg.body ?? '',
                DateTime.fromMillisecondsSinceEpoch(msg.date ?? DateTime.now().millisecondsSinceEpoch),
                _isSafeSms(msg.body ?? ''),
              ))
          .toList();
    });
  }

  bool _isSafeSms(String body) {
    final lower = body.toLowerCase();
    return !(lower.contains('phish') || lower.contains('http'));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Remove observer logic, not needed for most apps
  }

  @override
  void dispose() {
    // Remove observer logic, not needed for most apps
    super.dispose();
  }

  Future<void> _loadDetectionState() async {
    final prefs = await SharedPreferences.getInstance();
    final detection = prefs.getBool('isScanning') ?? false;
    setState(() {
      _isDetectionOn = detection;
    });
    if (detection) {
      await _loadSmsHistory();
    } else {
      setState(() {
        _historyItems = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: !_isDetectionOn
          ? const Center(child: Text('Detection is OFF. Turn it ON to see SMS history.'))
          : _historyItems.isEmpty
              ? const Center(child: Text('No scan history yet'))
              : ListView.builder(
                  itemCount: _historyItems.length,
                  itemBuilder: (context, index) {
                    final item = _historyItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: Icon(
                          item.isSafe ? Icons.check_circle : Icons.warning,
                          color: item.isSafe ? Colors.green : Colors.orange,
                        ),
                        title: Text(
                          item.url,
                          style: TextStyle(
                            decoration: item.isSafe ? null : TextDecoration.lineThrough,
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
      builder: (context) => AlertDialog(
        title: Text(item.isSafe ? 'Safe URL' : 'Phishing Detected'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('URL: ${item.url}'),
            const SizedBox(height: 10),
            Text('Date: ${item.date.toString()}'),
            const SizedBox(height: 20),
            Text(
              item.isSafe
                  ? 'This URL has been verified as safe'
                  : 'Warning: Potential phishing site detected',
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
      builder: (context) => AlertDialog(
        title: const Text('Clear History?'),
        content: const Text('This will permanently delete all scan history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
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
    );
  }
}