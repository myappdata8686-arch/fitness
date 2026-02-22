import 'package:flutter/material.dart';

class SpiritualScreen extends StatelessWidget {
  const SpiritualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const items = <String>['Salah', 'Ilm', 'Zikr'];
    return Scaffold(
      appBar: AppBar(title: const Text('Spiritual')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: items
            .map((String section) => Card(
                  child: CheckboxListTile(
                    title: Text(section),
                    value: false,
                    onChanged: (_) {},
                    subtitle: const Text('Track completion and weekly %'),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
