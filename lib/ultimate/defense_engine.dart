import 'weight_zone.dart';

class DefenseEngine {
  bool resolveDefense({
    required double weight,
    required double weeklyIntegrity,
    required bool twoWeekLowIntegrity,
    required bool twoWeekStableIntegrity,
    required bool currentlyActive,
  }) {
    final shouldActivate = weight >= defenseThreshold || (weight >= earlyWarningMax && weeklyIntegrity < 60 && twoWeekLowIntegrity);
    final shouldDeactivate = weight <= earlyWarningMax && weeklyIntegrity >= 70 && twoWeekStableIntegrity;

    if (shouldActivate) {
      return true;
    }
    if (shouldDeactivate) {
      return false;
    }
    return currentlyActive;
  }
}
