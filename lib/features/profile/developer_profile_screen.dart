import 'dart:io';

import 'package:devtrack/features/auth/providers/auth_provider.dart';
import 'package:devtrack/shared/models/tag.dart';
import 'package:devtrack/shared/providers/github_provider.dart';
import 'package:devtrack/shared/providers/leetcode_provider.dart';
import 'package:devtrack/shared/providers/tag_provider.dart';
import 'package:devtrack/shared/providers/task_provider.dart';
import 'package:devtrack/shared/providers/user_provider.dart';
import 'package:devtrack/shared/storage/profile_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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

  final TextEditingController _tagController =
      TextEditingController();

  final ProfileStorage _profileStorage =
      ProfileStorage();

  final ImagePicker _imagePicker =
      ImagePicker();

  String? _profileImagePath;

  bool _editingDisplayName = false;
  bool _addingTag = false;
  bool _isSavingDisplayName = false;
  bool _isChangingPhoto = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _loadData();
    });
  }

  Future<void> _loadData() async {
    final authProvider =
        context.read<AuthProvider>();

    final userId = authProvider.userId;

    if (userId != null) {
      await context
          .read<UserProvider>()
          .getUser(userId);
    }

    await Future.wait([
      context.read<TagProvider>().getTags(),
      context.read<TaskProvider>().getTasks(),
      context.read<GithubProvider>().getProfiles(),
      context.read<LeetcodeProvider>().getProfiles(),
    ]);

    final savedPath =
        await _profileStorage.getImagePath();

    if (!mounted) return;

    final userProvider =
        context.read<UserProvider>();

    setState(() {
      _profileImagePath = savedPath;
      _displayNameController.text =
          userProvider.user?.displayName ??
          userProvider.user?.userName ??
          "";
    });
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _tagController.dispose();

    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    if (_isChangingPhoto) return;

    setState(() {
      _isChangingPhoto = true;
    });

    try {
      final image =
          await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null) {
        return;
      }

      final savedPath =
          await _profileStorage.saveImage(
        image.path,
      );

      if (!mounted) return;

      setState(() {
        _profileImagePath = savedPath;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isChangingPhoto = false;
        });
      }
    }
  }

  Future<void> _removeProfileImage() async {
    await _profileStorage.removeImage();

    if (!mounted) return;

    setState(() {
      _profileImagePath = null;
    });
  }

  Future<void> _showPhotoOptions() async {
    if (_isChangingPhoto) return;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor:
          const Color(0xff1A1A1E),

      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),

      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              20,
            ),

            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                Text(
                  "PROFILE PHOTO",
                  style:
                      GoogleFonts.pressStart2p(
                    color:
                        const Color(
                      0xffB388FF,
                    ),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                ListTile(
                  leading:
                      const Icon(
                    Icons.photo_library_outlined,
                    color:
                        Color(0xff6EE7A2),
                  ),
                  title:
                      Text(
                    "CHOOSE FROM GALLERY",
                    style: GoogleFonts
                        .jetBrainsMono(
                      color:
                          Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(
                      sheetContext,
                    );

                    _pickProfileImage();
                  },
                ),

                if (_profileImagePath !=
                    null)
                  ListTile(
                    leading:
                        const Icon(
                      Icons.delete_outline,
                      color:
                          Color(0xffFF8BA7),
                    ),
                    title:
                        Text(
                      "REMOVE PHOTO",
                      style:
                          GoogleFonts
                              .jetBrainsMono(
                        color:
                            Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(
                        sheetContext,
                      );

                      _removeProfileImage();
                    },
                  ),

                ListTile(
                  leading:
                      const Icon(
                    Icons.close,
                    color:
                        Colors.white38,
                  ),
                  title:
                      Text(
                    "CANCEL",
                    style: GoogleFonts
                        .jetBrainsMono(
                      color:
                          Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(
                      sheetContext,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveDisplayName() async {
    final value =
        _displayNameController.text.trim();

    if (value.isEmpty) {
      _showError(
        "Display name cannot be empty.",
      );
      return;
    }

    final authProvider =
        context.read<AuthProvider>();

    final userId =
        authProvider.userId;

    if (userId == null) {
      _showError(
        "User is not authenticated.",
      );
      return;
    }

    setState(() {
      _isSavingDisplayName = true;
    });

    final userProvider =
        context.read<UserProvider>();

    await userProvider.updateUser(
      userId,
      {
        "displayName": value,
      },
    );

    if (!mounted) return;

    setState(() {
      _isSavingDisplayName = false;
      _editingDisplayName = false;
    });

    if (userProvider.error != null) {
      _showError(
        userProvider.error!,
      );
    }
  }

  Future<void> _createTag() async {
    final name =
        _tagController.text.trim();

    if (name.isEmpty) {
      return;
    }

    final tagProvider =
        context.read<TagProvider>();

    await tagProvider.createTag(name);

    if (!mounted) return;

    if (tagProvider.error != null) {
      _showError(
        tagProvider.error!,
      );
      return;
    }

    _tagController.clear();

    setState(() {
      _addingTag = false;
    });
  }

  bool _isTagUsed(int tagId) {
    final tasks =
        context.read<TaskProvider>().tasks;

    return tasks.any(
      (task) =>
          task.tagIds?.contains(tagId) ??
          false,
    );
  }

  Future<void> _deleteTag(
    Tag tag,
  ) async {
    if (_isTagUsed(tag.id)) {
      _showError(
        "This tag is currently being used by a task.",
      );
      return;
    }

    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              const Color(0xff1A1A1E),

          title: Text(
            "DELETE TAG?",
            style:
                GoogleFonts.pressStart2p(
              color:
                  const Color(0xffFF8BA7),
              fontSize: 14,
            ),
          ),

          content: Text(
            '"${tag.name}" will be permanently removed.',
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
                "CANCEL",
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
                "DELETE",
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

    if (confirmed != true) {
      return;
    }

    final tagProvider =
        context.read<TagProvider>();

    await tagProvider.deleteTag(
      tag.id,
    );

    if (!mounted) return;

    if (tagProvider.error != null) {
      _showError(
        tagProvider.error!,
      );
    }
  }

  void _showError(String message) {
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

  @override
  Widget build(BuildContext context) {
    final userProvider =
        context.watch<UserProvider>();

    final tagProvider =
        context.watch<TagProvider>();

    final githubProvider =
        context.watch<GithubProvider>();

    final leetcodeProvider =
        context.watch<LeetcodeProvider>();

    final user =
        userProvider.user;

    final github =
        githubProvider.profiles.isNotEmpty
            ? githubProvider.profiles.first
            : null;

    final leetcode =
        leetcodeProvider
                .profiles.isNotEmpty
            ? leetcodeProvider
                .profiles.first
            : null;

    final displayName =
        user?.displayName ??
        user?.userName ??
        "USER";

    return Scaffold(
      backgroundColor:
          const Color(0xff121214),

      appBar: AppBar(
        backgroundColor:
            const Color(0xff121214),
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white70,
          ),
        ),

        title: Text(
          "DEVELOPER PROFILE",
          style:
              GoogleFonts.pressStart2p(
            color:
                const Color(0xffB388FF),
            fontSize: 15,
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
              _buildProfileHeader(
                displayName,
              ),

              const SizedBox(
                height: 24,
              ),

              _buildSectionTitle(
                "ACCOUNT",
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

              _buildSectionTitle(
                "MY TAGS",
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

              _buildSectionTitle(
                "CONNECTED ACCOUNTS",
                Icons.link,
                const Color(
                  0xff6EE7A2,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              _buildConnectedAccounts(
                github,
                leetcode,
              ),

              const SizedBox(
                height: 22,
              ),

              _buildSectionTitle(
                "ACCOUNT ACTIONS",
                Icons.settings_outlined,
                const Color(
                  0xffFF8BA7,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              _buildAccountActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    String displayName,
  ) {
    final hasImage =
        _profileImagePath != null &&
        File(
          _profileImagePath!,
        ).existsSync();

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap:
                _showPhotoOptions,

            child: Stack(
              alignment:
                  Alignment.bottomRight,

              children: [
                Container(
                  width: 120,
                  height: 120,

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xff1A1A1E,
                    ),

                    shape:
                        BoxShape.circle,

                    border:
                        Border.all(
                      color:
                          const Color(
                        0xffB388FF,
                      ).withOpacity(
                        .35,
                      ),
                      width: 2,
                    ),

                    image: hasImage
                        ? DecorationImage(
                            image:
                                FileImage(
                              File(
                                _profileImagePath!,
                              ),
                            ),
                            fit:
                                BoxFit.cover,
                          )
                        : null,
                  ),

                  child: hasImage
                      ? null
                      : const Icon(
                          Icons
                              .person_outline,
                          color:
                              Colors.white24,
                          size: 52,
                        ),
                ),

                Container(
                  width: 36,
                  height: 36,

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xffB388FF,
                    ),
                    shape:
                        BoxShape.circle,
                    border:
                        Border.all(
                      color:
                          const Color(
                        0xff121214,
                      ),
                      width: 3,
                    ),
                  ),

                  child:
                      const Icon(
                    Icons.camera_alt_outlined,
                    color:
                        Colors.white,
                    size: 17,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          Text(
            displayName.toUpperCase(),
            textAlign:
                TextAlign.center,
            style:
                GoogleFonts.pressStart2p(
              color:
                  Colors.white,
              fontSize: 17,
            ),
          ),

          const SizedBox(
            height: 7,
          ),

          Text(
            "> tap your profile picture to change it",
            textAlign:
                TextAlign.center,
            style:
                GoogleFonts.jetBrainsMono(
              color:
                  Colors.white24,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(
    dynamic user,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(17),

      decoration:
          BoxDecoration(
        color:
            const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(14),
        border:
            Border.all(
          color: Colors.white10,
        ),
      ),

      child: Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildField(
                  "DISPLAY NAME",
                  _displayNameController
                          .text
                          .isNotEmpty
                      ? _displayNameController
                          .text
                      : user?.displayName ??
                          user?.userName ??
                          "USER",
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              IconButton(
                onPressed:
                    _editingDisplayName
                        ? _saveDisplayName
                        : () {
                            setState(() {
                              _displayNameController
                                      .text =
                                  user
                                          ?.displayName ??
                                      user
                                          ?.userName ??
                                      "";

                              _editingDisplayName =
                                  true;
                            });
                          },
                icon: Icon(
                  _editingDisplayName
                      ? Icons.check
                      : Icons.edit_outlined,
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
              height: 12,
            ),

            TextField(
              controller:
                  _displayNameController,

              enabled:
                  !_isSavingDisplayName,

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
                "Display name",
              ),
            ),
          ],

          const Divider(
            color: Colors.white10,
            height: 28,
          ),

          _buildField(
            "USERNAME",
            user?.userName ??
                "UNKNOWN",
          ),

          const SizedBox(
            height: 17,
          ),

          _buildField(
            "EMAIL",
            user?.email ??
                "UNKNOWN",
          ),
        ],
      ),
    );
  }

  Widget _buildTagsCard(
    TagProvider tagProvider,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(17),

      decoration:
          BoxDecoration(
        color:
            const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(14),
        border:
            Border.all(
          color: Colors.white10,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          if (tagProvider
              .isLoading)
            const Center(
              child:
                  CircularProgressIndicator(
                color:
                    Color(0xffF3C86A),
                strokeWidth: 2,
              ),
            )
          else if (tagProvider
              .tags
              .isEmpty)
            Text(
              "> No tags yet.",
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
                  tagProvider.tags.map(
                (tag) {
                  final used =
                      _isTagUsed(
                    tag.id,
                  );

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
                              .circular(
                        8,
                      ),

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
                              ? Icons
                                  .lock_outline
                              : Icons
                                  .label_outline,
                          color: used
                              ? const Color(
                                  0xffF3C86A,
                                )
                              : Colors
                                  .white38,
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
                                  _deleteTag(
                                tag,
                              ),
                          child:
                              Icon(
                            Icons
                                .close,
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

                    style: GoogleFonts
                        .jetBrainsMono(
                      color:
                          Colors.white,
                      fontSize: 12,
                    ),

                    cursorColor:
                        const Color(
                      0xffF3C86A,
                    ),

                    onSubmitted:
                        (_) => _createTag(),

                    decoration:
                        _inputDecoration(
                      "New tag name",
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
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                          9,
                        ),
                      ),
                    ),

                    child:
                        const Icon(
                      Icons.check,
                      size: 18,
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
                  ).withOpacity(
                    .05,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    8,
                  ),

                  border:
                      Border.all(
                    color:
                        const Color(
                      0xffF3C86A,
                    ).withOpacity(
                      .3,
                    ),
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
                      "ADD TAG",
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
            height: 11,
          ),

          Text(
            "> locked tags are currently used by a task",
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

  Widget _buildConnectedAccounts(
    dynamic github,
    dynamic leetcode,
  ) {
    return Column(
      children: [
        _buildConnectionCard(
          icon: Icons.code,
          title: "GITHUB",
          value:
              github == null
                  ? "Not connected"
                  : "@${github.username}",
          color:
              const Color(0xffB388FF),
        ),

        const SizedBox(
          height: 10,
        ),

        _buildConnectionCard(
          icon: Icons.terminal,
          title: "LEETCODE",
          value:
              leetcode == null
                  ? "Not connected"
                  : leetcode.username,
          color:
              const Color(0xffFF8BA7),
        ),
      ],
    );
  }

  Widget _buildConnectionCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),

      decoration:
          BoxDecoration(
        color:
            const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(14),
        border:
            Border.all(
          color:
              color.withOpacity(.18),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration:
                BoxDecoration(
              color:
                  color.withOpacity(.08),
              borderRadius:
                  BorderRadius.circular(
                10,
              ),
            ),

            child: Icon(
              icon,
              color: color,
              size: 21,
            ),
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      GoogleFonts.jetBrainsMono(
                    color:
                        Colors.white54,
                    fontSize: 9,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  value,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      GoogleFonts.jetBrainsMono(
                    color:
                        Colors.white,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right,
            color: Colors.white24,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountActions() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(10),

      decoration:
          BoxDecoration(
        color:
            const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(14),
        border:
            Border.all(
          color: Colors.white10,
        ),
      ),

      child: Column(
        children: [
          ListTile(
            leading:
                const Icon(
              Icons.logout,
              color:
                  Color(0xffFF8BA7),
            ),

            title: Text(
              "LOGOUT",
              style:
                  GoogleFonts.jetBrainsMono(
                color:
                    Colors.white70,
                fontSize: 11,
              ),
            ),

            onTap:
                _logout,
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await context
        .read<AuthProvider>()
        .logout();

    if (!mounted) return;

    Navigator.of(context)
        .popUntil(
      (route) =>
          route.isFirst,
    );
  }

  Widget _buildField(
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
        color: Colors.white24,
        fontSize: 11,
      ),

      filled: true,

      fillColor:
          Colors.white.withOpacity(
        .05,
      ),

      contentPadding:
          const EdgeInsets.symmetric(
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
          color: Colors.white10,
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
          color: Colors.white10,
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
          color: Color(0xffB388FF),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
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
            letterSpacing: 1.4,
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child: Container(
            height: 1,
            color: Colors.white10,
          ),
        ),
      ],
    );
  }
}