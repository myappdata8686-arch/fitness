import 'ultimate_state.dart';

class CalorieEngineResult {
  const CalorieEngineResult({required this.targetCalories, required this.proteinTarget});

  final double targetCalories;
  final double proteinTarget;
}

class CalorieEngine {
  CalorieEngineResult evaluate({
    required bool defenseActive,
    required UltimateMode mode,
    required double bmr,
    required double weight,
  }) {
    final safeBmr = bmr <= 0 ? 1.0 : bmr;
    final safeWeight = weight <= 0 ? 1.0 : weight;

    if (defenseActive) {
      return CalorieEngineResult(targetCalories: safeBmr * 0.95, proteinTarget: safeWeight * 1.8);
    }

    switch (mode) {
      case UltimateMode.stability:
        return CalorieEngineResult(targetCalories: safeBmr, proteinTarget: safeWeight * 1.5);
      case UltimateMode.cut:
        return CalorieEngineResult(targetCalories: safeBmr * 0.93, proteinTarget: safeWeight * 1.8);
      case UltimateMode.build:
        return CalorieEngineResult(targetCalories: safeBmr * 1.07, proteinTarget: safeWeight * 2.0);
    }
  }
}
