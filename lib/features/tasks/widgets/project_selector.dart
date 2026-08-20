import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildProjectSelection extends StatelessWidget {
  final int? selectedProjectId;
  final List projects;
  final ValueChanged<int?> onChanged;

  const BuildProjectSelection({
    super.key,
    required this.selectedProjectId,
    required this.projects,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selectedProjectId != null
              ? const Color(0xffFF8BA7)
              : Colors.white10,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedProjectId,
          isExpanded: true,
          dropdownColor: const Color(0xff1A1A1E),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white38,
          ),
          hint: Text(
            'Select a project',
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white24,
              fontSize: 13,
            ),
          ),
          items: projects.map<DropdownMenuItem<int>>((project) {
            return DropdownMenuItem<int>(
              value: project.id,
              child: Row(
                children: [
                  const Icon(
                    Icons.folder_outlined,
                    color: Color(0xff6EE7A2),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      project.name,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.jetBrainsMono(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}