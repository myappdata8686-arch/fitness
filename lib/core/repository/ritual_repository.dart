import '../domain/app_state.dart';
import 'storage_engine.dart';

class RitualRepository {
  RitualRepository(this.storage);

  final StorageEngine storage;
  static const String _key = 'ritual_state';

  Future<void> saveRitual(RitualState ritual) async {
    await storage.save(_key, ritual.toJson());
  }

  Future<RitualState?> loadRitual() async {
    final data = await storage.read(_key);
    return data is Map ? RitualState.fromJson(Map<String, dynamic>.from(data)) : null;
  }
}
