import 'dart:math';

enum SpiritualSection { salah, zikr, ilm }

class SpiritualState {
  SpiritualState({
    required this.currentLevel,
    required this.successfulWeeks,
    required this.history,
  });

  int currentLevel; // 1..5
  int successfulWeeks; // 0..4
  final Map<DateTime, SpiritualRecord> history;

  double get levelProgress => successfulWeeks / 4.0;
}

class SpiritualRecord {
  SpiritualRecord({
    this.fajr = false,
    this.zuhr = false,
    this.asr = false,
    this.maghrib = false,
    this.isha = false,
    this.tahajud = false,
    this.sleepZikr = false,
    this.extendedZikr = false,
    this.quran = false,
    this.nahjulBalagha = false,
  });

  bool fajr;
  bool zuhr;
  bool asr;
  bool maghrib;
  bool isha;
  bool tahajud;

  bool sleepZikr;
  bool extendedZikr;

  bool quran;
  bool nahjulBalagha;

  Map<String, dynamic> toJson() {
    return {
      'fajr': fajr,
      'zuhr': zuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
      'tahajud': tahajud,
      'sleepZikr': sleepZikr,
      'extendedZikr': extendedZikr,
      'quran': quran,
      'nahjulBalagha': nahjulBalagha,
    };
  }

  factory SpiritualRecord.fromJson(Map<String, dynamic> json) {
    return SpiritualRecord(
      fajr: json['fajr'] == true,
      zuhr: json['zuhr'] == true,
      asr: json['asr'] == true,
      maghrib: json['maghrib'] == true,
      isha: json['isha'] == true,
      tahajud: json['tahajud'] == true,
      sleepZikr: json['sleepZikr'] == true,
      extendedZikr: json['extendedZikr'] == true,
      quran: json['quran'] == true,
      nahjulBalagha: json['nahjulBalagha'] == true,
    );
  }
}

DateTime normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

List<String> getUnlockedHabits(int level) {
  final safeLevel = min(max(level, 1), 5);
  switch (safeLevel) {
    case 1:
      return const ['fajr', 'sleepZikr'];
    case 2:
      return const ['fajr', 'zuhr', 'maghrib', 'sleepZikr', 'quran'];
    case 3:
      return const ['fajr', 'zuhr', 'asr', 'maghrib', 'sleepZikr', 'quran'];
    case 4:
      return const ['fajr', 'zuhr', 'asr', 'maghrib', 'isha', 'sleepZikr', 'quran'];
    default:
      return const [
        'fajr',
        'zuhr',
        'asr',
        'maghrib',
        'isha',
        'tahajud',
        'sleepZikr',
        'extendedZikr',
        'quran',
        'nahjulBalagha',
      ];
  }
}
