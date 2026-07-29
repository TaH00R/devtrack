import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Task extends StatelessWidget {
  final String text;
  final bool done;
  final String tag;
  const Task({required this.text, required this.done, required this.tag, super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(
        done ? Icons.check_box : Icons.check_box_outline_blank,
        color: done ? const Color(0xffFF8BA7) : Colors.white24,
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          text,
          style: GoogleFonts.jetBrainsMono(color: Colors.white),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: tag == "Daily"
              ? const Color(0x33FF8BA7)
              : const Color(0x336F5BFF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          tag,
          style: GoogleFonts.jetBrainsMono(
            color: tag == "Daily"
                ? const Color(0xffFF8BA7)
                : const Color(0xffB388FF),
            fontSize: 12,
          ),
        ),
      ),
    ],
  );
}