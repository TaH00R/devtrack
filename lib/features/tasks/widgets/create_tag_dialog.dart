import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTagDialog extends StatefulWidget {
  const CreateTagDialog({super.key});

  @override
  State<CreateTagDialog> createState() =>
      _CreateTagDialogState();
}

class _CreateTagDialogState extends State<CreateTagDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();

    if (name.isEmpty) {
      return;
    }

    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff1A1A1E),
      title: Text(
        'NEW TAG',
        style: GoogleFonts.pressStart2p(
          color: const Color(0xffB388FF),
          fontSize: 14,
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: GoogleFonts.jetBrainsMono(
          color: Colors.white,
          fontSize: 13,
        ),
        cursorColor: const Color(0xffB388FF),
        decoration: InputDecoration(
          hintText: 'Tag name',
          hintStyle: GoogleFonts.jetBrainsMono(
            color: Colors.white24,
            fontSize: 12,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.white10,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xffB388FF),
            ),
          ),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'CANCEL',
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white38,
            ),
          ),
        ),
        TextButton(
          onPressed: _submit,
          child: Text(
            'CREATE',
            style: GoogleFonts.jetBrainsMono(
              color: const Color(0xffB388FF),
            ),
          ),
        ),
      ],
    );
  }
}