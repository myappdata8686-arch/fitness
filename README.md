# Athletic OS (Flutter MVP)

Version 1 architecture scaffold for a deterministic wellness operating system.

## Stack
- Flutter
- Riverpod state management
- Firebase Auth + Firestore repositories
- Dark theme with emerald accent

## Implemented MVP structure
- Bottom navigation: Home, Physical, Spiritual, Self-Care, Settings
- Physical sub-tabs: Today, Week, Metrics, Journey
- Deterministic day-color rules and phase-transition engine
- Firestore collection constants:
  - users
  - daily_logs
  - weekly_summary
  - physical_metrics
  - spiritual_logs
  - selfcare_logs
  - credits

## Next incremental steps
1. Replace demo data with repository-backed streams.
2. Add Firebase Auth flow and user binding.
3. Add weekly aggregation job/service using deterministic engine.
4. Add data export implementation.
