import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

import 'features/todos/cubit/todo_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // Shared Package - Repositories
  // Note: For local storage, no network providers are required here
  sl.registerLazySingleton<TodoDataRepository>(
    () => TodoDataRepository(),
  );

  // Cubits
  sl.registerFactory<TodoCubit>(() => TodoCubit(sl<TodoDataRepository>()));
}
