import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteEmptyState extends StatelessWidget {
  final VoidCallback onAddNote;

  const NoteEmptyState({
    super.key,
    required this.onAddNote,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sticky_note_2_outlined,
              color: Color(0xffF3C86A),
              size: 55,
            ),

            const SizedBox(height: 20),

            Text(
              "> No notes found.",
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Write something worth remembering.",
              textAlign: TextAlign.center,
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white24,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: onAddNote,
              icon: const Icon(Icons.add),
              label: Text(
                "ADD NOTE",
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffB388FF),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}