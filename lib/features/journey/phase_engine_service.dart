import '../../core/app_data.dart';

class PhaseEngineService {
  JourneyEvaluation evaluate({required JourneyState journey, required DateTime now}) {
    switch (journey.currentPhase) {
      case 0:
        final weeks = now.difference(journey.phaseStartDate).inDays / 7.0;
        final progress = (weeks / 8).clamp(0.0, 1.0);
        final manual = weeks >= 6;
        final complete = weeks >= 8;
        return JourneyEvaluation(
          progress: progress,
          allowManualAdvance: manual,
          completed: complete,
          majorBonus: complete ? 3 : 0,
          rewards: complete
              ? const [
                  'calorieCounterUnlocked',
                  'Weighing Scale',
                  'Haircut',
                  'Surma & Oil Ritual',
                ]
              : const [],
        );
      case 1:
        final denominator = (journey.phaseStartWeight - 93);
        final progress = denominator <= 0
            ? 0.0
            : ((journey.phaseStartWeight - journey.latestWeight) / denominator)
                .clamp(0.0, 1.0);
        final complete = journey.latestWeight > 0 && journey.latestWeight <= 93;
        return JourneyEvaluation(
          progress: progress,
          allowManualAdvance: false,
          completed: complete,
          majorBonus: complete ? 3 : 0,
          rewards: complete
              ? const ['Hair Treatment', 'Clothes Revival 2024']
              : const [],
        );
      case 2:
        final progress = (journey.stableWeeks / 10).clamp(0.0, 1.0);
        final complete = journey.stableWeeks >= 10;
        return JourneyEvaluation(
          progress: progress,
          allowManualAdvance: false,
          completed: complete,
          majorBonus: complete ? 3 : 0,
          rewards: complete
              ? const [
                  'macroTrackingUnlocked',
                  'Skin Mask',
                  'Daily Hair Serum',
                ]
              : const [],
        );
      case 3:
        final weightDen = (journey.phaseStartWeight - 83);
        final waistDen = (journey.phaseStartWaist - 34);
        final weightProgress = weightDen <= 0
            ? 0.0
            : ((journey.phaseStartWeight - journey.latestWeight) / weightDen)
                .clamp(0.0, 1.0);
        final waistProgress = waistDen <= 0
            ? 0.0
            : ((journey.phaseStartWaist - journey.latestWaist) / waistDen)
                .clamp(0.0, 1.0);
        final progress = weightProgress > waistProgress ? weightProgress : waistProgress;
        final complete = (journey.latestWeight > 0 && journey.latestWeight <= 83) ||
            (journey.latestWaist > 0 && journey.latestWaist <= 34);
        return JourneyEvaluation(
          progress: progress,
          allowManualAdvance: false,
          completed: complete,
          majorBonus: complete ? 3 : 0,
          rewards: complete
              ? const [
                  'foodFeelUnlocked',
                  'Body Hair Removal',
                  'Clothes Revival 2021',
                ]
              : const [],
        );
      case 4:
        final progress = (journey.stableMonths / 12).clamp(0.0, 1.0);
        final complete = journey.stableMonths >= 12;
        return JourneyEvaluation(
          progress: progress,
          allowManualAdvance: false,
          completed: complete,
          majorBonus: complete ? 10 : 0,
          rewards: complete ? const ['ultimateUnlocked'] : const [],
        );
      case 5:
        return const JourneyEvaluation(
          progress: 1.0,
          allowManualAdvance: false,
          completed: false,
          majorBonus: 0,
          rewards: [],
        );
      default:
        return const JourneyEvaluation(
          progress: 0,
          allowManualAdvance: false,
          completed: false,
          majorBonus: 0,
          rewards: [],
        );
    }
  }
}

class JourneyEvaluation {
  const JourneyEvaluation({
    required this.progress,
    required this.allowManualAdvance,
    required this.completed,
    required this.majorBonus,
    required this.rewards,
  });

  final double progress;
  final bool allowManualAdvance;
  final bool completed;
  final int majorBonus;
  final List<String> rewards;
}
