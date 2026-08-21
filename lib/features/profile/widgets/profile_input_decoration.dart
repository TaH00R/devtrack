import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration profileInputDecoration(
  String hint,
) {
  return InputDecoration(
    hintText: hint,
    hintStyle:
        GoogleFonts.jetBrainsMono(
      color: Colors.white24,
      fontSize: 11,
    ),
    filled: true,
    fillColor:
        Colors.white.withOpacity(.05),
    contentPadding:
        const EdgeInsets.symmetric(
      horizontal: 14,
      vertical: 14,
    ),
    border: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(9),
      borderSide:
          const BorderSide(
        color: Colors.white10,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(9),
      borderSide:
          const BorderSide(
        color: Colors.white10,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(9),
      borderSide:
          const BorderSide(
        color: Color(0xffB388FF),
      ),
    ),
  );
}