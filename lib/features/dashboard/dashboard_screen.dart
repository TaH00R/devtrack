import 'package:devtrack/features/auth/providers/auth_provider.dart';
import 'package:devtrack/features/dashboard/widgets/dashboard_body.dart';
import 'package:devtrack/shared/providers/goal_provider.dart';
import 'package:devtrack/shared/providers/github_provider.dart';
import 'package:devtrack/shared/providers/leetcode_provider.dart';
import 'package:devtrack/shared/providers/project_provider.dart';
import 'package:devtrack/shared/providers/task_provider.dart';
import 'package:devtrack/shared/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> availableTechnologies = [
    'Flutter',
    'Dart',
    'Java',
    'Spring Boot',
    'PostgreSQL',
    'MySQL',
    'MongoDB',
    'React',
    'Next.js',
    'TypeScript',
    'JavaScript',
    'Node.js',
    'Express',
    'Python',
    'C++',
    'C',
    'Docker',
    'Redis',
    'Kafka',
    'Kubernetes',
    'Git',
    'GitHub',
    'Firebase',
    'Three.js',
    'Tailwind CSS',
    'FastAPI',
  ];

  final List<String> techStack = [
    'Flutter',
    'Dart',
    'Java',
    'Spring Boot',
    'PostgreSQL',
  ];

  bool addingTechnology = false;

  final TextEditingController technologyController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadDashboard();
    });
  }

  @override
  void dispose() {
    technologyController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboard() async {
    final authProvider = context.read<AuthProvider>();

    context.read<GithubProvider>().getProfiles();
    context.read<LeetcodeProvider>().getProfiles();
    context.read<ProjectProvider>().getProjects();
    context.read<GoalProvider>().getGoals();
    context.read<TaskProvider>().getTasks();

    final userId = authProvider.userId;

    if (userId != null) {
      context.read<UserProvider>().getUser(userId);
    }
  }

  Future<void> _refresh() async {
    final authProvider = context.read<AuthProvider>();

    await Future.wait([
      context.read<GithubProvider>().getProfiles(),
      context.read<LeetcodeProvider>().getProfiles(),
      context.read<ProjectProvider>().getProjects(),
      context.read<GoalProvider>().getGoals(),
      context.read<TaskProvider>().getTasks(),
      if (authProvider.userId != null)
        context.read<UserProvider>().getUser(
              authProvider.userId!,
            ),
    ]);
  }

  void _addTechnology() {
    final tech = technologyController.text.trim();

    if (tech.isEmpty) return;

    if (!techStack.contains(tech)) {
      setState(() {
        techStack.add(tech);
        technologyController.clear();
        addingTechnology = false;
      });
    }
  }

  void _removeTechnology(String tech) {
    setState(() {
      techStack.remove(tech);
    });
  }

  void _setAddingTechnology(bool value) {
    setState(() {
      addingTechnology = value;

      if (!value) {
        technologyController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final githubProvider = context.watch<GithubProvider>();
    final leetcodeProvider = context.watch<LeetcodeProvider>();
    final projectProvider = context.watch<ProjectProvider>();
    final goalProvider = context.watch<GoalProvider>();
    final taskProvider = context.watch<TaskProvider>();

    return DashboardBody(
      user: userProvider.user,
      github: githubProvider.liveData,
      leetcode: leetcodeProvider.liveData,
      projects: projectProvider.projects,
      goals: goalProvider.goals,
      tasks: taskProvider.tasks,
      githubLoading: githubProvider.isLiveLoading,
      leetcodeLoading: leetcodeProvider.isLiveLoading,
      techStack: techStack,
      availableTechnologies: availableTechnologies,
      addingTechnology: addingTechnology,
      technologyController: technologyController,
      onRefresh: _refresh,
      onAddTechnology: _addTechnology,
      onRemoveTechnology: _removeTechnology,
      onSetAddingTechnology: _setAddingTechnology,
    );
  }
}