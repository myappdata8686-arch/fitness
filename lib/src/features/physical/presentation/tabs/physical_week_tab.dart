import 'package:flutter/material.dart';

class PhysicalWeekTab extends StatelessWidget {
  const PhysicalWeekTab({super.key});

  @override
  Widget build(BuildContext context) {
    const List<MapEntry<String, String>> metrics = <MapEntry<String, String>>[
      MapEntry<String, String>('Walk count', '4 / 5'),
      MapEntry<String, String>('Strength count', '2 / 3'),
      MapEntry<String, String>('Junk count', '1 / 2'),
      MapEntry<String, String>('Mobility consistency', '5 / 7'),
      MapEntry<String, String>('Color distribution', 'G:3 Y:2 R:1'),
      MapEntry<String, String>('Weekly Integrity %', '82%'),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: metrics
          .map((MapEntry<String, String> item) => Card(
                child: ListTile(
                  title: Text(item.key),
                  trailing: Text(item.value),
                ),
              ))
          .toList(),
    );
  }
}
