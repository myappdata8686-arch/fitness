import '../features/physical/physical_screen.dart';
import '../ultimate/ultimate_state.dart';
import '../ultimate/weight_zone.dart';

class MurshidContext {
  const MurshidContext({
    required this.userName,
    required this.currentPhase,
    required this.phaseProgress,
    required this.spiritualLevel,
    required this.dayType,
    required this.stress,
    required this.pain,
    required this.junkCount,
    required this.weeklyIntegrity,
    required this.weeklyAvgCalories,
    required this.bmr,
    required this.weight,
    required this.bloodPressure,
    required this.eczemaLevel,
    required this.vertigoActive,
    required this.illnessActive,
    required this.streakBroken,
    required this.internetAvailable,
    required this.isUltimateUnlocked,
    required this.ultimateMode,
    required this.weightZone,
    required this.defenseActive,
    required this.belowFloor,
    required this.aboveCeiling,
    required this.stabilityMastery,
  });

  final String userName;
  final int currentPhase;
  final double phaseProgress;
  final double spiritualLevel;
  final DayType dayType;
  final int stress;
  final int pain;
  final int junkCount;
  final double weeklyIntegrity;
  final double weeklyAvgCalories;
  final double bmr;
  final double weight;
  final double? bloodPressure;
  final int? eczemaLevel;
  final bool vertigoActive;
  final bool illnessActive;
  final bool streakBroken;
  final bool internetAvailable;

  final bool isUltimateUnlocked;
  final UltimateMode? ultimateMode;
  final WeightZone? weightZone;
  final bool defenseActive;
  final bool belowFloor;
  final bool aboveCeiling;
  final bool stabilityMastery;
}
