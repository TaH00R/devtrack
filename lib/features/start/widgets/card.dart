import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppCard extends StatelessWidget {
  final String title;
  final Color color;
  final Widget child;
  final String? trailing;

  const AppCard({
    super.key,
    required this.title,
    required this.color,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff1A1A1E),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.pressStart2p(
                  color: color,
                  fontSize: 10,
                ),
              ),
              const Spacer(),
              if (trailing != null)
                Text(
                  trailing!,
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}