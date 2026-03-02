import '../daily_record.dart';
import 'storage_engine.dart';

class CalendarRepository {
  CalendarRepository(this.storage);

  final StorageEngine storage;

  static const String _indexKey = 'calendar_index';

  String _dayKey(DateTime date) => dateOnly(date).toIso8601String();

  Future<void> saveDayEntry(DateTime date, DailyRecord log) async {
    final key = _dayKey(date);
    await storage.saveCalendar(key, log.toJson());

    final dates = await _readIndex();
    final normalized = key;
    if (!dates.contains(normalized)) {
      dates.add(normalized);
      await storage.saveCalendar(_indexKey, dates);
    }
  }

  Future<DailyRecord?> getDayEntry(DateTime date) async {
    final data = await storage.readCalendar(_dayKey(date));
    if (data is Map) {
      return DailyRecord.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<List<DailyRecord>> getEntriesForMonth(int year, int month) async {
    final all = await _readAll();
    return all.where((entry) => entry.date.year == year && entry.date.month == month).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<List<DailyRecord>> getEntriesForRange(DateTime from, DateTime to) async {
    final start = dateOnly(from);
    final end = dateOnly(to);
    final all = await _readAll();
    return all.where((entry) {
      final d = dateOnly(entry.date);
      return !d.isBefore(start) && !d.isAfter(end);
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  Future<List<DailyRecord>> _readAll() async {
    final dates = await _readIndex();
    final records = <DailyRecord>[];

    for (final dateIso in dates) {
      final raw = await storage.readCalendar(dateIso);
      if (raw is Map) {
        records.add(DailyRecord.fromJson(Map<String, dynamic>.from(raw)));
      }
    }

    return records;
  }

  Future<List<String>> _readIndex() async {
    final raw = await storage.readCalendar(_indexKey);
    if (raw is List<String>) {
      return List<String>.from(raw);
    }
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return <String>[];
  }
}
