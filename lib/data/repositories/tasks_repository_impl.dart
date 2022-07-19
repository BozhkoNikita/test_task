import 'package:test_task/data/data_sources/interfaces/database_data_source.dart';
import 'package:test_task/domain/data_interfaces/tasks_repository.dart';
import 'package:test_task/domain/entities/task.dart';

class TasksRepositoryImpl implements TasksRepository {
  final DatabaseDataSource _databaseDataSource;

  TasksRepositoryImpl(this._databaseDataSource);

  @override
  Future<Task> createTask(Task task) => _databaseDataSource.createTask(task);

  @override
  Future<void> deleteTask(int taskId) => _databaseDataSource.deleteTask(taskId);

  @override
  Future<List<Task>> getTasks() => _databaseDataSource.getTasks();

  @override
  Future<void> updateTask(Task task) => _databaseDataSource.updateTask(task);
}
