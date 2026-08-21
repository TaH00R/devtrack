import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteCard extends StatelessWidget {
  final int noteId;
  final String title;
  final String content;

  const NoteCard({
    super.key,
    required this.noteId,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff1A1A1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'note-icon-$noteId',
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xffF3C86A)
                      .withOpacity(0.08),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: const Color(0xffF3C86A)
                        .withOpacity(0.2),
                  ),
                ),
                child: const Icon(
                  Icons.sticky_note_2_outlined,
                  color: Color(0xffF3C86A),
                  size: 27,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'note-title-$noteId',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.pressStart2p(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.white38,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Text(
                      "> open note",
                      style: GoogleFonts.jetBrainsMono(
                        color: const Color(0xffB388FF),
                        fontSize: 10,
                      ),
                    ),

                    const Spacer(),

                    const Icon(
                      Icons.chevron_right,
                      color: Colors.white24,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}