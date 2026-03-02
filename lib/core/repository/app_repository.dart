import '../domain/app_state.dart';
import 'storage_engine.dart';

class AppRepository {
  AppRepository(this.storage);

  final StorageEngine storage;

  static const String _key = 'app_state';

  Future<void> saveAppState(AppState state) async {
    await storage.save(_key, state.toJson());
  }

  Future<AppState?> loadAppState() async {
    final data = await storage.read(_key);
    if (data is Map) {
      return AppState.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }
}
