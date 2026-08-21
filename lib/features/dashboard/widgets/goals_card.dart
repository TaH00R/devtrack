import 'package:devtrack/features/dashboard/widgets/progress_bar.dart';
import 'package:devtrack/features/dashboard/widgets/stat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalsCard extends StatelessWidget {
  final int totalGoals;
  final int completedGoals;
  final int activeGoals;

  const GoalsCard({
    super.key,
    required this.totalGoals,
    required this.completedGoals,
    required this.activeGoals,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalGoals == 0
        ? 0.0
        : completedGoals / totalGoals;

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
                value: '$totalGoals',
                color: const Color(0xffF3C86A),
              ),
              DashboardStat(
                label: 'ACTIVE',
                value: '$activeGoals',
                color: const Color(0xff64D8FF),
              ),
              DashboardStat(
                label: 'DONE',
                value: '$completedGoals',
                color: const Color(0xff6EE7A2),
              ),
            ],
          ),

          const SizedBox(height: 20),

          DashboardProgressBar(
            value: progress,
            color: const Color(0xffF3C86A),
          ),

          const SizedBox(height: 10),

          Text(
            '${(progress * 100).round()}% GOALS COMPLETED',
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