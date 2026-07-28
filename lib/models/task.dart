enum TaskStatus {
  todo,
  inProgress,
  done,
}

class Task {
  final String id;
  final String title;
  final TaskStatus status;
  final DateTime? deadline;

  const Task({
    required this.id,
    required this.title,
    required this.status,
    this.deadline,
  });
}