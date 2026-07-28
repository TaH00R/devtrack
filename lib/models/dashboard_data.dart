import 'package:devtrack/models/achievement.dart';
import 'package:devtrack/models/goal.dart';
import 'package:devtrack/models/note.dart';
import 'package:devtrack/models/project.dart';
import 'package:devtrack/models/user.dart';

class DashboardData {
  final User user;
  final List<Goal> goals;
  final List<Project> projects;
  final List<Note> notes;
  final List<Achievement> achievements;

  const DashboardData({
    required this.user,
    required this.goals,
    required this.projects,
    required this.notes,
    required this.achievements,
  });
}