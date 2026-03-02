import 'package:hive/hive.dart';

abstract class StorageEngine {
  Future<void> save(String key, dynamic value);
  Future<dynamic> read(String key);
  Future<void> delete(String key);
  Future<void> clear();

  Future<void> saveCalendar(String key, dynamic value);
  Future<dynamic> readCalendar(String key);
  Future<void> deleteCalendar(String key);

  Future<void> saveWorkout(String key, dynamic value);
  Future<dynamic> readWorkout(String key);
  Future<void> deleteWorkout(String key);
}

class InMemoryStorageEngine implements StorageEngine {
  final Map<String, dynamic> _memory = {};
  final Map<String, dynamic> _calendarMemory = {};
  final Map<String, dynamic> _workoutMemory = {};

  @override
  Future<void> save(String key, dynamic value) async {
    _memory[key] = value;
  }

  @override
  Future<dynamic> read(String key) async {
    return _memory[key];
  }

  @override
  Future<void> delete(String key) async {
    _memory.remove(key);
  }

  @override
  Future<void> clear() async {
    _memory.clear();
    _calendarMemory.clear();
    _workoutMemory.clear();
  }

  @override
  Future<void> saveCalendar(String key, dynamic value) async {
    _calendarMemory[key] = value;
  }

  @override
  Future<dynamic> readCalendar(String key) async {
    return _calendarMemory[key];
  }

  @override
  Future<void> deleteCalendar(String key) async {
    _calendarMemory.remove(key);
  }

  @override
  Future<void> saveWorkout(String key, dynamic value) async {
    _workoutMemory[key] = value;
  }

  @override
  Future<dynamic> readWorkout(String key) async {
    return _workoutMemory[key];
  }

  @override
  Future<void> deleteWorkout(String key) async {
    _workoutMemory.remove(key);
  }
}

class HiveStorageEngine implements StorageEngine {
  HiveStorageEngine({
    Box<dynamic>? appBox,
    Box<dynamic>? calendarBox,
    Box<dynamic>? workoutBox,
  })  : _appBox = appBox ?? Hive.box('appBox'),
        _calendarBox = calendarBox ?? Hive.box('calendarBox'),
        _workoutBox = workoutBox ?? Hive.box('workoutBox');

  final Box<dynamic> _appBox;
  final Box<dynamic> _calendarBox;
  final Box<dynamic> _workoutBox;

  @override
  Future<void> save(String key, dynamic value) async {
    await _appBox.put(key, value);
  }

  @override
  Future<dynamic> read(String key) async {
    return _appBox.get(key);
  }

  @override
  Future<void> delete(String key) async {
    await _appBox.delete(key);
  }

  @override
  Future<void> clear() async {
    await _appBox.clear();
    await _calendarBox.clear();
    await _workoutBox.clear();
  }

  @override
  Future<void> saveCalendar(String key, dynamic value) async {
    await _calendarBox.put(key, value);
  }

  @override
  Future<dynamic> readCalendar(String key) async {
    return _calendarBox.get(key);
  }

  @override
  Future<void> deleteCalendar(String key) async {
    await _calendarBox.delete(key);
  }

  @override
  Future<void> saveWorkout(String key, dynamic value) async {
    await _workoutBox.put(key, value);
  }

  @override
  Future<dynamic> readWorkout(String key) async {
    return _workoutBox.get(key);
  }

  @override
  Future<void> deleteWorkout(String key) async {
    await _workoutBox.delete(key);
  }
}
