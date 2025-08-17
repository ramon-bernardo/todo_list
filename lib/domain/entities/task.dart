import 'package:flutter/widgets.dart';

import 'package:todo_list/domain/entities/task_type.dart';

@immutable
final class Task {
  final int? id;
  final String title;
  final String? description;
  final TaskStatus status;

  const Task({
    required this.id,
    required this.title,
    required this.status,
    required this.description,
  }) : assert(id == null || id > 0);
}
