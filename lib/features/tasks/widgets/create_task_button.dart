import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTaskButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const CreateTaskButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color(0xffFF8BA7),
          disabledBackgroundColor:
              Colors.white10,
          foregroundColor:
              const Color(0xff121214),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xff121214),
                ),
              )
            : Text(
                'CREATE TASK',
                style: GoogleFonts.pressStart2p(
                  fontSize: 12,
                ),
              ),
      ),
    );
  }
}