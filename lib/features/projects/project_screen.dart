import 'package:devtrack/features/projects/add_project_screen.dart';
import 'package:devtrack/features/projects/project_details_screen.dart';
import 'package:devtrack/features/projects/widgets/project_card.dart';
import 'package:devtrack/features/projects/widgets/project_empty_state.dart';
import 'package:devtrack/shared/providers/project_provider.dart';
import 'package:devtrack/shared/providers/task_provider.dart';
import 'package:devtrack/shared/routes/smooth_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().getProjects();
      context.read<TaskProvider>().getTasks();
    });
  }

  void _openAddProject() {
    Navigator.push(
      context,
      smoothRoute(
        const AddProjectScreen(),
      ),
    );
  }

  void _openProjectDetails(project) {
    Navigator.push(
      context,
      smoothRoute(
        ProjectDetailsScreen(
          project: project,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider =
        context.watch<ProjectProvider>();

    final taskProvider =
        context.watch<TaskProvider>();

    final projects =
        projectProvider.projects;

    final tasks =
        taskProvider.tasks;

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            const Color(0xff121214),

        appBar: AppBar(
          backgroundColor:
              const Color(0xff121214),

          elevation: 0,

          title: Text(
            "PROJECTS",
            style:
                GoogleFonts.pressStart2p(
              color:
                  const Color(0xff6EE7A2),
              fontSize: 18,
            ),
          ),

          actions: [
            IconButton(
              onPressed: _openAddProject,
              icon: const Icon(
                Icons.add,
                color: Color(0xffB388FF),
                size: 28,
              ),
            ),

            const SizedBox(width: 8),
          ],
        ),

        body:
            projectProvider.isLoading &&
                    projects.isEmpty
                ? const Center(
                    child:
                        CircularProgressIndicator(
                      color:
                          Color(0xff6EE7A2),
                      strokeWidth: 2,
                    ),
                  )
                : projects.isEmpty
                    ? ProjectEmptyState(
                        onAddProject:
                            _openAddProject,
                      )
                    : RefreshIndicator(
                        color:
                            const Color(
                          0xff6EE7A2,
                        ),

                        backgroundColor:
                            const Color(
                          0xff1A1A1E,
                        ),

                        onRefresh: () async {
                          await projectProvider
                              .getProjects();

                          await taskProvider
                              .getTasks();
                        },

                        child:
                            ListView.builder(
                          padding:
                              const EdgeInsets
                                  .fromLTRB(
                            20,
                            18,
                            20,
                            30,
                          ),

                          itemCount:
                              projects.length,

                          itemBuilder:
                              (context, index) {
                            final project =
                                projects[index];

                            final projectTasks =
                                tasks
                                    .where(
                                      (task) =>
                                          task.projectId ==
                                          project.id,
                                    )
                                    .toList();

                            final completedTasks =
                                projectTasks
                                    .where(
                                      (task) =>
                                          task.completed ==
                                          true,
                                    )
                                    .length;

                            final totalTasks =
                                projectTasks.length;

                            final progress =
                                totalTasks == 0
                                    ? 0.0
                                    : completedTasks /
                                        totalTasks;

                            return Padding(
                              padding:
                                  const EdgeInsets
                                      .only(
                                bottom: 16,
                              ),

                              child:
                                  GestureDetector(
                                onTap: () =>
                                    _openProjectDetails(
                                  project,
                                ),

                                child:
                                    ProjectCard(
                                  projectId:
                                      project.id,

                                  name:
                                      project.name,

                                  description:
                                      project.description,

                                  completedTasks:
                                      completedTasks,

                                  totalTasks:
                                      totalTasks,

                                  progress:
                                      progress,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
      ),
    );
  }
}