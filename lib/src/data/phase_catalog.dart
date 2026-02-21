import '../models/enums.dart';
import '../models/phase_definition.dart';

class PhaseCatalog {
  static const phase0 = PhaseDefinition(
    id: PhaseId.phase0RegulationRepair,
    name: 'Phase 0 – Regulation & Repair',
    metrics: [
      WeeklyMetricWeight(key: 'wakeupConsistency', weight: 20),
      WeeklyMetricWeight(key: 'mobilityConsistency', weight: 20),
      WeeklyMetricWeight(key: 'proteinAtBreakfastLunch', weight: 20),
      WeeklyMetricWeight(key: 'stressDownRegulation', weight: 20),
      WeeklyMetricWeight(key: 'protocolAdherence', weight: 20),
    ],
    allowedStrengthDays: '0-2 light rehab sessions',
    requiresManualConfirmation: true,
    notes: 'Repair rhythm, protect nervous system, no pressure dieting.',
  );

  static const phase1 = PhaseDefinition(
    id: PhaseId.phase1FoundationFatLoss,
    name: 'Phase 1 – Foundation Fat Loss',
    metrics: [
      WeeklyMetricWeight(key: 'strength2x', weight: 25),
      WeeklyMetricWeight(key: 'walkingFrequency', weight: 20),
      WeeklyMetricWeight(key: 'proteinConsistency', weight: 15),
      WeeklyMetricWeight(key: 'junkMax2Days', weight: 15),
      WeeklyMetricWeight(key: 'mobility', weight: 15),
      WeeklyMetricWeight(key: 'portionAwareness', weight: 10),
    ],
    allowedStrengthDays: '2 beginner calisthenics sessions',
    requiresManualConfirmation: true,
    notes: 'Gentle progress without stress.',
  );

  static const phase2 = PhaseDefinition(
    id: PhaseId.phase2MaintenanceRecess,
    name: 'Phase 2 – Maintenance Recess',
    metrics: [
      WeeklyMetricWeight(key: 'strength2to3x', weight: 25),
      WeeklyMetricWeight(key: 'walkingConsistency', weight: 20),
      WeeklyMetricWeight(key: 'mobilityPosture', weight: 20),
      WeeklyMetricWeight(key: 'proteinConsistency', weight: 20),
      WeeklyMetricWeight(key: 'socialFlexibilityWithinCeiling', weight: 15),
    ],
    allowedStrengthDays: '2-3 moderate sessions',
    requiresManualConfirmation: true,
    notes: 'Teach body safety and prevent rebound.',
  );

  static const phase3 = PhaseDefinition(
    id: PhaseId.phase3Recomposition,
    name: 'Phase 3 – Recomposition',
    metrics: [
      WeeklyMetricWeight(key: 'strength3x', weight: 30),
      WeeklyMetricWeight(key: 'walking4to5x', weight: 20),
      WeeklyMetricWeight(key: 'proteinPriority', weight: 20),
      WeeklyMetricWeight(key: 'mobilityCore', weight: 15),
      WeeklyMetricWeight(key: 'junkWithinLimit', weight: 15),
    ],
    allowedStrengthDays: '3 progressive overload sessions',
    requiresManualConfirmation: true,
    notes: 'Strong first, lean second.',
  );

  static const phase4 = PhaseDefinition(
    id: PhaseId.phase4ForeverAthletic,
    name: 'Phase 4 – Forever Athletic',
    metrics: [
      WeeklyMetricWeight(key: 'strength2to3x', weight: 30),
      WeeklyMetricWeight(key: 'walkingMostDays', weight: 25),
      WeeklyMetricWeight(key: 'mobilityDaily', weight: 20),
      WeeklyMetricWeight(key: 'socialBalance', weight: 15),
      WeeklyMetricWeight(key: 'recoveryDeloadCompliance', weight: 10),
    ],
    allowedStrengthDays: '2-3 lifelong sessions',
    requiresManualConfirmation: true,
    notes: 'Performance-driven, calm, lifelong.',
  );

  static const byId = {
    PhaseId.phase0RegulationRepair: phase0,
    PhaseId.phase1FoundationFatLoss: phase1,
    PhaseId.phase2MaintenanceRecess: phase2,
    PhaseId.phase3Recomposition: phase3,
    PhaseId.phase4ForeverAthletic: phase4,
  };
}
