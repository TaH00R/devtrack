import 'package:flutter/material.dart';

import 'stat_card.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.45,
      children: const [

        StatCard(
          title: "GitHub",
          value: "182",
          icon: Icons.code_rounded,
          color: Color(0xffA970FF),
        ),

        StatCard(
          title: "LeetCode",
          value: "121",
          icon: Icons.psychology_alt_rounded,
          color: Color(0xff6EE7A2),
        ),

        StatCard(
          title: "XP",
          value: "2450",
          icon: Icons.auto_awesome_rounded,
          color: Color(0xffF3C86A),
        ),

        StatCard(
          title: "Focus",
          value: "34h",
          icon: Icons.timer_outlined,
          color: Color(0xff6EA8FF),
        ),
      ],
    );
  }
}