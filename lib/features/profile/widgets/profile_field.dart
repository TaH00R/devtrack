import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              GoogleFonts.jetBrainsMono(
            color: Colors.white24,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          value,
          style:
              GoogleFonts.jetBrainsMono(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}