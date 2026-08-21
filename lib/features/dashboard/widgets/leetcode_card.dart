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
        message:
            '> leetcode profile not connected.',
        icon: Icons.terminal,
        color: Color(0xffFF8BA7),
      );
    }

    final username =
        leetcode.username?.toString() ??
        'Unknown';

    final totalSolved =
        leetcode.totalSolved ?? 0;

    final easySolved =
        leetcode.easySolved ?? 0;

    final mediumSolved =
        leetcode.mediumSolved ?? 0;

    final hardSolved =
        leetcode.hardSolved ?? 0;

    final totalQuestions =
        leetcode.totalQuestions ?? 0;

    final easyTotal =
        leetcode.totalEasy ?? 0;

    final mediumTotal =
        leetcode.totalMedium ?? 0;

    final hardTotal =
        leetcode.totalHard ?? 0;

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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xffFF8BA7)
                      .withOpacity(.12),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.terminal,
                  color: Color(0xffFF8BA7),
                  size: 25,
                ),
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
                      '> leetcode connected',
                      style:
                          GoogleFonts.jetBrainsMono(
                        color:
                            const Color(0xffFF8BA7),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Center(
            child: _SolvedCircle(
              solved: totalSolved,
              total: totalQuestions,
            ),
          ),

          const SizedBox(height: 24),

          _DifficultyRow(
            label: 'EASY',
            solved: easySolved,
            total: easyTotal,
            color: const Color(0xff6EE7A2),
          ),

          const SizedBox(height: 12),

          _DifficultyRow(
            label: 'MEDIUM',
            solved: mediumSolved,
            total: mediumTotal,
            color: const Color(0xffF3C86A),
          ),

          const SizedBox(height: 12),

          _DifficultyRow(
            label: 'HARD',
            solved: hardSolved,
            total: hardTotal,
            color: const Color(0xffFF8BA7),
          ),
        ],
      ),
    );
  }
}

class _SolvedCircle extends StatelessWidget {
  final int solved;
  final int total;

  const _SolvedCircle({
    required this.solved,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        total == 0 ? 0.0 : solved / total;

    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: 9,
              backgroundColor:
                  Colors.white10,
              valueColor:
                  const AlwaysStoppedAnimation(
                Color(0xffFF8BA7),
              ),
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$solved',
                style:
                    GoogleFonts.pressStart2p(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 9),

              Text(
                'SOLVED',
                style:
                    GoogleFonts.jetBrainsMono(
                  color: Colors.white38,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DifficultyRow extends StatelessWidget {
  final String label;
  final int solved;
  final int total;
  final Color color;

  const _DifficultyRow({
    required this.label,
    required this.solved,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        total == 0 ? 0.0 : solved / total;

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 62,
              child: Text(
                label,
                style:
                    GoogleFonts.jetBrainsMono(
                  color: color,
                  fontSize: 10,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(10),
                child:
                    LinearProgressIndicator(
                  value:
                      progress.clamp(0.0, 1.0),
                  minHeight: 7,
                  backgroundColor:
                      Colors.white10,
                  valueColor:
                      AlwaysStoppedAnimation(
                    color,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            SizedBox(
              width: 48,
              child: Text(
                '$solved',
                textAlign: TextAlign.right,
                style:
                    GoogleFonts.jetBrainsMono(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}