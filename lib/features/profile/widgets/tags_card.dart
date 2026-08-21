import 'package:devtrack/features/profile/widgets/profile_card.dart';
import 'package:devtrack/features/profile/widgets/profile_input_decoration.dart';
import 'package:devtrack/shared/models/tag.dart';
import 'package:devtrack/shared/providers/tag_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TagsCard extends StatelessWidget {
  final TagProvider provider;
  final TextEditingController controller;
  final bool addingTag;

  final bool Function(int tagId) isTagUsed;

  final Future<void> Function(Tag tag)
      onDeleteTag;

  final Future<void> Function()
      onCreateTag;

  final VoidCallback onStartAdding;

  const TagsCard({
    super.key,
    required this.provider,
    required this.controller,
    required this.addingTag,
    required this.isTagUsed,
    required this.onDeleteTag,
    required this.onCreateTag,
    required this.onStartAdding,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          if (provider.isLoading)
            const Center(
              child:
                  CircularProgressIndicator(
                color:
                    Color(0xffF3C86A),
                strokeWidth: 2,
              ),
            )
          else if (provider.tags.isEmpty)
            Text(
              '> No tags yet.',
              style:
                  GoogleFonts.jetBrainsMono(
                color: Colors.white24,
                fontSize: 11,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  provider.tags.map(
                (tag) {
                  final used =
                      isTagUsed(tag.id);

                  return Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 11,
                      vertical: 9,
                    ),
                    decoration:
                        BoxDecoration(
                      color: used
                          ? const Color(
                              0xffF3C86A,
                            ).withOpacity(
                              .08,
                            )
                          : Colors.white
                              .withOpacity(
                              .04,
                            ),
                      borderRadius:
                          BorderRadius
                              .circular(8),
                      border:
                          Border.all(
                        color: used
                            ? const Color(
                                0xffF3C86A,
                              ).withOpacity(
                                .22,
                              )
                            : Colors.white10,
                      ),
                    ),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Icon(
                          used
                              ? Icons.lock_outline
                              : Icons
                                  .label_outline,
                          color: used
                              ? const Color(
                                  0xffF3C86A,
                                )
                              : Colors.white38,
                          size: 14,
                        ),

                        const SizedBox(
                          width: 6,
                        ),

                        Text(
                          tag.name,
                          style:
                              GoogleFonts
                                  .jetBrainsMono(
                            color:
                                Colors.white70,
                            fontSize: 10,
                          ),
                        ),

                        const SizedBox(
                          width: 7,
                        ),

                        GestureDetector(
                          onTap: used
                              ? null
                              : () =>
                                  onDeleteTag(
                                    tag,
                                  ),
                          child: Icon(
                            Icons.close,
                            color: used
                                ? Colors.white12
                                : const Color(
                                    0xffFF8BA7,
                                  ),
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),

          const SizedBox(height: 15),

          if (addingTag)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    onSubmitted:
                        (_) =>
                            onCreateTag(),
                    style:
                        GoogleFonts
                            .jetBrainsMono(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    cursorColor:
                        const Color(
                      0xffF3C86A,
                    ),
                    decoration:
                        profileInputDecoration(
                      'New tag name',
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed:
                        onCreateTag,
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          const Color(
                        0xffF3C86A,
                      ),
                      foregroundColor:
                          const Color(
                        0xff121214,
                      ),
                      elevation: 0,
                    ),
                    child: const Icon(
                      Icons.check,
                    ),
                  ),
                ),
              ],
            )
          else
            GestureDetector(
              onTap: onStartAdding,
              child: Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration:
                    BoxDecoration(
                  color: const Color(
                    0xffF3C86A,
                  ).withOpacity(.05),
                  borderRadius:
                      BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(
                      0xffF3C86A,
                    ).withOpacity(.3),
                  ),
                ),
                child: Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add,
                      color:
                          Color(0xffF3C86A),
                      size: 15,
                    ),

                    const SizedBox(width: 5),

                    Text(
                      'ADD TAG',
                      style:
                          GoogleFonts
                              .jetBrainsMono(
                        color:
                            const Color(
                          0xffF3C86A,
                        ),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 10),

          Text(
            '> locked tags are currently used by a task',
            style:
                GoogleFonts.jetBrainsMono(
              color: Colors.white30,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}