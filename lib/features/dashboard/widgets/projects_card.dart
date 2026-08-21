import 'package:devtrack/features/dashboard/widgets/progress_bar.dart';
import 'package:devtrack/features/dashboard/widgets/stat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectsCard extends StatelessWidget {
  final int totalProjects;
  final int completedProjects;
  final int activeProjects;

  const ProjectsCard({
    super.key,
    required this.totalProjects,
    required this.completedProjects,
    required this.activeProjects,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalProjects == 0
        ? 0.0
        : completedProjects / totalProjects;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff1A1A1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              DashboardStat(
                label: 'TOTAL',
                value: '$totalProjects',
                color: const Color(0xff6EE7A2),
              ),
              DashboardStat(
                label: 'ACTIVE',
                value: '$activeProjects',
                color: const Color(0xff64D8FF),
              ),
              DashboardStat(
                label: 'DONE',
                value: '$completedProjects',
                color: const Color(0xffB388FF),
              ),
            ],
          ),

          const SizedBox(height: 20),

          DashboardProgressBar(
            value: progress,
            color: const Color(0xff6EE7A2),
          ),

          const SizedBox(height: 10),

          Text(
            '${(progress * 100).round()}% PROJECTS COMPLETED',
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white38,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}