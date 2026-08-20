import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildEmptyState extends StatelessWidget {
  final VoidCallback? _openAddTask;
  const BuildEmptyState({super.key, this._openAddTask});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.checklist_outlined,
              color: Color(0xffFF8BA7),
              size: 58,
            ),

            const SizedBox(height: 20),

            Text(
              "> NO TASKS FOUND",
              style: GoogleFonts.pressStart2p(
                color: Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              "Nothing to do yet.\nCreate your first task.",
              textAlign: TextAlign.center,
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white38,
                fontSize: 12,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 26),

            ElevatedButton.icon(
              onPressed: _openAddTask,

              icon: const Icon(Icons.add),

              label: Text(
                "ADD TASK",
                style: GoogleFonts.pressStart2p(fontSize: 11),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffB388FF),
                foregroundColor: Colors.white,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
