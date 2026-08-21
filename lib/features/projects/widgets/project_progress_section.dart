import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectProgressSection
    extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;
  final double progress;
  final int percentage;

  const ProjectProgressSection({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
    required this.progress,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

          children: [
            Text(
              "$completedTasks / $totalTasks tasks",

              style: GoogleFonts.jetBrainsMono(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),

            Text(
              "$percentage%",

              style: GoogleFonts.jetBrainsMono(
                color: const Color(0xff6EE7A2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: List.generate(
            20,
            (index) {
              final filled =
                  index < (progress * 20).round();

              return Expanded(
                child: Container(
                  height: 8,

                  margin: EdgeInsets.only(
                    right: index == 19 ? 0 : 3,
                  ),

                  decoration: BoxDecoration(
                    color: filled
                        ? const Color(0xff6EE7A2)
                        : Colors.white10,

                    borderRadius:
                        BorderRadius.circular(2),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}