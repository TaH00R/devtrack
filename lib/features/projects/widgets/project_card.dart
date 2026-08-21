import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectCard extends StatelessWidget {
  final int projectId;
  final String name;
  final String description;
  final int completedTasks;
  final int totalTasks;
  final double progress;

  const ProjectCard({
    super.key,
    required this.projectId,
    required this.name,
    required this.description,
    required this.completedTasks,
    required this.totalTasks,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final percentage =
        (progress * 100).round();

    return Container(
      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color:
            const Color(0xff1A1A1E),

        borderRadius:
            BorderRadius.circular(14),

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
              Hero(
                tag:
                    'project-icon-$projectId',

                child: Material(
                  color:
                      Colors.transparent,

                  child: Container(
                    width: 58,
                    height: 58,

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xff6EE7A2,
                      ).withOpacity(
                            0.08,
                          ),

                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),

                      border:
                          Border.all(
                        color:
                            const Color(
                          0xff6EE7A2,
                        ).withOpacity(
                              0.2,
                            ),
                      ),
                    ),

                    child: const Icon(
                      Icons.folder_outlined,
                      color:
                          Color(0xff6EE7A2),
                      size: 30,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Hero(
                  tag:
                      'project-name-$projectId',

                  child: Material(
                    color:
                        Colors.transparent,

                    child: Text(
                      name,

                      maxLines: 1,

                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          GoogleFonts
                              .pressStart2p(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: Colors.white24,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            description,

            maxLines: 2,

            overflow:
                TextOverflow.ellipsis,

            style:
                GoogleFonts.jetBrainsMono(
              color: Colors.white38,
              fontSize: 11,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [
              Text(
                "PROGRESS",

                style:
                    GoogleFonts.jetBrainsMono(
                  color:
                      const Color(
                    0xffF3C86A,
                  ),

                  fontSize: 10,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              Text(
                "$percentage%",

                style:
                    GoogleFonts.jetBrainsMono(
                  color:
                      const Color(
                    0xff6EE7A2,
                  ),

                  fontSize: 11,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          Row(
            children:
                List.generate(
              20,
              (index) {
                final filled =
                    index <
                        (progress * 20)
                            .round();

                return Expanded(
                  child: Container(
                    height: 7,

                    margin:
                        EdgeInsets.only(
                      right:
                          index == 19
                              ? 0
                              : 3,
                    ),

                    decoration:
                        BoxDecoration(
                      color: filled
                          ? const Color(
                              0xff6EE7A2,
                            )
                          : Colors.white10,

                      borderRadius:
                          BorderRadius.circular(
                        2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white24,
                size: 15,
              ),

              const SizedBox(width: 6),

              Text(
                "$completedTasks / $totalTasks tasks completed",

                style:
                    GoogleFonts.jetBrainsMono(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}