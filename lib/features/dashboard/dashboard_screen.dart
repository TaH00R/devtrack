import 'package:devtrack/features/auth/providers/auth_provider.dart';
import 'package:devtrack/shared/providers/goal_provider.dart';
import 'package:devtrack/shared/providers/github_provider.dart';
import 'package:devtrack/shared/providers/leetcode_provider.dart';
import 'package:devtrack/shared/providers/project_provider.dart';
import 'package:devtrack/shared/providers/task_provider.dart';
import 'package:devtrack/shared/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  final List<String> _availableTechnologies = [
    "Flutter",
    "Dart",
    "Java",
    "Spring Boot",
    "PostgreSQL",
    "MySQL",
    "MongoDB",
    "React",
    "Next.js",
    "TypeScript",
    "JavaScript",
    "Node.js",
    "Express",
    "Python",
    "C++",
    "C",
    "Docker",
    "Redis",
    "Kafka",
    "Kubernetes",
    "Git",
    "GitHub",
    "Firebase",
    "Three.js",
    "Tailwind CSS",
    "FastAPI",
  ];

  final List<String> _techStack = [
    "Flutter",
    "Dart",
    "Java",
    "Spring Boot",
    "PostgreSQL",
  ];

  bool _addingTechnology = false;

  final TextEditingController _technologyController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final authProvider =
          context.read<AuthProvider>();

      context
          .read<GithubProvider>()
          .getProfiles();

      context
          .read<LeetcodeProvider>()
          .getProfiles();

      context
          .read<ProjectProvider>()
          .getProjects();

      context
          .read<GoalProvider>()
          .getGoals();

      context
          .read<TaskProvider>()
          .getTasks();

      final userId = authProvider.userId;

      if (userId != null) {
        context
            .read<UserProvider>()
            .getUser(userId);
      }
    });
  }

  @override
  void dispose() {
    _technologyController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final authProvider =
        context.read<AuthProvider>();

    await Future.wait([
      context
          .read<GithubProvider>()
          .getProfiles(),

      context
          .read<LeetcodeProvider>()
          .getProfiles(),

      context
          .read<ProjectProvider>()
          .getProjects(),

      context
          .read<GoalProvider>()
          .getGoals(),

      context
          .read<TaskProvider>()
          .getTasks(),

      if (authProvider.userId != null)
        context
            .read<UserProvider>()
            .getUser(authProvider.userId!),
    ]);
  }

  void _addTechnology() {
    final tech =
        _technologyController.text.trim();

    if (tech.isEmpty) {
      return;
    }

    if (!_techStack.contains(tech)) {
      setState(() {
        _techStack.add(tech);
        _technologyController.clear();
        _addingTechnology = false;
      });
    }
  }

  void _removeTechnology(String tech) {
    setState(() {
      _techStack.remove(tech);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider =
        context.watch<UserProvider>();

    final githubProvider =
        context.watch<GithubProvider>();

    final leetcodeProvider =
        context.watch<LeetcodeProvider>();

    final projectProvider =
        context.watch<ProjectProvider>();

    final goalProvider =
        context.watch<GoalProvider>();

    final taskProvider =
        context.watch<TaskProvider>();

    final user = userProvider.user;

    final github =
        githubProvider.profiles.isNotEmpty
            ? githubProvider.profiles.first
            : null;

    final leetcode =
        leetcodeProvider.profiles.isNotEmpty
            ? leetcodeProvider.profiles.first
            : null;

    final projects =
        projectProvider.projects;

    final goals =
        goalProvider.goals;

    final tasks =
        taskProvider.tasks;

    final completedTasks = tasks
        .where(
          (task) =>
              task.completed == true,
        )
        .length;

    final completedProjects =
        projects.isEmpty
            ? 0
            : projects.where((project) {
                final projectTasks = tasks
                    .where(
                      (task) =>
                          task.projectId ==
                          project.id,
                    )
                    .toList();

                return projectTasks.isNotEmpty &&
                    projectTasks.every(
                      (task) =>
                          task.completed ==
                          true,
                    );
              }).length;

    final completedGoals = goals
        .where(
          (goal) =>
              goal.completed == true,
        )
        .length;

    final activeGoals =
        goals.length - completedGoals;

    final activeProjects =
        projects.length - completedProjects;

    final username =
        user?.displayName ??
        user?.userName ??
        "USER";

    return Scaffold(
      backgroundColor:
          const Color(0xff121214),

      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xffB388FF),
          backgroundColor:
              const Color(0xff1A1A1E),

          onRefresh: _refresh,

          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(),

            padding:
                const EdgeInsets.fromLTRB(
              22,
              18,
              22,
              40,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                _buildHeader(
                  username,
                ),

                const SizedBox(height: 24),

                _buildProfileSection(
                  user?.email,
                  user?.displayName,
                ),

                const SizedBox(height: 22),

                _buildSectionTitle(
                  "GITHUB",
                  Icons.code,
                  const Color(
                    0xffB388FF,
                  ),
                ),

                const SizedBox(height: 10),

                _buildGithubCard(
                  github,
                  githubProvider.isLoading,
                ),

                const SizedBox(height: 22),

                _buildSectionTitle(
                  "LEETCODE",
                  Icons.terminal,
                  const Color(
                    0xffFF8BA7,
                  ),
                ),

                const SizedBox(height: 10),

                _buildLeetcodeCard(
                  leetcode,
                  leetcodeProvider.isLoading,
                ),

                const SizedBox(height: 22),

                _buildSectionTitle(
                  "PROJECTS",
                  Icons.folder_outlined,
                  const Color(
                    0xff6EE7A2,
                  ),
                ),

                const SizedBox(height: 10),

                _buildProjectsCard(
                  projects.length,
                  completedProjects,
                  activeProjects,
                ),

                const SizedBox(height: 22),

                _buildSectionTitle(
                  "GOALS",
                  Icons.flag_outlined,
                  const Color(
                    0xffF3C86A,
                  ),
                ),

                const SizedBox(height: 10),

                _buildGoalsCard(
                  goals.length,
                  completedGoals,
                  activeGoals,
                ),

                const SizedBox(height: 22),

                _buildSectionTitle(
                  "ACTIVITY",
                  Icons.bolt,
                  const Color(
                    0xff64D8FF,
                  ),
                ),

                const SizedBox(height: 10),

                _buildActivityCard(
                  tasks.length,
                  completedTasks,
                ),

                const SizedBox(height: 22),

                _buildSectionTitle(
                  "TECH STACK",
                  Icons.memory,
                  const Color(
                    0xff64D8FF,
                  ),
                ),

                const SizedBox(height: 10),

                _buildTechStackCard(),

                const SizedBox(height: 28),

                Center(
                  child: Text(
                    "> keep building.",
                    style:
                        GoogleFonts.jetBrainsMono(
                      color: Colors.white24,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    String username,
  ) {
    final hour =
        DateTime.now().hour;

    String greeting;

    if (hour < 12) {
      greeting = "Good morning,";
    } else if (hour < 17) {
      greeting = "Good afternoon,";
    } else {
      greeting = "Good evening,";
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style:
              GoogleFonts.jersey10(
            color: Colors.white70,
            fontSize: 24,
          ),
        ),

        const SizedBox(height: 4),

        Row(
          children: [
            Expanded(
              child: Text(
                username,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style:
                    GoogleFonts.pressStart2p(
                  color:
                      const Color(
                    0xffB388FF,
                  ),
                  fontSize: 22,
                ),
              ),
            ),

            const SizedBox(width: 10),

            const Icon(
              Icons.waving_hand_outlined,
              color:
                  Color(0xffF3C86A),
              size: 27,
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            Text(
              ">",
              style:
                  GoogleFonts.jetBrainsMono(
                color:
                    const Color(
                  0xff6EE7A2,
                ),
                fontSize: 17,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(width: 7),

            Text(
              "one commit at a time.",
              style:
                  GoogleFonts.jetBrainsMono(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileSection(
    String? email,
    String? displayName,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color:
            const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(16),
        border:
            Border.all(
          color: Colors.white10,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,

            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xffB388FF,
              ).withOpacity(.10),

              borderRadius:
                  BorderRadius.circular(
                14,
              ),

              border:
                  Border.all(
                color:
                    const Color(
                  0xffB388FF,
                ).withOpacity(.25),
              ),
            ),

            child: const Icon(
              Icons.person_outline,
              color:
                  Color(0xffB388FF),
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
                      "No Display Name",
                  style:
                      GoogleFonts.jetBrainsMono(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                if (email != null &&
                    email.isNotEmpty) ...[
                  const SizedBox(height: 7),

                  Text(
                    email,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        GoogleFonts.jetBrainsMono(
                      color:
                          Colors.white38,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGithubCard(
    dynamic github,
    bool loading,
  ) {
    if (loading && github == null) {
      return _buildLoadingCard();
    }

    if (github == null) {
      return _buildEmptyCard(
        icon: Icons.code,
        title:
            "NO GITHUB PROFILE",
        subtitle:
            "Connect your GitHub profile to track your stats.",
      );
    }

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color:
            const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(16),
        border:
            Border.all(
          color:
              const Color(
            0xffB388FF,
          ).withOpacity(.2),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xffB388FF,
                  ).withOpacity(.10),
                  borderRadius:
                      BorderRadius.circular(
                    11,
                  ),
                ),

                child: const Icon(
                  Icons.code,
                  color:
                      Color(0xffB388FF),
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
                      "@${github.username}",
                      style:
                          GoogleFonts.pressStart2p(
                        color:
                            Colors.white,
                        fontSize: 11,
                      ),
                    ),

                    if (github.profileUrl !=
                        null) ...[
                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        github.profileUrl!,
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            GoogleFonts.jetBrainsMono(
                          color:
                              Colors.white24,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildStat(
                  "PUBLIC REPOS",
                  "${github.publicRepos ?? 0}",
                  const Color(
                    0xffB388FF,
                  ),
                ),
              ),

              _verticalDivider(),

              Expanded(
                child: _buildStat(
                  "FOLLOWERS",
                  "${github.followers ?? 0}",
                  const Color(
                    0xff64D8FF,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeetcodeCard(
    dynamic leetcode,
    bool loading,
  ) {
    if (loading && leetcode == null) {
      return _buildLoadingCard();
    }

    if (leetcode == null) {
      return _buildEmptyCard(
        icon: Icons.terminal,
        title:
            "NO LEETCODE PROFILE",
        subtitle:
            "Connect your LeetCode profile to track your progress.",
      );
    }

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color:
            const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(16),
        border:
            Border.all(
          color:
              const Color(
            0xffFF8BA7,
          ).withOpacity(.2),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xffFF8BA7,
                  ).withOpacity(.10),
                  borderRadius:
                      BorderRadius.circular(
                    11,
                  ),
                ),

                child: const Icon(
                  Icons.terminal,
                  color:
                      Color(0xffFF8BA7),
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Text(
                leetcode.username,
                style:
                    GoogleFonts.pressStart2p(
                  color:
                      Colors.white,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _buildStat(
            "TOTAL SOLVED",
            "${leetcode.totalSolved ?? 0}",
            const Color(0xffFF8BA7),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _buildStat(
                  "EASY",
                  "${leetcode.easySolved ?? 0}",
                  const Color(
                    0xff6EE7A2,
                  ),
                ),
              ),

              _verticalDivider(),

              Expanded(
                child: _buildStat(
                  "MEDIUM",
                  "${leetcode.mediumSolved ?? 0}",
                  const Color(
                    0xffF3C86A,
                  ),
                ),
              ),

              _verticalDivider(),

              Expanded(
                child: _buildStat(
                  "HARD",
                  "${leetcode.hardSolved ?? 0}",
                  const Color(
                    0xffFF6B6B,
                  ),
                ),
              ),
            ],
          ),

          if (leetcode.contestRatings !=
              null) ...[
            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(
                13,
              ),

              decoration:
                  BoxDecoration(
                color:
                    Colors.white
                        .withOpacity(.03),

                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),

              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events_outlined,
                    color:
                        Color(0xffF3C86A),
                    size: 19,
                  ),

                  const SizedBox(
                    width: 9,
                  ),

                  Text(
                    "CONTEST RATING",
                    style:
                        GoogleFonts.jetBrainsMono(
                      color:
                          Colors.white38,
                      fontSize: 10,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    "${leetcode.contestRatings}",
                    style:
                        GoogleFonts.jetBrainsMono(
                      color:
                          Colors.white,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProjectsCard(
    int total,
    int completed,
    int active,
  ) {
    final progress =
        total == 0
            ? 0.0
            : completed / total;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color:
            const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(16),
        border:
            Border.all(
          color:
              const Color(
            0xff6EE7A2,
          ).withOpacity(.2),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              _bigNumber(
                "$total",
                "TOTAL",
                const Color(
                  0xff6EE7A2,
                ),
              ),

              _verticalDivider(),

              _bigNumber(
                "$completed",
                "DONE",
                const Color(
                  0xffB388FF,
                ),
              ),

              _verticalDivider(),

              _bigNumber(
                "$active",
                "ACTIVE",
                const Color(
                  0xffF3C86A,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            "PROJECT COMPLETION",
            style:
                GoogleFonts.jetBrainsMono(
              color:
                  Colors.white38,
              fontSize: 10,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 9),

          _buildProgressBar(
            progress,
            const Color(
              0xff6EE7A2,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "${(progress * 100).round()}% of projects completed",
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

  Widget _buildGoalsCard(
    int total,
    int completed,
    int active,
  ) {
    final progress =
        total == 0
            ? 0.0
            : completed / total;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color:
            const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(16),
        border:
            Border.all(
          color:
              const Color(
            0xffF3C86A,
          ).withOpacity(.2),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              _bigNumber(
                "$total",
                "TOTAL",
                const Color(
                  0xffF3C86A,
                ),
              ),

              _verticalDivider(),

              _bigNumber(
                "$completed",
                "DONE",
                const Color(
                  0xff6EE7A2,
                ),
              ),

              _verticalDivider(),

              _bigNumber(
                "$active",
                "ACTIVE",
                const Color(
                  0xffFF8BA7,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            "GOAL COMPLETION",
            style:
                GoogleFonts.jetBrainsMono(
              color:
                  Colors.white38,
              fontSize: 10,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 9),

          _buildProgressBar(
            progress,
            const Color(
              0xffF3C86A,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "${(progress * 100).round()}% of goals completed",
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

  Widget _buildActivityCard(
    int totalTasks,
    int completedTasks,
  ) {
    final progress =
        totalTasks == 0
            ? 0.0
            : completedTasks /
                totalTasks;

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color:
            const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(16),
        border:
            Border.all(
          color:
              const Color(
            0xff64D8FF,
          ).withOpacity(.2),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              const Icon(
                Icons.checklist_outlined,
                color:
                    Color(0xff64D8FF),
                size: 25,
              ),

              const SizedBox(
                width: 12,
              ),

              Text(
                "TASKS",
                style:
                    GoogleFonts.pressStart2p(
                  color:
                      Colors.white,
                  fontSize: 11,
                ),
              ),

              const Spacer(),

              Text(
                "$completedTasks / $totalTasks",
                style:
                    GoogleFonts.jetBrainsMono(
                  color:
                      const Color(
                    0xff64D8FF,
                  ),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _buildProgressBar(
            progress,
            const Color(
              0xff64D8FF,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            totalTasks == 0
                ? "No tasks yet."
                : "${(progress * 100).round()}% completed",
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

  Widget _buildTechStackCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color:
            const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(16),
        border:
            Border.all(
          color:
              const Color(
            0xff64D8FF,
          ).withOpacity(.2),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,

            children:
                _techStack.map(
              (tech) {
                return Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 11,
                    vertical: 8,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xff64D8FF,
                    ).withOpacity(.07),

                    borderRadius:
                        BorderRadius.circular(
                      8,
                    ),

                    border:
                        Border.all(
                      color:
                          const Color(
                        0xff64D8FF,
                      ).withOpacity(.20),
                    ),
                  ),

                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min,

                    children: [
                      Text(
                        tech,
                        style:
                            GoogleFonts
                                .jetBrainsMono(
                          color:
                              Colors.white70,
                          fontSize: 10,
                        ),
                      ),

                      const SizedBox(
                        width: 6,
                      ),

                      GestureDetector(
                        onTap: () {
                          _removeTechnology(
                            tech,
                          );
                        },

                        child:
                            const Icon(
                          Icons.close,
                          size: 13,
                          color:
                              Colors.white24,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),

          const SizedBox(height: 14),

          GestureDetector(
            onTap: () {
              setState(() {
                _addingTechnology =
                    !_addingTechnology;
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
                  0xffB388FF,
                ).withOpacity(.05),

                borderRadius:
                    BorderRadius.circular(
                  8,
                ),

                border:
                    Border.all(
                  color:
                      const Color(
                    0xffB388FF,
                  ).withOpacity(.30),
                ),
              ),

              child: Row(
                mainAxisSize:
                    MainAxisSize.min,

                children: [
                  Icon(
                    _addingTechnology
                        ? Icons.close
                        : Icons.add,

                    color:
                        const Color(
                      0xffB388FF,
                    ),

                    size: 15,
                  ),

                  const SizedBox(
                    width: 6,
                  ),

                  Text(
                    _addingTechnology
                        ? "CANCEL"
                        : "ADD TECHNOLOGY",

                    style:
                        GoogleFonts
                            .jetBrainsMono(
                      color:
                          const Color(
                        0xffB388FF,
                      ),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_addingTechnology) ...[
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Autocomplete<String>(
                    optionsBuilder:
                        (textEditingValue) {
                      final query =
                          textEditingValue
                              .text
                              .toLowerCase();

                      if (query.isEmpty) {
                        return _availableTechnologies
                            .where(
                          (tech) =>
                              !_techStack
                                  .contains(
                                tech,
                              ),
                        );
                      }

                      return _availableTechnologies
                          .where(
                        (tech) =>
                            !_techStack
                                .contains(
                              tech,
                            ) &&
                            tech
                                .toLowerCase()
                                .contains(
                              query,
                            ),
                      );
                    },

                    onSelected: (value) {
                      if (!_techStack
                          .contains(value)) {
                        setState(() {
                          _techStack.add(value);
                          _addingTechnology =
                              false;
                        });
                      }
                    },

                    fieldViewBuilder:
                        (
                      context,
                      controller,
                      focusNode,
                      onFieldSubmitted,
                    ) {
                      _technologyController
                        .value =
                          controller.value;

                      return TextField(
                        controller:
                            controller,
                        focusNode:
                            focusNode,

                        style:
                            GoogleFonts
                                .jetBrainsMono(
                          color:
                              Colors.white,
                          fontSize: 12,
                        ),

                        cursorColor:
                            const Color(
                          0xffB388FF,
                        ),

                        decoration:
                            InputDecoration(
                          hintText:
                              "Search technology...",

                          hintStyle:
                              GoogleFonts
                                  .jetBrainsMono(
                            color:
                                Colors.white24,
                            fontSize: 11,
                          ),

                          filled: true,

                          fillColor:
                              Colors.white
                                  .withOpacity(
                            .05,
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

                          focusedBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              9,
                            ),
                            borderSide:
                                const BorderSide(
                              color:
                                  Color(
                                0xffB388FF,
                              ),
                            ),
                          ),
                        ),
                      );
                    },

                    optionsViewBuilder:
                        (
                      context,
                      onSelected,
                      options,
                    ) {
                      return Align(
                        alignment:
                            Alignment.topLeft,

                        child: Material(
                          color:
                              const Color(
                            0xff1A1A1E,
                          ),

                          elevation: 8,

                          borderRadius:
                              BorderRadius
                                  .circular(
                            10,
                          ),

                          child: ConstrainedBox(
                            constraints:
                                const BoxConstraints(
                              maxHeight: 190,
                            ),

                            child: ListView.builder(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                vertical: 6,
                              ),

                              itemCount:
                                  options.length,

                              itemBuilder:
                                  (context, index) {
                                final option =
                                    options.elementAt(
                                  index,
                                );

                                return ListTile(
                                  dense: true,

                                  title: Text(
                                    option,
                                    style:
                                        GoogleFonts
                                            .jetBrainsMono(
                                      color:
                                          Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),

                                  onTap: () {
                                    onSelected(
                                      option,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 8),

                SizedBox(
                  height: 48,

                  child:
                      ElevatedButton(
                    onPressed:
                        _addTechnology,

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
                      Icons.add,
                      size: 18,
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

        const SizedBox(width: 8),

        Text(
          title,
          style:
              GoogleFonts.jetBrainsMono(
            color: Colors.white,
            fontSize: 12,
            fontWeight:
                FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Container(
            height: 1,
            color: Colors.white10,
          ),
        ),
      ],
    );
  }

  Widget _buildStat(
    String label,
    String value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style:
              GoogleFonts.pressStart2p(
            color: color,
            fontSize: 17,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          label,
          style:
              GoogleFonts.jetBrainsMono(
            color: Colors.white30,
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _bigNumber(
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style:
                GoogleFonts.pressStart2p(
              color: color,
              fontSize: 17,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            label,
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

  Widget _verticalDivider() {
    return Container(
      height: 35,
      width: 1,
      margin:
          const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      color: Colors.white10,
    );
  }

  Widget _buildProgressBar(
    double progress,
    Color color,
  ) {
    return Row(
      children: List.generate(
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
                    ? color
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
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      width: double.infinity,
      height: 130,

      decoration:
          BoxDecoration(
        color:
            const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(16),
        border:
            Border.all(
          color: Colors.white10,
        ),
      ),

      child: const Center(
        child:
            CircularProgressIndicator(
          color:
              Color(0xffB388FF),
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildEmptyCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color:
            const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(16),
        border:
            Border.all(
          color: Colors.white10,
        ),
      ),

      child: Row(
        children: [
          const SizedBox(width: 4),

          Icon(
            icon,
            color:
                Colors.white24,
            size: 30,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      GoogleFonts.pressStart2p(
                    color:
                        Colors.white54,
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  subtitle,
                  style:
                      GoogleFonts.jetBrainsMono(
                    color:
                        Colors.white24,
                    fontSize: 10,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}