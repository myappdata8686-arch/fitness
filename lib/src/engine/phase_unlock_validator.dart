import '../models/enums.dart';

class PhaseUnlockValidator {
  const PhaseUnlockValidator();

  bool canUnlockNextPhase({
    required List<WeekLabel> recentWeekLabels,
    required bool hasCeilingViolation,
    required bool userConfirmed,
    required bool phaseMetricsComplete,
  }) {
    if (recentWeekLabels.length < 3) return false;

    final lastThree = recentWeekLabels.sublist(recentWeekLabels.length - 3);
    final stableOrBetter = lastThree.every(
      (label) => label == WeekLabel.stable || label == WeekLabel.progressive || label == WeekLabel.adaptive,
    );

    return stableOrBetter &&
        !hasCeilingViolation &&
        userConfirmed &&
        phaseMetricsComplete;
  }
}
