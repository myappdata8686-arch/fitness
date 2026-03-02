import '../domain/app_state.dart';
import 'storage_engine.dart';

class TrendsRepository {
  TrendsRepository(this.storage);

  final StorageEngine storage;
  static const String _key = 'trends_state';

  Future<void> saveTrends(TrendState trends) async {
    await storage.save(_key, trends.toJson());
  }

  Future<TrendState?> loadTrends() async {
    final data = await storage.read(_key);
    return data is Map ? TrendState.fromJson(Map<String, dynamic>.from(data)) : null;
  }

  Future<List<double>> getIntegrityTrend() async {
    final trends = await loadTrends();
    return trends?.integrityTrend ?? const <double>[];
  }
}
