import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteFormLabel extends StatelessWidget {
  final String text;

  const NoteFormLabel(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.jetBrainsMono(
        color: const Color(0xffF3C86A),
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}