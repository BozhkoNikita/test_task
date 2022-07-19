import 'package:test_task/data/entities/task_db.dart';

import '../../domain/entities/task.dart';

extension TaskMapper on TaskDB {
  Task fromHive() => Task(id: id, title: title, isDone: isDone);
}

extension TaskDbMapper on Task {
  TaskDB toHive() => TaskDB(id: id, title: title, isDone: isDone);
}
