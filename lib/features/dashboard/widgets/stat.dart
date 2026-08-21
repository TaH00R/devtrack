import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const DashboardStat({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style:
                GoogleFonts.pressStart2p(
              color: color,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            label,
            textAlign: TextAlign.center,
            style:
                GoogleFonts.jetBrainsMono(
              color: Colors.white38,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
