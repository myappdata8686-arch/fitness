import 'enums.dart';

class WeeklyMetricResult {
  const WeeklyMetricResult({
    required this.key,
    required this.weight,
    required this.completed,
  });

  final String key;
  final double weight;
  final bool completed;

  double get contribution => completed ? weight : 0;
}

class WeeklyScore {
  const WeeklyScore({
    required this.value,
    required this.label,
    required this.adaptive,
    required this.floorViolation,
    required this.ceilingViolation,
    required this.metrics,
  });

  final double value;
  final WeekLabel label;
  final bool adaptive;
  final bool floorViolation;
  final bool ceilingViolation;
  final List<WeeklyMetricResult> metrics;
}
