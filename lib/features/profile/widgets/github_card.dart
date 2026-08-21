import 'package:devtrack/features/profile/widgets/profile_card.dart';
import 'package:devtrack/features/profile/widgets/profile_input_decoration.dart';
import 'package:devtrack/features/profile/widgets/profile_mini_stat.dart';
import 'package:devtrack/features/profile/widgets/profile_vertical_divider.dart';
import 'package:devtrack/shared/models/github_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GithubCard extends StatelessWidget {
  final GithubProfile? profile;
  final dynamic liveData;
  final bool loading;
  final bool linking;

  final TextEditingController controller;
  final Future<void> Function() onSave;

  const GithubCard({
    super.key,
    required this.profile,
    required this.liveData,
    required this.loading,
    required this.linking,
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor:
                    const Color(
                  0xffB388FF,
                ).withOpacity(.10),

                backgroundImage:
                    liveData != null &&
                            liveData.avatarUrl
                                .toString()
                                .isNotEmpty
                        ? NetworkImage(
                            liveData.avatarUrl
                                .toString(),
                          )
                        : null,

                child: liveData == null ||
                        liveData.avatarUrl
                            .toString()
                            .isEmpty
                    ? const Icon(
                        Icons.code,
                        color:
                            Color(
                          0xffB388FF,
                        ),
                      )
                    : null,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  profile == null
                      ? 'LINK GITHUB'
                      : '@${profile!.username}',
                  style:
                      GoogleFonts.pressStart2p(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          TextField(
            controller: controller,
            decoration:
                profileInputDecoration(
              'GitHub username',
            ),
            style:
                GoogleFonts.jetBrainsMono(
              color: Colors.white,
              fontSize: 12,
            ),
            cursorColor:
                const Color(
              0xffB388FF,
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed:
                  linking || loading
                      ? null
                      : onSave,
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xffB388FF,
                ),
                foregroundColor:
                    Colors.white,
                elevation: 0,
              ),
              child: linking
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      profile == null
                          ? 'LINK GITHUB'
                          : 'UPDATE GITHUB',
                      style:
                          GoogleFonts.pressStart2p(
                        fontSize: 10,
                      ),
                    ),
            ),
          ),

          if (liveData != null) ...[
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: ProfileMiniStat(
                    label: 'REPOS',
                    value:
                        '${liveData.publicRepos}',
                    color:
                        const Color(
                      0xffB388FF,
                    ),
                  ),
                ),

                const ProfileVerticalDivider(),

                Expanded(
                  child: ProfileMiniStat(
                    label: 'FOLLOWERS',
                    value:
                        '${liveData.followers}',
                    color:
                        const Color(
                      0xff64D8FF,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}