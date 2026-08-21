import 'package:devtrack/features/auth/providers/auth_provider.dart';
import 'package:devtrack/features/profile/widgets/account_card.dart';
import 'package:devtrack/features/profile/widgets/github_card.dart';
import 'package:devtrack/features/profile/widgets/leetcode_card.dart';
import 'package:devtrack/features/profile/widgets/logout_card.dart';
import 'package:devtrack/features/profile/widgets/profile_header.dart';
import 'package:devtrack/features/profile/widgets/profile_section_title.dart';
import 'package:devtrack/features/profile/widgets/tags_card.dart';
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

    final authProvider = context.read<AuthProvider>();
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

    final user = context.read<UserProvider>().user;

    final githubProfiles =
        context.read<GithubProvider>().profiles;

    final leetcodeProfiles =
        context.read<LeetcodeProvider>().profiles;

    _displayNameController.text =
        user?.displayName ??
        user?.userName ??
        '';

    if (githubProfiles.isNotEmpty) {
      _githubController.text =
          githubProfiles.first.username;
    }

    if (leetcodeProfiles.isNotEmpty) {
      _leetcodeController.text =
          leetcodeProfiles.first.username;
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

  // DISPLAY NAME
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
      _showError(
        provider.error!,
      );
      return;
    }

    setState(() {
      _editingDisplayName = false;
    });
  }

  // TAGS
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
      _showError(
        provider.error!,
      );
      return;
    }

    _tagController.clear();

    setState(() {
      _addingTag = false;
    });
  }

  Future<void> _deleteTag(
    Tag tag,
  ) async {
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

    await provider.deleteTag(
      tag.id,
    );

    if (!mounted) return;

    if (provider.error != null) {
      _showError(
        provider.error!,
      );
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

  // GITHUB
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
          avatarUrl:
              existing.avatarUrl,
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
      _showError(
        provider.error!,
      );
    }
  }

  // LEETCODE
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
      _showError(
        provider.error!,
      );
    }
  }

  // LOGOUT
  Future<void> _logout() async {
    await context
        .read<AuthProvider>()
        .logout();

    if (!mounted) return;

    Navigator.of(context).popUntil(
      (route) => route.isFirst,
    );
  }

  // BUILD
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

    final githubProfile =
        githubProvider.profiles.isNotEmpty
            ? githubProvider.profiles.first
            : null;

    final leetcodeProfile =
        leetcodeProvider.profiles.isNotEmpty
            ? leetcodeProvider.profiles.first
            : null;

    final github =
        githubProvider.liveData;

    final leetcode =
        leetcodeProvider.liveData;

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
            color: Colors.white70,
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
              ProfileHeader(
                name:
                    user?.displayName ??
                    user?.userName ??
                    'USER',
              ),

              const SizedBox(height: 25),

              const ProfileSectionTitle(
                title: 'ACCOUNT',
                icon: Icons.person_outline,
                color: Color(0xffB388FF),
              ),

              const SizedBox(height: 10),

              AccountCard(
                user: user,
                editingDisplayName:
                    _editingDisplayName,
                savingDisplayName:
                    _savingDisplayName,
                controller:
                    _displayNameController,
                onEdit: () {
                  setState(() {
                    _displayNameController.text =
                        user?.displayName ??
                        user?.userName ??
                        '';

                    _editingDisplayName =
                        true;
                  });
                },
                onSave:
                    _saveDisplayName,
              ),

              const SizedBox(height: 22),

              const ProfileSectionTitle(
                title: 'MY TAGS',
                icon: Icons.label_outline,
                color: Color(0xffF3C86A),
              ),

              const SizedBox(height: 10),

              TagsCard(
                provider: tagProvider,
                controller: _tagController,
                addingTag: _addingTag,
                isTagUsed: _isTagUsed,
                onDeleteTag: _deleteTag,
                onCreateTag: _createTag,
                onStartAdding: () {
                  setState(() {
                    _addingTag = true;
                  });
                },
              ),

              const SizedBox(height: 22),

              const ProfileSectionTitle(
                title: 'GITHUB',
                icon: Icons.code,
                color: Color(0xffB388FF),
              ),

              const SizedBox(height: 10),

              GithubCard(
                profile: githubProfile,
                liveData: github,
                loading:
                    githubProvider.isLiveLoading,
                linking: _linkingGithub,
                controller:
                    _githubController,
                onSave: _saveGithub,
              ),

              const SizedBox(height: 22),

              const ProfileSectionTitle(
                title: 'LEETCODE',
                icon: Icons.terminal,
                color: Color(0xffFF8BA7),
              ),

              const SizedBox(height: 10),

              LeetcodeCard(
                profile: leetcodeProfile,
                liveData: leetcode,
                loading:
                    leetcodeProvider.isLiveLoading,
                linking: _linkingLeetcode,
                controller:
                    _leetcodeController,
                onSave: _saveLeetcode,
              ),

              const SizedBox(height: 22),

              const ProfileSectionTitle(
                title: 'ACCOUNT ACTIONS',
                icon: Icons.settings_outlined,
                color: Color(0xffFF8BA7),
              ),

              const SizedBox(height: 10),

              LogoutCard(
                onLogout: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              GoogleFonts.jetBrainsMono(
            fontSize: 12,
          ),
        ),
        backgroundColor:
            const Color(0xff2A1A20),
      ),
    );
  }
}