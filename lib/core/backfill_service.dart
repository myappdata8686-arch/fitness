import 'daily_record.dart';
import '../features/physical/physical_screen.dart';

class BackfillService {
  bool canEditDate(DateTime date) {
    final today = dateOnly(DateTime.now());
    final difference = today.difference(dateOnly(date)).inDays;
    return difference >= 0 && difference <= 7;
  }

  bool isDayValid(DailyRecord record) {
    return _ritualValid(record) || _spiritualValid(record) || _selfCareValid(record);
  }

  int calculateStreak(Map<DateTime, DailyRecord> dailyHistory) {
    var streak = 0;
    var day = dateOnly(DateTime.now());
    while (true) {
      final rec = dailyHistory[day];
      if (rec == null || !isDayValid(rec)) break;
      streak += 1;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  void recalculateChronologically(
    Map<DateTime, DailyRecord> dailyHistory,
    void Function(DailyRecord rec) applyRecord,
  ) {
    final keys = dailyHistory.keys.toList()..sort();
    for (final key in keys) {
      applyRecord(dailyHistory[key]!);
    }
  }

  bool _ritualValid(DailyRecord r) {
    return r.ritual.dayType != DayType.none && r.ritual.hasTrainingBlock;
  }

  bool _spiritualValid(DailyRecord r) {
    final s = r.spiritual;
    return s.fajr || s.zuhr || s.asr || s.maghrib || s.isha || s.tahajud || s.sleepZikr || s.extendedZikr || s.quran || s.nahjulBalagha;
  }

  bool _selfCareValid(DailyRecord r) {
    return r.selfCare.habits.values.any((v) => v);
  }
}
