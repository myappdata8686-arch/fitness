import '../models/enums.dart';
import '../models/streak_data.dart';

class StreakEngine {
  const StreakEngine();

  StreakData updateAfterWeek(StreakData current, WeekLabel label) {
    final correctionCount = label == WeekLabel.correction
        ? current.consecutiveCorrectionWeeks + 1
        : 0;

    if (correctionCount >= 2) {
      return const StreakData(integrityStreakWeeks: 0, consecutiveCorrectionWeeks: 2);
    }

    return StreakData(
      integrityStreakWeeks: current.integrityStreakWeeks + 1,
      consecutiveCorrectionWeeks: correctionCount,
    );
  }
}
