import '../features/physical/physical_screen.dart';
import '../features/spiritual/spiritual_state.dart';

DayType _dayTypeFromName(String? value) {
  return DayType.values.firstWhere(
    (dayType) => dayType.name == value,
    orElse: () => DayType.none,
  );
}

class RitualData {
  RitualData({
    this.dayType = DayType.none,
    this.hasTrainingBlock = false,
    this.hasMealLogged = false,
  });

  DayType dayType;
  bool hasTrainingBlock;
  bool hasMealLogged;

  Map<String, dynamic> toJson() {
    return {
      'dayType': dayType.name,
      'hasTrainingBlock': hasTrainingBlock,
      'hasMealLogged': hasMealLogged,
    };
  }

  factory RitualData.fromJson(Map<String, dynamic> json) {
    return RitualData(
      dayType: _dayTypeFromName(json['dayType'] as String?),
      hasTrainingBlock: json['hasTrainingBlock'] == true,
      hasMealLogged: json['hasMealLogged'] == true,
    );
  }
}

class HealthData {
  HealthData({
    this.systolic,
    this.eczemaLevel,
    this.allergyLevel,
    this.weightKg,
  });

  double? systolic;
  int? eczemaLevel;
  int? allergyLevel;
  double? weightKg;

  Map<String, dynamic> toJson() {
    return {
      'systolic': systolic,
      'eczemaLevel': eczemaLevel,
      'allergyLevel': allergyLevel,
      'weightKg': weightKg,
    };
  }

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      systolic: (json['systolic'] as num?)?.toDouble(),
      eczemaLevel: json['eczemaLevel'] as int?,
      allergyLevel: json['allergyLevel'] as int?,
      weightKg: (json['weightKg'] as num?)?.toDouble(),
    );
  }
}

class SelfCareData {
  SelfCareData({Map<String, bool>? habits}) : habits = habits ?? {};

  final Map<String, bool> habits;

  Map<String, dynamic> toJson() => {'habits': habits};

  factory SelfCareData.fromJson(Map<String, dynamic> json) {
    final habitsRaw = Map<String, dynamic>.from(json['habits'] as Map? ?? const {});
    return SelfCareData(
      habits: habitsRaw.map((key, value) => MapEntry(key, value == true)),
    );
  }
}

class DailyRecord {
  DailyRecord({
    required this.date,
    required this.ritual,
    required this.spiritual,
    required this.health,
    required this.selfCare,
    this.isBackfilled = false,
  });

  final DateTime date;
  RitualData ritual;
  SpiritualRecord spiritual;
  HealthData health;
  SelfCareData selfCare;
  bool isBackfilled;

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'ritual': ritual.toJson(),
      'spiritual': spiritual.toJson(),
      'health': health.toJson(),
      'selfCare': selfCare.toJson(),
      'isBackfilled': isBackfilled,
    };
  }

  factory DailyRecord.fromJson(Map<String, dynamic> json) {
    return DailyRecord(
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      ritual: RitualData.fromJson(Map<String, dynamic>.from(json['ritual'] as Map? ?? const {})),
      spiritual: SpiritualRecord.fromJson(Map<String, dynamic>.from(json['spiritual'] as Map? ?? const {})),
      health: HealthData.fromJson(Map<String, dynamic>.from(json['health'] as Map? ?? const {})),
      selfCare: SelfCareData.fromJson(Map<String, dynamic>.from(json['selfCare'] as Map? ?? const {})),
      isBackfilled: json['isBackfilled'] == true,
    );
  }
}

DateTime dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
