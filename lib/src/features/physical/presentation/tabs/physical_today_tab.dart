import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/physical_providers.dart';
import '../../domain/physical_models.dart';

class PhysicalTodayTab extends ConsumerStatefulWidget {
  const PhysicalTodayTab({super.key});

  @override
  ConsumerState<PhysicalTodayTab> createState() => _PhysicalTodayTabState();
}

class _PhysicalTodayTabState extends ConsumerState<PhysicalTodayTab> {
  bool _checkedIn = false;
  DailyCheckInInput? _input;

  @override
  Widget build(BuildContext context) {
    final TodayState state = ref.watch(todayControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!_checkedIn)
            FilledButton(
              onPressed: _openCheckIn,
              child: const Text('Start Daily Check-in'),
            )
          else
            Text('Day color: ${state.dayColor?.name.toUpperCase() ?? '-'}'),
          const SizedBox(height: 12),
          if (state.checklist.isNotEmpty)
            Expanded(
              child: ListView(
                children: state.checklist
                    .map(
                      (String item) => CheckboxListTile(
                        title: Text(item),
                        value: state.completed.contains(item),
                        onChanged: (bool? selected) {
                          ref.read(todayControllerProvider.notifier).toggleItem(item, selected ?? false);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          if (state.checklist.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: state.isLoading
                    ? null
                    : () async {
                        await ref
                            .read(todayControllerProvider.notifier)
                            .persist(userId: 'demo-user', input: _input!);
                        if (mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(content: Text('Today log saved')));
                        }
                      },
                child: const Text('Save Today'),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openCheckIn() async {
    int sleep = 3;
    EnergyLevel energy = EnergyLevel.medium;
    StressLevel stress = StressLevel.medium;
    int pain = 0;
    bool illness = false;

    final bool? submitted = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setModalState) {
            return AlertDialog(
              title: const Text('Daily Check-in'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    DropdownButtonFormField<int>(
                      value: sleep,
                      decoration: const InputDecoration(labelText: 'Sleep (1-5)'),
                      items: List<DropdownMenuItem<int>>.generate(
                        5,
                        (int i) => DropdownMenuItem<int>(value: i + 1, child: Text('${i + 1}')),
                      ),
                      onChanged: (int? v) => setModalState(() => sleep = v ?? 3),
                    ),
                    DropdownButtonFormField<EnergyLevel>(
                      value: energy,
                      decoration: const InputDecoration(labelText: 'Energy'),
                      items: EnergyLevel.values
                          .map((EnergyLevel e) => DropdownMenuItem<EnergyLevel>(value: e, child: Text(e.name)))
                          .toList(),
                      onChanged: (EnergyLevel? v) => setModalState(() => energy = v ?? EnergyLevel.medium),
                    ),
                    DropdownButtonFormField<StressLevel>(
                      value: stress,
                      decoration: const InputDecoration(labelText: 'Stress'),
                      items: StressLevel.values
                          .map((StressLevel s) => DropdownMenuItem<StressLevel>(value: s, child: Text(s.name)))
                          .toList(),
                      onChanged: (StressLevel? v) => setModalState(() => stress = v ?? StressLevel.medium),
                    ),
                    DropdownButtonFormField<int>(
                      value: pain,
                      decoration: const InputDecoration(labelText: 'Pain (0-3)'),
                      items: List<DropdownMenuItem<int>>.generate(
                        4,
                        (int i) => DropdownMenuItem<int>(value: i, child: Text('$i')),
                      ),
                      onChanged: (int? v) => setModalState(() => pain = v ?? 0),
                    ),
                    SwitchListTile(
                      value: illness,
                      title: const Text('Illness/Vertigo'),
                      onChanged: (bool v) => setModalState(() => illness = v),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Apply')),
              ],
            );
          },
        );
      },
    );

    if (submitted == true) {
      final DailyCheckInInput input = DailyCheckInInput(
        sleep: sleep,
        energy: energy,
        stress: stress,
        pain: pain,
        illness: illness,
      );
      setState(() {
        _checkedIn = true;
        _input = input;
      });
      ref.read(todayControllerProvider.notifier).buildChecklist(phaseId: 0, input: input);
    }
  }
}
