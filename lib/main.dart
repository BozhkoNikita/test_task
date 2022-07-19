import 'package:flutter/material.dart';
import 'package:test_task/presentation/app/app.dart';
import 'package:test_task/presentation/di/injector.dart';

import 'data/data_sources/database_data_source_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseDataSourceImpl.initializeHive();
  initInjector();
  runApp(const App());
}
