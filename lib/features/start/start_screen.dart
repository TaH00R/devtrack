import 'package:devtrack/features/auth/providers/auth_provider.dart';
import 'package:devtrack/features/dashboard/dashboard_screen.dart';
import 'package:devtrack/features/start/widgets/card.dart';
import 'package:devtrack/features/start/widgets/note.dart';
import 'package:devtrack/features/start/widgets/task.dart';
import 'package:devtrack/shared/providers/note_provider.dart';
import 'package:devtrack/shared/providers/project_provider.dart';
import 'package:devtrack/shared/providers/task_provider.dart';
import 'package:devtrack/shared/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().getTasks();
      context.read<ProjectProvider>().getProjects();
      context.read<NoteProvider>().getNotes();

      final userId = context.read<AuthProvider>().userId;

      if (userId != null) {
        context.read<UserProvider>().getUser(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final projectProvider = context.watch<ProjectProvider>();
    final noteProvider = context.watch<NoteProvider>();
    final userProvider = context.watch<UserProvider>();

    final tasks = taskProvider.tasks;
    final projects = projectProvider.projects;
    final notes = noteProvider.notes;

    final displayName =
        userProvider.user?.displayName ??
        userProvider.user?.userName ??
        "USER";

    final displayedTasks = tasks.take(3).toList();

    final completedTasks = displayedTasks
        .where((task) => task.completed == true)
        .length;

    final activeProject = projects.isNotEmpty ? projects.first : null;

    final projectTasks = activeProject == null
        ? []
        : tasks
            .where((task) => task.projectId == activeProject.id)
            .toList();

    final completedProjectTasks = projectTasks
        .where((task) => task.completed == true)
        .length;

    final projectProgress = projectTasks.isEmpty
        ? 0.0
        : completedProjectTasks / projectTasks.length;

    final projectPercentage = (projectProgress * 100).round();

    final hour = DateTime.now().hour;

    String greeting;

    if (hour < 12) {
      greeting = "Good morning,";
    } else if (hour < 17) {
      greeting = "Good afternoon,";
    } else {
      greeting = "Good evening,";
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff121214),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),

              SizedBox(
                height: 220,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        "assets/images/cat_watching_rain.png",
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 3,
                      left: 15,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DashboardScreen(),
                            ),
                          );
                        },
                        child: Hero(
                          tag: "dashboard_logo",
                          child: Image.asset(
                            "assets/images/appbar.png",
                            width: 50,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: GoogleFonts.jersey10(
                        color: Colors.white70,
                        fontSize: 22,
                      ),
                    ),

                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            displayName,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.pressStart2p(
                              fontSize: 25,
                              color: const Color(0xffB388FF),
                            ),
                          ),
                        ),

                        Image.asset(
                          "assets/images/smile_pixel.png",
                          width: 40,
                          height: 40,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Text(
                          ">",
                          style: GoogleFonts.jetBrainsMono(
                            color: const Color(0xff6EE7A2),
                            fontSize: 18,
                          ),
                        ),

                        Text(
                          " One commit at a time.",
                          style: GoogleFonts.jetBrainsMono(
                            color: Colors.white38,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // TASKS
                    AppCard(
                      title: "TASKS",
                      color: const Color(0xffFF8BA7),
                      trailing:
                          "${completedTasks} / ${displayedTasks.length} completed",
                      child: displayedTasks.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: Text(
                                "No tasks yet.",
                                style: GoogleFonts.jetBrainsMono(
                                  color: Colors.white38,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          : Column(
                              children: List.generate(
                                displayedTasks.length,
                                (index) {
                                  final task = displayedTasks[index];

                                  return Column(
                                    children: [
                                      Task(
                                        text: task.title,
                                        done: task.completed ?? false,
                                        tag: task.tagIds?.isNotEmpty == true
                                            ? "Tagged"
                                            : "Task",
                                      ),

                                      if (index !=
                                          displayedTasks.length - 1)
                                        const Divider(
                                          color: Colors.white10,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                    ),

                    const SizedBox(height: 18),

                    // ACTIVE PROJECT
                    AppCard(
                      title: "ACTIVE PROJECT",
                      color: const Color(0xff6EE7A2),
                      child: activeProject == null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: Text(
                                "No projects yet.",
                                style: GoogleFonts.jetBrainsMono(
                                  color: Colors.white38,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius:
                                            BorderRadius.circular(14),
                                      ),
                                      child: const Icon(
                                        Icons.folder,
                                        color: Color(0xff6EE7A2),
                                        size: 42,
                                      ),
                                    ),

                                    const SizedBox(width: 18),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            activeProject.name,
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow.ellipsis,
                                            style:
                                                GoogleFonts.jetBrainsMono(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),

                                          Text(
                                            activeProject.description,
                                            maxLines: 2,
                                            overflow:
                                                TextOverflow.ellipsis,
                                            style:
                                                GoogleFonts.jetBrainsMono(
                                              color: Colors.white54,
                                            ),
                                          ),

                                          const SizedBox(height: 12),

                                          Row(
                                            children: List.generate(
                                              10,
                                              (i) => Container(
                                                margin:
                                                    const EdgeInsets.only(
                                                  right: 4,
                                                ),
                                                width: 12,
                                                height: 8,
                                                decoration:
                                                    BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(3),
                                                  color: i <
                                                          (projectProgress *
                                                                  10)
                                                              .round()
                                                      ? const Color(
                                                          0xff6EE7A2)
                                                      : Colors.white12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    Text(
                                      "$projectPercentage%",
                                      style: GoogleFonts.jetBrainsMono(
                                        color:
                                            const Color(0xff6EE7A2),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    projectTasks.isEmpty
                                        ? "No tasks in this project"
                                        : "$completedProjectTasks / ${projectTasks.length} tasks completed",
                                    style: GoogleFonts.jetBrainsMono(
                                      color: Colors.white38,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 18),

                    // RECENT NOTES
                    AppCard(
                      title: "RECENT NOTES",
                      color: const Color(0xffF3C86A),
                      trailing: "View all >",
                      child: notes.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: Text(
                                "No notes yet.",
                                style: GoogleFonts.jetBrainsMono(
                                  color: Colors.white38,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                ...notes
                                    .take(2)
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map(
                                  (entry) {
                                    final note = entry.value;

                                    return Column(
                                      children: [
                                        Note(
                                          note.title,
                                          "Recent note",
                                        ),

                                        if (entry.key !=
                                            notes.take(2).length - 1)
                                          const Divider(
                                            color: Colors.white10,
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}