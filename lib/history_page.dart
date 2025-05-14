//history_page.dart
import 'package:flutter/material.dart';

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

class _HistoryPageState extends State<HistoryPage> {
  final List<HistoryItem> _historyItems = [
    HistoryItem('https://example.com', DateTime.now().subtract(const Duration(days: 1)), true),
    HistoryItem('https://phishing-site.com', DateTime.now().subtract(const Duration(days: 2)), false),
    HistoryItem('https://trusted-site.org', DateTime.now().subtract(const Duration(days: 3)), true),
  ];

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
      body: _historyItems.isEmpty
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