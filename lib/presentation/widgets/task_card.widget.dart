import 'package:flutter/material.dart';

import 'package:flutter_modular/flutter_modular.dart'
    show ModularWatchExtension;

import 'package:todo_list/domain/entities/task.dart';
import 'package:todo_list/presentation/blocs/task/task_cubit.bloc.dart';

final class TaskCardWidget extends StatelessWidget {
  final Task task;

  const TaskCardWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Draggable(
        data: task,
        feedback: Material(
          color: Colors.transparent,
          child: _Content(task: task, inDrag: true),
        ),
        childWhenDragging: Opacity(
          opacity: 0.4,
          child: _Content(task: task, inDrag: true),
        ),
        child: _Content(task: task),
      ),
    );
  }
}

final class _Content extends StatelessWidget {
  final Task task;
  final bool inDrag;

  const _Content({required this.task, this.inDrag = false});

  @override
  Widget build(BuildContext context) {
    final taskCubit = context.read<TaskCubit>();

    Future<void> handleDeleteRequested() async {
      // Add a loading service to block user input while saving...
      await taskCubit.delete(task);
    }

    return Card(
      elevation: 0,
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (task.description != null)
                  Text(
                    task.description!,
                    style: const TextStyle(
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            if (!inDrag)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: handleDeleteRequested,
              ),
          ],
        ),
      ),
    );
  }
}
