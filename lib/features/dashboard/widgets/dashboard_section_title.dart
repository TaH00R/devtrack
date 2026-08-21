import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardSectionTitle
    extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const DashboardSectionTitle({
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
          size: 18,
        ),

        const SizedBox(width: 8),

        Text(
          title,
          style: GoogleFonts.pressStart2p(
            color: color,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}