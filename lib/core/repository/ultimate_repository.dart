import '../../ultimate/ultimate_state.dart';
import 'storage_engine.dart';

class UltimateRepository {
  UltimateRepository(this.storage);

  final StorageEngine storage;
  static const String _key = 'ultimate_state';

  Future<void> saveUltimate(UltimateState ultimate) async {
    await storage.save(_key, ultimate.toJson());
  }

  Future<UltimateState?> loadUltimate() async {
    final data = await storage.read(_key);
    return data is Map ? UltimateState.fromJson(Map<String, dynamic>.from(data)) : null;
  }
}
