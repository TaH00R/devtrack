import 'package:devtrack/features/dashboard/widgets/dashboard_header.dart';
import 'package:devtrack/features/dashboard/widgets/profile_card.dart';
import 'package:devtrack/features/dashboard/widgets/stat_card.dart';
import 'package:devtrack/features/dashboard/widgets/stats_grid.dart';
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
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 220,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 18),
                  Expanded(
                    child: Container(
                      height: 220,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 22),

              // Achievements + Goals
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 250,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(width: 18),
                  Expanded(
                    child: Container(
                      height: 250,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 22),

              // Quick Actions
              Container(
                height: 150,
                color: Colors.cyan,
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}