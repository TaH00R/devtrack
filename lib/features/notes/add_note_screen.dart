import 'package:devtrack/features/auth/providers/auth_provider.dart';
import 'package:devtrack/features/notes/widgets/note_form_label.dart';
import 'package:devtrack/features/notes/widgets/note_text_field.dart';
import 'package:devtrack/shared/models/note_request.dart';
import 'package:devtrack/shared/providers/note_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _createNote() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userId = context.read<AuthProvider>().userId;

    if (userId == null) {
      _showError("User not authenticated.");
      return;
    }

    final noteProvider = context.read<NoteProvider>();

    final request = NoteRequest(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      userId: userId,
    );

    await noteProvider.createNote(request);

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
    final noteProvider = context.watch<NoteProvider>();

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
            "ADD NOTE",
            style: GoogleFonts.pressStart2p(
              color: const Color(0xffF3C86A),
              fontSize: 17,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            22,
            18,
            22,
            30,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "> Write something.",
                  style: GoogleFonts.jetBrainsMono(
                    color: const Color(0xffF3C86A),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 28),

                const NoteFormLabel("NOTE TITLE"),

                const SizedBox(height: 10),

                NoteTextField(
                  controller: _titleController,
                  hintText: "What are you thinking about?",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Note title is required";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                const NoteFormLabel("CONTENT"),

                const SizedBox(height: 10),

                NoteTextField(
                  controller: _contentController,
                  hintText: "Write your note...",
                  maxLines: 14,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Note content is required";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 36),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: noteProvider.isLoading
                        ? null
                        : _createNote,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF3C86A),
                      disabledBackgroundColor: Colors.white10,
                      foregroundColor: const Color(0xff121214),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: noteProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xff121214),
                            ),
                          )
                        : Text(
                            "SAVE NOTE",
                            style: GoogleFonts.pressStart2p(
                              fontSize: 12,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 18),

                Center(
                  child: Text(
                    "> thoughts stored locally in the cloud.",
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
      ),
    );
  }
}