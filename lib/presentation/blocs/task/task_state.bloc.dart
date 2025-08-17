import 'package:todo_list/domain/entities/task.dart';

abstract class TaskState {}

final class TaskPendingState extends TaskState {}

final class TaskLoadingState extends TaskState {}

final class TaskSuccessState extends TaskState {
  final List<Task> tasks;

  TaskSuccessState({required this.tasks});
}
