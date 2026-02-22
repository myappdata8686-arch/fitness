import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/physical_repository.dart';
import '../domain/physical_engine.dart';
import '../domain/physical_models.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final physicalRepositoryProvider = Provider<PhysicalRepository>((ref) {
  return FirestorePhysicalRepository(ref.watch(firestoreProvider));
});

final physicalEngineProvider = Provider<PhysicalEngine>((ref) => const PhysicalEngine());

class TodayState {
  const TodayState({
    this.dayColor,
    this.checklist = const <String>[],
    this.completed = const <String>{},
    this.isLoading = false,
  });

  final DayColor? dayColor;
  final List<String> checklist;
  final Set<String> completed;
  final bool isLoading;

  TodayState copyWith({
    DayColor? dayColor,
    List<String>? checklist,
    Set<String>? completed,
    bool? isLoading,
  }) {
    return TodayState(
      dayColor: dayColor ?? this.dayColor,
      checklist: checklist ?? this.checklist,
      completed: completed ?? this.completed,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class TodayController extends StateNotifier<TodayState> {
  TodayController(this._engine, this._repository) : super(const TodayState());

  final PhysicalEngine _engine;
  final PhysicalRepository _repository;

  void buildChecklist({required int phaseId, required DailyCheckInInput input}) {
    final DayColor color = _engine.evaluateColor(input);
    final List<String> checklist = _engine.checklistFor(phaseId: phaseId, color: color);
    state = state.copyWith(dayColor: color, checklist: checklist, completed: <String>{});
  }

  void toggleItem(String item, bool selected) {
    final Set<String> completed = <String>{...state.completed};
    if (selected) {
      completed.add(item);
    } else {
      completed.remove(item);
    }
    state = state.copyWith(completed: completed);
  }

  Future<void> persist({required String userId, required DailyCheckInInput input}) async {
    if (state.dayColor == null || state.checklist.isEmpty) return;

    state = state.copyWith(isLoading: true);
    await _repository.saveCheckIn(
      userId: userId,
      date: DateTime.now(),
      input: input,
      color: state.dayColor!,
      checklist: state.checklist,
    );
    state = state.copyWith(isLoading: false);
  }
}

final todayControllerProvider = StateNotifierProvider<TodayController, TodayState>((ref) {
  return TodayController(ref.watch(physicalEngineProvider), ref.watch(physicalRepositoryProvider));
});
