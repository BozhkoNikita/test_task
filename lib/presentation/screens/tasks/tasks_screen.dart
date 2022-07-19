import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:test_task/presentation/screens/tasks/tasks_cubit.dart';
import 'package:test_task/presentation/screens/tasks/tasks_state.dart';
import 'package:test_task/presentation/utils/bottom_sheet.dart';
import 'package:test_task/presentation/utils/constants.dart';
import 'package:test_task/presentation/widgets/task_tile.dart';

import '../../../domain/entities/task.dart';
import '../../utils/colors.dart';

const _expandedHeight = 125.0;
const _toolbarHeight = 50.0;
const _expandDelta = _expandedHeight - _toolbarHeight;

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final ScrollController _scrollController = ScrollController();
  double _expandMultiplier = 1.0;
  final TasksCubit _cubit = GetIt.I.get<TasksCubit>();

  @override
  void initState() {
    _cubit.init();
    _scrollController.addListener(
      () {
        final offset = _scrollController.hasClients ? _scrollController.offset : 0;
        setState(
          () {
            _expandMultiplier = offset > _expandDelta ? 0.0 : 1.0 - (offset / _expandDelta);
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      bloc: _cubit,
      builder: (context, state) {
        final done = state.tasks.where((task) => task.isDone).map(_taskToTile).toList();
        final todo = state.tasks.where((task) => !task.isDone).map(_taskToTile).toList();
        return Material(
          child: Stack(
            children: [
              ColoredBox(
                color: AppColors.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.normal),
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        backgroundColor: AppColors.backgroundColor,
                        elevation: 0,
                        expandedHeight: _expandedHeight,
                        toolbarHeight: _toolbarHeight,
                        pinned: true,
                        leadingWidth: 0,
                        flexibleSpace: FlexibleSpaceBar(
                          titlePadding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top,
                          ),
                          expandedTitleScale: 1,
                          title: _Title(
                            expandMultiplier: _expandMultiplier,
                            count: todo.length,
                          ),
                        ),
                        actions: [
                          if (state.isOnEdit)
                            _IconButton(
                              icon: Icons.close,
                              onTap: _cubit.setOffEdit,
                            ),
                          _IconButton(
                            icon: Icons.delete,
                            onTap: () {
                              if (state.isOnEdit) {
                                _cubit.setOffEdit();
                                _cubit.delete();
                              } else {
                                _cubit.setOnEdit();
                              }
                            },
                          ),
                        ],
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            ...todo,
                            const SizedBox(height: AppDimens.normal),
                            if (done.isNotEmpty) ...[
                              Text(
                                'done (${done.length})',
                                style: const TextStyle(color: AppColors.subtitle),
                              ),
                              ...done,
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _FloatingActionButton(
                onCreate: (title) {
                  _cubit.addTask(
                    Task(
                      isDone: false,
                      title: title,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  TaskTile _taskToTile(Task task) {
    return TaskTile(
      task: task,
      onDone: (isDone) => _cubit.editDone(task, isDone),
      isSelected: _cubit.state.selected.contains(task),
      onSelect: (isSelected) => _cubit.select(task),
      isOnEdit: _cubit.state.isOnEdit,
      onLongPress: () {
        _cubit.setOnEdit();
        _cubit.select(task);
      },
      onTap: () {
        AppBottomSheet.showSheet(
          context: context,
          task: task,
          onSave: (title) {
            _cubit.editTitle(task, title);
          },
        );
      },
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  final TaskSaveCallback onCreate;

  const _FloatingActionButton({
    Key? key,
    required this.onCreate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppDimens.big,
      right: AppDimens.big,
      child: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          AppBottomSheet.showSheet(
            context: context,
            onSave: onCreate,
          );
        },
        child: const Icon(Icons.add, size: AppSize.big),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: AppSize.normal,
      icon: Icon(
        icon,
        color: AppColors.title,
      ),
      onPressed: onTap,
    );
  }
}

class _Title extends StatelessWidget {
  final double expandMultiplier;
  final int count;

  const _Title({
    Key? key,
    required this.expandMultiplier,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "To-dos",
                style: TextStyle(
                  fontSize: 22 + (20 * expandMultiplier),
                  color: AppColors.title,
                ),
              ),
              Text(
                "$count to-dos",
                style: TextStyle(
                  fontSize: 16 * expandMultiplier,
                  color: AppColors.accent.withOpacity(expandMultiplier),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 1,
            width: MediaQuery.of(context).size.width * (1 - expandMultiplier),
            child: const Divider(height: 1),
          ),
        ),
      ],
    );
  }
}
