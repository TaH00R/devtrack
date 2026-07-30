import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AchievementsCard extends StatelessWidget {
  const AchievementsCard({super.key});

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
            "Achievements",
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          _tile(
            Icons.local_fire_department_rounded,
            "30 Day Streak",
            const Color(0xffFF8B5E),
          ),

          _tile(
            Icons.emoji_events_rounded,
            "100 Problems",
            const Color(0xffF3C86A),
          ),

          _tile(
            Icons.code_rounded,
            "First OSS PR",
            const Color(0xff6EA8FF),
          ),

          _tile(
            Icons.rocket_launch_rounded,
            "Built DevTrack",
            const Color(0xffA970FF),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    IconData icon,
    String title,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [

          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white70,
              ),
            ),
          )
        ],
      ),
    );
  }
}