import 'package:flutter/material.dart';

import '../../domain/phase_blueprints.dart';

class PhysicalJourneyTab extends StatelessWidget {
  const PhysicalJourneyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: phaseBlueprints.length,
      itemBuilder: (BuildContext context, int index) {
        final phase = phaseBlueprints[index];
        final String status = index == 0 ? 'Active' : 'Locked';
        return Card(
          child: ListTile(
            title: Text('Phase ${phase.id} – ${phase.name}'),
            subtitle: Text('Criteria: ${phase.successCriteria}\nReward: ${phase.reward}'),
            trailing: Text(status),
          ),
        );
      },
    );
  }
}
