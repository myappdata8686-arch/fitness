import '../domain/app_state.dart';
import 'storage_engine.dart';

class JourneyRepository {
  JourneyRepository(this.storage);

  final StorageEngine storage;
  static const String _key = 'journey_state';

  Future<void> saveJourney(JourneyState journey) async {
    await storage.save(_key, journey.toJson());
  }

  Future<JourneyState?> loadJourney() async {
    final data = await storage.read(_key);
    return data is Map ? JourneyState.fromJson(Map<String, dynamic>.from(data)) : null;
  }
}
