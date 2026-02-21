# Athletic For Life – Constitutional Health System App

Flutter architecture starter for an Android-first, phase-based constitutional health system.

## Implemented Foundations

- **Phase engine** (`PhaseCatalog`, `PhaseUnlockValidator`)
- **Red–Yellow–Green day suggestion** (`DayColorEngine`)
- **Weekly integrity scoring** with floor/ceiling cap logic (`WeeklyScoringEngine`)
- **Protected streak behavior** (`StreakEngine`)
- **Credit accumulation (1 kg = 1 credit)** (`CreditEngine`)
- **Analytics helpers** for moving-average weight and color distribution (`AnalyticsEngine`)
- **Calm, mature dark UI shell** with emerald and soft-gold accents

## Data Model Mapping

Planned backend collections/tables:

- `Users`
- `Phases`
- `DailyLogs`
- `WeeklyScores`
- `Credits`
- `StreakData`
- `Measurements`
- `RewardsUnlocked`

## Key Rules Encoded

- Red days do not punish streak progression by default.
- Weekly score labels: Progressive / Stable / Maintenance / Correction / Adaptive.
- Illness/travel/stress support lowers success threshold to 70% as Adaptive Week.
- Floor or ceiling violations cap week score at `75`.
- Phase progression requires manual confirmation + 3 stable+ weeks + no ceiling violations.

## Next Steps

1. Add Firebase auth and Firestore repositories.
2. Add local persistence (Hive/Isar) for offline-first daily logs.
3. Implement notification scheduler (morning / midday / evening / weekly review).
4. Add dedicated screens for phase protocol checklists and reward redemption.
