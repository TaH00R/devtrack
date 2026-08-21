import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectSectionLabel extends StatelessWidget {
  final String text;

  const ProjectSectionLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,

      style: GoogleFonts.jetBrainsMono(
        color: const Color(0xffF3C86A),
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}