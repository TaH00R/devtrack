import 'package:devtrack/features/profile/profile_screen.dart';
import 'package:devtrack/shared/routes/smooth_route.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatelessWidget {
  final String? email;
  final String? displayName;

  const ProfileCard({
    super.key,
    required this.email,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          smoothRoute(
            const DeveloperProfileScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xff1A1A1E),
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white10,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xffB388FF)
                    .withOpacity(.15),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xffB388FF),
                size: 30,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName ??
                        'No Display Name',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        GoogleFonts.jetBrainsMono(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  if (email != null &&
                      email!.isNotEmpty) ...[
                    const SizedBox(height: 7),

                    Text(
                      email!,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          GoogleFonts.jetBrainsMono(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: Colors.white24,
            ),
          ],
        ),
      ),
    );
  }
}