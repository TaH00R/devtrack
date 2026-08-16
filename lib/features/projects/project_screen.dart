import 'package:devtrack/features/projects/add_project_screen.dart';
import 'package:devtrack/features/projects/project_details_screen.dart';
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
                color:
                    Color(0xffB388FF),
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
                    ? _buildEmptyState()
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
                                projectTasks
                                    .length;

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
                                    _ProjectCard(
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.folder_open,
              color:
                  Color(0xff6EE7A2),
              size: 55,
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
              "> No projects found.",
              style:
                  GoogleFonts.jetBrainsMono(
                color:
                    Colors.white70,
                fontSize: 14,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              "Create a project and start building.",
              textAlign:
                  TextAlign.center,
              style:
                  GoogleFonts.jetBrainsMono(
                color:
                    Colors.white24,
                fontSize: 12,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            ElevatedButton.icon(
              onPressed:
                  _openAddProject,
              icon:
                  const Icon(Icons.add),
              label: Text(
                "ADD PROJECT",
                style:
                    GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                ),
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xffB388FF,
                ),
                foregroundColor:
                    Colors.white,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard
    extends StatelessWidget {
  final int projectId;
  final String name;
  final String description;
  final int completedTasks;
  final int totalTasks;
  final double progress;

  const _ProjectCard({
    required this.projectId,
    required this.name,
    required this.description,
    required this.completedTasks,
    required this.totalTasks,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final percentage =
        (progress * 100).round();

    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration:
          BoxDecoration(
        color:
            const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Hero(
                tag:
                    'project-icon-$projectId',
                child: Material(
                  color:
                      Colors.transparent,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xff6EE7A2,
                      ).withOpacity(
                        0.08,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                      border:
                          Border.all(
                        color:
                            const Color(
                          0xff6EE7A2,
                        ).withOpacity(
                          0.2,
                        ),
                      ),
                    ),
                    child:
                        const Icon(
                      Icons
                          .folder_outlined,
                      color:
                          Color(0xff6EE7A2),
                      size: 30,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 15,
              ),

              Expanded(
                child: Hero(
                  tag:
                      'project-name-$projectId',
                  child: Material(
                    color:
                        Colors.transparent,
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          GoogleFonts
                              .pressStart2p(
                        color:
                            Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color:
                    Colors.white24,
              ),
            ],
          ),

          const SizedBox(
            height: 14,
          ),

          Text(
            description,
            maxLines: 2,
            overflow:
                TextOverflow.ellipsis,
            style:
                GoogleFonts
                    .jetBrainsMono(
              color:
                  Colors.white38,
              fontSize: 11,
              height: 1.4,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: [
              Text(
                "PROGRESS",
                style:
                    GoogleFonts
                        .jetBrainsMono(
                  color:
                      const Color(
                    0xffF3C86A,
                  ),
                  fontSize: 10,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              Text(
                "$percentage%",
                style:
                    GoogleFonts
                        .jetBrainsMono(
                  color:
                      const Color(
                    0xff6EE7A2,
                  ),
                  fontSize: 11,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 9,
          ),

          Row(
            children:
                List.generate(
              20,
              (index) {
                final filled =
                    index <
                        (progress *
                                20)
                            .round();

                return Expanded(
                  child:
                      Container(
                    height: 7,
                    margin:
                        EdgeInsets.only(
                      right:
                          index == 19
                              ? 0
                              : 3,
                    ),
                    decoration:
                        BoxDecoration(
                      color: filled
                          ? const Color(
                              0xff6EE7A2,
                            )
                          : Colors
                              .white10,
                      borderRadius:
                          BorderRadius
                              .circular(
                        2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          Row(
            children: [
              const Icon(
                Icons
                    .check_circle_outline,
                color:
                    Colors.white24,
                size: 15,
              ),

              const SizedBox(
                width: 6,
              ),

              Text(
                "$completedTasks / $totalTasks tasks completed",
                style:
                    GoogleFonts
                        .jetBrainsMono(
                  color:
                      Colors.white38,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}