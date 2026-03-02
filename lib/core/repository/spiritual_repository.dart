import '../domain/app_state.dart';
import 'storage_engine.dart';

class SpiritualRepository {
  SpiritualRepository(this.storage);

  final StorageEngine storage;
  static const String _key = 'spiritual_state';

  Future<void> saveSpiritual(SpiritualState spiritual) async {
    await storage.save(_key, spiritual.toJson());
  }

  Future<SpiritualState?> loadSpiritual() async {
    final data = await storage.read(_key);
    return data is Map ? SpiritualState.fromJson(Map<String, dynamic>.from(data)) : null;
  }
}
