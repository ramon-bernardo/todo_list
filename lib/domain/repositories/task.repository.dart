import 'package:todo_list/domain/entities/task.dart';

abstract interface class TaskRepository {
  Future<List<Task>> find();
  Future<Task> save(Task task);
  Future<void> delete(int id);
}
