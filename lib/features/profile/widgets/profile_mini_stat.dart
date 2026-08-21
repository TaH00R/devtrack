import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileMiniStat
    extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const ProfileMiniStat({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style:
              GoogleFonts.pressStart2p(
            color: color,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          label,
          style:
              GoogleFonts.jetBrainsMono(
            color: Colors.white30,
            fontSize: 8,
          ),
        ),
      ],
    );
  }
}