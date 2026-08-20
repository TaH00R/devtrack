import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TagSelector extends StatelessWidget {
  final List tags;
  final Set<int> selectedTagIds;
  final ValueChanged<int> onToggleTag;
  final VoidCallback onCreateTag;

  const TagSelector({
    super.key,
    required this.tags,
    required this.selectedTagIds,
    required this.onToggleTag,
    required this.onCreateTag,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 9,
      children: [
        ...tags.map((tag) {
          final selected = selectedTagIds.contains(tag.id);

          return GestureDetector(
            onTap: () => onToggleTag(tag.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xffB388FF).withOpacity(0.16)
                    : Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected
                      ? const Color(0xffB388FF)
                      : Colors.white10,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selected
                        ? Icons.check
                        : Icons.label_outline,
                    size: 14,
                    color: selected
                        ? const Color(0xffB388FF)
                        : Colors.white38,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tag.name,
                    style: GoogleFonts.jetBrainsMono(
                      color: selected
                          ? Colors.white
                          : Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        GestureDetector(
          onTap: onCreateTag,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffB388FF).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xffB388FF).withOpacity(0.35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add,
                  color: Color(0xffB388FF),
                  size: 15,
                ),
                const SizedBox(width: 5),
                Text(
                  'NEW TAG',
                  style: GoogleFonts.jetBrainsMono(
                    color: const Color(0xffB388FF),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}