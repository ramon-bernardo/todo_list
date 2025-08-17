import 'package:flutter/material.dart';

import 'package:flutter_modular/flutter_modular.dart'
    show ModularWatchExtension;
import 'package:todo_list/domain/entities/task.dart';

import 'package:todo_list/domain/entities/task_type.dart';
import 'package:todo_list/presentation/blocs/task/task_cubit.bloc.dart';
import 'package:todo_list/presentation/blocs/task/task_state.bloc.dart';
import 'package:todo_list/presentation/widgets/task_card.widget.dart';

final class TaskListWidget extends StatelessWidget {
  final TaskStatus status;

  const TaskListWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final taskCubit = context.read<TaskCubit>();

    return DragTarget<Task>(
      onWillAcceptWithDetails: (details) {
        final task = details.data;
        return task.status != status;
      },
      onAcceptWithDetails: (details) async {
        final task = details.data;
        await taskCubit.updateStatus(task, status);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(status: status),
              _Items(status: status),
            ],
          ),
        );
      },
    );
  }
}

final class _Header extends StatelessWidget {
  final TaskStatus status;

  const _Header({required this.status});

  @override
  Widget build(BuildContext context) {
    final taskCubit = context.read<TaskCubit>();

    int? getCurrentLength(TaskState state) {
      switch (state) {
        case TaskPendingState():
        case TaskLoadingState():
          return null;

        case TaskSuccessState():
          final filteredTasks = state.tasks
              .where((task) => task.status == status)
              .toList();

          return filteredTasks.length;

        default:
          throw Exception('Invalid TaskCubit state.');
      }
    }

    String getSuffix(int? length) {
      if (length == null) {
        return '(...)';
      } else if (length == 0) {
        return '';
      }
      return '($length)';
    }

    return StreamBuilder(
      stream: taskCubit.stream,
      initialData: taskCubit.state,
      builder: (context, taskStateSnapshot) {
        final currentLength = getCurrentLength(taskStateSnapshot.data!);
        final suffix = getSuffix(currentLength);
        return Text(
          '${status.getDescription} $suffix',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
          ),
        );
      },
    );
  }
}

final class _Items extends StatelessWidget {
  final TaskStatus status;

  const _Items({required this.status});

  @override
  Widget build(BuildContext context) {
    final taskCubit = context.read<TaskCubit>();

    return Expanded(
      child: StreamBuilder(
        stream: taskCubit.stream,
        initialData: taskCubit.state,
        builder: (context, taskStateSnapshot) {
          final state = taskStateSnapshot.data!;
          switch (state) {
            case TaskPendingState():
            case TaskLoadingState():
              return Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: Color(0xFF424242),
                  ),
                ),
              );

            case TaskSuccessState():
              final filteredTasks = state.tasks
                  .where((task) => task.status == status)
                  .toList();

              return Visibility(
                visible: filteredTasks.isNotEmpty,
                replacement: Text(
                  'Nenhuma tarefa encontrada.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF424242)),
                ),
                child: ListView(
                  children: filteredTasks
                      .map((task) => TaskCardWidget(task: task))
                      .toList(),
                ),
              );

            default:
              throw Exception('Invalid TaskCubit state.');
          }
        },
      ),
    );
  }
}
