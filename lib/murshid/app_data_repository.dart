import '../core/app_data.dart';
import 'murshid_context.dart';

class AppDataRepository {
  const AppDataRepository(this.app);

  final AppData app;

  MurshidContext buildContext() {
    final bp = app.systolicBP.isEmpty ? null : app.systolicBP.values.last;
    final eczema = app.eczemaLevel.isEmpty ? null : app.eczemaLevel.values.last;

    return MurshidContext(
      userName: app.userProfile.name ?? 'Athlete',
      currentPhase: app.journey.currentPhase,
      phaseProgress: app.journey.progress,
      spiritualLevel: app.currentSpiritualLevel,
      dayType: app.confirmedDay,
      stress: app.currentStress,
      pain: app.currentPain,
      junkCount: app.junkCount.values.isEmpty ? 0 : app.junkCount.values.last,
      weeklyIntegrity: app.ultimateState?.weeklyIntegrity ?? 0,
      weeklyAvgCalories: app.homeOverview.weeklyAvgCalories,
      bmr: app.currentBMR,
      weight: app.journey.latestWeight,
      bloodPressure: bp,
      eczemaLevel: eczema,
      vertigoActive: app.vertigoActive,
      illnessActive: app.illnessActive,
      streakBroken: app.currentStreak == 0,
      internetAvailable: app.internetAvailable,
      isUltimateUnlocked: app.ultimateState?.isUnlocked ?? false,
      ultimateMode: app.ultimateState?.mode,
      weightZone: app.ultimateState?.weightZone,
      defenseActive: app.ultimateState?.defenseActive ?? false,
      belowFloor: app.ultimateState?.belowFloor ?? false,
      aboveCeiling: app.ultimateState?.aboveCeiling ?? false,
      stabilityMastery: app.ultimateState?.stabilityMastery ?? false,
    );
  }
}
