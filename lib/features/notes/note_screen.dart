import 'package:devtrack/features/notes/add_note_screen.dart';
import 'package:devtrack/features/notes/note_details_screen.dart';
import 'package:devtrack/shared/providers/note_provider.dart';
import 'package:devtrack/shared/routes/smooth_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteProvider>().getNotes();
    });
  }

  void _openAddNote() {
    Navigator.push(
      context,
      smoothRoute(
        const AddNoteScreen(),
      ),
    );
  }

  void _openNoteDetails(note) {
    Navigator.push(
      context,
      smoothRoute(
        NoteDetailsScreen(note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();

    // Create a copy so we don't modify the provider's actual list.
    final notes = [...noteProvider.notes];

    // Ascending alphabetical order: A -> Z
    notes.sort(
      (a, b) => a.title.toLowerCase().compareTo(
            b.title.toLowerCase(),
          ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff121214),

        appBar: AppBar(
          backgroundColor: const Color(0xff121214),
          elevation: 0,
          title: Text(
            "NOTES",
            style: GoogleFonts.pressStart2p(
              color: const Color(0xffF3C86A),
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _openAddNote,
              icon: const Icon(
                Icons.add,
                color: Color(0xffB388FF),
                size: 28,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),

        body: noteProvider.isLoading && notes.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xffF3C86A),
                  strokeWidth: 2,
                ),
              )
            : notes.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    color: const Color(0xffF3C86A),
                    backgroundColor: const Color(0xff1A1A1E),
                    onRefresh: () async {
                      await noteProvider.getNotes();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        18,
                        20,
                        30,
                      ),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];

                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 14,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _openNoteDetails(note);
                            },
                            child: _NoteCard(
                              noteId: note.id,
                              title: note.title,
                              content: note.content,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
              onPressed: _openAddNote,
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

class _NoteCard extends StatelessWidget {
  final int noteId;
  final String title;
  final String content;

  const _NoteCard({
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