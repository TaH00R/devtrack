import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeadlineSelector extends StatelessWidget {
  final DateTime? deadline;
  final VoidCallback onTap;
  final String Function(DateTime) formatDate;

  const DeadlineSelector({
    super.key,
    required this.deadline,
    required this.onTap,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white10,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xffF3C86A),
              size: 20,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                deadline == null
                    ? "Select a deadline"
                    : formatDate(deadline!),
                style: GoogleFonts.jetBrainsMono(
                  color: deadline == null
                      ? Colors.white38
                      : Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Colors.white38,
            ),
          ],
        ),
      ),
    );
  }
}