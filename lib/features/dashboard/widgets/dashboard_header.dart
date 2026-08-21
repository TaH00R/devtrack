import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardHeader extends StatelessWidget {
  final String username;

  const DashboardHeader({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;

    String greeting;

    if (hour < 12) {
      greeting = 'Good morning,';
    } else if (hour < 17) {
      greeting = 'Good afternoon,';
    } else {
      greeting = 'Good evening,';
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: GoogleFonts.jersey10(
            color: Colors.white70,
            fontSize: 24,
          ),
        ),

        const SizedBox(height: 4),

        Row(
          children: [
            Expanded(
              child: Text(
                username,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style:
                    GoogleFonts.pressStart2p(
                  color:
                      const Color(0xffB388FF),
                  fontSize: 22,
                ),
              ),
            ),

            const SizedBox(width: 10),

            const Icon(
              Icons.waving_hand_outlined,
              color: Color(0xffF3C86A),
              size: 27,
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            Text(
              '>',
              style: GoogleFonts.jetBrainsMono(
                color:
                    const Color(0xff6EE7A2),
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(width: 7),

            Text(
              'one commit at a time.',
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}