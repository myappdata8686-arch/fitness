import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_data.dart';
import '../common/week_view_screen.dart';

enum Frequency { daily, weekly, monthly }

class SelfCareHabit {
  const SelfCareHabit({
    required this.id,
    required this.title,
    required this.frequency,
    required this.requiredPhase,
  });

  final String id;
  final String title;
  final Frequency frequency;
  final int requiredPhase;
}

const List<SelfCareHabit> allHabits = [
  SelfCareHabit(id: 'oral', title: 'Oral Care', frequency: Frequency.daily, requiredPhase: 0),
  SelfCareHabit(id: 'clothes', title: 'Clothes Change', frequency: Frequency.daily, requiredPhase: 0),
  SelfCareHabit(id: 'night', title: 'Night Hygiene', frequency: Frequency.daily, requiredPhase: 0),
  SelfCareHabit(id: 'bath', title: 'Bath', frequency: Frequency.daily, requiredPhase: 0),
  SelfCareHabit(id: 'mild_shampoo', title: 'Mild Shampoo', frequency: Frequency.weekly, requiredPhase: 0),
  SelfCareHabit(id: 'beard_trim', title: 'Beard Trim', frequency: Frequency.weekly, requiredPhase: 0),
  SelfCareHabit(id: 'laundry', title: 'Laundry', frequency: Frequency.weekly, requiredPhase: 0),
  SelfCareHabit(id: 'private_groom', title: 'Private Groom', frequency: Frequency.weekly, requiredPhase: 0),
  SelfCareHabit(id: 'menipedi', title: 'Meni-Pedi', frequency: Frequency.weekly, requiredPhase: 1),
  SelfCareHabit(id: 'skin_mask', title: 'Skin Mask / Scrub', frequency: Frequency.weekly, requiredPhase: 2),
  SelfCareHabit(id: 'surma', title: 'Surma', frequency: Frequency.monthly, requiredPhase: 1),
  SelfCareHabit(id: 'oil', title: 'Oil Ritual', frequency: Frequency.monthly, requiredPhase: 1),
  SelfCareHabit(id: 'haircut', title: 'Monthly Haircut', frequency: Frequency.monthly, requiredPhase: 1),
  SelfCareHabit(id: 'body_hair', title: 'Body Hair Removal', frequency: Frequency.monthly, requiredPhase: 3),
];

class SelfCareScreen extends StatefulWidget {
  const SelfCareScreen({
    super.key,
    required this.journeyState,
    this.customHabits = const [],
  });

  final JourneyState journeyState;
  final List<SelfCareHabit> customHabits;

  @override
  State<SelfCareScreen> createState() => _SelfCareScreenState();
}

class _SelfCareScreenState extends State<SelfCareScreen> {
  final Map<String, Map<DateTime, bool>> completionData = {};

  @override
  Widget build(BuildContext context) {
    final allHabitsMerged = [...allHabits, ...widget.customHabits];
    final unlockedHabits = allHabitsMerged
        .where((habit) => widget.journeyState.currentPhase >= habit.requiredPhase)
        .toList();
    final lockedHabits = allHabitsMerged
        .where((habit) => widget.journeyState.currentPhase < habit.requiredPhase)
        .toList();

    final dailyHabits = unlockedHabits.where((h) => h.frequency == Frequency.daily).toList();
    final weeklyHabits = unlockedHabits.where((h) => h.frequency == Frequency.weekly).toList();
    final monthlyHabits = unlockedHabits.where((h) => h.frequency == Frequency.monthly).toList();

    final today = _normalizeDate(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () {
            final app = context.read<AppData>();
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => WeekViewScreen(app: app, onOpenDate: (_) {})));
          },
        ),
        title: const Text('Self-Care Discipline'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => LockedHabitsModal(lockedHabits: lockedHabits),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MonthlyOverviewScreen(
                    journeyState: widget.journeyState,
                    completionData: completionData,
                    allHabitsSource: allHabitsMerged,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SelfCareChecklistSection(
            title: 'Daily',
            habits: dailyHabits,
            completionData: completionData,
            date: today,
            onChanged: () => setState(() {}),
          ),
          const SizedBox(height: 12),
          SelfCareChecklistSection(
            title: 'Weekly',
            habits: weeklyHabits,
            completionData: completionData,
            date: today,
            onChanged: () => setState(() {}),
          ),
          const SizedBox(height: 12),
          SelfCareChecklistSection(
            title: 'Monthly',
            habits: monthlyHabits,
            completionData: completionData,
            date: today,
            onChanged: () => setState(() {}),
          ),
        ],
      ),
    );
  }
}

class SelfCareChecklistSection extends StatelessWidget {
  const SelfCareChecklistSection({
    super.key,
    required this.title,
    required this.habits,
    required this.completionData,
    required this.date,
    required this.onChanged,
  });

  final String title;
  final List<SelfCareHabit> habits;
  final Map<String, Map<DateTime, bool>> completionData;
  final DateTime date;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            if (habits.isEmpty)
              const Text('No unlocked routines here yet.')
            else
              ...habits.map((habit) {
                final value = completionData[habit.id]?[_normalizeDate(date)] ?? false;
                return CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: value,
                  title: Text(habit.title),
                  subtitle: Text('Phase ${habit.requiredPhase}+'),
                  onChanged: (checked) {
                    final value = checked ?? false;
                    final perHabit = completionData.putIfAbsent(habit.id, () => {});
                    perHabit[_normalizeDate(date)] = value;
                    final app = Provider.of<AppData>(context, listen: false);
                    final rec = app.getOrCreateDailyRecord(_normalizeDate(date));
                    rec.selfCare.habits[habit.id] = value;
                    app.saveDailyRecord(_normalizeDate(date), rec);
                    onChanged();
                  },
                );
              }),
          ],
        ),
      ),
    );
  }
}

class MonthlyOverviewScreen extends StatefulWidget {
  const MonthlyOverviewScreen({
    super.key,
    required this.journeyState,
    required this.completionData,
    required this.allHabitsSource,
  });

  final JourneyState journeyState;
  final Map<String, Map<DateTime, bool>> completionData;
  final List<SelfCareHabit> allHabitsSource;

  @override
  State<MonthlyOverviewScreen> createState() => _MonthlyOverviewScreenState();
}

class _MonthlyOverviewScreenState extends State<MonthlyOverviewScreen> {
  late DateTime selectedMonth;
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
    selectedYear = DateTime.now().year;
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = widget.allHabitsSource
        .where((habit) => widget.journeyState.currentPhase >= habit.requiredPhase)
        .toList();
    final dailyHabits = unlocked.where((h) => h.frequency == Frequency.daily).toList();
    final weeklyHabits = unlocked.where((h) => h.frequency == Frequency.weekly).toList();
    final monthlyHabits = unlocked.where((h) => h.frequency == Frequency.monthly).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Overview · ${_monthLabel(selectedMonth.month)} ${selectedMonth.year}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
                  });
                },
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                '${_monthLabel(selectedMonth.month)} ${selectedMonth.year}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
                  });
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          ExpansionTile(
            initiallyExpanded: true,
            title: const Text('Daily Grid'),
            children: [
              DailyGridWidget(
                dailyHabits: dailyHabits,
                completionData: widget.completionData,
                month: selectedMonth,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ExpansionTile(
            initiallyExpanded: true,
            title: const Text('Weekly Summary (Monthly Stack Bars)'),
            children: [
              WeeklyStackWidget(
                weeklyHabits: weeklyHabits,
                completionData: widget.completionData,
                month: selectedMonth,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ExpansionTile(
            initiallyExpanded: true,
            title: const Text('Monthly Summary (Yearly Stack Bars)'),
            children: [
              YearlyStackWidget(
                monthlyHabits: monthlyHabits,
                completionData: widget.completionData,
                selectedYear: selectedYear,
                onYearChanged: (year) => setState(() => selectedYear = year),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DailyGridWidget extends StatelessWidget {
  const DailyGridWidget({
    super.key,
    required this.dailyHabits,
    required this.completionData,
    required this.month,
  });

  final List<SelfCareHabit> dailyHabits;
  final Map<String, Map<DateTime, bool>> completionData;
  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 130),
              ...List.generate(
                daysInMonth,
                (index) => Container(
                  width: 26,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  child: Text('${index + 1}', style: const TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...dailyHabits.map((habit) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(width: 130, child: Text(habit.title, style: const TextStyle(fontSize: 12))),
                  ...List.generate(daysInMonth, (index) {
                    final day = DateTime(month.year, month.month, index + 1);
                    final value = completionData[habit.id]?[_normalizeDate(day)];
                    return Container(
                      width: 26,
                      height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _dailyCellColor(day, value),
                        border: Border.all(color: Colors.white12),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _dailyCellColor(DateTime day, bool? value) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (day.isAfter(today)) {
      return Colors.transparent;
    }
    if (value == true) return Colors.green;
    if (value == false) return Colors.red;
    return Colors.grey;
  }
}

class WeeklyStackWidget extends StatefulWidget {
  const WeeklyStackWidget({
    super.key,
    required this.weeklyHabits,
    required this.completionData,
    required this.month,
  });

  final List<SelfCareHabit> weeklyHabits;
  final Map<String, Map<DateTime, bool>> completionData;
  final DateTime month;

  @override
  State<WeeklyStackWidget> createState() => _WeeklyStackWidgetState();
}

class _WeeklyStackWidgetState extends State<WeeklyStackWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.weeklyHabits.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: Text('No unlocked weekly habits yet.'),
      );
    }

    final weekRanges = _weekRanges(widget.month);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Column(
          children: widget.weeklyHabits.map((habit) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(habit.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(weekRanges.length, (index) {
                      final range = weekRanges[index];
                      final expected = _isWeekExpected(range.$2) ? 1 : 0;
                      final complete = expected == 0 ? 0 : (_hasTrueInRange(habit.id, range.$1, range.$2) ? 1 : 0);
                      final missed = math.max(0, expected - complete);
                      return Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 86,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  width: 18,
                                  height: 70,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.22),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        heightFactor: _barFactor(missed, expected) * _animation.value,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        heightFactor: _barFactor(complete, expected) * _animation.value,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('W${index + 1}', style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  bool _hasTrueInRange(String habitId, DateTime start, DateTime end) {
    final entries = widget.completionData[habitId];
    if (entries == null || entries.isEmpty) return false;
    return entries.entries.any((e) {
      final key = _normalizeDate(e.key);
      return !key.isBefore(start) && !key.isAfter(end) && e.value == true;
    });
  }

  bool _isWeekExpected(DateTime end) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return !end.isAfter(today);
  }

  double _barFactor(int count, int total) {
    if (total == 0) return 0;
    return count / total;
  }

  List<(DateTime, DateTime)> _weekRanges(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final ranges = <(DateTime, DateTime)>[];
    final starts = [1, 8, 15, 22, 29];
    for (final start in starts) {
      if (start > daysInMonth) continue;
      final end = start == 29 ? daysInMonth : math.min(start + 6, daysInMonth);
      ranges.add((DateTime(month.year, month.month, start), DateTime(month.year, month.month, end)));
    }
    return ranges;
  }
}

class YearlyStackWidget extends StatefulWidget {
  const YearlyStackWidget({
    super.key,
    required this.monthlyHabits,
    required this.completionData,
    required this.selectedYear,
    required this.onYearChanged,
  });

  final List<SelfCareHabit> monthlyHabits;
  final Map<String, Map<DateTime, bool>> completionData;
  final int selectedYear;
  final ValueChanged<int> onYearChanged;

  @override
  State<YearlyStackWidget> createState() => _YearlyStackWidgetState();
}

class _YearlyStackWidgetState extends State<YearlyStackWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant YearlyStackWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedYear != widget.selectedYear) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.monthlyHabits.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: Text('No unlocked monthly habits yet.'),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => widget.onYearChanged(widget.selectedYear - 1),
              icon: const Icon(Icons.chevron_left),
            ),
            Text('${widget.selectedYear}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            IconButton(
              onPressed: () => widget.onYearChanged(widget.selectedYear + 1),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...widget.monthlyHabits.map((habit) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(habit.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 108,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(12, (monthIndex) {
                      final month = monthIndex + 1;
                      final monthDate = DateTime(widget.selectedYear, month);
                      final state = _monthState(habit.id, monthDate);
                      final color = switch (state.$1) {
                        _MonthStatus.future => Colors.grey,
                        _MonthStatus.completed => Colors.green,
                        _MonthStatus.missed => Colors.red,
                        _MonthStatus.none => Colors.grey,
                      };

                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 24,
                              child: Text(
                                state.$2 ?? '',
                                style: const TextStyle(fontSize: 9),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOut,
                              width: 14,
                              height: 62 * _animation.value,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(_monthShort(month), style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  (_MonthStatus, String?) _monthState(String habitId, DateTime monthDate) {
    final now = DateTime.now();
    if (monthDate.year > now.year || (monthDate.year == now.year && monthDate.month > now.month)) {
      return (_MonthStatus.future, null);
    }

    final entries = widget.completionData[habitId] ?? {};
    DateTime? trueDate;
    bool sawFalse = false;
    for (final e in entries.entries) {
      final key = _normalizeDate(e.key);
      if (key.year == monthDate.year && key.month == monthDate.month) {
        if (e.value) {
          trueDate = key;
        } else {
          sawFalse = true;
        }
      }
    }

    if (trueDate != null) {
      return (_MonthStatus.completed, '${trueDate.day} ${_monthShort(trueDate.month)}');
    }
    if (sawFalse) {
      return (_MonthStatus.missed, null);
    }
    return (_MonthStatus.none, null);
  }
}

enum _MonthStatus { future, completed, missed, none }

class LockedHabitsModal extends StatelessWidget {
  const LockedHabitsModal({super.key, required this.lockedHabits});

  final List<SelfCareHabit> lockedHabits;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Locked Routines', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            if (lockedHabits.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('All routines are unlocked.'),
              )
            else
              ...lockedHabits.map((habit) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(habit.title),
                    subtitle: Text('Unlocks in Phase ${habit.requiredPhase}'),
                  )),
          ],
        ),
      ),
    );
  }
}

DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

String _monthLabel(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return months[month - 1];
}

String _monthShort(int month) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return months[month - 1];
}
