enum DayColor { green, yellow, red }

enum EnergyLevel { low, medium, high }

enum StressLevel { low, medium, high }

enum PhaseStatus { locked, active, completed }

class DailyCheckInInput {
  const DailyCheckInInput({
    required this.sleep,
    required this.energy,
    required this.stress,
    required this.pain,
    required this.illness,
  });

  final int sleep;
  final EnergyLevel energy;
  final StressLevel stress;
  final int pain;
  final bool illness;
}

class PhysicalPhaseBlueprint {
  const PhysicalPhaseBlueprint({
    required this.id,
    required this.name,
    required this.successCriteria,
    required this.reward,
    required this.requiredWalks,
    required this.requiredStrength,
    required this.allowedJunk,
    required this.greenChecklist,
  });

  final int id;
  final String name;
  final String successCriteria;
  final String reward;
  final int requiredWalks;
  final int requiredStrength;
  final int allowedJunk;
  final List<String> greenChecklist;
}

class PhaseProgress {
  const PhaseProgress({
    required this.currentPhase,
    required this.weekInPhase,
    required this.successfulWeeks,
    required this.totalWeeks,
    required this.weightKg,
    required this.waistInches,
    required this.manualUnlockPhase1,
  });

  final int currentPhase;
  final int weekInPhase;
  final int successfulWeeks;
  final int totalWeeks;
  final double weightKg;
  final double waistInches;
  final bool manualUnlockPhase1;
}
