import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_data.dart';

class PhaseConfig {
  const PhaseConfig({
    required this.phaseNumber,
    required this.title,
    required this.ideology,
    required this.timeline,
    required this.completionCriteria,
    required this.planDescription,
    required this.rewardPreview,
    required this.weeklySuccessSummary,
    required this.calorieSystemStatus,
    required this.selfCareTieIns,
  });

  final int phaseNumber;
  final String title;
  final String ideology;
  final String timeline;
  final String completionCriteria;
  final String planDescription;
  final List<String> rewardPreview;
  final String weeklySuccessSummary;
  final String calorieSystemStatus;
  final String selfCareTieIns;
}

const List<PhaseConfig> _phaseConfigs = [
  PhaseConfig(
    phaseNumber: 0,
    title: 'PHASE 0 — FOUNDATION',
    ideology: 'Repair rhythm. Restore movement. Calm system.',
    timeline: '6–8 weeks',
    completionCriteria: '6 stable weeks (manual unlock) · Auto unlock at week 8',
    planDescription:
        '• Rehab mobility daily\n• Light walking\n• Sleep rhythm discipline\n• Gut calm focus',
    rewardPreview: ['Weighing scale', 'Haircut', '+1 Big Credit'],
    weeklySuccessSummary:
        'Mobility ≥ 5 days\nWalking ≥ 3 days\nSleep rhythm ≥ 5 days',
    calorieSystemStatus: 'Calorie tracking locked until Phase 1.',
    selfCareTieIns: 'Base hygiene consistency + weekly grooming rhythm.',
  ),
  PhaseConfig(
    phaseNumber: 1,
    title: 'PHASE 1 — FAT LOSS INITIATION',
    ideology: 'Controlled deficit with structured strength.',
    timeline: '5–6 months (estimated)',
    completionCriteria: 'Reach 93 kg',
    planDescription:
        '• Walking most days\n• Calisthenics 2×/week\n• Daily mobility (with walk as base movement)\n• Mild calorie deficit (counter active)',
    rewardPreview: ['Hair treatment', 'Wardrobe revival', '+1 Big Credit'],
    weeklySuccessSummary:
        'Walking ≥ 4 days\nCalisthenics ≥ 2 sessions\nCalorie deficit ≥ 4 days',
    calorieSystemStatus: 'Calorie tracking active with mild deficit.',
    selfCareTieIns: 'Grooming upgrades and early wardrobe return.',
  ),
  PhaseConfig(
    phaseNumber: 2,
    title: 'PHASE 2 — STABILITY REFINEMENT',
    ideology: 'Hold shape. Build posture. Strengthen base.',
    timeline: '~2 months',
    completionCriteria: 'Time-based stability period',
    planDescription:
        '• Light walking most days\n• Strength 2–3×/week\n• Posture correction work\n• No calorie deficit',
    rewardPreview: ['Stability badge', 'Confidence unlock', '+1 Big Credit'],
    weeklySuccessSummary:
        'Strength ≥ 2 sessions\nPosture ≥ 3 days\nNo deficit days',
    calorieSystemStatus: 'Maintenance calories, no deficit target.',
    selfCareTieIns: 'Consistency layer and confidence routines.',
  ),
  PhaseConfig(
    phaseNumber: 3,
    title: 'PHASE 3 — ADVANCED FAT LOSS',
    ideology: 'Progressive overload with macro precision.',
    timeline: '5–6 months (estimated)',
    completionCriteria: 'Reach 83 kg OR waist 34 inches',
    planDescription:
        '• Walking 4–5×/week\n• Calisthenics 3×/week\n• Progressive overload\n• Macro tracking active\n• Mild calorie deficit',
    rewardPreview: ['Food Feel unlocked', 'Further wardrobe revival', '+2 Big Credits'],
    weeklySuccessSummary:
        'Walking ≥ 4 days\nCalisthenics ≥ 3 sessions\nMacro tracking ≥ 4 days\nDeficit ≥ 4 days',
    calorieSystemStatus: 'Macro + deficit tracking active.',
    selfCareTieIns: 'Higher discipline self-care + appearance refinement.',
  ),
  PhaseConfig(
    phaseNumber: 4,
    title: 'PHASE 4 — ATHLETIC STABILITY',
    ideology: 'Durable. Athletic. Adaptable.',
    timeline: '12 months stability',
    completionCriteria: '12-month stability adherence',
    planDescription:
        '• Walking most days\n• Strength 2–3×/week\n• Posture work\n• No deficit (unless Bodybuilding Mode enabled)',
    rewardPreview: ['Ultimate Mode', 'Studio upgrade', '+3 Big Credits'],
    weeklySuccessSummary:
        'Strength ≥ 2 sessions\nWalking ≥ 4 days\nFloor–Ceiling respected',
    calorieSystemStatus: 'Maintenance by default; configurable in Ultimate mode.',
    selfCareTieIns: 'Wardrobe and identity consolidation.',
  ),
];

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppData>();
    final state = app.journey;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Journey', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        ..._phaseConfigs.map(
          (phase) => _PhaseCard(
            config: phase,
            journeyState: state,
          ),
        ),
        const SizedBox(height: 12),
        _CreditsCard(softCredits: state.softCredits, bigCredits: state.bigCredits),
      ],
    );
  }
}

class _PhaseCard extends StatelessWidget {
  const _PhaseCard({required this.config, required this.journeyState});

  final PhaseConfig config;
  final JourneyState journeyState;

  @override
  Widget build(BuildContext context) {
    final phase = config.phaseNumber;
    final current = journeyState.currentPhase;
    final isLocked = phase > current;
    final isCurrent = phase == current;
    final progress = isCurrent
        ? journeyState.progress.clamp(0.0, 1.0)
        : phase < current
            ? 1.0
            : 0.0;

    return Opacity(
      opacity: isLocked ? 0.6 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              const Color(0x66D4AF37).withOpacity(isLocked ? 0 : progress),
              const Color(0x00121212),
            ],
          ),
          boxShadow: [
            if (!isLocked)
              BoxShadow(
                color: const Color(0x55D4AF37).withOpacity(progress),
                blurRadius: 14,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Card(
          color: const Color(0xFF1D1D1D),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(config.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(config.ideology, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Text(
                  isLocked
                      ? 'Progress: Locked · ${config.completionCriteria}'
                      : 'Progress: ${(progress * 100).toStringAsFixed(0)}%',
                ),
                const SizedBox(height: 4),
                Text('Completion Criteria: ${config.completionCriteria}', style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 4),
                Text('Timeline: ${config.timeline}', style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => _openPlan(context),
                      child: const Text('View Plan'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => _openRewards(context),
                      child: const Text('View Rewards'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPlan(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${config.title} · Plan'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(config.ideology),
              const SizedBox(height: 10),
              Text(config.planDescription),
              const SizedBox(height: 10),
              Text('Weekly success structure:\n${config.weeklySuccessSummary}'),
              const SizedBox(height: 10),
              Text('Calorie system status:\n${config.calorieSystemStatus}'),
              const SizedBox(height: 10),
              Text('SelfCare tie-ins:\n${config.selfCareTieIns}'),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  void _openRewards(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${config.title} · Rewards'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...config.rewardPreview.map((r) => Text('• $r')),
            const SizedBox(height: 8),
            const Text('Read-only preview.'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }
}

class _CreditsCard extends StatelessWidget {
  const _CreditsCard({required this.softCredits, required this.bigCredits});

  final int softCredits;
  final int bigCredits;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text('Soft Credits', style: TextStyle(color: Colors.white70)),
                Text('$softCredits', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              ],
            ),
            Column(
              children: [
                const Text('Big Credits', style: TextStyle(color: Color(0xFFFFD54F))),
                Text('$bigCredits', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
