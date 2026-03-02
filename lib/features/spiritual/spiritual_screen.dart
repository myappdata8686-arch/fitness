import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'spiritual_gradients.dart';
import 'spiritual_service.dart';
import 'spiritual_state.dart';
import 'widgets/locked_levels_modal.dart';
import '../common/week_view_screen.dart';
import '../../core/app_data.dart';
import 'widgets/spiritual_level_card.dart';

class SpiritualScreen extends StatefulWidget {
  const SpiritualScreen({super.key});

  @override
  State<SpiritualScreen> createState() => _SpiritualScreenState();
}

class _SpiritualScreenState extends State<SpiritualScreen> {
  final SpiritualService _service = SpiritualService();
  final SpiritualState _state = SpiritualState(
    currentLevel: 1,
    successfulWeeks: 0,
    history: {},
  );

  DateTime _selectedDate = normalizeDate(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppData>();
    final unlocked = getUnlockedHabits(_state.currentLevel);
    final shared = app.getOrCreateDailyRecord(_selectedDate);
    final record = shared.spiritual;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () {
            final app = context.read<AppData>();
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => WeekViewScreen(app: app, onOpenDate: (d) => setState(() => _selectedDate = d))));
          },
        ),
        title: const Text('Spiritual'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline),
            onPressed: () => showLockedModal(context, _state.currentLevel),
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(gradient: getLevelGradient(_state.currentLevel)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SpiritualLevelCard(state: _state),
            _dateSelector(context),
            const SizedBox(height: 10),
            _sectionCard(
              title: 'Salah',
              icon: Icons.mosque,
              children: [
                if (unlocked.contains('fajr')) _tile('Fajr', record.fajr, (v) => _saveSpiritualValue(record, app, (r) => r.fajr = v)),
                if (unlocked.contains('zuhr')) _tile('Zuhr', record.zuhr, (v) => _saveSpiritualValue(record, app, (r) => r.zuhr = v)),
                if (unlocked.contains('asr')) _tile('Asr', record.asr, (v) => _saveSpiritualValue(record, app, (r) => r.asr = v)),
                if (unlocked.contains('maghrib')) _tile('Maghrib', record.maghrib, (v) => _saveSpiritualValue(record, app, (r) => r.maghrib = v)),
                if (unlocked.contains('isha')) _tile('Isha', record.isha, (v) => _saveSpiritualValue(record, app, (r) => r.isha = v)),
                if (unlocked.contains('tahajud')) _tile('Tahajud', record.tahajud, (v) => _saveSpiritualValue(record, app, (r) => r.tahajud = v)),
              ],
            ),
            const SizedBox(height: 10),
            _sectionCard(
              title: 'Zikr',
              icon: Icons.nightlight_round,
              children: [
                if (unlocked.contains('sleepZikr')) _tile('Sleep Zikr', record.sleepZikr, (v) => _saveSpiritualValue(record, app, (r) => r.sleepZikr = v)),
                if (unlocked.contains('extendedZikr')) _tile('Extended Zikr', record.extendedZikr, (v) => _saveSpiritualValue(record, app, (r) => r.extendedZikr = v)),
              ],
            ),
            const SizedBox(height: 10),
            _sectionCard(
              title: 'Ilm',
              icon: Icons.menu_book,
              children: [
                if (unlocked.contains('quran')) _tile('Quran', record.quran, (v) => _saveSpiritualValue(record, app, (r) => r.quran = v)),
                if (unlocked.contains('nahjulBalagha')) _tile('Nahjul Balagha', record.nahjulBalagha, (v) => _saveSpiritualValue(record, app, (r) => r.nahjulBalagha = v)),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _evaluateCurrentWeek(app),
              child: const Text('Evaluate Current Week'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateSelector(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Entry Date (Back-entry supported)'),
        subtitle: Text('${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}'),
        trailing: const Icon(Icons.edit_calendar),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            initialDate: _selectedDate,
          );
          if (picked == null) return;
          setState(() => _selectedDate = normalizeDate(picked));
        },
      ),
    );
  }

  Widget _sectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon), const SizedBox(width: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.w700))]),
            const SizedBox(height: 4),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _tile(String label, bool value, ValueChanged<bool> onChanged) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      activeColor: Colors.green,
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _evaluateCurrentWeek(AppData app) {
    final now = normalizeDate(DateTime.now());
    final start = now.subtract(Duration(days: now.weekday - 1));
    final records = List.generate(7, (i) {
      final d = normalizeDate(start.add(Duration(days: i)));
      return app.getOrCreateDailyRecord(d).spiritual;
    });

    setState(() {
      _service.evaluateAndAdvanceWeek(state: _state, weekRecords: records);
    });
  }

  void _saveSpiritualValue(SpiritualRecord record, AppData app, void Function(SpiritualRecord r) setter) {
    setState(() {
      setter(record);
      final daily = app.getOrCreateDailyRecord(_selectedDate);
      daily.spiritual = record;
      app.saveDailyRecord(_selectedDate, daily);
    });
  }
}
