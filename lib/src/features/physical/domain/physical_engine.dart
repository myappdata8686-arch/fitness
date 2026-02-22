import 'phase_blueprints.dart';
import 'physical_models.dart';

class PhysicalEngine {
  const PhysicalEngine();

  DayColor evaluateColor(DailyCheckInInput input) {
    if (input.pain >= 2 || input.sleep <= 2 || input.illness) {
      return DayColor.red;
    }

    final bool moderate =
        input.sleep == 3 ||
        input.energy == EnergyLevel.medium ||
        input.energy == EnergyLevel.low ||
        input.stress == StressLevel.medium ||
        input.stress == StressLevel.high ||
        input.pain == 1;

    if (moderate) {
      return DayColor.yellow;
    }

    return DayColor.green;
  }

  List<String> checklistFor({required int phaseId, required DayColor color}) {
    if (color == DayColor.red) return redProtocol;
    if (color == DayColor.yellow) return yellowProtocol;
    return phaseBlueprints.firstWhere((p) => p.id == phaseId).greenChecklist;
  }

  int resolveNextPhase(PhaseProgress progress) {
    switch (progress.currentPhase) {
      case 0:
        if (progress.totalWeeks >= 8 || (progress.totalWeeks >= 6 && progress.manualUnlockPhase1)) {
          return 1;
        }
        return 0;
      case 1:
        return progress.weightKg <= 93 ? 2 : 1;
      case 2:
        return progress.totalWeeks >= 8 ? 3 : 2;
      case 3:
        return (progress.weightKg <= 83 || progress.waistInches <= 34) ? 4 : 3;
      case 4:
        return 4;
      default:
        return progress.currentPhase;
    }
  }

  int calculateWeeklyIntegrity({
    required int completedWalks,
    required int completedStrength,
    required int junkCount,
    required int mobilityDays,
    required PhysicalPhaseBlueprint blueprint,
  }) {
    final int walkScore = _ratioScore(completedWalks, blueprint.requiredWalks);
    final int strengthScore = _ratioScore(completedStrength, blueprint.requiredStrength);
    final int junkScore = junkCount <= blueprint.allowedJunk ? 100 : 60;
    final int mobilityScore = _ratioScore(mobilityDays, 7);

    return ((walkScore + strengthScore + junkScore + mobilityScore) / 4).round();
  }

  int _ratioScore(int value, int target) {
    if (target == 0) return 100;
    final double ratio = value / target;
    if (ratio >= 1) return 100;
    return (ratio * 100).round().clamp(0, 100);
  }
}
