import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoProjectsBody extends StatelessWidget {
  final VoidCallback onCreateProject;

  const NoProjectsBody({
    super.key,
    required this.onCreateProject,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.folder_off_outlined,
              color: Color(0xffF3C86A),
              size: 60,
            ),

            const SizedBox(height: 22),

            Text(
              '> NO PROJECTS FOUND',
              textAlign: TextAlign.center,
              style: GoogleFonts.pressStart2p(
                color: Colors.white,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              'Tasks need to belong to a project.\n'
              'Create a project first.',
              textAlign: TextAlign.center,
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white38,
                fontSize: 12,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: onCreateProject,
                icon: const Icon(Icons.add),
                label: Text(
                  'CREATE PROJECT',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 11,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xffB388FF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}