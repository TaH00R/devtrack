import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSectionTitle
    extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const ProfileSectionTitle({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 17,
        ),

        const SizedBox(width: 8),

        Text(
          title,
          style:
              GoogleFonts.jetBrainsMono(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.4,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Container(
            height: 1,
            color: Colors.white10,
          ),
        ),
      ],
    );
  }
}