import '../../murshid/murshid_relationship_engine.dart';
import '../../ultimate/ultimate_engine.dart';
import '../../ultimate/ultimate_state.dart';
import '../../ultimate/weight_zone.dart';
import 'app_event.dart';
import 'app_state.dart';

class RecalculationPipeline {
  RecalculationPipeline._();

  static final UltimateEngine _ultimateEngine = UltimateEngine();

  static AppState process(AppState current, AppEvent event) {
    var updated = current;

    switch (event.type) {
      case AppEventType.ritualUpdated:
        updated = _updateRitual(updated, event.payload);
        updated = _recalculateUltimate(updated);
        updated = _updateMurshidContext(updated);
        updated = _updateTrends(updated);
        break;
      case AppEventType.spiritualUpdated:
        updated = _updateSpiritual(updated, event.payload);
        updated = _recalculateUltimate(updated);
        updated = _updateMurshidContext(updated);
        break;
      case AppEventType.healthUpdated:
        updated = _updateHealth(updated, event.payload);
        updated = _updateMurshidContext(updated);
        break;
      case AppEventType.journeyUpdated:
        updated = _updateJourney(updated, event.payload);
        updated = _recalculateUltimate(updated);
        break;
      case AppEventType.weekClosed:
        updated = _recalculateUltimate(updated);
        updated = _evaluateDefense(updated);
        updated = _evaluateMastery(updated);
        updated = _updateMurshidContext(updated);
        updated = _updateTrends(updated);
        break;
      case AppEventType.daySelected:
      case AppEventType.manualRecalculate:
        updated = _recalculateUltimate(updated);
        updated = _updateMurshidContext(updated);
        updated = _updateTrends(updated);
        break;
    }

    return updated.copyWith(lastUpdated: DateTime.now());
  }

  static AppState _updateRitual(AppState state, dynamic payload) {
    final map = payload is Map<String, dynamic> ? payload : const <String, dynamic>{};
    return state.copyWith(
      ritual: state.ritual.copyWith(
        walkingDays: map['walkingDays'] as int?,
        strengthDays: map['strengthDays'] as int?,
        junkCount: map['junkCount'] as int?,
        weeklyAverageCalories: (map['weeklyAverageCalories'] as num?)?.toDouble(),
        trainingScore: (map['trainingScore'] as num?)?.toDouble(),
      ),
    );
  }

  static AppState _updateSpiritual(AppState state, dynamic payload) {
    final map = payload is Map<String, dynamic> ? payload : const <String, dynamic>{};
    return state.copyWith(
      spiritual: state.spiritual.copyWith(
        score: (map['score'] as num?)?.toDouble(),
        level: (map['level'] as num?)?.toDouble(),
      ),
    );
  }

  static AppState _updateHealth(AppState state, dynamic payload) {
    final map = payload is Map<String, dynamic> ? payload : const <String, dynamic>{};
    return state.copyWith(
      health: state.health.copyWith(
        weight: (map['weight'] as num?)?.toDouble(),
        bmr: (map['bmr'] as num?)?.toDouble(),
        highStress: map['highStress'] as bool?,
        highPain: map['highPain'] as bool?,
        illnessActive: map['illnessActive'] as bool?,
        vertigoActive: map['vertigoActive'] as bool?,
      ),
    );
  }

  static AppState _updateJourney(AppState state, dynamic payload) {
    final map = payload is Map<String, dynamic> ? payload : const <String, dynamic>{};
    return state.copyWith(
      journey: state.journey.copyWith(
        currentPhase: map['currentPhase'] as int?,
        ultimateUnlocked: map['ultimateUnlocked'] as bool?,
        requestedMode: map['requestedMode'] as UltimateMode?,
        masteryWeeksInRange: map['masteryWeeksInRange'] as int?,
        twoWeekLowIntegrity: map['twoWeekLowIntegrity'] as bool?,
        twoWeekStableIntegrity: map['twoWeekStableIntegrity'] as bool?,
      ),
    );
  }

  static AppState _recalculateUltimate(AppState state) {
    final newUltimate = _ultimateEngine.evaluate(
      isUnlocked: state.journey.ultimateUnlocked,
      requestedMode: state.journey.requestedMode,
      currentlyDefenseActive: state.ultimate.defenseActive,
      masteryWeeksInRange: state.journey.masteryWeeksInRange,
      weight: state.health.weight,
      bmr: state.health.bmr,
      weeklyAvgCalories: state.ritual.weeklyAverageCalories,
      junkCount: state.ritual.junkCount,
      trainingScore: state.ritual.trainingScore,
      spiritualScore: state.spiritual.score,
      walkingDays: state.ritual.walkingDays,
      strengthDays: state.ritual.strengthDays,
      twoWeekLowIntegrity: state.journey.twoWeekLowIntegrity,
      twoWeekStableIntegrity: state.journey.twoWeekStableIntegrity,
    );

    return state.copyWith(ultimate: newUltimate);
  }

  static AppState _updateMurshidContext(AppState state) {
    var emotionalDepth = state.murshid.emotionalDepthScore;
    var crisisMoments = state.murshid.crisisSupportMoments;

    if (state.ultimate.stabilityMastery) {
      emotionalDepth += 1;
    }
    if (state.ultimate.defenseActive || state.health.illnessActive || state.health.vertigoActive) {
      crisisMoments += 1;
    }

    final nextMurshid = MurshidState(
      sleepMode: state.murshid.sleepMode,
      stage: state.murshid.stage,
      totalMessages: state.murshid.totalMessages,
      emotionalDepthScore: emotionalDepth,
      vulnerabilityScore: state.murshid.vulnerabilityScore,
      humorSharedCount: state.murshid.humorSharedCount,
      crisisSupportMoments: crisisMoments,
      onboardingDate: state.murshid.onboardingDate,
    );

    return state.copyWith(murshid: nextMurshid);
  }

  static AppState _updateTrends(AppState state) {
    final updatedTrend = <double>[...state.trends.integrityTrend, state.ultimate.weeklyIntegrity];
    return state.copyWith(trends: state.trends.copyWith(integrityTrend: updatedTrend));
  }

  static AppState _evaluateDefense(AppState state) => state;

  static AppState _evaluateMastery(AppState state) => state;

  static UltimateState initialUltimateState() {
    return const UltimateState(
      isUnlocked: false,
      mode: UltimateMode.stability,
      weightZone: WeightZone.workingRange,
      defenseActive: false,
      weeklyIntegrity: 0,
      belowFloor: false,
      aboveCeiling: false,
      stabilityMastery: false,
      targetCalories: 0,
      proteinTarget: 0,
      buildDiscouraged: false,
      cutDisabled: false,
      minWalkingDays: 3,
      minStrengthDays: 2,
      maxJunkCount: 2,
    );
  }

  static MurshidState initialMurshidState() => MurshidState();
}
