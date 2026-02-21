import 'package:flutter_test/flutter_test.dart';

import 'package:athletic_for_life/src/data/phase_catalog.dart';
import 'package:athletic_for_life/src/engine/day_color_engine.dart';
import 'package:athletic_for_life/src/engine/phase_unlock_validator.dart';
import 'package:athletic_for_life/src/engine/weekly_scoring_engine.dart';
import 'package:athletic_for_life/src/models/daily_log.dart';
import 'package:athletic_for_life/src/models/enums.dart';

void main() {
  test('day color engine returns red for high risk', () {
    const engine = DayColorEngine();
    const checkIn = MorningCheckIn(
      sleepQuality: 1,
      stress: StressLevel.high,
      pain: 3,
      energy: EnergyLevel.low,
    );

    expect(engine.suggestColor(checkIn), DayColor.red);
  });

  test('weekly scoring returns stable label at 80+', () {
    const scoring = WeeklyScoringEngine();

    final score = scoring.compute(
      phase: PhaseCatalog.phase1,
      completion: {
        'strength2x': true,
        'walkingFrequency': true,
        'proteinConsistency': true,
        'junkMax2Days': true,
        'mobility': false,
        'portionAwareness': true,
      },
      illnessTravelOrStressFlag: false,
      floorViolation: false,
      ceilingViolation: false,
    );

    expect(score.value, 85);
    expect(score.label, WeekLabel.stable);
  });

  test('phase unlock requires three stable+ weeks and manual confirmation', () {
    const validator = PhaseUnlockValidator();

    final result = validator.canUnlockNextPhase(
      recentWeekLabels: [WeekLabel.stable, WeekLabel.progressive, WeekLabel.stable],
      hasCeilingViolation: false,
      userConfirmed: true,
      phaseMetricsComplete: true,
    );

    expect(result, isTrue);
  });
}
