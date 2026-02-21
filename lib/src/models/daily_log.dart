import 'enums.dart';

class MorningCheckIn {
  const MorningCheckIn({
    required this.sleepQuality,
    required this.stress,
    required this.pain,
    required this.energy,
    this.bloodPressure,
  });

  final int sleepQuality;
  final StressLevel stress;
  final int pain;
  final EnergyLevel energy;
  final String? bloodPressure;
}

class DailyLog {
  const DailyLog({
    required this.date,
    required this.phase,
    required this.dayColor,
    required this.walkingMinutes,
    required this.strengthDone,
    required this.mobilityDone,
    required this.proteinIncluded,
    required this.junkConsumed,
    required this.sleepHours,
    required this.mood,
    this.bloodPressure,
  });

  final DateTime date;
  final DayColor dayColor;
  final int walkingMinutes;
  final bool strengthDone;
  final bool mobilityDone;
  final bool proteinIncluded;
  final bool junkConsumed;
  final double sleepHours;
  final String mood;
  final String? bloodPressure;
  final PhaseId phase;
}
