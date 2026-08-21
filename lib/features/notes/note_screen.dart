import 'package:devtrack/features/notes/add_note_screen.dart';
import 'package:devtrack/features/notes/note_details_screen.dart';
import 'package:devtrack/features/notes/widgets/note_card.dart';
import 'package:devtrack/features/notes/widgets/note_empty_state.dart';
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
                ? NoteEmptyState(
                    onAddNote: _openAddNote,
                  )
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
                            child: NoteCard(
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
}