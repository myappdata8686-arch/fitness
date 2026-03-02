enum RelationshipStage { initial, familiar, bonded, intimate }

RelationshipStage relationshipStageFromName(String? value) {
  return RelationshipStage.values.firstWhere(
    (stage) => stage.name == value,
    orElse: () => RelationshipStage.initial,
  );
}

class MurshidState {
  MurshidState({
    this.sleepMode = false,
    this.stage = RelationshipStage.initial,
    this.totalMessages = 0,
    this.emotionalDepthScore = 0,
    this.vulnerabilityScore = 0,
    this.humorSharedCount = 0,
    this.crisisSupportMoments = 0,
    DateTime? onboardingDate,
  }) : onboardingDate = onboardingDate ?? DateTime.now();

  bool sleepMode;
  RelationshipStage stage;
  int totalMessages;
  int emotionalDepthScore;
  int vulnerabilityScore;
  int humorSharedCount;
  int crisisSupportMoments;
  DateTime onboardingDate;

  Map<String, dynamic> toJson() {
    return {
      'sleepMode': sleepMode,
      'stage': stage.name,
      'totalMessages': totalMessages,
      'emotionalDepthScore': emotionalDepthScore,
      'vulnerabilityScore': vulnerabilityScore,
      'humorSharedCount': humorSharedCount,
      'crisisSupportMoments': crisisSupportMoments,
      'onboardingDate': onboardingDate.toIso8601String(),
    };
  }

  factory MurshidState.fromJson(Map<String, dynamic> json) {
    return MurshidState(
      sleepMode: json['sleepMode'] == true,
      stage: relationshipStageFromName(json['stage'] as String?),
      totalMessages: json['totalMessages'] as int? ?? 0,
      emotionalDepthScore: json['emotionalDepthScore'] as int? ?? 0,
      vulnerabilityScore: json['vulnerabilityScore'] as int? ?? 0,
      humorSharedCount: json['humorSharedCount'] as int? ?? 0,
      crisisSupportMoments: json['crisisSupportMoments'] as int? ?? 0,
      onboardingDate: DateTime.tryParse(json['onboardingDate'] as String? ?? ''),
    );
  }
}

class MurshidRelationshipEngine {
  void updateStage(MurshidState state) {
    final ageDays = DateTime.now().difference(state.onboardingDate).inDays;
    final score = (state.emotionalDepthScore * 3) +
        (state.vulnerabilityScore * 5) +
        (state.crisisSupportMoments * 6) +
        (state.humorSharedCount * 2);

    if (ageDays < 14 && score > 60) {
      state.stage = RelationshipStage.familiar;
      return;
    }

    if (score <= 20) {
      state.stage = RelationshipStage.initial;
    } else if (score <= 60) {
      state.stage = RelationshipStage.familiar;
    } else if (score <= 120) {
      state.stage = RelationshipStage.bonded;
    } else {
      state.stage = RelationshipStage.intimate;
    }
  }

  String titleFor(MurshidState state, {required bool humorDetected}) {
    switch (state.stage) {
      case RelationshipStage.initial:
        return 'Murshid';
      case RelationshipStage.familiar:
        return 'Bhai';
      case RelationshipStage.bonded:
        return 'Adu';
      case RelationshipStage.intimate:
        if (humorDetected && state.humorSharedCount > 10) return 'My love';
        return 'Mere jan';
    }
  }
}
