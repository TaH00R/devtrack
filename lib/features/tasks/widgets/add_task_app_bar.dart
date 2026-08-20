import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTaskAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AddTaskAppBar({super.key});

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        'ADD TASK',
        style: GoogleFonts.pressStart2p(
          color: const Color(0xffFF8BA7),
          fontSize: 17,
        ),
      ),
    );
  }
}