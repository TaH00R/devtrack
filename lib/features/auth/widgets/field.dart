import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Field extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;

  const Field({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.suffix
  });

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.jetBrainsMono(
            color: const Color.fromARGB(176, 255, 255, 255),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 7),

        TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          style: GoogleFonts.jetBrainsMono(color: Colors.white, fontSize: 13),
          cursorColor: const Color(0xffB388FF),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: GoogleFonts.jetBrainsMono(
              color: Colors.white12,
              fontSize: 13,
            ),
            filled: true,
            fillColor: const Color(0xff121214),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            suffixIcon: widget.suffix,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Color(0xffB388FF)),
            ),
          ),
        ),
      ],
    );
  }
}