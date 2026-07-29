import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Note extends StatelessWidget {
  final String title;
  final String date;
  const Note(this.title, this.date);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        const Icon(Icons.description_outlined, color: Color(0xffF3C86A)),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                date,
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.white38),
      ],
    ),
  );
}
