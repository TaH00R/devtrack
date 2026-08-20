import 'package:devtrack/features/tasks/add_task_screen.dart';
import 'package:devtrack/features/tasks/widgets/build_empty_state.dart';
import 'package:devtrack/features/tasks/widgets/task_card.dart';
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
                ? BuildEmptyState(openAddTask: _openAddTask)
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
                          child: TaskCard(
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
}