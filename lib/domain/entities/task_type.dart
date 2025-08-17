enum TaskStatus {
  pending,
  doing,
  done;

  String get getDescription {
    switch (this) {
      case TaskStatus.pending:
        return 'Pendente';
      case TaskStatus.doing:
        return 'Em andamento';
      case TaskStatus.done:
        return 'Concluído';
    }
  }
}
