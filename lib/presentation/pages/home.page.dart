import 'package:flutter/material.dart';

import 'package:flutter_modular/flutter_modular.dart'
    show ModularWatchExtension;

import 'package:todo_list/domain/entities/task_type.dart';
import 'package:todo_list/presentation/blocs/task/task_cubit.bloc.dart';
import 'package:todo_list/presentation/modals/task_registration.modal.dart';
import 'package:todo_list/presentation/widgets/add_button.dart';
import 'package:todo_list/presentation/widgets/task_list.widget.dart';

final class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final class _HomePageState extends State<HomePage> {
  late final _taskCubit = context.read<TaskCubit>();

  @override
  void initState() {
    // Init with the saved tasks.
    _taskCubit.init();

    super.initState();
  }

  @override
  Widget build(final context) {
    return Scaffold(appBar: _AppBar(), body: _Body());
  }
}

final class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'MEU TO-DO LIST',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: const Color(0xFF424242),
        ),
      ),
    );
  }
}

final class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    Future<void> handleAddRequested() async {
      await showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        constraints: BoxConstraints(maxHeight: 390.0),
        builder: (context) => TaskRegistrationModal(),
      );
    }

    final orientation = MediaQuery.of(context).orientation;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 16,
        children: [
          AddButton(
            text: 'Adicionar nova tarefa',
            onPressed: handleAddRequested,
          ),
          Expanded(
            child: Flex(
              direction: orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: TaskStatus.values
                  .map(
                    (status) => Expanded(child: TaskListWidget(status: status)),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
