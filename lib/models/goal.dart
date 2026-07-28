enum GoalPriority { low, medium, high }

class Goal {
  final String id;
  final String title;
  final bool completed;
  final GoalPriority priority;

  const Goal({
    required this.id,
    required this.title,
    required this.completed,
    required this.priority,
  });
}