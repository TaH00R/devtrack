import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteContentView extends StatelessWidget {
  final String content;

  const NoteContentView({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff1A1A1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Text(
        content,
        style: GoogleFonts.jetBrainsMono(
          color: Colors.white70,
          fontSize: 13,
          height: 1.65,
        ),
      ),
    );
  }
}