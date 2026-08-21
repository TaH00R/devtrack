import 'package:devtrack/features/dashboard/widgets/empty_card.dart';
import 'package:devtrack/features/dashboard/widgets/loading_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GithubCard extends StatelessWidget {
  final dynamic github;
  final bool loading;

  const GithubCard({
    super.key,
    required this.github,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const LoadingCard(
        color: Color(0xffB388FF),
      );
    }

    if (github == null) {
      return const EmptyCard(
        message: '> github profile not connected.',
        icon: Icons.code_off,
        color: Color(0xffB388FF),
      );
    }

    final username = github.username;
    final publicRepos = github.publicRepos;
    final followers = github.followers;
    final avatarUrl = github.avatarUrl;
    final contributions = github.contributions;

    final int totalContributions = contributions.values.fold<int>(
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
              _GithubAvatar(
                avatarUrl: avatarUrl,
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
                      '> github connected',
                      style: GoogleFonts.jetBrainsMono(
                        color: const Color(0xffB388FF),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              _GithubStat(
                label: 'REPOS',
                value: '$publicRepos',
                color: const Color(0xffB388FF),
              ),

              _GithubStat(
                label: 'FOLLOWERS',
                value: '$followers',
                color: const Color(0xff6EE7A2),
              ),

              _GithubStat(
                label: 'CONTRIBS',
                value: '$totalContributions',
                color: const Color(0xff64D8FF),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            'CONTRIBUTION ACTIVITY',
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white38,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 10),

          _ContributionGraph(
            contributions: contributions,
          ),
        ],
      ),
    );
  }
}

class _GithubAvatar extends StatelessWidget {
  final String avatarUrl;

  const _GithubAvatar({
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xffB388FF).withOpacity(.12),
      ),
      clipBehavior: Clip.antiAlias,
      child: avatarUrl.isEmpty
          ? const Icon(
              Icons.person,
              color: Color(0xffB388FF),
            )
          : Image.network(
              avatarUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.person,
                  color: Color(0xffB388FF),
                );
              },
            ),
    );
  }
}

class _GithubStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _GithubStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.pressStart2p(
              color: color,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white38,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContributionGraph extends StatelessWidget {
  final Map<DateTime, int> contributions;

  const _ContributionGraph({
    required this.contributions,
  });

  static const int columns = 24;
  static const int rows = 6;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    // Normalize today's date.
    final normalizedToday = DateTime(
      today.year,
      today.month,
      today.day,
    );

    // GitHub-style graph:
    // each column = one week
    // each row = one day
    final startDate = normalizedToday.subtract(
      const Duration(days: columns * rows - 1),
    );

    final int maxContribution = contributions.values.isEmpty
        ? 0
        : contributions.values.reduce(
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
                  // IMPORTANT:
                  // Fill vertically first, then move right.
                  final dayIndex =
                      column * rows + row;

                  final date = startDate.add(
                    Duration(days: dayIndex),
                  );

                  final value = _getContribution(date);

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
                        maxContribution,
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

  int _getContribution(DateTime date) {
    final normalizedDate = DateTime(
      date.year,
      date.month,
      date.day,
    );

    for (final entry in contributions.entries) {
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
    int maxContribution,
  ) {
    // Empty
    if (value == 0) {
      return const Color(0xff2B2C33);
    }

    if (maxContribution == 0) {
      return const Color(0xff6EE7A2);
    }

    final ratio = value / maxContribution;

    if (ratio <= 0.25) {
      return const Color(0xff315849);
    }

    if (ratio <= 0.5) {
      return const Color(0xff438065);
    }

    if (ratio <= 0.75) {
      return const Color(0xff5EBE89);
    }

    return const Color(0xff7BE6A8);
  }
}