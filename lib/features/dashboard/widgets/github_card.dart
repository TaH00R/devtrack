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

    final username =
        github.username?.toString() ??
        github.login?.toString() ??
        'Unknown';

    final publicRepos =
        github.publicRepos ?? 0;

    final followers =
        github.followers ?? 0;

    final following =
        github.following ?? 0;

    final avatarUrl =
        github.avatarUrl?.toString();

    final contributions =
        github.contributions ??
        github.totalContributions ??
        0;

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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _GithubAvatar(
                avatarUrl: avatarUrl,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          GoogleFonts.jetBrainsMono(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '> github connected',
                      style:
                          GoogleFonts.jetBrainsMono(
                        color:
                            const Color(0xffB388FF),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.open_in_new,
                color: Colors.white24,
                size: 18,
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
                label: 'FOLLOWING',
                value: '$following',
                color: const Color(0xff64D8FF),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(
                0.025,
              ),
              borderRadius:
                  BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white10,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_fire_department_outlined,
                  color: Color(0xffFF8BA7),
                  size: 20,
                ),

                const SizedBox(width: 10),

                Text(
                  '$contributions',
                  style:
                      GoogleFonts.pressStart2p(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(width: 9),

                Expanded(
                  child: Text(
                    'CONTRIBUTIONS',
                    style:
                        GoogleFonts.jetBrainsMono(
                      color: Colors.white38,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'ACTIVITY',
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white38,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 10),

          const _ContributionGraph(),
        ],
      ),
    );
  }
}

class _GithubAvatar extends StatelessWidget {
  final String? avatarUrl;

  const _GithubAvatar({
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(12),
        color: const Color(0xffB388FF)
            .withOpacity(.12),
      ),
      clipBehavior: Clip.antiAlias,
      child: avatarUrl == null ||
              avatarUrl!.isEmpty
          ? const Icon(
              Icons.person,
              color: Color(0xffB388FF),
            )
          : Image.network(
              avatarUrl!,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) {
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
            style:
                GoogleFonts.pressStart2p(
              color: color,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            label,
            textAlign: TextAlign.center,
            style:
                GoogleFonts.jetBrainsMono(
              color: Colors.white38,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContributionGraph
    extends StatelessWidget {
  const _ContributionGraph();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 3.0;
        const columns = 20;
        const rows = 5;

        final cellSize =
            (constraints.maxWidth -
                    ((columns - 1) * spacing)) /
                columns;

        return Column(
          children: List.generate(rows, (row) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: row == rows - 1
                    ? 0
                    : spacing,
              ),
              child: Row(
                children: List.generate(
                  columns,
                  (column) {
                    final value =
                        (row * columns +
                            column) %
                            5;

                    return Container(
                      width: cellSize,
                      height: cellSize,
                      margin:
                          EdgeInsets.only(
                        right:
                            column ==
                                    columns - 1
                                ? 0
                                : spacing,
                      ),
                      decoration: BoxDecoration(
                        color: _getColor(value),
                        borderRadius:
                            BorderRadius.circular(
                          2,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Color _getColor(int value) {
    switch (value) {
      case 0:
        return Colors.white.withOpacity(
          0.04,
        );
      case 1:
        return const Color(0xffB388FF)
            .withOpacity(.2);
      case 2:
        return const Color(0xffB388FF)
            .withOpacity(.4);
      case 3:
        return const Color(0xffB388FF)
            .withOpacity(.65);
      default:
        return const Color(0xffB388FF);
    }
  }
}