import 'package:flutter/material.dart';
import 'package:pbp_project_flutter_speedrun/helpers/database_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: const Text('Task Manager v1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Task Manager',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 PBP Project',
                children: [
                  const SizedBox(height: 10),
                  const Text('Simple Task Manager built with Flutter & SQLite.'),
                ],
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Clear All Data', style: TextStyle(color: Colors.red)),
            subtitle: const Text('Delete all tasks permanently'),
            onTap: () {
              _showClearDataDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will delete ALL tasks (including history) permanently.\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              DatabaseHelper dbHelper = DatabaseHelper();
              await dbHelper.deleteAllTasks();

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data has been cleared')),
                );
              }
            },
            child: const Text('Clear Everything'),
          ),
        ],
      ),
    );
  }
}