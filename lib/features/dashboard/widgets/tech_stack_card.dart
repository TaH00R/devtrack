import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TechStackCard extends StatelessWidget {
  const TechStackCard({super.key});

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
            "Tech Stack",
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          _skill("Java", .92),

          _skill("Flutter", .86),

          _skill("Dart", .84),

          _skill("C++", .73),

          _skill("Python", .65),
        ],
      ),
    );
  }

  Widget _skill(String name, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                name,
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white70,
                ),
              ),

              Text(
                "${(value * 100).toInt()}%",
                style: GoogleFonts.jetBrainsMono(
                  color: const Color(0xffA970FF),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 7,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation(
                Color(0xffA970FF),
              ),
            ),
          )
        ],
      ),
    );
  }
}