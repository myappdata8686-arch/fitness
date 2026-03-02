import 'package:flutter/foundation.dart';

import '../repository/app_repository.dart';
import '../repository/storage_engine.dart';
import 'app_event.dart';
import 'app_state.dart';
import 'recalculation_pipeline.dart';

class AppCoordinator extends ChangeNotifier {
  AppCoordinator({
    AppState? initialState,
    AppRepository? repository,
  })  : repository = repository ?? AppRepository(HiveStorageEngine()),
        _state = initialState ??
            AppState(
              ritual: const RitualState(),
              spiritual: const SpiritualState(),
              health: const HealthState(),
              journey: const JourneyState(),
              ultimate: RecalculationPipeline.initialUltimateState(),
              murshid: RecalculationPipeline.initialMurshidState(),
              trends: const TrendState(),
              lastUpdated: DateTime.now(),
            );

  final AppRepository repository;
  AppState _state;

  AppState get state => _state;

  Future<void> initialize() async {
    final loaded = await repository.loadAppState();
    if (loaded != null) {
      _state = loaded;
      notifyListeners();
    }
  }

  Future<void> dispatch(AppEvent event) async {
    _state = RecalculationPipeline.process(_state, event);
    await repository.saveAppState(_state);
    notifyListeners();
  }
}
