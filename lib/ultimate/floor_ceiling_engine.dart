class FloorCeilingFlags {
  const FloorCeilingFlags({required this.belowFloor, required this.aboveCeiling});
  final bool belowFloor;
  final bool aboveCeiling;
}

class FloorCeilingEngine {
  FloorCeilingFlags evaluate({
    required int walkingDays,
    required int strengthDays,
    required int junkCount,
    required double weeklyIntegrity,
    required double weeklyAvgCalories,
    required double targetCalories,
  }) {
    final calorieDeviationPct = targetCalories <= 0 ? 100.0 : ((weeklyAvgCalories - targetCalories).abs() / targetCalories) * 100;

    final belowFloor = walkingDays < 3 || strengthDays < 2 || junkCount > 2 || weeklyIntegrity < 65;
    final aboveCeiling = junkCount > 3 || calorieDeviationPct > 15 || weeklyIntegrity < 60;
    return FloorCeilingFlags(belowFloor: belowFloor, aboveCeiling: aboveCeiling);
  }
}
