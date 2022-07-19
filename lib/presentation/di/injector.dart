import 'package:get_it/get_it.dart';
import 'package:test_task/data/data_sources/database_data_source_impl.dart';
import 'package:test_task/data/data_sources/interfaces/database_data_source.dart';
import 'package:test_task/data/repositories/tasks_repository_impl.dart';
import 'package:test_task/domain/data_interfaces/tasks_repository.dart';
import 'package:test_task/presentation/screens/tasks/tasks_cubit.dart';

GetIt get i => GetIt.instance;

void initInjector() {
  i.registerSingleton<DatabaseDataSource>(
    DatabaseDataSourceImpl(),
  );
  i.registerSingleton<TasksRepository>(
    TasksRepositoryImpl(
      i.get(),
    ),
  );
  i.registerFactory(
    () => TasksCubit(
      i.get(),
    ),
  );
}
