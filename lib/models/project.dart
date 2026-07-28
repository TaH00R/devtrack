enum ProjectStatus {
  planning,
  active,
  completed,
  paused,
}

class Project {
  final String id;
  final String title;
  final String description;
  final double progress;
  final ProjectStatus status;
  final List<String> technologies;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.status,
    required this.technologies,
  });
}