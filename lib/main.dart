import 'package:flutter/material.dart';

import 'package:flutter_modular/flutter_modular.dart';

import 'package:todo_list/data/repositories/task_inmemory.repository.dart';
import 'package:todo_list/domain/repositories/task.repository.dart';
import 'package:todo_list/presentation/blocs/task/task_cubit.bloc.dart';
import 'package:todo_list/presentation/blocs/task_registration_form/task_registration_form_cubit.bloc.dart';
import 'package:todo_list/presentation/pages/home.page.dart';

void main() {
  runApp(ModularApp(module: _AppModule(), child: _AppWidget()));
}

final class _AppModule extends Module {
  @override
  void binds(final i) {
    // Repositories
    i.addLazySingleton<TaskRepository>(TaskInMemoryRepository.new);

    // Cubits
    i.addLazySingleton<TaskCubit>(TaskCubit.new);
    i.addLazySingleton<TaskRegistrationFormCubit>(
      TaskRegistrationFormCubit.new,
    );
  }

  @override
  void routes(final r) {
    r.child('/', child: (_) => const HomePage());
  }
}

final class _AppWidget extends StatelessWidget {
  const _AppWidget();

  @override
  Widget build(final context) {
    return MaterialApp.router(
      title: 'To-Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(primary: const Color(0xFF424242)),
      ),
      routerConfig: Modular.routerConfig,
    );
  }
}
