import 'package:flutter/material.dart';

import '../../core/app_data.dart';
import '../../core/daily_record.dart';
import '../physical/physical_screen.dart';

class WeekViewScreen extends StatelessWidget {
  const WeekViewScreen({
    super.key,
    required this.app,
    required this.onOpenDate,
  });

  final AppData app;
  final ValueChanged<DateTime> onOpenDate;

  @override
  Widget build(BuildContext context) {
    final now = dateOnly(DateTime.now());
    final monday = now.subtract(Duration(days: now.weekday - 1));

    return Scaffold(
      appBar: AppBar(title: const Text('Week View')),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 4,
        children: List.generate(7, (i) {
          final d = dateOnly(monday.add(Duration(days: i)));
          final rec = app.dailyHistory[d];
          final editable = app.canEditDate(d);
          final hasBackfill = rec?.isBackfilled ?? false;
          final dayColor = switch (rec?.ritual.dayType ?? DayType.none) {
            DayType.red => Colors.red,
            DayType.yellow => Colors.amber,
            DayType.green => Colors.green,
            DayType.none => Colors.grey,
          };
          return GestureDetector(
            onTap: () {
              onOpenDate(d);
              Navigator.pop(context);
            },
            child: Tooltip(
              message: editable ? (hasBackfill ? 'Added later' : 'Editable') : 'Past entries locked',
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: hasBackfill ? Colors.lightBlueAccent : Colors.white12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i]),
                      const SizedBox(height: 4),
                      Text('${d.day}'),
                      const SizedBox(height: 6),
                      CircleAvatar(radius: 5, backgroundColor: dayColor),
                      if (hasBackfill) const Padding(padding: EdgeInsets.only(top: 4), child: Text('⏳')),
                      if (!editable) const Icon(Icons.lock, size: 14),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
