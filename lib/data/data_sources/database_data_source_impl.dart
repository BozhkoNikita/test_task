import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_task/data/data_sources/interfaces/database_data_source.dart';
import 'package:test_task/data/mappers/task_mapper.dart';
import 'package:test_task/domain/entities/task.dart';

import '../entities/task_db.dart';

class DatabaseDataSourceImpl extends DatabaseDataSource {
  static const _tasksTag = 'tasks';
  static const _testTag = 'test';

  static late final Box<TaskDB> _tasksBox;

  static Future<void> initializeHive({isTesting = false}) async {
    Directory document = await getApplicationDocumentsDirectory();
    Hive
      ..init(document.path)
      ..registerAdapter(TaskDBAdapter());
    _tasksBox = await Hive.openBox<TaskDB>(isTesting ? _testTag : _tasksTag);
    if (isTesting) await _tasksBox.clear();
  }

  @override
  Future<Task> createTask(Task task) async {
    final toCreate = TaskDB(title: task.title, isDone: task.isDone);
    final id = await _tasksBox.add(toCreate);
    final created = toCreate.copyWith(id: id);
    await _tasksBox.put(id, created);
    return created.fromHive();
  }

  @override
  Future<List<Task>> getTasks() async {
    Iterable<TaskDB> result;
    result = _tasksBox.values;
    return List<Task>.generate(
      result.length,
      (index) => result.elementAt(index).fromHive(),
    );
  }

  @override
  Future<void> deleteTask(int taskId) async => _tasksBox.delete(taskId);

  @override
  Future<void> updateTask(Task task) async => _tasksBox.put(task.id!, task.toHive());

  @override
  Future<void> dispose() async => await _tasksBox.close();
}
