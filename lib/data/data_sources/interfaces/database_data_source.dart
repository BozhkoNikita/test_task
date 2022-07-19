import 'package:test_task/domain/entities/task.dart';

abstract class DatabaseDataSource {
  Future<Task> createTask(Task task);

  Future<List<Task>> getTasks();

  Future<void> deleteTask(int taskId);

  Future<void> updateTask(Task task);

  void dispose();
}