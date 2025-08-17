import 'package:todo_list/domain/entities/task.dart';
import 'package:todo_list/domain/repositories/task.repository.dart';

final class TaskInMemoryRepository implements TaskRepository {
  final _tasks = <int, Task>{};

  @override
  Future<List<Task>> find() async {
    return _tasks.values.toList();
  }

  @override
  Future<Task> save(Task task) async {
    int lastTaskId() {
      if (_tasks.keys.isEmpty) {
        return 0;
      }

      return _tasks.keys.reduce(
        (previous, current) => previous > current ? previous : current,
      );
    }

    Task insertTask(Task task) {
      final id = lastTaskId() + 1;
      final updatedTask = Task(
        id: id,
        title: task.title,
        description: task.description,
        status: task.status,
      );

      _tasks[id] = updatedTask;
      return updatedTask;
    }

    Task updateTask(int id, Task task) {
      _tasks[id] = task;
      return task;
    }

    final id = task.id;
    if (id == null) {
      return insertTask(task);
    }
    return updateTask(id, task);
  }

  @override
  Future<void> delete(int id) async {
    _tasks.remove(id);
  }
}
