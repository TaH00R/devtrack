import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: const Color(0xff1B1C20),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white10,
            ),
          ),
          child: const Center(
            child: Text(
              "</>",
              style: TextStyle(
                color: Color(0xffA970FF),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(width: 18),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Developer Dashboard",
                style: GoogleFonts.pressStart2p(
                  color: const Color(0xffA970FF),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Overview of your coding journey",
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.white70,
          ),
        )
      ],
    );
  }
}