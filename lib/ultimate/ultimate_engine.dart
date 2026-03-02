import 'calorie_engine.dart';
import 'defense_engine.dart';
import 'floor_ceiling_engine.dart';
import 'integrity_engine.dart';
import 'mastery_engine.dart';
import 'ultimate_state.dart';
import 'weight_zone.dart';

class UltimateEngine {
  UltimateEngine({
    IntegrityEngine? integrityEngine,
    CalorieEngine? calorieEngine,
    FloorCeilingEngine? floorCeilingEngine,
    DefenseEngine? defenseEngine,
    MasteryEngine? masteryEngine,
  })  : _integrityEngine = integrityEngine ?? IntegrityEngine(),
        _calorieEngine = calorieEngine ?? CalorieEngine(),
        _floorCeilingEngine = floorCeilingEngine ?? FloorCeilingEngine(),
        _defenseEngine = defenseEngine ?? DefenseEngine(),
        _masteryEngine = masteryEngine ?? MasteryEngine();

  final IntegrityEngine _integrityEngine;
  final CalorieEngine _calorieEngine;
  final FloorCeilingEngine _floorCeilingEngine;
  final DefenseEngine _defenseEngine;
  final MasteryEngine _masteryEngine;

  UltimateState evaluate({
    required bool isUnlocked,
    required UltimateMode requestedMode,
    required bool currentlyDefenseActive,
    required int masteryWeeksInRange,
    required double weight,
    required double bmr,
    required double weeklyAvgCalories,
    required int junkCount,
    required double trainingScore,
    required double spiritualScore,
    required int walkingDays,
    required int strengthDays,
    required bool twoWeekLowIntegrity,
    required bool twoWeekStableIntegrity,
  }) {
    final zone = resolveWeightZone(weight);

    final nutritionForIntegrity = _integrityEngine.calculateNutritionScore(
      weeklyAvgCalories: weeklyAvgCalories,
      weeklyTarget: bmr,
      junkCount: junkCount,
    );

    final integrity = _integrityEngine.calculateWeeklyIntegrity(
      trainingScore: trainingScore,
      nutritionScore: nutritionForIntegrity,
      spiritualScore: spiritualScore,
    );

    var defense = _defenseEngine.resolveDefense(
      weight: weight,
      weeklyIntegrity: integrity,
      twoWeekLowIntegrity: twoWeekLowIntegrity,
      twoWeekStableIntegrity: twoWeekStableIntegrity,
      currentlyActive: currentlyDefenseActive,
    );

    if (zone == WeightZone.defenseZone) {
      defense = true;
    }

    final cutDisabled = zone == WeightZone.leanVisit;
    final buildDiscouraged = zone == WeightZone.earlyWarning;

    var mode = requestedMode;
    if (defense) {
      mode = UltimateMode.stability;
    } else if (cutDisabled && mode == UltimateMode.cut) {
      mode = UltimateMode.stability;
    }

    final calories = _calorieEngine.evaluate(
      defenseActive: defense,
      mode: mode,
      bmr: bmr,
      weight: weight,
    );

    final flags = _floorCeilingEngine.evaluate(
      walkingDays: walkingDays,
      strengthDays: strengthDays,
      junkCount: junkCount,
      weeklyIntegrity: integrity,
      weeklyAvgCalories: weeklyAvgCalories,
      targetCalories: calories.targetCalories,
    );

    final mastery = _masteryEngine.resolveMastery(
      zone: zone,
      weeklyIntegrity: integrity,
      junkCount: junkCount,
      consecutiveWeeks: masteryWeeksInRange,
    );

    return UltimateState(
      isUnlocked: isUnlocked,
      mode: mode,
      weightZone: zone,
      defenseActive: defense,
      weeklyIntegrity: integrity,
      belowFloor: flags.belowFloor,
      aboveCeiling: flags.aboveCeiling,
      stabilityMastery: mastery,
      targetCalories: calories.targetCalories,
      proteinTarget: calories.proteinTarget,
      buildDiscouraged: buildDiscouraged,
      cutDisabled: cutDisabled,
      minWalkingDays: defense ? 4 : 3,
      minStrengthDays: 2,
      maxJunkCount: defense ? 1 : 2,
    );
  }
}
