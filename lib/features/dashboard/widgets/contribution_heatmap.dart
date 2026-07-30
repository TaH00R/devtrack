import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContributionHeatmap extends StatelessWidget {
  const ContributionHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random(7);

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
            "Activity",
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "July 2026",
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white38,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 18),

          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: List.generate(
              56,
              (index) {

                final value = random.nextInt(5);

                return Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: _color(value),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: [

              _legend(Colors.white10, "0"),

              const SizedBox(width: 8),

              _legend(
                const Color(0xff6EE7A2).withOpacity(.25),
                "1",
              ),

              const SizedBox(width: 8),

              _legend(
                const Color(0xff6EE7A2).withOpacity(.5),
                "2",
              ),

              const SizedBox(width: 8),

              _legend(
                const Color(0xff6EE7A2).withOpacity(.75),
                "3",
              ),

              const SizedBox(width: 8),

              _legend(
                const Color(0xff6EE7A2),
                "4",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [

        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        const SizedBox(width: 4),

        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            color: Colors.white38,
            fontSize: 10,
          ),
        )
      ],
    );
  }

  Color _color(int level) {
    switch (level) {
      case 1:
        return const Color(0xff6EE7A2).withOpacity(.25);

      case 2:
        return const Color(0xff6EE7A2).withOpacity(.5);

      case 3:
        return const Color(0xff6EE7A2).withOpacity(.75);

      case 4:
        return const Color(0xff6EE7A2);

      default:
        return Colors.white10;
    }
  }
}