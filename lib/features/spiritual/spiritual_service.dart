import 'dart:math';

import 'spiritual_state.dart';

class SpiritualService {
  bool isWeekSuccessful(List<SpiritualRecord> weekRecords, int level) {
    if (weekRecords.isEmpty) return false;

    final unlocked = getUnlockedHabits(level);
    final salahZikr = unlocked
        .where((h) => _salahHabits.contains(h) || _zikrHabits.contains(h))
        .toList();

    final totalRequired = salahZikr.length * 7;
    int completed = 0;
    for (final record in weekRecords.take(7)) {
      for (final habit in salahZikr) {
        if (_habitValue(record, habit)) {
          completed += 1;
        }
      }
    }

    final salahZikrPass =
        totalRequired == 0 ? false : completed >= (totalRequired * 0.8);

    int ilmDays = 0;
    for (final record in weekRecords.take(7)) {
      if (record.quran || record.nahjulBalagha) {
        ilmDays += 1;
      }
    }
    final ilmPass = ilmDays >= 5;

    return salahZikrPass && ilmPass;
  }

  void evaluateAndAdvanceWeek({
    required SpiritualState state,
    required List<SpiritualRecord> weekRecords,
  }) {
    final success = isWeekSuccessful(weekRecords, state.currentLevel);
    if (!success) return;

    state.successfulWeeks += 1;
    if (state.successfulWeeks >= 4) {
      state.currentLevel = min(5, state.currentLevel + 1);
      state.successfulWeeks = 0;
    }
  }

  static const _salahHabits = ['fajr', 'zuhr', 'asr', 'maghrib', 'isha', 'tahajud'];
  static const _zikrHabits = ['sleepZikr', 'extendedZikr'];

  bool _habitValue(SpiritualRecord record, String key) {
    switch (key) {
      case 'fajr':
        return record.fajr;
      case 'zuhr':
        return record.zuhr;
      case 'asr':
        return record.asr;
      case 'maghrib':
        return record.maghrib;
      case 'isha':
        return record.isha;
      case 'tahajud':
        return record.tahajud;
      case 'sleepZikr':
        return record.sleepZikr;
      case 'extendedZikr':
        return record.extendedZikr;
      case 'quran':
        return record.quran;
      case 'nahjulBalagha':
        return record.nahjulBalagha;
      default:
        return false;
    }
  }
}
