import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const <Widget>[
          ListTile(title: Text('Notification times')),
          ListTile(title: Text('BP threshold')),
          ListTile(title: Text('Manual phase override (if unlocked)')),
          ListTile(title: Text('Data export')),
        ],
      ),
    );
  }
}
