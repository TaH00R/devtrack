import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectEmptyState extends StatelessWidget {
  final VoidCallback onAddProject;

  const ProjectEmptyState({
    super.key,
    required this.onAddProject,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 30,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.folder_open,
              color: Color(0xff6EE7A2),
              size: 55,
            ),

            const SizedBox(height: 20),

            Text(
              "> No projects found.",
              style:
                  GoogleFonts.jetBrainsMono(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Create a project and start building.",
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.jetBrainsMono(
                color: Colors.white24,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: onAddProject,

              icon: const Icon(Icons.add),

              label: Text(
                "ADD PROJECT",
                style:
                    GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                ),
              ),

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xffB388FF),

                foregroundColor:
                    Colors.white,

                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}