import 'package:devtrack/features/tasks/add_task_screen.dart';
import 'package:devtrack/shared/providers/task_provider.dart';
import 'package:devtrack/shared/routes/smooth_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<TaskProvider>().getTasks();
    });
  }

  void _openAddTask() async {
    await Navigator.push(
      context,
      smoothRoute(
        const AddTaskScreen(),
      ),
    );

    if (!mounted) return;

    // Refresh when returning from AddTaskScreen.
    await context.read<TaskProvider>().getTasks();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    final tasks = [...taskProvider.tasks];

    // Active tasks first, completed tasks after.
    tasks.sort((a, b) {
      if (a.completed == b.completed) {
        return a.title.toLowerCase().compareTo(
              b.title.toLowerCase(),
            );
      }

      return a.completed ?? false ? 1 : -1;
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff121214),

        appBar: AppBar(
          backgroundColor: const Color(0xff121214),
          elevation: 0,

          title: Text(
            "TASKS",
            style: GoogleFonts.pressStart2p(
              color: const Color(0xffFF8BA7),
              fontSize: 18,
            ),
          ),

          actions: [
            IconButton(
              onPressed: _openAddTask,
              icon: const Icon(
                Icons.add,
                color: Color(0xffB388FF),
                size: 28,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),

        body: taskProvider.isLoading && tasks.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xffFF8BA7),
                  strokeWidth: 2,
                ),
              )
            : tasks.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    color: const Color(0xffFF8BA7),
                    backgroundColor: const Color(0xff1A1A1E),

                    onRefresh: () async {
                      await taskProvider.getTasks();
                    },

                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        18,
                        20,
                        30,
                      ),

                      itemCount: tasks.length,

                      itemBuilder: (context, index) {
                        final task = tasks[index];

                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: _TaskCard(
                            title: task.title,
                            description: task.description?.trim() ?? "",
                            completed: task.completed ?? false,
                            tagIds: task.tagIds?.toSet() ?? {}, taskId: task.id,
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
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.checklist_outlined,
              color: Color(0xffFF8BA7),
              size: 58,
            ),

            const SizedBox(height: 20),

            Text(
              "> NO TASKS FOUND",
              style: GoogleFonts.pressStart2p(
                color: Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              "Nothing to do yet.\nCreate your first task.",
              textAlign: TextAlign.center,
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white38,
                fontSize: 12,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 26),

            ElevatedButton.icon(
              onPressed: _openAddTask,

              icon: const Icon(
                Icons.add,
              ),

              label: Text(
                "ADD TASK",
                style: GoogleFonts.pressStart2p(
                  fontSize: 11,
                ),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xffB388FF),
                foregroundColor: Colors.white,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final int taskId;
  final String title;
  final String description;
  final bool completed;
  final Set<int> tagIds;

  const _TaskCard({
    required this.taskId,
    required this.title,
    required this.description,
    this.completed = false,
    required this.tagIds,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await context
            .read<TaskProvider>()
            .toggleTaskCompletion(taskId);
      },

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),

        padding: const EdgeInsets.all(17),

        decoration: BoxDecoration(
          color: const Color(0xff1A1A1E),

          borderRadius:
              BorderRadius.circular(14),

          border: Border.all(
            color: completed
                ? const Color(0xff6EE7A2)
                    .withOpacity(0.15)
                : Colors.white10,
          ),
        ),

        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            AnimatedContainer(
              duration: const Duration(
                milliseconds: 180,
              ),

              width: 25,
              height: 25,

              decoration: BoxDecoration(
                color: completed
                    ? const Color(0xff6EE7A2)
                        .withOpacity(0.15)
                    : Colors.white
                        .withOpacity(0.04),

                borderRadius:
                    BorderRadius.circular(7),

                border: Border.all(
                  color: completed
                      ? const Color(
                          0xff6EE7A2,
                        )
                      : Colors.white24,
                ),
              ),

              child: completed
                  ? const Icon(
                      Icons.check,
                      color:
                          Color(0xff6EE7A2),
                      size: 17,
                    )
                  : null,
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    maxLines: 1,

                    overflow:
                        TextOverflow.ellipsis,

                    style:
                        GoogleFonts
                            .pressStart2p(
                      color: completed
                          ? Colors.white30
                          : Colors.white,

                      fontSize: 11,

                      decoration: completed
                          ? TextDecoration
                              .lineThrough
                          : null,
                    ),
                  ),

                  if (description
                      .trim()
                      .isNotEmpty) ...[
                    const SizedBox(height: 9),

                    Text(
                      description,

                      maxLines: 2,

                      overflow:
                          TextOverflow.ellipsis,

                      style: GoogleFonts
                          .jetBrainsMono(
                        color: completed
                            ? Colors.white30
                            : Colors.white38,

                        fontSize: 11,

                        height: 1.4,
                      ),
                    ),
                  ],

                  const SizedBox(height: 11),

                  Row(
                    children: [
                      const Icon(
                        Icons.label_outline,
                        color:
                            Color(0xffB388FF),
                        size: 14,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        "${tagIds.length} "
                        "${tagIds.length == 1 ? "tag" : "tags"}",

                        style: GoogleFonts
                            .jetBrainsMono(
                          color:
                              Colors.white24,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}