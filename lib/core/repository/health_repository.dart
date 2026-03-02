import '../domain/app_state.dart';
import 'storage_engine.dart';

class HealthRepository {
  HealthRepository(this.storage);

  final StorageEngine storage;
  static const String _key = 'health_state';

  Future<void> saveHealth(HealthState health) async {
    await storage.save(_key, health.toJson());
  }

  Future<HealthState?> loadHealth() async {
    final data = await storage.read(_key);
    return data is Map ? HealthState.fromJson(Map<String, dynamic>.from(data)) : null;
  }
}
