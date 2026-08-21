import 'package:devtrack/features/notes/widgets/note_edit_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteDetailsHeader extends StatelessWidget {
  final int noteId;
  final String title;
  final bool editing;
  final TextEditingController controller;

  const NoteDetailsHeader({
    super.key,
    required this.noteId,
    required this.title,
    required this.editing,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'note-icon-$noteId',
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xffF3C86A)
                    .withOpacity(0.08),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xffF3C86A)
                      .withOpacity(0.2),
                ),
              ),
              child: const Icon(
                Icons.sticky_note_2_outlined,
                color: Color(0xffF3C86A),
                size: 35,
              ),
            ),
          ),
        ),

        const SizedBox(width: 17),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 5,
            ),
            child: editing
                ? NoteEditField(
                    controller: controller,
                    hint: "Note title",
                  )
                : Hero(
                    tag: 'note-title-$noteId',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        title,
                        style: GoogleFonts.pressStart2p(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}