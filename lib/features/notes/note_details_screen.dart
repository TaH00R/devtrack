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
              onPressed: () {
                setState(() {
                  _editing = !_editing;
                });
              },
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
              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'note-icon-${widget.note.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: const Color(0xffF3C86A)
                              .withOpacity(0.08),
                          borderRadius:
                              BorderRadius.circular(15),
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
                      child: _editing
                          ? _buildTextField(
                              _titleController,
                              "Note title",
                            )
                          : Hero(
                              tag:
                                  'note-title-${widget.note.id}',
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  widget.note.title,
                                  style:
                                      GoogleFonts.pressStart2p(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              _sectionLabel("CONTENT"),

              const SizedBox(height: 12),

              _editing
                  ? _buildTextField(
                      _contentController,
                      "Note content",
                      maxLines: 18,
                    )
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xff1A1A1E),
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white10,
                        ),
                      ),
                      child: Text(
                        widget.note.content,
                        style: GoogleFonts.jetBrainsMono(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.65,
                        ),
                      ),
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

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.jetBrainsMono(
        color: const Color(0xffF3C86A),
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.jetBrainsMono(
        color: Colors.white,
        fontSize: 13,
      ),
      cursorColor: const Color(0xffF3C86A),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.jetBrainsMono(
          color: Colors.white24,
          fontSize: 12,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white10,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white10,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xffF3C86A),
          ),
        ),
      ),
    );
  }
}