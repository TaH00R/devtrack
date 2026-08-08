import 'package:devtrack/features/dashboard/widgets/achievements_card.dart';
import 'package:devtrack/features/dashboard/widgets/contribution_heatmap.dart';
import 'package:devtrack/features/dashboard/widgets/dashboard_header.dart';
import 'package:devtrack/features/dashboard/widgets/goals_card.dart';
import 'package:devtrack/features/dashboard/widgets/profile_card.dart';
import 'package:devtrack/features/dashboard/widgets/stats_grid.dart';
import 'package:devtrack/features/dashboard/widgets/tech_stack_card.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121214),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const DashboardHeader(),

              SizedBox(height: 22),

              // Profile
              const ProfileCard(),

              SizedBox(height: 22),

              // Stats
              const StatsGrid(),

              SizedBox(height: 22),

              // Heatmap + Languages
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: ContributionHeatmap()),

                  SizedBox(width: 18),

                  Expanded(child: TechStackCard()),
                ],
              ),

              SizedBox(height: 22),

              // Achievements + Goals
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: AchievementsCard()),

                  SizedBox(width: 18),

                  Expanded(child: GoalsCard()),
                ],
              ),
              SizedBox(height: 22),

              // Quick Actions
              Container(height: 150, color: Colors.cyan),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
