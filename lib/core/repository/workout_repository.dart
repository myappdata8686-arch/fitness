import 'storage_engine.dart';

class WorkoutSession {
  const WorkoutSession({
    required this.date,
    required this.name,
    this.steps = 0,
    this.durationMinutes = 0,
  });

  final DateTime date;
  final String name;
  final int steps;
  final int durationMinutes;

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'name': name,
      'steps': steps,
      'durationMinutes': durationMinutes,
    };
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      name: json['name'] as String? ?? '',
      steps: json['steps'] as int? ?? 0,
      durationMinutes: json['durationMinutes'] as int? ?? 0,
    );
  }
}

class WorkoutRepository {
  WorkoutRepository(this.storage);

  final StorageEngine storage;

  Future<void> saveWorkoutSession(WorkoutSession session) async {
    await storage.saveWorkout(session.date.toIso8601String(), session.toJson());
  }

  Future<WorkoutSession?> getWorkoutSession(DateTime date) async {
    final data = await storage.readWorkout(date.toIso8601String());
    return data is Map ? WorkoutSession.fromJson(Map<String, dynamic>.from(data)) : null;
  }
}
