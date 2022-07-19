import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/domain/data_interfaces/tasks_repository.dart';
import 'package:test_task/presentation/screens/tasks/tasks_state.dart';

import '../../../domain/entities/task.dart';

class TasksCubit extends Cubit<TasksState> {
  final TasksRepository _tasksRepository;

  TasksCubit(this._tasksRepository)
      : super(
          const TasksState(
            tasks: [],
            selected: [],
            isOnEdit: false,
          ),
        );

  void init() {
    _tasksRepository.getTasks().then(
      (tasks) {
        return emit(state.copyWith(tasks: tasks));
      },
    );
  }

  void editDone(Task task, bool isDone) async {
    final tasks = List.of(state.tasks);
    final index = tasks.indexOf(task);
    final updated = task.copyWith(isDone: isDone);
    _tasksRepository.updateTask(updated).then(
      (_) {
        tasks.remove(task);
        tasks.insert(index, updated);
        emit(state.copyWith(tasks: tasks));
      },
    );
  }

  void addTask(Task task) async {
    _tasksRepository.createTask(task).then(
      (task) {
        final tasks = List.of(state.tasks);
        tasks.add(task);
        emit(state.copyWith(tasks: tasks));
      },
    );
  }

  void editTitle(Task task, String title) async {
    final tasks = List.of(state.tasks);
    final index = tasks.indexOf(task);
    final updated = task.copyWith(title: title);
    _tasksRepository.updateTask(updated).then(
      (_) {
        tasks.remove(task);
        tasks.insert(index, updated);
        emit(state.copyWith(tasks: tasks));
      },
    );
  }

  void select(Task task) {
    final selected = List.of(state.selected);
    if (selected.contains(task)) {
      selected.remove(task);
    } else {
      selected.add(task);
    }
    emit(state.copyWith(selected: selected));
  }

  void setOnEdit() => emit(state.copyWith(isOnEdit: true));

  void setOffEdit() => emit(state.copyWith(isOnEdit: false));

  void delete() async {
    final tasks = List.of(state.tasks);
    for (var task in state.selected) {
      await _tasksRepository.deleteTask(task.id!).then(
        (_) {
          tasks.remove(task);
        },
      );
    }
    emit(
      state.copyWith(
        tasks: tasks,
        selected: [],
      ),
    );
  }
}
