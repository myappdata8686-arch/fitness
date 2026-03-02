import 'package:hive/hive.dart';

import '../../core/app_data.dart';

abstract class JourneyStorage {
  Future<JourneySnapshot?> loadJourneyState();
  Future<void> saveJourneyState(JourneySnapshot snapshot);
}

class InMemoryJourneyStorage implements JourneyStorage {
  JourneySnapshot? _snapshot;

  @override
  Future<JourneySnapshot?> loadJourneyState() async => _snapshot;

  @override
  Future<void> saveJourneyState(JourneySnapshot snapshot) async {
    _snapshot = snapshot;
  }
}

class HiveJourneyStorage implements JourneyStorage {
  HiveJourneyStorage({this.boxName = 'journey_box'});

  final String boxName;

  @override
  Future<JourneySnapshot?> loadJourneyState() async {
    if (!Hive.isBoxOpen(boxName)) await Hive.openBox(boxName);
    final box = Hive.box(boxName);
    final m = box.get('snapshot');
    if (m is! Map) return null;

    return JourneySnapshot(
      currentPhase: m['currentPhase'] as int? ?? 0,
      phaseStartDate: DateTime.tryParse(m['phaseStartDate'] as String? ?? '') ?? DateTime.now(),
      phaseStartWeight: (m['phaseStartWeight'] as num?)?.toDouble() ?? 0,
      phaseStartWaist: (m['phaseStartWaist'] as num?)?.toDouble() ?? 0,
      latestWeight: (m['latestWeight'] as num?)?.toDouble() ?? 0,
      latestWaist: (m['latestWaist'] as num?)?.toDouble() ?? 0,
      stableWeeks: m['stableWeeks'] as int? ?? 0,
      stableMonths: m['stableMonths'] as int? ?? 0,
      disciplineCredits: m['disciplineCredits'] as int? ?? 0,
      majorCredits: m['majorCredits'] as int? ?? 0,
      calorieCounterUnlocked: m['calorieCounterUnlocked'] as bool? ?? false,
      macroTrackingUnlocked: m['macroTrackingUnlocked'] as bool? ?? false,
      foodFeelUnlocked: m['foodFeelUnlocked'] as bool? ?? false,
      ultimateUnlocked: m['ultimateUnlocked'] as bool? ?? false,
      defenceModeActive: m['defenceModeActive'] as bool? ?? false,
      bodybuildingMode: _decodeMode(m['bodybuildingMode'] as String?),
      allowManualAdvance: m['allowManualAdvance'] as bool? ?? false,
      progress: (m['progress'] as num?)?.toDouble() ?? 0,
      defenceAbove83Weeks: m['defenceAbove83Weeks'] as int? ?? 0,
      defenceBelow80Weeks: m['defenceBelow80Weeks'] as int? ?? 0,
      bodybuildingCycleWeeks: m['bodybuildingCycleWeeks'] as int? ?? 0,
    );
  }

  @override
  Future<void> saveJourneyState(JourneySnapshot s) async {
    if (!Hive.isBoxOpen(boxName)) await Hive.openBox(boxName);
    final box = Hive.box(boxName);
    await box.put('snapshot', {
      'currentPhase': s.currentPhase,
      'phaseStartDate': s.phaseStartDate.toIso8601String(),
      'phaseStartWeight': s.phaseStartWeight,
      'phaseStartWaist': s.phaseStartWaist,
      'latestWeight': s.latestWeight,
      'latestWaist': s.latestWaist,
      'stableWeeks': s.stableWeeks,
      'stableMonths': s.stableMonths,
      'disciplineCredits': s.disciplineCredits,
      'majorCredits': s.majorCredits,
      'calorieCounterUnlocked': s.calorieCounterUnlocked,
      'macroTrackingUnlocked': s.macroTrackingUnlocked,
      'foodFeelUnlocked': s.foodFeelUnlocked,
      'ultimateUnlocked': s.ultimateUnlocked,
      'defenceModeActive': s.defenceModeActive,
      'bodybuildingMode': _encodeMode(s.bodybuildingMode),
      'allowManualAdvance': s.allowManualAdvance,
      'progress': s.progress,
      'defenceAbove83Weeks': s.defenceAbove83Weeks,
      'defenceBelow80Weeks': s.defenceBelow80Weeks,
      'bodybuildingCycleWeeks': s.bodybuildingCycleWeeks,
    });
  }

  static BodybuildingMode? _decodeMode(String? value) {
    switch (value) {
      case 'cut':
        return BodybuildingMode.cut;
      case 'build':
        return BodybuildingMode.build;
      default:
        return null;
    }
  }

  static String? _encodeMode(BodybuildingMode? mode) {
    switch (mode) {
      case BodybuildingMode.cut:
        return 'cut';
      case BodybuildingMode.build:
        return 'build';
      case null:
        return null;
    }
  }
}

class JourneySnapshot {
  JourneySnapshot({
    required this.currentPhase,
    required this.phaseStartDate,
    required this.phaseStartWeight,
    required this.phaseStartWaist,
    required this.latestWeight,
    required this.latestWaist,
    required this.stableWeeks,
    required this.stableMonths,
    required this.disciplineCredits,
    required this.majorCredits,
    required this.calorieCounterUnlocked,
    required this.macroTrackingUnlocked,
    required this.foodFeelUnlocked,
    required this.ultimateUnlocked,
    required this.defenceModeActive,
    required this.bodybuildingMode,
    required this.allowManualAdvance,
    required this.progress,
    required this.defenceAbove83Weeks,
    required this.defenceBelow80Weeks,
    required this.bodybuildingCycleWeeks,
  });

  final int currentPhase;
  final DateTime phaseStartDate;
  final double phaseStartWeight;
  final double phaseStartWaist;
  final double latestWeight;
  final double latestWaist;
  final int stableWeeks;
  final int stableMonths;
  final int disciplineCredits;
  final int majorCredits;
  final bool calorieCounterUnlocked;
  final bool macroTrackingUnlocked;
  final bool foodFeelUnlocked;
  final bool ultimateUnlocked;
  final bool defenceModeActive;
  final BodybuildingMode? bodybuildingMode;
  final bool allowManualAdvance;
  final double progress;
  final int defenceAbove83Weeks;
  final int defenceBelow80Weeks;
  final int bodybuildingCycleWeeks;
}
