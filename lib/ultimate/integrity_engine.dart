class IntegrityEngine {
  double calculateWeeklyIntegrity({
    required double trainingScore,
    required double nutritionScore,
    required double spiritualScore,
  }) {
    final value = (trainingScore * 0.4) + (nutritionScore * 0.4) + (spiritualScore * 0.2);
    return value.clamp(0.0, 100.0);
  }

  double calculateNutritionScore({
    required double weeklyAvgCalories,
    required double weeklyTarget,
    required int junkCount,
  }) {
    if (weeklyTarget <= 0) return 0;
    final calorieDeviation = (weeklyAvgCalories - weeklyTarget).abs() / weeklyTarget;
    final caloriePenalty = calorieDeviation * 100;
    final junkPenalty = (junkCount - 2) > 0 ? (junkCount - 2) * 10 : 0;
    final score = 100 - (caloriePenalty + junkPenalty);
    return score.clamp(0.0, 100.0);
  }
}
