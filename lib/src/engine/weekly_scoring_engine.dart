import '../models/weekly_score.dart';
import '../models/enums.dart';
import '../models/phase_definition.dart';

class WeeklyScoringEngine {
  const WeeklyScoringEngine();

  WeeklyScore compute({
    required PhaseDefinition phase,
    required Map<String, bool> completion,
    required bool illnessTravelOrStressFlag,
    required bool floorViolation,
    required bool ceilingViolation,
  }) {
    final metrics = phase.metrics
        .map(
          (m) => WeeklyMetricResult(
            key: m.key,
            weight: m.weight,
            completed: completion[m.key] ?? false,
          ),
        )
        .toList();

    var rawScore = metrics.fold<double>(0, (sum, metric) => sum + metric.contribution);
    if (floorViolation || ceilingViolation) {
      rawScore = rawScore > 75 ? 75 : rawScore;
    }

    final adaptive = illnessTravelOrStressFlag;
    final threshold = adaptive ? 70.0 : 80.0;

    return WeeklyScore(
      value: rawScore,
      label: _resolveLabel(rawScore, threshold: threshold, adaptive: adaptive),
      adaptive: adaptive,
      floorViolation: floorViolation,
      ceilingViolation: ceilingViolation,
      metrics: metrics,
    );
  }

  WeekLabel _resolveLabel(double score, {required double threshold, required bool adaptive}) {
    if (adaptive && score >= threshold) {
      return WeekLabel.adaptive;
    }
    if (score >= 90) return WeekLabel.progressive;
    if (score >= 80) return WeekLabel.stable;
    if (score >= 70) return WeekLabel.maintenance;
    return WeekLabel.correction;
  }
}
