import 'package:bloc/bloc.dart' show Cubit;

import 'package:todo_list/domain/entities/task.dart';
import 'package:todo_list/domain/entities/task_type.dart';
import 'package:todo_list/domain/repositories/task.repository.dart';
import 'package:todo_list/presentation/blocs/task/task_state.bloc.dart';

final class TaskCubit extends Cubit<TaskState> {
  final TaskRepository _taskRepository;

  TaskCubit(this._taskRepository) : super(TaskPendingState());

  Future<void> init() async {
    emit(TaskLoadingState());
    final tasks = await _taskRepository.find();
    emit(TaskSuccessState(tasks: tasks));
  }

  Future<void> save(Task task) async {
    await _taskRepository.save(task);
    await init();
  }

  Future<void> updateStatus(Task task, TaskStatus status) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      status: status,
    );

    await _taskRepository.save(updatedTask);
    await init();
  }

  Future<void> delete(Task task) async {
    final id = task.id;
    if (id != null) {
      await _taskRepository.delete(id);
      await init();
    }
  }
}
