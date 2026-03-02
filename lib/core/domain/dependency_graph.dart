class DependencyGraph {
  static const String ritualToUltimateToMurshidToTrends = 'Ritual -> Ultimate -> Murshid -> Trends';
  static const String spiritualToIntegrityToUltimateToMurshid = 'Spiritual -> Integrity -> Ultimate -> Murshid';
  static const String healthToMurshid = 'Health -> Murshid';
  static const String journeyToUltimateUnlock = 'Journey -> Ultimate unlock';
  static const String ultimateToRitualTargets = 'Ultimate -> Ritual calorie targets';

  static const List<String> noReverseDependencies = [
    'Murshid never modifies Ultimate',
    'Ultimate never modifies Journey',
  ];
}
