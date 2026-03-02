import 'weight_zone.dart';

enum UltimateMode { stability, cut, build }

UltimateMode ultimateModeFromName(String? value) {
  return UltimateMode.values.firstWhere(
    (mode) => mode.name == value,
    orElse: () => UltimateMode.stability,
  );
}

class UltimateState {
  const UltimateState({
    required this.isUnlocked,
    required this.mode,
    required this.weightZone,
    required this.defenseActive,
    required this.weeklyIntegrity,
    required this.belowFloor,
    required this.aboveCeiling,
    required this.stabilityMastery,
    required this.targetCalories,
    required this.proteinTarget,
    required this.buildDiscouraged,
    required this.cutDisabled,
    required this.minWalkingDays,
    required this.minStrengthDays,
    required this.maxJunkCount,
  });

  final bool isUnlocked;
  final UltimateMode mode;
  final WeightZone weightZone;
  final bool defenseActive;
  final double weeklyIntegrity;
  final bool belowFloor;
  final bool aboveCeiling;
  final bool stabilityMastery;

  final double targetCalories;
  final double proteinTarget;

  final bool buildDiscouraged;
  final bool cutDisabled;

  final int minWalkingDays;
  final int minStrengthDays;
  final int maxJunkCount;

  Map<String, dynamic> toJson() {
    return {
      'isUnlocked': isUnlocked,
      'mode': mode.name,
      'weightZone': weightZone.name,
      'defenseActive': defenseActive,
      'weeklyIntegrity': weeklyIntegrity,
      'belowFloor': belowFloor,
      'aboveCeiling': aboveCeiling,
      'stabilityMastery': stabilityMastery,
      'targetCalories': targetCalories,
      'proteinTarget': proteinTarget,
      'buildDiscouraged': buildDiscouraged,
      'cutDisabled': cutDisabled,
      'minWalkingDays': minWalkingDays,
      'minStrengthDays': minStrengthDays,
      'maxJunkCount': maxJunkCount,
    };
  }

  factory UltimateState.fromJson(Map<String, dynamic> json) {
    return UltimateState(
      isUnlocked: json['isUnlocked'] == true,
      mode: ultimateModeFromName(json['mode'] as String?),
      weightZone: weightZoneFromName(json['weightZone'] as String?),
      defenseActive: json['defenseActive'] == true,
      weeklyIntegrity: (json['weeklyIntegrity'] as num?)?.toDouble() ?? 0,
      belowFloor: json['belowFloor'] == true,
      aboveCeiling: json['aboveCeiling'] == true,
      stabilityMastery: json['stabilityMastery'] == true,
      targetCalories: (json['targetCalories'] as num?)?.toDouble() ?? 0,
      proteinTarget: (json['proteinTarget'] as num?)?.toDouble() ?? 0,
      buildDiscouraged: json['buildDiscouraged'] == true,
      cutDisabled: json['cutDisabled'] == true,
      minWalkingDays: json['minWalkingDays'] as int? ?? 3,
      minStrengthDays: json['minStrengthDays'] as int? ?? 2,
      maxJunkCount: json['maxJunkCount'] as int? ?? 2,
    );
  }
}
