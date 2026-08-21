import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TechStackCard extends StatelessWidget {
  final List<String> techStack;
  final List<String> availableTechnologies;
  final bool addingTechnology;

  final TextEditingController controller;

  final VoidCallback onAddTechnology;
  final ValueChanged<String> onRemoveTechnology;
  final ValueChanged<bool> onSetAddingTechnology;

  const TechStackCard({
    super.key,
    required this.techStack,
    required this.availableTechnologies,
    required this.addingTechnology,
    required this.controller,
    required this.onAddTechnology,
    required this.onRemoveTechnology,
    required this.onSetAddingTechnology,
  });

  @override
  Widget build(BuildContext context) {
    final unusedTechnologies =
        availableTechnologies
            .where(
              (tech) => !techStack.contains(tech),
            )
            .toList();

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
          if (techStack.isEmpty)
            Text(
              '> no technologies added yet.',
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white38,
                fontSize: 11,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: techStack.map((tech) {
                return _TechChip(
                  tech: tech,
                  onRemove: () =>
                      onRemoveTechnology(tech),
                );
              }).toList(),
            ),

          const SizedBox(height: 16),

          if (addingTechnology)
            Column(
              children: [
                DropdownButtonFormField<String>(
                  value: null,
                  dropdownColor:
                      const Color(0xff242428),
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Select technology',
                    hintStyle:
                        GoogleFonts.jetBrainsMono(
                      color: Colors.white24,
                      fontSize: 11,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(
                      0.04,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.white10,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.white10,
                      ),
                    ),
                  ),
                  items: unusedTechnologies
                      .map(
                        (tech) =>
                            DropdownMenuItem(
                          value: tech,
                          child: Text(tech),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    controller.text = value;
                  },
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          onSetAddingTechnology(
                            false,
                          );
                        },
                        style:
                            OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.white10,
                          ),
                        ),
                        child: Text(
                          'CANCEL',
                          style:
                              GoogleFonts.jetBrainsMono(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAddTechnology,
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xff64D8FF,
                          ),
                          foregroundColor:
                              const Color(
                            0xff121214,
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'ADD',
                          style:
                              GoogleFonts.jetBrainsMono(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            InkWell(
              onTap: () {
                onSetAddingTechnology(true);
              },
              borderRadius:
                  BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(
                      0xff64D8FF,
                    ).withOpacity(.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      color: Color(0xff64D8FF),
                      size: 17,
                    ),

                    const SizedBox(width: 7),

                    Text(
                      'ADD TECHNOLOGY',
                      style:
                          GoogleFonts.jetBrainsMono(
                        color:
                            const Color(0xff64D8FF),
                        fontSize: 10,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String tech;
  final VoidCallback onRemove;

  const _TechChip({
    required this.tech,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 5,
        top: 5,
        bottom: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff64D8FF)
            .withOpacity(.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xff64D8FF)
              .withOpacity(.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tech,
            style: GoogleFonts.jetBrainsMono(
              color: const Color(0xff64D8FF),
              fontSize: 10,
            ),
          ),

          const SizedBox(width: 5),

          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              color: Colors.white38,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}