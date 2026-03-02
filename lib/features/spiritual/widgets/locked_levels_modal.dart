import 'package:flutter/material.dart';

import '../spiritual_state.dart';

void showLockedModal(BuildContext context, int currentLevel) {
  showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Locked Levels'),
      content: SizedBox(
        width: 360,
        child: ListView(
          shrinkWrap: true,
          children: [
            ...List.generate(5, (index) => index + 1)
                .where((level) => level > currentLevel)
                .map(
                  (level) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Level $level', style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text('Unlocks: ${getUnlockedHabits(level).join(', ')}'),
                        const Text('Requirement: 4 successful weeks'),
                        const Text('Rule: 80% Salah/Zikr + 70% Ilm'),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
    ),
  );
}
