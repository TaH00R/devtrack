import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteNoteDialog extends StatelessWidget {
  const DeleteNoteDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff1A1A1E),

      title: Text(
        "DELETE NOTE?",
        style: GoogleFonts.pressStart2p(
          color: const Color(0xffFF8BA7),
          fontSize: 14,
        ),
      ),

      content: Text(
        "This action cannot be undone.",
        style: GoogleFonts.jetBrainsMono(
          color: Colors.white54,
          fontSize: 12,
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(
            "CANCEL",
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white54,
            ),
          ),
        ),

        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(
            "DELETE",
            style: GoogleFonts.jetBrainsMono(
              color: const Color(0xffFF8BA7),
            ),
          ),
        ),
      ],
    );
  }
}