import 'package:devtrack/shared/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatelessWidget {
  final int taskId;
  final String title;
  final String description;
  final bool completed;
  final Set<int> tagIds;
  const TaskCard({
    super.key,
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
        await context.read<TaskProvider>().toggleTaskCompletion(taskId);
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        padding: const EdgeInsets.all(17),

        decoration: BoxDecoration(
          color: const Color(0xff1A1A1E),

          borderRadius: BorderRadius.circular(14),

          border: Border.all(
            color: completed
                ? const Color(0xff6EE7A2).withOpacity(0.15)
                : Colors.white10,
          ),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),

              width: 25,
              height: 25,

              decoration: BoxDecoration(
                color: completed
                    ? const Color(0xff6EE7A2).withOpacity(0.15)
                    : Colors.white.withOpacity(0.04),

                borderRadius: BorderRadius.circular(7),

                border: Border.all(
                  color: completed ? const Color(0xff6EE7A2) : Colors.white24,
                ),
              ),

              child: completed
                  ? const Icon(Icons.check, color: Color(0xff6EE7A2), size: 17)
                  : null,
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: GoogleFonts.pressStart2p(
                      color: completed ? Colors.white30 : Colors.white,

                      fontSize: 11,

                      decoration: completed ? TextDecoration.lineThrough : null,
                    ),
                  ),

                  if (description.trim().isNotEmpty) ...[
                    const SizedBox(height: 9),

                    Text(
                      description,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: GoogleFonts.jetBrainsMono(
                        color: completed ? Colors.white30 : Colors.white38,

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
                        color: Color(0xffB388FF),
                        size: 14,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        "${tagIds.length} "
                        "${tagIds.length == 1 ? "tag" : "tags"}",

                        style: GoogleFonts.jetBrainsMono(
                          color: Colors.white24,
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
