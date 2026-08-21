import 'package:devtrack/features/projects/widgets/project_details_text_field.dart';
import 'package:devtrack/features/projects/widgets/project_progress_section.dart';
import 'package:devtrack/features/projects/widgets/project_section_label.dart';
import 'package:devtrack/features/projects/widgets/project_task_list.dart';
import 'package:devtrack/shared/models/project_request.dart';
import 'package:devtrack/shared/models/project_response.dart';
import 'package:devtrack/shared/providers/project_provider.dart';
import 'package:devtrack/shared/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final ProjectResponse project;

  const ProjectDetailsScreen({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDetailsScreen> createState() =>
      _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState
    extends State<ProjectDetailsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _githubController;

  bool _editing = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.project.name,
    );

    _descriptionController = TextEditingController(
      text: widget.project.description,
    );

    _githubController = TextEditingController(
      text: widget.project.githubUrl ?? "",
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().getTasks();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _githubController.dispose();

    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty) {
      _showError("Name and description are required.");
      return;
    }

    final projectProvider =
        context.read<ProjectProvider>();

    final request = ProjectRequest(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      githubUrl: _githubController.text.trim().isEmpty
          ? null
          : _githubController.text.trim(),
      userId: widget.project.userId,
    );

    await projectProvider.updateProject(
      widget.project.id,
      request,
    );

    if (!mounted) return;

    if (projectProvider.error != null) {
      _showError(projectProvider.error!);
      return;
    }

    setState(() {
      _editing = false;
    });
  }

  Future<void> _deleteProject() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff1A1A1E),

          title: Text(
            "DELETE PROJECT?",
            style: GoogleFonts.pressStart2p(
              color: const Color(0xffFF8BA7),
              fontSize: 14,
            ),
          ),

          content: Text(
            "This action cannot be undone.",
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: Text(
                "CANCEL",
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white54,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              child: Text(
                "DELETE",
                style: GoogleFonts.jetBrainsMono(
                  color: const Color(0xffFF8BA7),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final projectProvider =
        context.read<ProjectProvider>();

    await projectProvider.deleteProject(
      widget.project.id,
    );

    if (!mounted) return;

    if (projectProvider.error != null) {
      _showError(projectProvider.error!);
      return;
    }

    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
          ),
        ),

        backgroundColor: const Color(0xff2A1A20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider =
        context.watch<TaskProvider>();

    final tasks = taskProvider.tasks
        .where(
          (task) => task.projectId == widget.project.id,
        )
        .toList();

    final completedTasks = tasks
        .where(
          (task) => task.completed == true,
        )
        .length;

    final progress = tasks.isEmpty
        ? 0.0
        : completedTasks / tasks.length;

    final percentage = (progress * 100).round();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff121214),

        appBar: AppBar(
          backgroundColor: const Color(0xff121214),
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
            "PROJECT",
            style: GoogleFonts.pressStart2p(
              color: const Color(0xff6EE7A2),
              fontSize: 17,
            ),
          ),

          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _editing = !_editing;
                });
              },

              icon: Icon(
                _editing
                    ? Icons.close
                    : Icons.edit_outlined,

                color: const Color(0xffB388FF),
              ),
            ),
          ],
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              _buildProjectHeader(),

              const SizedBox(height: 22),

              const ProjectSectionLabel(
                text: "DESCRIPTION",
              ),

              const SizedBox(height: 10),

              _editing
                  ? ProjectDetailsTextField(
                      controller:
                          _descriptionController,
                      hint: "Description",
                      maxLines: 5,
                    )
                  : Text(
                      widget.project.description,
                      style: GoogleFonts.jetBrainsMono(
                        color: Colors.white54,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),

              const SizedBox(height: 26),

              const ProjectSectionLabel(
                text: "GITHUB",
              ),

              const SizedBox(height: 10),

              _editing
                  ? ProjectDetailsTextField(
                      controller: _githubController,
                      hint: "https://github.com/...",
                    )
                  : _buildGithubDisplay(),

              if (_editing) ...[
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(
                    onPressed: _saveChanges,

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xff6EE7A2),

                      foregroundColor:
                          const Color(0xff121214),

                      elevation: 0,
                    ),

                    child: Text(
                      "SAVE CHANGES",
                      style:
                          GoogleFonts.pressStart2p(
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 30),

              const ProjectSectionLabel(
                text: "PROGRESS",
              ),

              const SizedBox(height: 12),

              ProjectProgressSection(
                completedTasks: completedTasks,
                totalTasks: tasks.length,
                progress: progress,
                percentage: percentage,
              ),

              const SizedBox(height: 30),

              const ProjectSectionLabel(
                text: "TASKS",
              ),

              const SizedBox(height: 12),

              ProjectTaskList(
                tasks: tasks,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: OutlinedButton.icon(
                  onPressed: _deleteProject,

                  icon: const Icon(
                    Icons.delete_outline,
                    size: 19,
                  ),

                  label: Text(
                    "DELETE PROJECT",
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                    ),
                  ),

                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        const Color(0xffFF8BA7),

                    side: const BorderSide(
                      color: Color(0xffFF8BA7),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  "> keep building.",
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.white24,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectHeader() {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Hero(
          tag:
              'project-icon-${widget.project.id}',

          child: Material(
            color: Colors.transparent,

            child: Container(
              width: 72,
              height: 72,

              decoration: BoxDecoration(
                color: const Color(0xff6EE7A2)
                    .withOpacity(0.08),

                borderRadius:
                    BorderRadius.circular(16),

                border: Border.all(
                  color: const Color(0xff6EE7A2)
                      .withOpacity(0.2),
                ),
              ),

              child: const Icon(
                Icons.folder_outlined,
                color: Color(0xff6EE7A2),
                size: 38,
              ),
            ),
          ),
        ),

        const SizedBox(width: 18),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),

            child: _editing
                ? ProjectDetailsTextField(
                    controller: _nameController,
                    hint: "Project name",
                  )
                : Hero(
                    tag:
                        'project-name-${widget.project.id}',

                    child: Material(
                      color: Colors.transparent,

                      child: Text(
                        widget.project.name,

                        style:
                            GoogleFonts.pressStart2p(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildGithubDisplay() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),

        borderRadius:
            BorderRadius.circular(10),

        border: Border.all(
          color: Colors.white10,
        ),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.code,
            color: Color(0xffB388FF),
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              widget.project.githubUrl ??
                  "No GitHub repository",

              maxLines: 1,

              overflow: TextOverflow.ellipsis,

              style: GoogleFonts.jetBrainsMono(
                color:
                    widget.project.githubUrl != null
                        ? Colors.white70
                        : Colors.white24,

                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}