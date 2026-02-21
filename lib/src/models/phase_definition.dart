import 'enums.dart';

class WeeklyMetricWeight {
  const WeeklyMetricWeight({required this.key, required this.weight});

  final String key;
  final double weight;
}

class PhaseDefinition {
  const PhaseDefinition({
    required this.id,
    required this.name,
    required this.metrics,
    required this.allowedStrengthDays,
    required this.requiresManualConfirmation,
    required this.notes,
  });

  final PhaseId id;
  final String name;
  final List<WeeklyMetricWeight> metrics;
  final String allowedStrengthDays;
  final bool requiresManualConfirmation;
  final String notes;
}
