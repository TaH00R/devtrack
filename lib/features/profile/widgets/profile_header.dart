import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeader extends StatelessWidget {
  final String name;

  const ProfileHeader({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'DEVELOPER',
          style:
              GoogleFonts.jetBrainsMono(
            color:
                const Color(0xff6EE7A2),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          name.toUpperCase(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style:
              GoogleFonts.pressStart2p(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
      ],
    );
  }
}