import 'package:devtrack/features/dashboard/widgets/progress_bar.dart';
import 'package:devtrack/features/dashboard/widgets/stat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityCard extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;

  const ActivityCard({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    final pendingTasks =
        totalTasks - completedTasks;

    final progress = totalTasks == 0
        ? 0.0
        : completedTasks / totalTasks;

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
                value: '$totalTasks',
                color: const Color(0xff64D8FF),
              ),
              DashboardStat(
                label: 'DONE',
                value: '$completedTasks',
                color: const Color(0xff6EE7A2),
              ),
              DashboardStat(
                label: 'PENDING',
                value: '$pendingTasks',
                color: const Color(0xffFF8BA7),
              ),
            ],
          ),

          const SizedBox(height: 20),

          DashboardProgressBar(
            value: progress,
            color: const Color(0xff64D8FF),
          ),

          const SizedBox(height: 10),

          Text(
            '${(progress * 100).round()}% TASKS COMPLETED',
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