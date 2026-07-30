import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff1B1C20),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Column(
        children: [

          CircleAvatar(
            radius: 42,
            backgroundColor: const Color(0xffA970FF).withOpacity(.15),
            child: const Icon(
              Icons.person_rounded,
              color: Color(0xffA970FF),
              size: 46,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            "TAHOOR",
            style: GoogleFonts.pressStart2p(
              color: Colors.white,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Full Stack Developer",
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 22),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: .72,
              minHeight: 8,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation(
                Color(0xffA970FF),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                "Level 12",
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white70,
                ),
              ),

              Text(
                "2450 / 3000 XP",
                style: GoogleFonts.jetBrainsMono(
                  color: const Color(0xffA970FF),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.04),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              "> Building.\n> Learning.\n> Shipping.",
              style: GoogleFonts.jetBrainsMono(
                color: const Color(0xff6EE7A2),
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}