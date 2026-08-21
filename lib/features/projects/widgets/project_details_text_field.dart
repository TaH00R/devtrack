import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectDetailsTextField
    extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const ProjectDetailsTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,

      style: GoogleFonts.jetBrainsMono(
        color: Colors.white,
        fontSize: 13,
      ),

      cursorColor: const Color(0xff6EE7A2),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: GoogleFonts.jetBrainsMono(
          color: Colors.white24,
          fontSize: 12,
        ),

        filled: true,

        fillColor:
            Colors.white.withOpacity(0.05),

        contentPadding:
            const EdgeInsets.all(15),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10),

          borderSide: const BorderSide(
            color: Colors.white10,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10),

          borderSide: const BorderSide(
            color: Colors.white10,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10),

          borderSide: const BorderSide(
            color: Color(0xff6EE7A2),
          ),
        ),
      ),
    );
  }
}