import 'package:flutter/material.dart';

import '../spiritual_state.dart';

class SpiritualLevelCard extends StatelessWidget {
  const SpiritualLevelCard({super.key, required this.state});

  final SpiritualState state;

  @override
  Widget build(BuildContext context) {
    final glow = state.levelProgress.clamp(0.0, 1.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0x6632CD80).withOpacity(glow),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Card(
        color: const Color(0xFF1C1C1C),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Spiritual Level ${state.currentLevel}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Progress: ${(state.levelProgress * 100).toStringAsFixed(0)}%'),
              const SizedBox(height: 4),
              Text('Successful Weeks: ${state.successfulWeeks}/4', style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
