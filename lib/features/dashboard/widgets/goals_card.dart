import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalsCard extends StatelessWidget {
  const GoalsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff1B1C20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Goals",
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          _goal("3 Full Stack Apps", .65),

          _goal("150 LeetCode", .82),

          _goal("Internship", .40),

          _goal("Open Source", .55),
        ],
      ),
    );
  }

  Widget _goal(String title, double progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 6),

          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation(
                Color(0xff6EE7A2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}