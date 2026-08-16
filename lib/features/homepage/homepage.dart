import 'package:devtrack/features/goals/goal_screen.dart';
import 'package:devtrack/features/start/start_screen.dart';
import 'package:devtrack/shared/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121214),
  body: [
  const StartScreen(),
  const GoalScreen(),
][selectedIndex],
  bottomNavigationBar: DevTrackNavBar(
    selectedIndex: selectedIndex,
    onTap: (index) {
      setState(() {
        selectedIndex = index;
      });
    },
  ),
);
  }
}