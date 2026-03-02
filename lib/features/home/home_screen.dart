import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/app_data.dart';
import '../physical/physical_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.data,
    required this.onNavigateTab,
    required this.onEnterToday,
    this.showProfileReminder = false,
  });

  final HomeOverviewData data;
  final ValueChanged<int> onNavigateTab;
  final VoidCallback onEnterToday;
  final bool showProfileReminder;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static DateTime? _lastGreetingDay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showGreetingIfNeeded());
  }

  void _showGreetingIfNeeded() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_lastGreetingDay == today) return;
    _lastGreetingDay = today;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('السلام عليكم', textAlign: TextAlign.center),
        content: const Text('Welcome back.', textAlign: TextAlign.center),
      ),
    );

    Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: _backgroundForDay(data.confirmedDay),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.showProfileReminder)
            Card(
              child: ListTile(
                title: const Text('Complete your profile'),
                subtitle: const Text('Tap to open Settings > Profile & Units'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => widget.onNavigateTab(6),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: _ProgressCard(
                  title: 'Physical Phase',
                  subtitle: data.phaseName,
                  percent: data.phaseProgressPercent,
                  onTap: () => widget.onNavigateTab(1),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ProgressCard(
                  title: 'Spiritual Level',
                  subtitle: data.spiritualLevelName,
                  percent: data.spiritualProgressPercent,
                  onTap: () => widget.onNavigateTab(0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Performance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _DayDistributionCard(data: data, onTap: () => widget.onNavigateTab(1)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HealthSnapshotCard(data: data, onTap: () => widget.onNavigateTab(1)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _WeeklyRoutineCard(data: data, onTap: () => widget.onNavigateTab(1)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _CaloriesCard(data: data, onTap: () => widget.onNavigateTab(1)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _JunkCard(data: data, onTap: () => widget.onNavigateTab(1)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _CreditsCard(
                  softCredits: data.softCredits,
                  hardCredits: data.hardCredits,
                  onTap: () => widget.onNavigateTab(4),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 88,
                  child: ElevatedButton(
                    onPressed: widget.onEnterToday,
                    child: const Text('Enter Today'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _backgroundForDay(DayType day) {
    switch (day) {
      case DayType.red:
        return const Color(0x22FF5252);
      case DayType.yellow:
        return const Color(0x22FFC107);
      case DayType.green:
        return const Color(0x2232CD80);
      case DayType.none:
        return const Color(0xFF121212);
    }
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.title,
    required this.subtitle,
    required this.percent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final double percent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(subtitle, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: (percent / 100).clamp(0, 1)),
              const SizedBox(height: 6),
              Text('${percent.toStringAsFixed(0)}%'),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayDistributionCard extends StatelessWidget {
  const _DayDistributionCard({required this.data, required this.onTap});

  final HomeOverviewData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final green = data.dayDistribution[DayType.green] ?? 0;
    final yellow = data.dayDistribution[DayType.yellow] ?? 0;
    final red = data.dayDistribution[DayType.red] ?? 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Day Type Distribution', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              SizedBox(
                height: 84,
                child: CustomPaint(
                  painter: _FlatPiePainter(distribution: data.dayDistribution),
                  child: const SizedBox.expand(),
                ),
              ),
              const SizedBox(height: 8),
              Text('Green ${green.toStringAsFixed(0)}% • Yellow ${yellow.toStringAsFixed(0)}% • Red ${red.toStringAsFixed(0)}%'),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlatPiePainter extends CustomPainter {
  _FlatPiePainter({required this.distribution});

  final Map<DayType, double> distribution;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final total = distribution.values.fold<double>(0, (a, b) => a + b);
    if (total <= 0) return;

    double start = -math.pi / 2;
    for (final part in [DayType.green, DayType.yellow, DayType.red, DayType.none]) {
      final value = distribution[part] ?? 0;
      if (value <= 0) continue;
      final sweep = (value / total) * math.pi * 2;
      final paint = Paint()
        ..color = switch (part) {
          DayType.green => Colors.green,
          DayType.yellow => Colors.amber,
          DayType.red => Colors.red,
          DayType.none => Colors.grey,
        }
        ..style = PaintingStyle.fill;
      canvas.drawArc(rect, start, sweep, true, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _FlatPiePainter oldDelegate) => oldDelegate.distribution != distribution;
}

class _HealthSnapshotCard extends StatelessWidget {
  const _HealthSnapshotCard({required this.data, required this.onTap});

  final HomeOverviewData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Health Snapshot', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Avg Weekly BP: ${data.avgWeeklyBp.toStringAsFixed(0)} mmHg'),
              if (data.eczemaActive) const Text('Eczema Active', style: TextStyle(color: Colors.orange)),
              if (data.allergyActive) const Text('ENT Allergy Active', style: TextStyle(color: Colors.orange)),
              const SizedBox(height: 6),
              const Text('Weekly BP Trend', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeeklyRoutineCard extends StatelessWidget {
  const _WeeklyRoutineCard({required this.data, required this.onTap});

  final HomeOverviewData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Weekly Overview — Routine Completion', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Row(
                children: List.generate(7, (index) {
                  final value = data.weeklyRoutine[index];
                  final color = value == null
                      ? Colors.grey
                      : value
                          ? Colors.green
                          : Colors.red;
                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 24,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                        ),
                        const SizedBox(height: 4),
                        Text(labels[index], style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CaloriesCard extends StatelessWidget {
  const _CaloriesCard({required this.data, required this.onTap});

  final HomeOverviewData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Average Weekly Calories vs Needed', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text('Avg Intake: ${data.weeklyAvgCalories.toStringAsFixed(0)} kcal'),
                  Text('Target: ${data.weeklyTargetCalories.toStringAsFixed(0)} kcal'),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: data.weeklyTargetCalories == 0 ? 0 : (data.weeklyAvgCalories / data.weeklyTargetCalories).clamp(0, 1),
                  ),
                ],
              ),
            ),
            if (!data.showCalories)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xAA2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_outline),
                        SizedBox(height: 6),
                        Text('Calorie tracking unlocks in Phase 1', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _JunkCard extends StatelessWidget {
  const _JunkCard({required this.data, required this.onTap});

  final HomeOverviewData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final maxValue = data.monthlyJunkWeekly.fold<int>(0, (a, b) => a > b ? a : b);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Junk Days', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              SizedBox(
                height: 84,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(data.monthlyJunkWeekly.length, (index) {
                    final junk = data.monthlyJunkWeekly[index].toDouble();
                    final top = math.max(4.0, maxValue.toDouble());
                    final factor = junk / top;
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(width: 14, height: 58, color: Colors.grey.shade700),
                              Container(width: 14, height: 58 * factor, color: const Color(0xFF7E57C2)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text('W${index + 1}', style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 4),
              const Text('Guide: 2', style: TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreditsCard extends StatelessWidget {
  const _CreditsCard({
    required this.softCredits,
    required this.hardCredits,
    required this.onTap,
  });

  final int softCredits;
  final int hardCredits;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Credits', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Soft Credits: $softCredits'),
              Text('Hard Credits: $hardCredits'),
            ],
          ),
        ),
      ),
    );
  }
}
