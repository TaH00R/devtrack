import 'package:devtrack/features/dashboard/widgets/empty_card.dart';
import 'package:devtrack/features/dashboard/widgets/loading_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeetcodeCard extends StatelessWidget {
  final dynamic leetcode;
  final bool loading;

  const LeetcodeCard({
    super.key,
    required this.leetcode,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const LoadingCard(
        color: Color(0xffFF8BA7),
      );
    }

    if (leetcode == null) {
      return const EmptyCard(
        message: '> leetcode profile not connected.',
        icon: Icons.terminal,
        color: Color(0xffFF8BA7),
      );
    }

    final username = leetcode.username;
    final totalSolved = leetcode.totalSolved;
    final easySolved = leetcode.easySolved;
    final mediumSolved = leetcode.mediumSolved;
    final hardSolved = leetcode.hardSolved;
    final contestRating = leetcode.contestRating;
    final submissions = leetcode.submissions;

    final int totalSubmissions = submissions.values.fold<int>(
  0,
  (int sum, int value) => sum + value,
);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xff1A1A1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _LeetcodeAvatar(
                avatarUrl: leetcode.avatarUrl,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.jetBrainsMono(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '> leetcode connected',
                      style: GoogleFonts.jetBrainsMono(
                        color: const Color(0xffFF8BA7),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _MainStat(
                  label: 'SOLVED',
                  value: '$totalSolved',
                  color: const Color(0xffFF8BA7),
                ),
              ),

              Expanded(
                child: _MainStat(
                  label: 'SUBMISSIONS',
                  value: '$totalSubmissions',
                  color: const Color(0xff64D8FF),
                ),
              ),

              Expanded(
                child: _MainStat(
                  label: 'RATING',
                  value: contestRating == null
                      ? '--'
                      : contestRating.round().toString(),
                  color: const Color(0xffF3C86A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _DifficultyRow(
            label: 'EASY',
            solved: easySolved,
            color: const Color(0xff6EE7A2),
          ),

          const SizedBox(height: 14),

          _DifficultyRow(
            label: 'MEDIUM',
            solved: mediumSolved,
            color: const Color(0xffF3C86A),
          ),

          const SizedBox(height: 14),

          _DifficultyRow(
            label: 'HARD',
            solved: hardSolved,
            color: const Color(0xffFF8BA7),
          ),

          const SizedBox(height: 22),

          Text(
            'SUBMISSION ACTIVITY',
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white38,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 10),

          _SubmissionGraph(
            submissions: submissions,
          ),
        ],
      ),
    );
  }
}

class _LeetcodeAvatar extends StatelessWidget {
  final String? avatarUrl;

  const _LeetcodeAvatar({
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xffFF8BA7).withOpacity(.12),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: avatarUrl == null || avatarUrl!.isEmpty
          ? const Icon(
              Icons.terminal,
              color: Color(0xffFF8BA7),
              size: 24,
            )
          : Image.network(
              avatarUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.terminal,
                  color: Color(0xffFF8BA7),
                  size: 24,
                );
              },
            ),
    );
  }
}

class _MainStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MainStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.pressStart2p(
            color: color,
            fontSize: 11,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.jetBrainsMono(
            color: Colors.white38,
            fontSize: 8,
          ),
        ),
      ],
    );
  }
}

class _DifficultyRow extends StatelessWidget {
  final String label;
  final int solved;
  final Color color;

  const _DifficultyRow({
    required this.label,
    required this.solved,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(.18),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: GoogleFonts.jetBrainsMono(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(
              '$solved problems solved',
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white54,
                fontSize: 10,
              ),
            ),
          ),

          Text(
            '$solved',
            style: GoogleFonts.pressStart2p(
              color: color,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmissionGraph extends StatelessWidget {
  final Map<DateTime, int> submissions;

  const _SubmissionGraph({
    required this.submissions,
  });

  static const int columns = 24;
  static const int rows = 6;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    final normalizedToday = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final startDate = normalizedToday.subtract(
      const Duration(days: columns * rows - 1),
    );

    final int maxSubmissions = submissions.values.isEmpty
        ? 0
        : submissions.values.reduce(
            (int a, int b) => a > b ? a : b,
          );

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 5.0;

        final cellSize =
            (constraints.maxWidth -
                    ((columns - 1) * spacing)) /
                columns;

        return Column(
          children: List.generate(rows, (row) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: row == rows - 1 ? 0 : spacing,
              ),
              child: Row(
                children: List.generate(columns, (column) {
                  // Fill vertically like the screenshot.
                  final dayIndex =
                      column * rows + row;

                  final date = startDate.add(
                    Duration(days: dayIndex),
                  );

                  final value = _getSubmissions(date);

                  return Container(
                    width: cellSize,
                    height: cellSize,
                    margin: EdgeInsets.only(
                      right: column == columns - 1
                          ? 0
                          : spacing,
                    ),
                    decoration: BoxDecoration(
                      color: _getColor(
                        value,
                        maxSubmissions,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            );
          }),
        );
      },
    );
  }

  int _getSubmissions(DateTime date) {
    final normalizedDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    for (final entry in submissions.entries) {
      final entryDate = DateTime(
        entry.key.year,
        entry.key.month,
        entry.key.day,
      );

      if (entryDate == normalizedDate) {
        return entry.value;
      }
    }

    return 0;
  }

  Color _getColor(
    int value,
    int maxSubmissions,
  ) {
    if (value == 0) {
      return const Color(0xff2B2C33);
    }

    if (maxSubmissions == 0) {
      return const Color(0xffF47A98);
    }

    final ratio = value / maxSubmissions;

    if (ratio <= 0.25) {
      return const Color(0xff663946);
    }

    if (ratio <= 0.5) {
      return const Color(0xff9E4F63);
    }

    if (ratio <= 0.75) {
      return const Color(0xffD66380);
    }

    return const Color(0xffFF91AA);
  }
}