//settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _threatAlertsEnabled = true;
  bool _autoScanEnabled = false;
  String _scanSensitivity = 'Medium';
  final List<String> _sensitivityOptions = ['Low', 'Medium', 'High'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          _buildSectionHeader('Appearance'),
          _buildSettingSwitch(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            value: _darkMode,
            onChanged: (value) {
              setState(() => _darkMode = value);
              // TODO: Implement theme change logic
            },
          ),
          const SizedBox(height: 16),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          _buildSettingSwitch(
            icon: Icons.notifications_active,
            title: 'Enable Notifications',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
                if (!value) _threatAlertsEnabled = false;
              });
            },
          ),
          const SizedBox(height: 8),
          _buildSettingSwitch(
            icon: Icons.security,
            title: 'Threat Alerts',
            value: _threatAlertsEnabled,
            onChanged: (value) {
              setState(() => _threatAlertsEnabled = value);
            },
            enabled: _notificationsEnabled,
          ),
          const SizedBox(height: 16),

          // Security Section
          _buildSectionHeader('Security'),
          _buildSettingSwitch(
            icon: Icons.auto_awesome,
            title: 'Auto-Scan Messages',
            value: _autoScanEnabled,
            onChanged: (value) => setState(() => _autoScanEnabled = value),
          ),
          const SizedBox(height: 16),
          _buildSettingDropdown(
            icon: Icons.speed,
            title: 'Scan Sensitivity',
            value: _scanSensitivity,
            items: _sensitivityOptions,
            onChanged: (value) => setState(() => _scanSensitivity = value!),
          ),
          const SizedBox(height: 24),

          // Account Section
          _buildSectionHeader('Account'),
          _buildSettingButton(
            icon: Icons.lock_reset,
            title: 'Change Password',
            onTap: () => _showPasswordChangeDialog(),
          ),
          _buildSettingButton(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            color: Colors.red,
            onTap: () => _showDeleteAccountConfirmation(),
          ),
          const SizedBox(height: 32),

          // About Section
          _buildSectionHeader('About'),
          _buildAppInfoRow('Version', '1.0.0'),
          _buildAppInfoRow('Build Number', '2023.12.1'),
          _buildAppInfoRow('Developer', 'PhishDetective Team'),
          Center(
            child: TextButton(
              onPressed: () {
                // TODO: Launch app store review
              },
              child: const Text('Rate this app'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingSwitch({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: enabled ? Theme.of(context).colorScheme.primary : Colors.grey,
      ),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildSettingDropdown({
    required IconData icon,
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items:
            items.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSettingButton({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildAppInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  void _showPasswordChangeDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password changed successfully'),
                    ),
                  );
                },
                child: const Text('Update'),
              ),
            ],
          ),
    );
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Account?'),
            content: const Text(
              'This will permanently delete all your data. This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement account deletion logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account deleted successfully'),
                    ),
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
