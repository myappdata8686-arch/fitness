import '../../murshid/murshid_relationship_engine.dart';
import '../../ultimate/ultimate_state.dart';

class RitualState {
  const RitualState({
    this.walkingDays = 0,
    this.strengthDays = 0,
    this.junkCount = 0,
    this.weeklyAverageCalories = 0,
    this.trainingScore = 0,
  });

  final int walkingDays;
  final int strengthDays;
  final int junkCount;
  final double weeklyAverageCalories;
  final double trainingScore;

  RitualState copyWith({
    int? walkingDays,
    int? strengthDays,
    int? junkCount,
    double? weeklyAverageCalories,
    double? trainingScore,
  }) {
    return RitualState(
      walkingDays: walkingDays ?? this.walkingDays,
      strengthDays: strengthDays ?? this.strengthDays,
      junkCount: junkCount ?? this.junkCount,
      weeklyAverageCalories: weeklyAverageCalories ?? this.weeklyAverageCalories,
      trainingScore: trainingScore ?? this.trainingScore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'walkingDays': walkingDays,
      'strengthDays': strengthDays,
      'junkCount': junkCount,
      'weeklyAverageCalories': weeklyAverageCalories,
      'trainingScore': trainingScore,
    };
  }

  factory RitualState.fromJson(Map<String, dynamic> json) {
    return RitualState(
      walkingDays: json['walkingDays'] as int? ?? 0,
      strengthDays: json['strengthDays'] as int? ?? 0,
      junkCount: json['junkCount'] as int? ?? 0,
      weeklyAverageCalories: (json['weeklyAverageCalories'] as num?)?.toDouble() ?? 0,
      trainingScore: (json['trainingScore'] as num?)?.toDouble() ?? 0,
    );
  }
}

class SpiritualState {
  const SpiritualState({this.score = 0, this.level = 0});

  final double score;
  final double level;

  SpiritualState copyWith({double? score, double? level}) {
    return SpiritualState(score: score ?? this.score, level: level ?? this.level);
  }

  Map<String, dynamic> toJson() => {'score': score, 'level': level};

  factory SpiritualState.fromJson(Map<String, dynamic> json) {
    return SpiritualState(
      score: (json['score'] as num?)?.toDouble() ?? 0,
      level: (json['level'] as num?)?.toDouble() ?? 0,
    );
  }
}

class HealthState {
  const HealthState({
    this.weight = 0,
    this.bmr = 0,
    this.highStress = false,
    this.highPain = false,
    this.illnessActive = false,
    this.vertigoActive = false,
  });

  final double weight;
  final double bmr;
  final bool highStress;
  final bool highPain;
  final bool illnessActive;
  final bool vertigoActive;

  HealthState copyWith({
    double? weight,
    double? bmr,
    bool? highStress,
    bool? highPain,
    bool? illnessActive,
    bool? vertigoActive,
  }) {
    return HealthState(
      weight: weight ?? this.weight,
      bmr: bmr ?? this.bmr,
      highStress: highStress ?? this.highStress,
      highPain: highPain ?? this.highPain,
      illnessActive: illnessActive ?? this.illnessActive,
      vertigoActive: vertigoActive ?? this.vertigoActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'bmr': bmr,
      'highStress': highStress,
      'highPain': highPain,
      'illnessActive': illnessActive,
      'vertigoActive': vertigoActive,
    };
  }

  factory HealthState.fromJson(Map<String, dynamic> json) {
    return HealthState(
      weight: (json['weight'] as num?)?.toDouble() ?? 0,
      bmr: (json['bmr'] as num?)?.toDouble() ?? 0,
      highStress: json['highStress'] == true,
      highPain: json['highPain'] == true,
      illnessActive: json['illnessActive'] == true,
      vertigoActive: json['vertigoActive'] == true,
    );
  }
}

class JourneyState {
  const JourneyState({
    this.currentPhase = 0,
    this.ultimateUnlocked = false,
    this.requestedMode = UltimateMode.stability,
    this.masteryWeeksInRange = 0,
    this.twoWeekLowIntegrity = false,
    this.twoWeekStableIntegrity = false,
  });

  final int currentPhase;
  final bool ultimateUnlocked;
  final UltimateMode requestedMode;
  final int masteryWeeksInRange;
  final bool twoWeekLowIntegrity;
  final bool twoWeekStableIntegrity;

  JourneyState copyWith({
    int? currentPhase,
    bool? ultimateUnlocked,
    UltimateMode? requestedMode,
    int? masteryWeeksInRange,
    bool? twoWeekLowIntegrity,
    bool? twoWeekStableIntegrity,
  }) {
    return JourneyState(
      currentPhase: currentPhase ?? this.currentPhase,
      ultimateUnlocked: ultimateUnlocked ?? this.ultimateUnlocked,
      requestedMode: requestedMode ?? this.requestedMode,
      masteryWeeksInRange: masteryWeeksInRange ?? this.masteryWeeksInRange,
      twoWeekLowIntegrity: twoWeekLowIntegrity ?? this.twoWeekLowIntegrity,
      twoWeekStableIntegrity: twoWeekStableIntegrity ?? this.twoWeekStableIntegrity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPhase': currentPhase,
      'ultimateUnlocked': ultimateUnlocked,
      'requestedMode': requestedMode.name,
      'masteryWeeksInRange': masteryWeeksInRange,
      'twoWeekLowIntegrity': twoWeekLowIntegrity,
      'twoWeekStableIntegrity': twoWeekStableIntegrity,
    };
  }

  factory JourneyState.fromJson(Map<String, dynamic> json) {
    return JourneyState(
      currentPhase: json['currentPhase'] as int? ?? 0,
      ultimateUnlocked: json['ultimateUnlocked'] == true,
      requestedMode: ultimateModeFromName(json['requestedMode'] as String?),
      masteryWeeksInRange: json['masteryWeeksInRange'] as int? ?? 0,
      twoWeekLowIntegrity: json['twoWeekLowIntegrity'] == true,
      twoWeekStableIntegrity: json['twoWeekStableIntegrity'] == true,
    );
  }
}

class TrendState {
  const TrendState({this.integrityTrend = const []});

  final List<double> integrityTrend;

  TrendState copyWith({List<double>? integrityTrend}) {
    return TrendState(integrityTrend: integrityTrend ?? this.integrityTrend);
  }

  Map<String, dynamic> toJson() => {'integrityTrend': integrityTrend};

  factory TrendState.fromJson(Map<String, dynamic> json) {
    final values = json['integrityTrend'] as List<dynamic>? ?? const [];
    return TrendState(integrityTrend: values.map((e) => (e as num).toDouble()).toList());
  }
}

class AppState {
  const AppState({
    required this.ritual,
    required this.spiritual,
    required this.health,
    required this.journey,
    required this.ultimate,
    required this.murshid,
    required this.trends,
    required this.lastUpdated,
  });

  final RitualState ritual;
  final SpiritualState spiritual;
  final HealthState health;
  final JourneyState journey;
  final UltimateState ultimate;
  final MurshidState murshid;
  final TrendState trends;
  final DateTime lastUpdated;

  AppState copyWith({
    RitualState? ritual,
    SpiritualState? spiritual,
    HealthState? health,
    JourneyState? journey,
    UltimateState? ultimate,
    MurshidState? murshid,
    TrendState? trends,
    DateTime? lastUpdated,
  }) {
    return AppState(
      ritual: ritual ?? this.ritual,
      spiritual: spiritual ?? this.spiritual,
      health: health ?? this.health,
      journey: journey ?? this.journey,
      ultimate: ultimate ?? this.ultimate,
      murshid: murshid ?? this.murshid,
      trends: trends ?? this.trends,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ritual': ritual.toJson(),
      'spiritual': spiritual.toJson(),
      'health': health.toJson(),
      'journey': journey.toJson(),
      'ultimate': ultimate.toJson(),
      'murshid': murshid.toJson(),
      'trends': trends.toJson(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory AppState.fromJson(Map<String, dynamic> json) {
    return AppState(
      ritual: RitualState.fromJson(Map<String, dynamic>.from(json['ritual'] as Map? ?? const {})),
      spiritual: SpiritualState.fromJson(Map<String, dynamic>.from(json['spiritual'] as Map? ?? const {})),
      health: HealthState.fromJson(Map<String, dynamic>.from(json['health'] as Map? ?? const {})),
      journey: JourneyState.fromJson(Map<String, dynamic>.from(json['journey'] as Map? ?? const {})),
      ultimate: UltimateState.fromJson(Map<String, dynamic>.from(json['ultimate'] as Map? ?? const {})),
      murshid: MurshidState.fromJson(Map<String, dynamic>.from(json['murshid'] as Map? ?? const {})),
      trends: TrendState.fromJson(Map<String, dynamic>.from(json['trends'] as Map? ?? const {})),
      lastUpdated: DateTime.tryParse(json['lastUpdated'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
