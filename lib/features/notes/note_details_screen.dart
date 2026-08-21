import 'package:devtrack/features/notes/widgets/delete_note_dialog.dart';
import 'package:devtrack/features/notes/widgets/note_content_view.dart';
import 'package:devtrack/features/notes/widgets/note_details_header.dart';
import 'package:devtrack/features/notes/widgets/note_edit_field.dart';
import 'package:devtrack/features/notes/widgets/note_section_label.dart';
import 'package:devtrack/shared/models/note_request.dart';
import 'package:devtrack/shared/models/note_response.dart';
import 'package:devtrack/shared/providers/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NoteDetailsScreen extends StatefulWidget {
  final NoteResponse note;

  const NoteDetailsScreen({
    super.key,
    required this.note,
  });

  @override
  State<NoteDetailsScreen> createState() =>
      _NoteDetailsScreenState();
}

class _NoteDetailsScreenState
    extends State<NoteDetailsScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  bool _editing = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.note.title,
    );

    _contentController = TextEditingController(
      text: widget.note.content,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      _showError("Title and content are required.");
      return;
    }

    final noteProvider = context.read<NoteProvider>();

    final request = NoteRequest(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      userId: widget.note.userId,
    );

    await noteProvider.updateNote(
      widget.note.id,
      request,
    );

    if (!mounted) return;

    if (noteProvider.error != null) {
      _showError(noteProvider.error!);
      return;
    }

    setState(() {
      _editing = false;
    });
  }

  Future<void> _deleteNote() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return const DeleteNoteDialog();
      },
    );

    if (confirmed != true) return;

    final noteProvider = context.read<NoteProvider>();

    await noteProvider.deleteNote(
      widget.note.id,
    );

    if (!mounted) return;

    if (noteProvider.error != null) {
      _showError(noteProvider.error!);
      return;
    }

    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
          ),
        ),
        backgroundColor: const Color(0xff2A1A20),
      ),
    );
  }

  void _toggleEditing() {
    setState(() {
      _editing = !_editing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff121214),

        appBar: AppBar(
          backgroundColor: const Color(0xff121214),
          elevation: 0,

          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white70,
            ),
          ),

          title: Text(
            "NOTE",
            style: GoogleFonts.pressStart2p(
              color: const Color(0xffF3C86A),
              fontSize: 17,
            ),
          ),

          actions: [
            IconButton(
              onPressed: _toggleEditing,
              icon: Icon(
                _editing
                    ? Icons.close
                    : Icons.edit_outlined,
                color: const Color(0xffB388FF),
              ),
            ),
          ],
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NoteDetailsHeader(
                noteId: widget.note.id,
                title: widget.note.title,
                editing: _editing,
                controller: _titleController,
              ),

              const SizedBox(height: 28),

              const NoteSectionLabel("CONTENT"),

              const SizedBox(height: 12),

              _editing
                  ? NoteEditField(
                      controller: _contentController,
                      hint: "Note content",
                      maxLines: 18,
                    )
                  : NoteContentView(
                      content: widget.note.content,
                    ),

              if (_editing) ...[
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xffF3C86A),
                      foregroundColor:
                          const Color(0xff121214),
                      elevation: 0,
                    ),
                    child: Text(
                      "SAVE CHANGES",
                      style: GoogleFonts.pressStart2p(
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _deleteNote,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 19,
                  ),
                  label: Text(
                    "DELETE NOTE",
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        const Color(0xffFF8BA7),
                    side: const BorderSide(
                      color: Color(0xffFF8BA7),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  "> write it down. remember it later.",
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.white24,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}