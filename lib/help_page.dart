//help_page.dart
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // FAQ Section
          _buildSectionHeader(context, 'Frequently Asked Questions'),
          _buildExpandableItem(
            title: 'How does PhishDetective work?',
            content:
                'PhishDetective analyzes URLs in your messages using advanced algorithms to detect potential phishing attempts before you interact with them.',
          ),
          _buildExpandableItem(
            title: 'Is my data secure?',
            content:
                'Yes, all analysis happens locally on your device. We never store or transmit your personal messages to our servers.',
          ),
          _buildExpandableItem(
            title: 'Why was a legitimate site flagged?',
            content:
                'Sometimes safe sites get flagged if they share characteristics with known phishing sites. You can report false positives in settings.',
          ),
          const SizedBox(height: 24),

          // Contact Support
          _buildSectionHeader(context, 'Contact Support'),
          _buildContactOption(
            context,
            icon: Icons.chat,
            title: 'Live Chat',
            subtitle: 'Available 9AM-5PM EST',
            onTap: () => _showLiveChat(context),
          ),
          const SizedBox(height: 24),

          // Resources
          _buildSectionHeader(context, 'Resources'),
          _buildResourceCard(
            context,
            title: 'Phishing Education Center',
            description: 'Learn how to identify and avoid phishing attempts',
            icon: Icons.school,
            color: Colors.blue,
          ),
          _buildResourceCard(
            context,
            title: 'Security Best Practices',
            description: 'Tips to keep your accounts secure',
            icon: Icons.security,
            color: Colors.green,
          ),
          const SizedBox(height: 16),

          // Emergency Section
          Card(
            color: Colors.red[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        'Emergency Assistance',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'If you believe your accounts have been compromised:',
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ActionChip(
                        label: const Text('Change passwords'),
                        onPressed: () {},
                      ),
                      ActionChip(
                        label: const Text('Contact banks'),
                        onPressed: () {},
                      ),
                      ActionChip(
                        label: const Text('Report incident'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildExpandableItem({
    required String title,
    required String content,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(title),
        children: [
          Padding(padding: const EdgeInsets.all(16), child: Text(content)),
        ],
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildResourceCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {}, // Add navigation to resource
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLiveChat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            height: 300,
            child: Column(
              children: [
                Text(
                  'Live Chat Support',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.support_agent, size: 48),
                        SizedBox(height: 16),
                        Text('Connecting you to a support agent...'),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
    );
  }
}
