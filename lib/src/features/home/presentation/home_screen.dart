import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, String>> rows = <MapEntry<String, String>>[
      const MapEntry<String, String>('Current Physical Phase', 'Phase 0 - Regulation'),
      const MapEntry<String, String>('Week in Phase', 'Week 2'),
      const MapEntry<String, String>('Weekly Integrity', '82%'),
      const MapEntry<String, String>('Spiritual Level', 'Level 3'),
      const MapEntry<String, String>('Credits', '14'),
      const MapEntry<String, String>('Green/Yellow/Red', '3 / 2 / 1'),
      const MapEntry<String, String>('Walks', '4 / 5'),
      const MapEntry<String, String>('Strength', '2 / 3'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Athletic OS')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('As-salamu alaykum', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: ListView.separated(
                  itemCount: rows.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      dense: true,
                      title: Text(rows[index].key),
                      trailing: Text(rows[index].value),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: () {}, child: const Text('Enter Today')),
            ),
          ],
        ),
      ),
    );
  }
}
