import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show TimeOfDay;

import 'backfill_service.dart';
import 'daily_record.dart';
import 'user_profile.dart';

import '../features/journey/journey_storage.dart';
import '../features/journey/phase_engine_service.dart';
import '../features/physical/physical_screen.dart';
import '../ultimate/ultimate_engine.dart';
import '../ultimate/ultimate_state.dart';

enum BodybuildingMode { cut, build }

class JourneyState {
  JourneyState({
    required this.currentPhase,
    required this.phaseStartDate,
    required this.phaseStartWeight,
    required this.phaseStartWaist,
    required this.latestWeight,
    required this.latestWaist,
    required this.stableWeeks,
    required this.stableMonths,
    required this.disciplineCredits,
    required this.majorCredits,
    required this.calorieCounterUnlocked,
    required this.macroTrackingUnlocked,
    required this.foodFeelUnlocked,
    required this.ultimateUnlocked,
    required this.defenceModeActive,
    required this.bodybuildingMode,
    required this.allowManualAdvance,
    required this.progress,
    required this.defenceAbove83Weeks,
    required this.defenceBelow80Weeks,
    required this.bodybuildingCycleWeeks,
    List<String>? wardrobeUnlocks,
    List<String>? redeemedRewards,
    List<PhaseReward>? phaseRewards,
  })  : wardrobeUnlocks = wardrobeUnlocks ?? [],
        redeemedRewards = redeemedRewards ?? [],
        phaseRewards = phaseRewards ?? const [];

  int currentPhase; // 0..5
  DateTime phaseStartDate;
  double phaseStartWeight;
  double phaseStartWaist;

  double latestWeight;
  double latestWaist;

  int stableWeeks;
  int stableMonths;

  int disciplineCredits;
  int majorCredits;

  bool calorieCounterUnlocked;
  bool macroTrackingUnlocked;
  bool foodFeelUnlocked;
  bool ultimateUnlocked;

  bool defenceModeActive;
  BodybuildingMode? bodybuildingMode;

  bool allowManualAdvance;
  double progress;

  int defenceAbove83Weeks;
  int defenceBelow80Weeks;
  int bodybuildingCycleWeeks;

  final List<String> wardrobeUnlocks;
  final List<String> redeemedRewards;
  final List<PhaseReward> phaseRewards;

  bool get calorieUnlocked => calorieCounterUnlocked;
  bool get macroUnlocked => macroTrackingUnlocked;
  int get softCredits => disciplineCredits;
  int get bigCredits => majorCredits;
  double get phaseProgressPercent => (progress * 100).clamp(0, 100);
  String get phaseName {
    switch (currentPhase) {
      case 0:
        return 'Foundation';
      case 1:
        return 'Fat Loss';
      case 2:
        return 'Recomposition';
      case 3:
        return 'Athletic Build';
      case 4:
        return 'Peak Discipline';
      default:
        return 'Ultimate';
    }
  }
}

class PhaseReward {
  const PhaseReward({
    required this.phase,
    required this.items,
  });

  final int phase;
  final List<String> items;
}

class SpiritualState {
  SpiritualState({
    required this.spiritualProgressPercent,
    required this.spiritualLevelName,
  });

  double spiritualProgressPercent;
  String spiritualLevelName;
}

class HomeOverviewData {
  const HomeOverviewData({
    required this.currentPhase,
    required this.phaseProgressPercent,
    required this.phaseName,
    required this.spiritualProgressPercent,
    required this.spiritualLevelName,
    required this.confirmedDay,
    required this.dayDistribution,
    required this.weeklyRoutine,
    required this.avgWeeklyBp,
    required this.eczemaActive,
    required this.allergyActive,
    required this.weeklyAvgCalories,
    required this.weeklyTargetCalories,
    required this.showCalories,
    required this.monthlyJunkWeekly,
    required this.softCredits,
    required this.hardCredits,
  });

  final int currentPhase;
  final double phaseProgressPercent;
  final String phaseName;
  final double spiritualProgressPercent;
  final String spiritualLevelName;
  final DayType confirmedDay;
  final Map<DayType, double> dayDistribution;
  final List<bool?> weeklyRoutine;
  final double avgWeeklyBp;
  final bool eczemaActive;
  final bool allergyActive;
  final double weeklyAvgCalories;
  final double weeklyTargetCalories;
  final bool showCalories;
  final List<int> monthlyJunkWeekly;
  final int softCredits;
  final int hardCredits;
}


enum AmbientSound { minimal, deepFocus, calm, none }
enum BodybuildingSetupMode { cut, build }
enum WeightUnit { kg, lb }
enum HeightUnit { ftIn, cm }
enum MeasureUnit { inch, cm }
enum ReminderDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

enum CustomSelfCareFrequency { daily, weekly, monthly }
enum RewardCostType { soft, big }

class CustomReward {
  const CustomReward({
    required this.id,
    required this.title,
    required this.cost,
    required this.costType,
    required this.description,
  });

  final String id;
  final String title;
  final int cost;
  final RewardCostType costType;
  final String description;
}

class CustomSelfCareItem {
  const CustomSelfCareItem({
    required this.id,
    required this.title,
    required this.frequency,
    required this.requiredPhase,
  });

  final String id;
  final String title;
  final CustomSelfCareFrequency frequency;
  final int requiredPhase;
}

class NotificationSettings {
  NotificationSettings({
    this.morningEnabled = false,
    this.morningTime,
    this.nightEnabled = false,
    this.nightTime,
    this.weeklyEnabled = false,
    this.weeklyDay = ReminderDay.sunday,
    this.weeklyTime,
    this.monthlyEnabled = false,
    this.monthlyDate = 1,
    this.monthlyTime,
    this.inactivityEnabled = false,
    this.inactivityDays = 3,
    this.phaseTransitionEnabled = false,
  });

  bool morningEnabled;
  TimeOfDay? morningTime;
  bool nightEnabled;
  TimeOfDay? nightTime;
  bool weeklyEnabled;
  ReminderDay weeklyDay;
  TimeOfDay? weeklyTime;
  bool monthlyEnabled;
  int monthlyDate;
  TimeOfDay? monthlyTime;
  bool inactivityEnabled;
  int inactivityDays;
  bool phaseTransitionEnabled;
}

class AudioSettings {
  AudioSettings({
    this.appSoundEffectsEnabled = true,
    this.daySelectionSoundEnabled = true,
    this.creditEarnSoundEnabled = true,
    this.rewardRedeemSoundEnabled = true,
    this.ambientEnabled = false,
    this.ambientSound = AmbientSound.none,
    this.hapticFeedbackEnabled = true,
  });

  bool appSoundEffectsEnabled;
  bool daySelectionSoundEnabled;
  bool creditEarnSoundEnabled;
  bool rewardRedeemSoundEnabled;
  bool ambientEnabled;
  AmbientSound ambientSound;
  bool hapticFeedbackEnabled;
}

class BodybuildingSetup {
  BodybuildingSetup({
    this.enabled = false,
    this.mode = BodybuildingSetupMode.cut,
    this.macroPreset = 'Balanced',
    this.calorieMultiplier = 1.0,
    this.workoutEmphasis = 'Mixed',
  });

  bool enabled;
  BodybuildingSetupMode mode;
  String macroPreset;
  double calorieMultiplier;
  String workoutEmphasis;
}

class UnitPreferences {
  UnitPreferences({
    this.weightUnit = WeightUnit.kg,
    this.heightUnit = HeightUnit.ftIn,
    this.measureUnit = MeasureUnit.inch,
  });

  WeightUnit weightUnit;
  HeightUnit heightUnit;
  MeasureUnit measureUnit;
}

class SettingsModel {
  SettingsModel({
    NotificationSettings? notificationSettings,
    AudioSettings? audioSettings,
    Map<String, String>? routineDescriptions,
    List<CustomReward>? customRewards,
    List<CustomSelfCareItem>? customSelfCareItems,
    BodybuildingSetup? bodybuildingMode,
    UnitPreferences? unitPreferences,
  })  : notificationSettings = notificationSettings ?? NotificationSettings(),
        audioSettings = audioSettings ?? AudioSettings(),
        routineDescriptions = routineDescriptions ??
            {
              'rehab_mobility': 'Joint-friendly mobility sequence.',
              'full_body_stretch': 'Gentle full body stretch flow.',
              'calisthenics': 'Bodyweight strength circuit.',
              'workout': 'Primary workout protocol.',
              'cardio': 'Cardio endurance block.',
              'bodybuilding_mode': 'Bodybuilding-focused progression block.',
            },
        customRewards = customRewards ?? [],
        customSelfCareItems = customSelfCareItems ?? [],
        bodybuildingMode = bodybuildingMode ?? BodybuildingSetup(),
        unitPreferences = unitPreferences ?? UnitPreferences();

  final NotificationSettings notificationSettings;
  final AudioSettings audioSettings;
  final Map<String, String> routineDescriptions;
  final List<CustomReward> customRewards;
  final List<CustomSelfCareItem> customSelfCareItems;
  final BodybuildingSetup bodybuildingMode;
  final UnitPreferences unitPreferences;
}

class PhaseHistoryEntry {
  PhaseHistoryEntry({
    required this.phase,
    required this.startDate,
    required this.endDate,
    required this.weightDelta,
    required this.creditsEarned,
    required this.rewardsUnlocked,
  });

  final int phase;
  final DateTime startDate;
  final DateTime endDate;
  final double weightDelta;
  final int creditsEarned;
  final List<String> rewardsUnlocked;
}

class AppData extends ChangeNotifier {
  AppData({JourneyStorage? storage})
      : _storage = storage ?? InMemoryJourneyStorage() {
    _seedDemoData();
  }

  final JourneyStorage _storage;
  final PhaseEngineService _engine = PhaseEngineService();

  final JourneyState journey = JourneyState(
    currentPhase: 0,
    phaseStartDate: DateTime.now(),
    phaseStartWeight: 0,
    phaseStartWaist: 0,
    latestWeight: 0,
    latestWaist: 0,
    stableWeeks: 0,
    stableMonths: 0,
    disciplineCredits: 0,
    majorCredits: 0,
    calorieCounterUnlocked: false,
    macroTrackingUnlocked: false,
    foodFeelUnlocked: false,
    ultimateUnlocked: false,
    defenceModeActive: false,
    bodybuildingMode: null,
    allowManualAdvance: false,
    progress: 0,
    defenceAbove83Weeks: 0,
    defenceBelow80Weeks: 0,
    bodybuildingCycleWeeks: 0,
    phaseRewards: const [
      PhaseReward(phase: 0, items: ['Weighing scale', 'Haircut']),
      PhaseReward(phase: 1, items: ['Hair treatment', 'Smaller clothes revival']),
      PhaseReward(phase: 2, items: ['Stability badge', 'Discipline recognition']),
      PhaseReward(phase: 3, items: ['Food Feel unlock', 'Further wardrobe revival']),
      PhaseReward(phase: 4, items: ['Ultimate Mode', 'Studio / Major upgrade']),
    ],
  );

  final SpiritualState spiritual = SpiritualState(
    spiritualProgressPercent: 38,
    spiritualLevelName: 'Mindful Apprentice',
  );

  DayType confirmedDay = DayType.none;
  final Map<DateTime, DayType> dayLog = {};
  final Map<DateTime, bool> dailyRoutineCompleted = {};
  final Map<DateTime, int> dailyCalories = {};
  final Map<DateTime, int> junkCount = {};

  final Map<DateTime, double> systolicBP = {};
  final Map<DateTime, int> eczemaLevel = {};
  final Map<DateTime, int> allergyLevel = {};

  double currentBMR = 1800;
  double phaseFactor = 1.2;

  bool showPhaseCeremony = false;
  List<PhaseHistoryEntry> phaseHistory = [];

  final SettingsModel settings = SettingsModel();

  final Map<DateTime, DailyRecord> dailyHistory = {};
  final BackfillService backfillService = BackfillService();
  int currentStreak = 0;

  UserProfile userProfile = UserProfile();
  bool onboardingComplete = false;

  bool internetAvailable = false;
  int currentStress = 0;
  int currentPain = 0;
  bool vertigoActive = false;
  bool illnessActive = false;
  double currentSpiritualLevel = 1;

  final UltimateEngine _ultimateEngine = UltimateEngine();
  UltimateState? ultimateState;

  // Compatibility getters for existing tabs.
  FeatureFlagsView get featureFlags => FeatureFlagsView(journey);
  UltimateModeView get ultimateMode {
    if (journey.bodybuildingMode == BodybuildingMode.cut) {
      return UltimateModeView.bodybuildingCut;
    }
    if (journey.bodybuildingMode == BodybuildingMode.build) {
      return UltimateModeView.bodybuildingBuild;
    }
    return UltimateModeView.stability;
  }

  HomeOverviewData get homeOverview {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    int red = 0;
    int yellow = 0;
    int green = 0;
    int neutral = 0;

    for (int day = 1; day <= monthEnd.day; day++) {
      final date = _normalize(DateTime(now.year, now.month, day));
      final value = dayLog[date] ?? DayType.none;
      switch (value) {
        case DayType.red:
          red += 1;
          break;
        case DayType.yellow:
          yellow += 1;
          break;
        case DayType.green:
          green += 1;
          break;
        case DayType.none:
          neutral += 1;
          break;
      }
    }

    final total = monthEnd.day.toDouble();

    final week = List.generate(7, (index) {
      final date = _normalize(now.subtract(Duration(days: now.weekday - 1 - index)));
      return dailyRoutineCompleted[date];
    });

    final last7 = List.generate(7, (index) => _normalize(now.subtract(Duration(days: index))));
    final bpValues = last7.map((d) => systolicBP[d]).whereType<double>().toList();
    final avgBp = bpValues.isEmpty ? 0.0 : bpValues.reduce((a, b) => a + b) / bpValues.length;

    final lastEczema = eczemaLevel[_normalize(now)] ?? 0;
    final lastAllergy = allergyLevel[_normalize(now)] ?? 0;

    final caloriesValues = last7.map((d) => dailyCalories[d]).whereType<int>().toList();
    final avgCalories = caloriesValues.isEmpty ? 0.0 : caloriesValues.reduce((a, b) => a + b) / caloriesValues.length;
    final target = currentBMR * phaseFactor;

    final weeklyJunk = _weeklyJunkForMonth(monthStart, monthEnd);

    return HomeOverviewData(
      currentPhase: journey.currentPhase,
      phaseProgressPercent: journey.phaseProgressPercent,
      phaseName: journey.phaseName,
      spiritualProgressPercent: spiritual.spiritualProgressPercent,
      spiritualLevelName: spiritual.spiritualLevelName,
      confirmedDay: confirmedDay,
      dayDistribution: {
        DayType.green: (green / total) * 100,
        DayType.yellow: (yellow / total) * 100,
        DayType.red: (red / total) * 100,
        DayType.none: (neutral / total) * 100,
      },
      weeklyRoutine: week,
      avgWeeklyBp: avgBp,
      eczemaActive: lastEczema >= 3,
      allergyActive: lastAllergy >= 2,
      weeklyAvgCalories: avgCalories,
      weeklyTargetCalories: target,
      showCalories: journey.currentPhase >= 1,
      monthlyJunkWeekly: weeklyJunk,
      softCredits: journey.disciplineCredits,
      hardCredits: journey.majorCredits,
    );
  }

  List<int> _weeklyJunkForMonth(DateTime monthStart, DateTime monthEnd) {
    final buckets = [0, 0, 0, 0, 0];
    for (int day = 1; day <= monthEnd.day; day++) {
      final date = _normalize(DateTime(monthStart.year, monthStart.month, day));
      final value = junkCount[date] ?? 0;
      int bucket = 0;
      if (day >= 8 && day <= 14) bucket = 1;
      if (day >= 15 && day <= 21) bucket = 2;
      if (day >= 22 && day <= 28) bucket = 3;
      if (day >= 29) bucket = 4;
      buckets[bucket] += value;
    }
    return buckets;
  }

  bool redeemReward({
    required String rewardId,
    required int costSoft,
    required int costBig,
  }) {
    if (journey.redeemedRewards.contains(rewardId)) return false;

    if (costSoft <= journey.softCredits) {
      journey.disciplineCredits -= costSoft;
    } else if (costBig <= journey.bigCredits) {
      journey.majorCredits -= costBig;
    } else {
      return false;
    }

    journey.redeemedRewards.add(rewardId);
    _persist();
    notifyListeners();
    return true;
  }

  void markWardrobeRedeemed(String item) {
    if (journey.redeemedRewards.contains(item)) return;
    journey.redeemedRewards.add(item);
    _persist();
    notifyListeners();
  }

  void _seedDemoData() {
    final now = DateTime.now();
    journey.currentPhase = 1;
    journey.progress = 0.46;
    journey.disciplineCredits = 18;
    journey.majorCredits = 5;

    confirmedDay = DayType.yellow;

    journey.wardrobeUnlocks
      ..clear()
      ..addAll(['Slim Trousers', 'White Kurta']);

    for (int i = 0; i < 35; i++) {
      final date = _normalize(now.subtract(Duration(days: i)));
      if (i % 5 == 0) {
        dayLog[date] = DayType.red;
      } else if (i % 3 == 0) {
        dayLog[date] = DayType.yellow;
      } else {
        dayLog[date] = DayType.green;
      }
      dailyRoutineCompleted[date] = i % 4 != 0;
      dailyCalories[date] = 1800 + (i % 5) * 90;
      junkCount[date] = i % 4 == 0 ? 1 : 0;
      systolicBP[date] = 116 + (i % 6).toDouble();
      eczemaLevel[date] = i % 10 == 0 ? 3 : 2;
      allergyLevel[date] = i % 8 == 0 ? 2 : 1;
    }
  }

  Future<void> load() async {
    final snap = await _storage.loadJourneyState();
    if (snap == null) return;

    journey.currentPhase = snap.currentPhase;
    journey.phaseStartDate = snap.phaseStartDate;
    journey.phaseStartWeight = snap.phaseStartWeight;
    journey.phaseStartWaist = snap.phaseStartWaist;
    journey.latestWeight = snap.latestWeight;
    journey.latestWaist = snap.latestWaist;
    journey.stableWeeks = snap.stableWeeks;
    journey.stableMonths = snap.stableMonths;
    journey.disciplineCredits = snap.disciplineCredits;
    journey.majorCredits = snap.majorCredits;
    journey.calorieCounterUnlocked = snap.calorieCounterUnlocked;
    journey.macroTrackingUnlocked = snap.macroTrackingUnlocked;
    journey.foodFeelUnlocked = snap.foodFeelUnlocked;
    journey.ultimateUnlocked = snap.ultimateUnlocked;
    journey.defenceModeActive = snap.defenceModeActive;
    journey.bodybuildingMode = snap.bodybuildingMode;
    journey.allowManualAdvance = snap.allowManualAdvance;
    journey.progress = snap.progress;
    journey.defenceAbove83Weeks = snap.defenceAbove83Weeks;
    journey.defenceBelow80Weeks = snap.defenceBelow80Weeks;
    journey.bodybuildingCycleWeeks = snap.bodybuildingCycleWeeks;

    notifyListeners();
  }

  Future<void> _persist() async {
    await _storage.saveJourneyState(
      JourneySnapshot(
        currentPhase: journey.currentPhase,
        phaseStartDate: journey.phaseStartDate,
        phaseStartWeight: journey.phaseStartWeight,
        phaseStartWaist: journey.phaseStartWaist,
        latestWeight: journey.latestWeight,
        latestWaist: journey.latestWaist,
        stableWeeks: journey.stableWeeks,
        stableMonths: journey.stableMonths,
        disciplineCredits: journey.disciplineCredits,
        majorCredits: journey.majorCredits,
        calorieCounterUnlocked: journey.calorieCounterUnlocked,
        macroTrackingUnlocked: journey.macroTrackingUnlocked,
        foodFeelUnlocked: journey.foodFeelUnlocked,
        ultimateUnlocked: journey.ultimateUnlocked,
        defenceModeActive: journey.defenceModeActive,
        bodybuildingMode: journey.bodybuildingMode,
        allowManualAdvance: journey.allowManualAdvance,
        progress: journey.progress,
        defenceAbove83Weeks: journey.defenceAbove83Weeks,
        defenceBelow80Weeks: journey.defenceBelow80Weeks,
        bodybuildingCycleWeeks: journey.bodybuildingCycleWeeks,
      ),
    );
  }

  // REQUIRED deterministic triggers.
  void onWeightChanged(double weightKg) {
    journey.latestWeight = weightKg;
    _recalculate();
  }

  void onWaistChanged(double waistIn) {
    journey.latestWaist = waistIn;
    _recalculate();
  }

  void onStableWeekUpdated({required int stableWeeks, required int stableMonths}) {
    journey.stableWeeks = stableWeeks;
    journey.stableMonths = stableMonths;
    _recalculate();
  }

  void onManualPhaseAdvance() {
    if (journey.currentPhase == 0 && !journey.allowManualAdvance) return;
    if (journey.currentPhase >= 5) return;
    _completeCurrentPhase(forceAdvance: true);
    _persist();
    notifyListeners();
  }

  // Compatibility wrapper used by body tab.
  void onBodyMetricsUpdated({required double weightKg, required double waistIn}) {
    journey.latestWeight = weightKg;
    journey.latestWaist = waistIn;
    _recalculate();
  }

  void setUltimateMode(UltimateModeView mode) {
    if (journey.defenceModeActive) return;
    if (mode == UltimateModeView.stability) {
      journey.bodybuildingMode = null;
      journey.bodybuildingCycleWeeks = 0;
    } else if (mode == UltimateModeView.bodybuildingCut) {
      journey.bodybuildingMode = BodybuildingMode.cut;
      journey.bodybuildingCycleWeeks = 0;
    } else {
      journey.bodybuildingMode = BodybuildingMode.build;
      journey.bodybuildingCycleWeeks = 0;
    }
    _persist();
    notifyListeners();
  }

  void onBodybuildingCycleWeekTick() {
    if (journey.bodybuildingMode == null) return;
    journey.bodybuildingCycleWeeks += 1;
    if (journey.bodybuildingCycleWeeks >= 12) {
      journey.bodybuildingMode = null;
      journey.bodybuildingCycleWeeks = 0;
    }
    _persist();
    notifyListeners();
  }

  void _recalculate() {
    final result = _engine.evaluate(journey: journey, now: DateTime.now());

    journey.progress = result.progress;
    journey.allowManualAdvance = result.allowManualAdvance;

    if (result.completed) {
      _completeCurrentPhase(rewards: result.rewards, majorBonus: result.majorBonus);
    }

    _applyDefenceLogic();
    _persist();
    notifyListeners();
  }

  void _completeCurrentPhase({
    bool forceAdvance = false,
    List<String> rewards = const [],
    int majorBonus = 0,
  }) {
    showPhaseCeremony = true;

    final oldPhase = journey.currentPhase;
    final next = (journey.currentPhase + 1).clamp(0, 5);

    phaseHistory.add(
      PhaseHistoryEntry(
        phase: oldPhase,
        startDate: journey.phaseStartDate,
        endDate: DateTime.now(),
        weightDelta: journey.phaseStartWeight == 0 ? 0 : journey.latestWeight - journey.phaseStartWeight,
        creditsEarned: majorBonus,
        rewardsUnlocked: rewards,
      ),
    );

    journey.majorCredits += majorBonus;

    for (final reward in rewards) {
      if (reward == 'calorieCounterUnlocked') journey.calorieCounterUnlocked = true;
      if (reward == 'macroTrackingUnlocked') journey.macroTrackingUnlocked = true;
      if (reward == 'foodFeelUnlocked') journey.foodFeelUnlocked = true;
      if (reward == 'ultimateUnlocked') journey.ultimateUnlocked = true;
    }

    journey.currentPhase = next;
    journey.phaseStartDate = DateTime.now();
    journey.phaseStartWeight = journey.latestWeight;
    journey.phaseStartWaist = journey.latestWaist;
    journey.progress = forceAdvance ? 0 : journey.progress;
    journey.allowManualAdvance = false;

    if (journey.currentPhase == 5) {
      journey.ultimateUnlocked = true;
    }
  }

  void _applyDefenceLogic() {
    if (journey.currentPhase != 5) return;

    if (journey.latestWeight >= 83) {
      journey.defenceAbove83Weeks += 1;
      journey.defenceBelow80Weeks = 0;
    } else if (journey.latestWeight <= 80) {
      journey.defenceBelow80Weeks += 1;
      journey.defenceAbove83Weeks = 0;
    } else {
      journey.defenceAbove83Weeks = 0;
      journey.defenceBelow80Weeks = 0;
    }

    if (journey.defenceAbove83Weeks >= 2) {
      journey.defenceModeActive = true;
      journey.bodybuildingMode = null;
    }

    if (journey.defenceBelow80Weeks >= 2) {
      journey.defenceModeActive = false;
    }
  }

  void dismissCeremony() {
    showPhaseCeremony = false;
    notifyListeners();
  }

  void updateRoutineDescription(String key, String value) {
    settings.routineDescriptions[key] = value;
    notifyListeners();
  }

  void addCustomReward({
    required String title,
    required int cost,
    required RewardCostType costType,
    required String description,
  }) {
    settings.customRewards.add(
      CustomReward(
        id: 'custom_reward_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        cost: cost,
        costType: costType,
        description: description,
      ),
    );
    notifyListeners();
  }

  void addCustomSelfCareItem({
    required String title,
    required CustomSelfCareFrequency frequency,
    required int requiredPhase,
  }) {
    settings.customSelfCareItems.add(
      CustomSelfCareItem(
        id: 'custom_selfcare_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        frequency: frequency,
        requiredPhase: requiredPhase,
      ),
    );
    notifyListeners();
  }

  void setMorningReminder({required bool enabled, TimeOfDay? time}) {
    settings.notificationSettings.morningEnabled = enabled;
    if (time != null) settings.notificationSettings.morningTime = time;
    notifyListeners();
  }

  void setNightReminder({required bool enabled, TimeOfDay? time}) {
    settings.notificationSettings.nightEnabled = enabled;
    if (time != null) settings.notificationSettings.nightTime = time;
    notifyListeners();
  }

  void setWeeklyWeighIn({required bool enabled, ReminderDay? day, TimeOfDay? time}) {
    settings.notificationSettings.weeklyEnabled = enabled;
    if (day != null) settings.notificationSettings.weeklyDay = day;
    if (time != null) settings.notificationSettings.weeklyTime = time;
    notifyListeners();
  }

  void setMonthlyMetrics({required bool enabled, int? date, TimeOfDay? time}) {
    settings.notificationSettings.monthlyEnabled = enabled;
    if (date != null) settings.notificationSettings.monthlyDate = date.clamp(1, 28);
    if (time != null) settings.notificationSettings.monthlyTime = time;
    notifyListeners();
  }

  void setInactivityAlert({required bool enabled, int? days}) {
    settings.notificationSettings.inactivityEnabled = enabled;
    if (days != null) settings.notificationSettings.inactivityDays = days.clamp(1, 30);
    notifyListeners();
  }

  void setPhaseTransitionReminder(bool enabled) {
    settings.notificationSettings.phaseTransitionEnabled = enabled;
    notifyListeners();
  }

  void setAppSoundEffects(bool enabled) {
    settings.audioSettings.appSoundEffectsEnabled = enabled;
    notifyListeners();
  }

  void setSoundEventToggles({bool? daySelection, bool? creditEarn, bool? rewardRedeem}) {
    if (daySelection != null) settings.audioSettings.daySelectionSoundEnabled = daySelection;
    if (creditEarn != null) settings.audioSettings.creditEarnSoundEnabled = creditEarn;
    if (rewardRedeem != null) settings.audioSettings.rewardRedeemSoundEnabled = rewardRedeem;
    notifyListeners();
  }

  void setAmbientSound({required bool enabled, AmbientSound? sound}) {
    settings.audioSettings.ambientEnabled = enabled;
    if (sound != null) settings.audioSettings.ambientSound = sound;
    notifyListeners();
  }

  void setHapticFeedback(bool enabled) {
    settings.audioSettings.hapticFeedbackEnabled = enabled;
    notifyListeners();
  }

  void setBodybuildingSetup({
    required bool enabled,
    BodybuildingSetupMode? mode,
    String? macroPreset,
    double? calorieMultiplier,
    String? workoutEmphasis,
  }) {
    settings.bodybuildingMode.enabled = enabled;
    if (mode != null) settings.bodybuildingMode.mode = mode;
    if (macroPreset != null) settings.bodybuildingMode.macroPreset = macroPreset;
    if (calorieMultiplier != null) settings.bodybuildingMode.calorieMultiplier = calorieMultiplier;
    if (workoutEmphasis != null) settings.bodybuildingMode.workoutEmphasis = workoutEmphasis;
    notifyListeners();
  }

  void setUnitPreferences({WeightUnit? weight, HeightUnit? height, MeasureUnit? measure}) {
    if (weight != null) settings.unitPreferences.weightUnit = weight;
    if (height != null) settings.unitPreferences.heightUnit = height;
    if (measure != null) settings.unitPreferences.measureUnit = measure;
    notifyListeners();
  }

  void resetRitualDataCurrentWeek() {
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final date = _normalize(now.subtract(Duration(days: i)));
      dailyRoutineCompleted.remove(date);
      dailyCalories.remove(date);
      junkCount.remove(date);
      dayLog.remove(date);
    }
    confirmedDay = DayType.none;
    notifyListeners();
  }

  void evaluateUltimate({
    required UltimateMode requestedMode,
    required int masteryWeeksInRange,
    required double trainingScore,
    required double spiritualScore,
    required int walkingDays,
    required int strengthDays,
    required bool twoWeekLowIntegrity,
    required bool twoWeekStableIntegrity,
  }) {
    ultimateState = _ultimateEngine.evaluate(
      isUnlocked: journey.ultimateUnlocked,
      requestedMode: requestedMode,
      currentlyDefenseActive: ultimateState?.defenseActive ?? false,
      masteryWeeksInRange: masteryWeeksInRange,
      weight: journey.latestWeight,
      bmr: currentBMR,
      weeklyAvgCalories: homeOverview.weeklyAvgCalories,
      junkCount: junkCount.values.isEmpty ? 0 : junkCount.values.last,
      trainingScore: trainingScore,
      spiritualScore: spiritualScore,
      walkingDays: walkingDays,
      strengthDays: strengthDays,
      twoWeekLowIntegrity: twoWeekLowIntegrity,
      twoWeekStableIntegrity: twoWeekStableIntegrity,
    );
    notifyListeners();
  }

  String exportAllDataJson() {
    final map = {
      'profile': {
        'name': userProfile.name,
        'gender': userProfile.gender,
        'age': userProfile.age,
        'weightKg': userProfile.weightKg,
        'heightCm': userProfile.heightCm,
        'waistCm': userProfile.waistCm,
        'chestCm': userProfile.chestCm,
        'hipsCm': userProfile.hipsCm,
        'neckCm': userProfile.neckCm,
        'targetWeightKg': userProfile.targetWeightKg,
      },
      'history': dailyHistory.map((k, v) => MapEntry(k.toIso8601String(), {
            'isBackfilled': v.isBackfilled,
            'dayType': v.ritual.dayType.name,
            'hasTrainingBlock': v.ritual.hasTrainingBlock,
            'systolic': v.health.systolic,
          })),
      'journey': {
        'currentPhase': journey.currentPhase,
        'progress': journey.progress,
      },
      'spiritual': {
        'level': currentSpiritualLevel,
      },
      'credits': {
        'soft': journey.disciplineCredits,
        'big': journey.majorCredits,
      },
      'body': {'bmr': currentBMR}
    };
    return jsonEncode(map);
  }

  bool importAllDataJson(String json) {
    final data = jsonDecode(json);
    if (data is! Map<String, dynamic>) return false;
    const required = ['profile', 'body', 'history', 'journey', 'spiritual', 'credits'];
    for (final key in required) {
      if (!data.containsKey(key)) return false;
    }

    // Overwrite, no merge.
    dailyHistory.clear();

    final profile = data['profile'] as Map<String, dynamic>;
    userProfile
      ..name = profile['name'] as String?
      ..gender = (profile['gender'] as String?) ?? 'male'
      ..age = profile['age'] as int?
      ..weightKg = (profile['weightKg'] as num?)?.toDouble()
      ..heightCm = (profile['heightCm'] as num?)?.toDouble()
      ..waistCm = (profile['waistCm'] as num?)?.toDouble()
      ..chestCm = (profile['chestCm'] as num?)?.toDouble()
      ..hipsCm = (profile['hipsCm'] as num?)?.toDouble()
      ..neckCm = (profile['neckCm'] as num?)?.toDouble()
      ..targetWeightKg = (profile['targetWeightKg'] as num?)?.toDouble();
    userProfile.recomputeCompleteness();

    final journeyMap = data['journey'] as Map<String, dynamic>;
    journey.currentPhase = (journeyMap['currentPhase'] as num?)?.toInt() ?? journey.currentPhase;
    journey.progress = (journeyMap['progress'] as num?)?.toDouble() ?? journey.progress;

    final credits = data['credits'] as Map<String, dynamic>;
    journey.disciplineCredits = (credits['soft'] as num?)?.toInt() ?? journey.disciplineCredits;
    journey.majorCredits = (credits['big'] as num?)?.toInt() ?? journey.majorCredits;

    currentBMR = ((data['body'] as Map<String, dynamic>)['bmr'] as num?)?.toDouble() ?? currentBMR;
    currentSpiritualLevel = ((data['spiritual'] as Map<String, dynamic>)['level'] as num?)?.toDouble() ?? currentSpiritualLevel;

    final historyMap = data['history'] as Map<String, dynamic>;
    historyMap.forEach((k, v) {
      final m = v as Map<String, dynamic>;
      final dt = dateOnly(DateTime.parse(k));
      final rec = DailyRecord(
        date: dt,
        ritual: RitualData(
          dayType: DayType.values.firstWhere((e) => e.name == (m['dayType'] ?? 'none'), orElse: () => DayType.none),
          hasTrainingBlock: m['hasTrainingBlock'] == true,
        ),
        spiritual: SpiritualRecord(),
        health: HealthData(systolic: (m['systolic'] as num?)?.toDouble()),
        selfCare: SelfCareData(),
        isBackfilled: m['isBackfilled'] == true,
      );
      dailyHistory[dt] = rec;
    });

    _recalculateFromDailyHistory();
    notifyListeners();
    return true;
  }

  void setCurrentPhaseForAdmin(int phase) {
    journey.currentPhase = phase.clamp(0, 5);
    notifyListeners();
  }

  void setCurrentSpiritualLevelForAdmin(int level) {
    currentSpiritualLevel = level.clamp(1, 5).toDouble();
    notifyListeners();
  }

  DailyRecord getOrCreateDailyRecord(DateTime date) {
    final key = dateOnly(date);
    return dailyHistory.putIfAbsent(
      key,
      () => DailyRecord(
        date: key,
        ritual: RitualData(),
        spiritual: SpiritualRecord(),
        health: HealthData(),
        selfCare: SelfCareData(),
      ),
    );
  }

  bool canEditDate(DateTime date) => backfillService.canEditDate(date);

  void saveDailyRecord(DateTime date, DailyRecord updated) {
    final key = dateOnly(date);
    final today = dateOnly(DateTime.now());
    if (!canEditDate(key)) return;

    if (key != today) {
      updated.isBackfilled = true;
    }
    dailyHistory[key] = updated;
    _recalculateFromDailyHistory();
    notifyListeners();
  }

  void _recalculateFromDailyHistory() {
    backfillService.recalculateChronologically(dailyHistory, (rec) {
      final d = rec.date;
      dayLog[d] = rec.ritual.dayType;
      dailyRoutineCompleted[d] = rec.ritual.dayType != DayType.none && rec.ritual.hasTrainingBlock;
      if (rec.health.systolic != null) systolicBP[d] = rec.health.systolic!;
      if (rec.health.eczemaLevel != null) eczemaLevel[d] = rec.health.eczemaLevel!;
      if (rec.health.allergyLevel != null) allergyLevel[d] = rec.health.allergyLevel!;
      if (rec.health.weightKg != null) {
        onWeightChanged(rec.health.weightKg!);
      }
    });

    currentStreak = backfillService.calculateStreak(dailyHistory);
  }

  void completeOnboarding(UserProfile profile) {
    profile.recomputeCompleteness();
    userProfile = profile;
    onboardingComplete = true;
    notifyListeners();
  }

  void skipOnboarding() {
    userProfile = UserProfile();
    userProfile.recomputeCompleteness();
    onboardingComplete = true;
    notifyListeners();
  }

  void updateUserProfile(UserProfile profile) {
    profile.recomputeCompleteness();
    userProfile = profile;

    if (userProfile.weightKg != null && userProfile.heightCm != null && userProfile.age != null) {
      final base = 10 * userProfile.weightKg! + 6.25 * userProfile.heightCm! - 5 * userProfile.age! + (userProfile.gender == 'female' ? -161 : 5);
      currentBMR = base;
      onBodyMetricsUpdated(weightKg: userProfile.weightKg!, waistIn: (userProfile.waistCm ?? 0) / 2.54);
    }

    notifyListeners();
  }

}

DateTime _normalize(DateTime date) => DateTime(date.year, date.month, date.day);

// Read-only flag view for other tabs.
class FeatureFlagsView {
  FeatureFlagsView(this._s);
  final JourneyState _s;

  bool get calorieCounterEnabled => _s.calorieCounterUnlocked;
  bool get macroTrackingEnabled => _s.macroTrackingUnlocked;
  bool get foodFeelLoggingEnabled => _s.foodFeelUnlocked;
  bool get ultimateModeEnabled => _s.ultimateUnlocked;
  bool get defenceModeActive => _s.defenceModeActive;
  bool get calorieTrackingMandatory => _s.defenceModeActive;
  bool get macroTrackingMandatory => _s.defenceModeActive;
  bool get mildDeficitFlag => _s.defenceModeActive;
}

enum UltimateModeView { stability, bodybuildingCut, bodybuildingBuild }
