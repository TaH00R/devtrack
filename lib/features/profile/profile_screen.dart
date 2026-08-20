import 'package:devtrack/features/auth/providers/auth_provider.dart';
import 'package:devtrack/shared/models/github_profile.dart';
import 'package:devtrack/shared/models/leetcode_profile.dart';
import 'package:devtrack/shared/models/tag.dart';
import 'package:devtrack/shared/providers/github_provider.dart';
import 'package:devtrack/shared/providers/leetcode_provider.dart';
import 'package:devtrack/shared/providers/tag_provider.dart';
import 'package:devtrack/shared/providers/task_provider.dart';
import 'package:devtrack/shared/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DeveloperProfileScreen extends StatefulWidget {
  const DeveloperProfileScreen({super.key});

  @override
  State<DeveloperProfileScreen> createState() =>
      _DeveloperProfileScreenState();
}

class _DeveloperProfileScreenState
    extends State<DeveloperProfileScreen> {
  final TextEditingController _displayNameController =
      TextEditingController();

  final TextEditingController _githubController =
      TextEditingController();

  final TextEditingController _leetcodeController =
      TextEditingController();

  final TextEditingController _tagController =
      TextEditingController();

  bool _editingDisplayName = false;
  bool _addingTag = false;
  bool _linkingGithub = false;
  bool _linkingLeetcode = false;
  bool _savingDisplayName = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  Future<void> _load() async {
    if (!mounted) return;

    final authProvider =
        context.read<AuthProvider>();

    final userId = authProvider.userId;

    await Future.wait([
      if (userId != null)
        context.read<UserProvider>().getUser(userId),
      context.read<TagProvider>().getTags(),
      context.read<TaskProvider>().getTasks(),
      context.read<GithubProvider>().getProfiles(),
      context.read<LeetcodeProvider>().getProfiles(),
    ]);

    if (!mounted) return;

    final user =
        context.read<UserProvider>().user;

    final github =
        context.read<GithubProvider>().profiles;

    final leetcode =
        context.read<LeetcodeProvider>().profiles;

    _displayNameController.text =
        user?.displayName ??
        user?.userName ??
        '';

    if (github.isNotEmpty) {
      _githubController.text =
          github.first.username;
    }

    if (leetcode.isNotEmpty) {
      _leetcodeController.text =
          leetcode.first.username;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _githubController.dispose();
    _leetcodeController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  // ===========================================================
  // DISPLAY NAME
  // ===========================================================

  Future<void> _saveDisplayName() async {
    final name =
        _displayNameController.text.trim();

    if (name.isEmpty) {
      _showError(
        'Display name cannot be empty.',
      );
      return;
    }

    final userId =
        context.read<AuthProvider>().userId;

    if (userId == null) {
      _showError(
        'User is not authenticated.',
      );
      return;
    }

    setState(() {
      _savingDisplayName = true;
    });

    final provider =
        context.read<UserProvider>();

    await provider.updateUser(
      userId,
      {
        'displayName': name,
      },
    );

    if (!mounted) return;

    setState(() {
      _savingDisplayName = false;
    });

    if (provider.error != null) {
      _showError(provider.error!);
      return;
    }

    setState(() {
      _editingDisplayName = false;
    });
  }

  // ===========================================================
  // TAGS
  // ===========================================================

  bool _isTagUsed(int tagId) {
    final tasks =
        context.read<TaskProvider>().tasks;

    return tasks.any(
      (task) =>
          task.tagIds?.contains(tagId) ??
          false,
    );
  }

  Future<void> _createTag() async {
    final name =
        _tagController.text.trim();

    if (name.isEmpty) return;

    final provider =
        context.read<TagProvider>();

    await provider.createTag(name);

    if (!mounted) return;

    if (provider.error != null) {
      _showError(provider.error!);
      return;
    }

    _tagController.clear();

    setState(() {
      _addingTag = false;
    });
  }

  Future<void> _deleteTag(Tag tag) async {
    if (_isTagUsed(tag.id)) {
      _showError(
        'This tag is linked to a task and cannot be removed.',
      );
      return;
    }

    final confirmed =
        await _confirmDeleteTag(tag);

    if (!confirmed) return;

    final provider =
        context.read<TagProvider>();

    await provider.deleteTag(tag.id);

    if (!mounted) return;

    if (provider.error != null) {
      _showError(provider.error!);
    }
  }

  Future<bool> _confirmDeleteTag(
    Tag tag,
  ) async {
    final result =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              const Color(0xff1A1A1E),

          title: Text(
            'DELETE TAG?',
            style:
                GoogleFonts.pressStart2p(
              color:
                  const Color(
                0xffFF8BA7,
              ),
              fontSize: 13,
            ),
          ),

          content: Text(
            'Delete "${tag.name}"?',
            style:
                GoogleFonts.jetBrainsMono(
              color:
                  Colors.white54,
              fontSize: 12,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: Text(
                'CANCEL',
                style:
                    GoogleFonts.jetBrainsMono(
                  color:
                      Colors.white38,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: Text(
                'DELETE',
                style:
                    GoogleFonts.jetBrainsMono(
                  color:
                      const Color(
                    0xffFF8BA7,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  // ===========================================================
  // GITHUB
  // ===========================================================

  Future<void> _saveGithub() async {
    final username =
        _githubController.text.trim();

    if (username.isEmpty) {
      _showError(
        'GitHub username cannot be empty.',
      );
      return;
    }

    final provider =
        context.read<GithubProvider>();

    setState(() {
      _linkingGithub = true;
    });

    try {
      if (provider.profiles.isEmpty) {
        await provider.createProfile(
          username,
        );
      } else {
        final existing =
            provider.profiles.first;

        final updated =
            GithubProfile(
          id: existing.id,
          username: username,
          profileUrl:
              existing.profileUrl,
          publicRepos:
              existing.publicRepos,
          followers:
              existing.followers,
        );

        await provider.updateProfile(
          existing.id,
          updated,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _linkingGithub = false;
        });
      }
    }

    if (!mounted) return;

    if (provider.error != null) {
      _showError(provider.error!);
    }
  }

  // ===========================================================
  // LEETCODE
  // ===========================================================

  Future<void> _saveLeetcode() async {
    final username =
        _leetcodeController.text.trim();

    if (username.isEmpty) {
      _showError(
        'LeetCode username cannot be empty.',
      );
      return;
    }

    final provider =
        context.read<LeetcodeProvider>();

    setState(() {
      _linkingLeetcode = true;
    });

    try {
      if (provider.profiles.isEmpty) {
        await provider.createProfile(
          username,
        );
      } else {
        final existing =
            provider.profiles.first;

        final updated =
            LeetcodeProfile(
          id: existing.id,
          username: username,
          totalSolved:
              existing.totalSolved,
          easySolved:
              existing.easySolved,
          mediumSolved:
              existing.mediumSolved,
          hardSolved:
              existing.hardSolved,
          contestRatings:
              existing.contestRatings,
        );

        await provider.updateProfile(
          existing.id,
          updated,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _linkingLeetcode = false;
        });
      }
    }

    if (!mounted) return;

    if (provider.error != null) {
      _showError(provider.error!);
    }
  }

  // ===========================================================
  // BUILD
  // ===========================================================

  @override
  Widget build(BuildContext context) {
    final user =
        context.watch<UserProvider>().user;

    final tagProvider =
        context.watch<TagProvider>();

    final githubProvider =
        context.watch<GithubProvider>();

    final leetcodeProvider =
        context.watch<LeetcodeProvider>();

    final github =
        githubProvider.profiles.isNotEmpty
            ? githubProvider.profiles.first
            : null;

    final leetcode =
        leetcodeProvider.profiles.isNotEmpty
            ? leetcodeProvider.profiles.first
            : null;

    return Scaffold(
      backgroundColor:
          const Color(0xff121214),

      appBar: AppBar(
        backgroundColor:
            const Color(0xff121214),
        elevation: 0,

        leading: IconButton(
          onPressed: () =>
              Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color:
                Colors.white70,
          ),
        ),

        title: Text(
          'DEVELOPER PROFILE',
          style:
              GoogleFonts.pressStart2p(
            color:
                const Color(
              0xffB388FF,
            ),
            fontSize: 14,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            22,
            12,
            22,
            35,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              _buildHeader(
                user?.displayName ??
                    user?.userName ??
                    'USER',
              ),

              const SizedBox(
                height: 25,
              ),

              _sectionTitle(
                'ACCOUNT',
                Icons.person_outline,
                const Color(
                  0xffB388FF,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              _buildAccountCard(
                user,
              ),

              const SizedBox(
                height: 22,
              ),

              _sectionTitle(
                'MY TAGS',
                Icons.label_outline,
                const Color(
                  0xffF3C86A,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              _buildTagsCard(
                tagProvider,
              ),

              const SizedBox(
                height: 22,
              ),

              _sectionTitle(
                'GITHUB',
                Icons.code,
                const Color(
                  0xffB388FF,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              _buildGithubCard(
                github,
                githubProvider.isLoading,
              ),

              const SizedBox(
                height: 22,
              ),

              _sectionTitle(
                'LEETCODE',
                Icons.terminal,
                const Color(
                  0xffFF8BA7,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              _buildLeetcodeCard(
                leetcode,
                leetcodeProvider.isLoading,
              ),

              const SizedBox(
                height: 22,
              ),

              _sectionTitle(
                'ACCOUNT ACTIONS',
                Icons.settings_outlined,
                const Color(
                  0xffFF8BA7,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              _buildLogoutCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    String name,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'DEVELOPER',
          style:
              GoogleFonts.jetBrainsMono(
            color:
                const Color(
              0xff6EE7A2,
            ),
            fontSize: 11,
            fontWeight:
                FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(
          height: 8,
        ),

        Text(
          name.toUpperCase(),
          maxLines: 2,
          overflow:
              TextOverflow.ellipsis,
          style:
              GoogleFonts.pressStart2p(
            color:
                Colors.white,
            fontSize: 19,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountCard(
    dynamic user,
  ) {
    return _card(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _field(
                  'DISPLAY NAME',
                  user?.displayName ??
                      user?.userName ??
                      'USER',
                ),
              ),

              IconButton(
                onPressed:
                    _editingDisplayName
                        ? _saveDisplayName
                        : () {
                            setState(() {
                              _displayNameController
                                  .text =
                                  user?.displayName ??
                                      user?.userName ??
                                      '';

                              _editingDisplayName =
                                  true;
                            });
                          },
                icon: Icon(
                  _editingDisplayName
                      ? Icons.check
                      : Icons
                          .edit_outlined,
                  color:
                      const Color(
                    0xffB388FF,
                  ),
                  size: 20,
                ),
              ),
            ],
          ),

          if (_editingDisplayName) ...[
            const SizedBox(
              height: 10,
            ),

            TextField(
              controller:
                  _displayNameController,
              enabled:
                  !_savingDisplayName,
              style:
                  GoogleFonts.jetBrainsMono(
                color:
                    Colors.white,
                fontSize: 12,
              ),
              cursorColor:
                  const Color(
                0xffB388FF,
              ),
              decoration:
                  _inputDecoration(
                'Display name',
              ),
            ),
          ],

          const Divider(
            color: Colors.white10,
            height: 28,
          ),

          _field(
            'USERNAME',
            user?.userName ??
                'UNKNOWN',
          ),

          const SizedBox(
            height: 17,
          ),

          _field(
            'EMAIL',
            user?.email ??
                'UNKNOWN',
          ),
        ],
      ),
    );
  }

  Widget _buildTagsCard(
    TagProvider provider,
  ) {
    return _card(
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
                color:
                    Colors.white24,
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
                      _isTagUsed(tag.id);

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
                            ).withOpacity(.08)
                          : Colors.white
                              .withOpacity(.04),
                      borderRadius:
                          BorderRadius.circular(
                        8,
                      ),
                      border:
                          Border.all(
                        color: used
                            ? const Color(
                                0xffF3C86A,
                              ).withOpacity(.22)
                            : Colors.white10,
                      ),
                    ),
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Icon(
                          used
                              ? Icons
                                  .lock_outline
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
                              GoogleFonts.jetBrainsMono(
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
                                  _deleteTag(
                                tag,
                              ),
                          child:
                              Icon(
                            Icons.close,
                            color: used
                                ? Colors
                                    .white12
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

          const SizedBox(
            height: 15,
          ),

          if (_addingTag)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller:
                        _tagController,
                    autofocus: true,
                    onSubmitted:
                        (_) => _createTag(),
                    style:
                        GoogleFonts.jetBrainsMono(
                      color:
                          Colors.white,
                      fontSize: 12,
                    ),
                    cursorColor:
                        const Color(
                      0xffF3C86A,
                    ),
                    decoration:
                        _inputDecoration(
                      'New tag name',
                    ),
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                SizedBox(
                  height: 48,
                  child:
                      ElevatedButton(
                    onPressed:
                        _createTag,
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
                      elevation:
                          0,
                    ),
                    child:
                        const Icon(
                      Icons.check,
                    ),
                  ),
                ),
              ],
            )
          else
            GestureDetector(
              onTap: () {
                setState(() {
                  _addingTag = true;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xffF3C86A,
                  ).withOpacity(.05),
                  borderRadius:
                      BorderRadius.circular(
                    8,
                  ),
                  border:
                      Border.all(
                    color:
                        const Color(
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
                          Color(
                        0xffF3C86A,
                      ),
                      size: 15,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
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

          const SizedBox(
            height: 10,
          ),

          Text(
            '> locked tags are currently used by a task',
            style:
                GoogleFonts.jetBrainsMono(
              color:
                  Colors.white30,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGithubCard(
    GithubProfile? profile,
    bool loading,
  ) {
    return _card(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.code,
                color:
                    Color(0xffB388FF),
              ),

              const SizedBox(
                width: 9,
              ),

              Text(
                profile == null
                    ? 'LINK GITHUB'
                    : 'CONNECTED',
                style:
                    GoogleFonts.pressStart2p(
                  color:
                      Colors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 14,
          ),

          TextField(
            controller:
                _githubController,
            decoration:
                _inputDecoration(
              'GitHub username',
            ),
            style:
                GoogleFonts.jetBrainsMono(
              color:
                  Colors.white,
              fontSize: 12,
            ),
            cursorColor:
                const Color(
              0xffB388FF,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          SizedBox(
            width:
                double.infinity,
            height: 46,
            child:
                ElevatedButton(
              onPressed:
                  _linkingGithub ||
                          loading
                      ? null
                      : _saveGithub,
              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    const Color(
                  0xffB388FF,
                ),
                foregroundColor:
                    Colors.white,
                elevation: 0,
              ),
              child:
                  _linkingGithub
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child:
                              CircularProgressIndicator(
                            strokeWidth:
                                2,
                            color:
                                Colors.white,
                          ),
                        )
                      : Text(
                          profile == null
                              ? 'LINK GITHUB'
                              : 'UPDATE GITHUB',
                          style: GoogleFonts
                              .pressStart2p(
                            fontSize:
                                10,
                          ),
                        ),
            ),
          ),

          if (profile != null) ...[
            const SizedBox(
              height: 10,
            ),
            Text(
              'Repos: ${profile.publicRepos ?? 0}   •   Followers: ${profile.followers ?? 0}',
              style:
                  GoogleFonts.jetBrainsMono(
                color:
                    Colors.white30,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLeetcodeCard(
    LeetcodeProfile? profile,
    bool loading,
  ) {
    return _card(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.terminal,
                color:
                    Color(0xffFF8BA7),
              ),

              const SizedBox(
                width: 9,
              ),

              Text(
                profile == null
                    ? 'LINK LEETCODE'
                    : 'CONNECTED',
                style:
                    GoogleFonts.pressStart2p(
                  color:
                      Colors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 14,
          ),

          TextField(
            controller:
                _leetcodeController,
            decoration:
                _inputDecoration(
              'LeetCode username',
            ),
            style:
                GoogleFonts.jetBrainsMono(
              color:
                  Colors.white,
              fontSize: 12,
            ),
            cursorColor:
                const Color(
              0xffFF8BA7,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          SizedBox(
            width:
                double.infinity,
            height: 46,
            child:
                ElevatedButton(
              onPressed:
                  _linkingLeetcode ||
                          loading
                      ? null
                      : _saveLeetcode,
              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    const Color(
                  0xffFF8BA7,
                ),
                foregroundColor:
                    const Color(
                  0xff121214,
                ),
                elevation: 0,
              ),
              child:
                  _linkingLeetcode
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child:
                              CircularProgressIndicator(
                            strokeWidth:
                                2,
                            color:
                                Color(
                              0xff121214,
                            ),
                          ),
                        )
                      : Text(
                          profile == null
                              ? 'LINK LEETCODE'
                              : 'UPDATE LEETCODE',
                          style: GoogleFonts
                              .pressStart2p(
                            fontSize:
                                10,
                          ),
                        ),
            ),
          ),

          if (profile != null) ...[
            const SizedBox(
              height: 10,
            ),
            Text(
              'Solved: ${profile.totalSolved ?? 0}   •   Rating: ${profile.contestRatings ?? 0}',
              style:
                  GoogleFonts.jetBrainsMono(
                color:
                    Colors.white30,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogoutCard() {
    return _card(
      child: ListTile(
        contentPadding:
            EdgeInsets.zero,
        leading:
            const Icon(
          Icons.logout,
          color:
              Color(0xffFF8BA7),
        ),
        title:
            Text(
          'LOGOUT',
          style:
              GoogleFonts.jetBrainsMono(
            color:
                Colors.white70,
            fontSize: 11,
          ),
        ),
        onTap: _logout,
      ),
    );
  }

  Future<void> _logout() async {
    await context
        .read<AuthProvider>()
        .logout();

    if (!mounted) return;

    Navigator.of(context).popUntil(
      (route) => route.isFirst,
    );
  }

  // bool _isTagUsed(int id) {
  //   final tasks =
  //       context.read<TaskProvider>().tasks;

  //   return tasks.any(
  //     (task) =>
  //         task.tagIds?.contains(id) ??
  //         false,
  //   );
  // }

  Widget _sectionTitle(
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 17,
        ),

        const SizedBox(
          width: 8,
        ),

        Text(
          title,
          style:
              GoogleFonts.jetBrainsMono(
            color:
                Colors.white,
            fontSize: 11,
            fontWeight:
                FontWeight.bold,
            letterSpacing:
                1.4,
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child:
              Container(
            height: 1,
            color:
                Colors.white10,
          ),
        ),
      ],
    );
  }

  Widget _card({
    required Widget child,
  }) {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        17,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(
          14,
        ),
        border:
            Border.all(
          color:
              Colors.white10,
        ),
      ),
      child: child,
    );
  }

  Widget _field(
    String label,
    String value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              GoogleFonts.jetBrainsMono(
            color:
                Colors.white24,
            fontSize: 9,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 5,
        ),

        Text(
          value,
          style:
              GoogleFonts.jetBrainsMono(
            color:
                Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          GoogleFonts.jetBrainsMono(
        color:
            Colors.white24,
        fontSize: 11,
      ),
      filled: true,
      fillColor:
          Colors.white.withOpacity(
        .05,
      ),
      contentPadding:
          const EdgeInsets
              .symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          9,
        ),
        borderSide:
            const BorderSide(
          color:
              Colors.white10,
        ),
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          9,
        ),
        borderSide:
            const BorderSide(
          color:
              Colors.white10,
        ),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          9,
        ),
        borderSide:
            const BorderSide(
          color:
              Color(0xffB388FF),
        ),
      ),
    );
  }

  void _showError(
    String message,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content:
            Text(
          message,
          style:
              GoogleFonts.jetBrainsMono(
            fontSize: 12,
          ),
        ),
        backgroundColor:
            const Color(
          0xff2A1A20,
        ),
      ),
    );
  }
}