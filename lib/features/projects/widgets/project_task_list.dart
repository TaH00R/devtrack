import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectTaskList extends StatelessWidget {
  final List tasks;

  const ProjectTaskList({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Text(
        "> No tasks assigned to this project.",

        style: GoogleFonts.jetBrainsMono(
          color: Colors.white24,
          fontSize: 12,
        ),
      );
    }

    return Column(
      children: tasks.map(
        (task) {
          return Container(
            margin:
                const EdgeInsets.only(bottom: 8),

            padding: const EdgeInsets.all(13),

            decoration: BoxDecoration(
              color: const Color(0xff1A1A1E),

              borderRadius:
                  BorderRadius.circular(10),

              border: Border.all(
                color: Colors.white10,
              ),
            ),

            child: Row(
              children: [
                Icon(
                  task.completed == true
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,

                  color: task.completed == true
                      ? const Color(0xff6EE7A2)
                      : Colors.white24,

                  size: 19,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    task.title,

                    style: GoogleFonts.jetBrainsMono(
                      color: Colors.white70,
                      fontSize: 12,

                      decoration:
                          task.completed == true
                              ? TextDecoration.lineThrough
                              : null,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}