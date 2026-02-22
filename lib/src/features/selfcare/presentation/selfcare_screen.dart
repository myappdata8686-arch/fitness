import 'package:flutter/material.dart';

class SelfCareScreen extends StatelessWidget {
  const SelfCareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Self-Care'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Daily'),
              Tab(text: 'Weekly'),
              Tab(text: 'Fortnightly'),
              Tab(text: 'Monthly'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            _ChecklistTab(title: 'Daily grouped checklist'),
            _ChecklistTab(title: 'Weekly phase-based rituals'),
            _ChecklistTab(title: '14-day tracker'),
            _ChecklistTab(title: 'Monthly rituals (phase-unlocked)'),
          ],
        ),
      ),
    );
  }
}

class _ChecklistTab extends StatelessWidget {
  const _ChecklistTab({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}
