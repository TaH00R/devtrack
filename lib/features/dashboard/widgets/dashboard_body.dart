import 'package:devtrack/features/dashboard/widgets/activity_card.dart';
import 'package:devtrack/features/dashboard/widgets/dashboard_header.dart';
import 'package:devtrack/features/dashboard/widgets/dashboard_section_title.dart';
import 'package:devtrack/features/dashboard/widgets/github_card.dart';
import 'package:devtrack/features/dashboard/widgets/goals_card.dart';
import 'package:devtrack/features/dashboard/widgets/leetcode_card.dart';
import 'package:devtrack/features/dashboard/widgets/profile_card.dart';
import 'package:devtrack/features/dashboard/widgets/projects_card.dart';
import 'package:devtrack/features/dashboard/widgets/tech_stack_card.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardBody extends StatelessWidget {
  final dynamic user;
  final dynamic github;
  final dynamic leetcode;

  final List projects;
  final List goals;
  final List tasks;

  final bool githubLoading;
  final bool leetcodeLoading;

  final List<String> techStack;
  final List<String> availableTechnologies;

  final bool addingTechnology;
  final TextEditingController technologyController;

  final Future<void> Function() onRefresh;
  final VoidCallback onAddTechnology;
  final ValueChanged<String> onRemoveTechnology;
  final ValueChanged<bool> onSetAddingTechnology;

  const DashboardBody({
    super.key,
    required this.user,
    required this.github,
    required this.leetcode,
    required this.projects,
    required this.goals,
    required this.tasks,
    required this.githubLoading,
    required this.leetcodeLoading,
    required this.techStack,
    required this.availableTechnologies,
    required this.addingTechnology,
    required this.technologyController,
    required this.onRefresh,
    required this.onAddTechnology,
    required this.onRemoveTechnology,
    required this.onSetAddingTechnology,
  });

  @override
  Widget build(BuildContext context) {
    final completedTasks = tasks
        .where((task) => task.completed == true)
        .length;

    final completedProjects = projects.isEmpty
        ? 0
        : projects.where((project) {
            final projectTasks = tasks
                .where(
                  (task) => task.projectId == project.id,
                )
                .toList();

            return projectTasks.isNotEmpty &&
                projectTasks.every(
                  (task) => task.completed == true,
                );
          }).length;

    final completedGoals = goals
        .where((goal) => goal.completed == true)
        .length;

    final activeGoals = goals.length - completedGoals;
    final activeProjects =
        projects.length - completedProjects;

    final username =
        user?.displayName ?? user?.userName ?? 'USER';

    return Scaffold(
      backgroundColor: const Color(0xff121214),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xffB388FF),
          backgroundColor: const Color(0xff1A1A1E),
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              22,
              18,
              22,
              40,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                DashboardHeader(
                  username: username,
                ),

                const SizedBox(height: 24),

                ProfileCard(
                  email: user?.email,
                  displayName: user?.displayName,
                ),

                const SizedBox(height: 22),

                const DashboardSectionTitle(
                  title: 'GITHUB',
                  icon: Icons.code,
                  color: Color(0xffB388FF),
                ),

                const SizedBox(height: 10),

                GithubCard(
                  github: github,
                  loading: githubLoading,
                ),

                const SizedBox(height: 22),

                const DashboardSectionTitle(
                  title: 'LEETCODE',
                  icon: Icons.terminal,
                  color: Color(0xffFF8BA7),
                ),

                const SizedBox(height: 10),

                LeetcodeCard(
                  leetcode: leetcode,
                  loading: leetcodeLoading,
                ),

                const SizedBox(height: 22),

                const DashboardSectionTitle(
                  title: 'PROJECTS',
                  icon: Icons.folder_outlined,
                  color: Color(0xff6EE7A2),
                ),

                const SizedBox(height: 10),

                ProjectsCard(
                  totalProjects: projects.length,
                  completedProjects:
                      completedProjects,
                  activeProjects: activeProjects,
                ),

                const SizedBox(height: 22),

                const DashboardSectionTitle(
                  title: 'GOALS',
                  icon: Icons.flag_outlined,
                  color: Color(0xffF3C86A),
                ),

                const SizedBox(height: 10),

                GoalsCard(
                  totalGoals: goals.length,
                  completedGoals: completedGoals,
                  activeGoals: activeGoals,
                ),

                const SizedBox(height: 22),

                const DashboardSectionTitle(
                  title: 'ACTIVITY',
                  icon: Icons.bolt,
                  color: Color(0xff64D8FF),
                ),

                const SizedBox(height: 10),

                ActivityCard(
                  totalTasks: tasks.length,
                  completedTasks: completedTasks,
                ),

                const SizedBox(height: 22),

                const DashboardSectionTitle(
                  title: 'TECH STACK',
                  icon: Icons.memory,
                  color: Color(0xff64D8FF),
                ),

                const SizedBox(height: 10),

                TechStackCard(
                  techStack: techStack,
                  availableTechnologies:
                      availableTechnologies,
                  addingTechnology:
                      addingTechnology,
                  controller:
                      technologyController,
                  onAddTechnology:
                      onAddTechnology,
                  onRemoveTechnology:
                      onRemoveTechnology,
                  onSetAddingTechnology:
                      onSetAddingTechnology,
                ),

                const SizedBox(height: 28),

                Center(
                  child: Text(
                    '> keep building.',
                    style: GoogleFonts.jetBrainsMono(
                      color: Colors.white24,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}