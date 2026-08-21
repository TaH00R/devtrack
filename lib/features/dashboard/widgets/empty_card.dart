import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyCard extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;

  const EmptyCard({
    super.key,
    required this.message,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 30,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color.withOpacity(.7),
            size: 36,
          ),

          const SizedBox(height: 14),

          Text(
            message,
            textAlign: TextAlign.center,
            style:
                GoogleFonts.jetBrainsMono(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}