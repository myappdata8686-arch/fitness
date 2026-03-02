import '../../murshid/murshid_relationship_engine.dart';
import 'storage_engine.dart';

class MurshidRepository {
  MurshidRepository(this.storage);

  final StorageEngine storage;
  static const String _key = 'murshid_state';

  Future<void> saveMurshidState(MurshidState murshidState) async {
    await storage.save(_key, murshidState.toJson());
  }

  Future<MurshidState?> loadMurshidState() async {
    final data = await storage.read(_key);
    return data is Map ? MurshidState.fromJson(Map<String, dynamic>.from(data)) : null;
  }
}
