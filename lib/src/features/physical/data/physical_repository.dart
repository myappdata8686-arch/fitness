import 'package:cloud_firestore/cloud_firestore.dart';

import '../../shared/data/firestore_collections.dart';
import '../domain/physical_models.dart';

abstract class PhysicalRepository {
  Future<void> saveCheckIn({
    required String userId,
    required DateTime date,
    required DailyCheckInInput input,
    required DayColor color,
    required List<String> checklist,
  });
}

class FirestorePhysicalRepository implements PhysicalRepository {
  FirestorePhysicalRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<void> saveCheckIn({
    required String userId,
    required DateTime date,
    required DailyCheckInInput input,
    required DayColor color,
    required List<String> checklist,
  }) async {
    await _firestore.collection(FirestoreCollections.dailyLogs).add(<String, dynamic>{
      'user_id': userId,
      'date': Timestamp.fromDate(date),
      'sleep': input.sleep,
      'energy': input.energy.name,
      'stress': input.stress.name,
      'pain': input.pain,
      'illness': input.illness,
      'day_color': color.name,
      'checklist': checklist,
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}
