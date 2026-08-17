import 'package:devtrack/features/projects/add_project_screen.dart';
import 'package:devtrack/shared/models/task_request.dart';
import 'package:devtrack/shared/providers/project_provider.dart';
import 'package:devtrack/shared/providers/tag_provider.dart';
import 'package:devtrack/shared/providers/task_provider.dart';
import 'package:devtrack/shared/routes/smooth_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _descriptionController =
      TextEditingController();

  int? _selectedProjectId;

  final Set<int> _selectedTagIds = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<ProjectProvider>().getProjects();
      context.read<TagProvider>().getTags();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedProjectId == null) {
      _showError("Please select a project.");
      return;
    }

    final taskProvider = context.read<TaskProvider>();

    final request = TaskRequest(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      completed: false,
      projectId: _selectedProjectId!,
      tagIds: _selectedTagIds,
    );

    await taskProvider.createTask(request);

    if (!mounted) return;

    if (taskProvider.error != null) {
      _showError(taskProvider.error!);
      return;
    }

  }

  Future<void> _createProject() async {
    await Navigator.push(
      context,
      smoothRoute(
        const AddProjectScreen(),
      ),
    );

    if (!mounted) return;

    final projectProvider =
        context.read<ProjectProvider>();

    await projectProvider.getProjects();

    if (!mounted) return;

    final projects = projectProvider.projects;

    if (projects.isNotEmpty) {
      setState(() {
        _selectedProjectId = projects.last.id;
      });
    }
  }

Future<void> _createTagDialog() async {
  final tagName = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return const _CreateTagDialog();
    },
  );

  if (!mounted || tagName == null) {
    return;
  }

  final name = tagName.trim();

  if (name.isEmpty) {
    return;
  }

  final tagProvider = context.read<TagProvider>();

  await tagProvider.createTag(name);

  if (!mounted) {
    return;
  }

  if (tagProvider.error != null) {
    _showError(tagProvider.error!);
    return;
  }

  if (tagProvider.tags.isNotEmpty) {
    final newTag = tagProvider.tags.last;

    setState(() {
      _selectedTagIds.add(newTag.id);
    });
  }
}
  
  void _toggleTag(int tagId) {
    setState(() {
      if (_selectedTagIds.contains(tagId)) {
        _selectedTagIds.remove(tagId);
      } else {
        _selectedTagIds.add(tagId);
      }
    });
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
        backgroundColor:
            const Color(0xff2A1A20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider =
        context.watch<ProjectProvider>();

    final projects =
        projectProvider.projects;

    return SafeArea(
      child: Scaffold(
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
            "ADD TASK",
            style: GoogleFonts.pressStart2p(
              color:
                  const Color(0xffFF8BA7),
              fontSize: 17,
            ),
          ),
        ),

        body: projectProvider.isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(
                  color:
                      Color(0xffFF8BA7),
                  strokeWidth: 2,
                ),
              )
            : projects.isEmpty
                ? _buildNoProjectsBody()
                : _buildTaskForm(),
      ),
    );
  }

  Widget _buildNoProjectsBody() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 30,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.folder_off_outlined,
              color:
                  Color(0xffF3C86A),
              size: 60,
            ),

            const SizedBox(height: 22),

            Text(
              "> NO PROJECTS FOUND",
              textAlign:
                  TextAlign.center,
              style:
                  GoogleFonts.pressStart2p(
                color: Colors.white,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              "Tasks need to belong to a project.\n"
              "Create a project first.",
              textAlign:
                  TextAlign.center,
              style:
                  GoogleFonts.jetBrainsMono(
                color: Colors.white38,
                fontSize: 12,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton.icon(
                onPressed:
                    _createProject,

                icon: const Icon(
                  Icons.add,
                ),

                label: Text(
                  "CREATE PROJECT",
                  style:
                      GoogleFonts.pressStart2p(
                    fontSize: 11,
                  ),
                ),

                style:
                    ElevatedButton.styleFrom(
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
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskForm() {
    final tagProvider =
        context.watch<TagProvider>();

    final taskProvider =
        context.watch<TaskProvider>();

    final projects =
        context.read<ProjectProvider>().projects;

    final tags = tagProvider.tags;

    return SingleChildScrollView(
      padding:
          const EdgeInsets.fromLTRB(
        22,
        18,
        22,
        30,
      ),

      child: Form(
        key: _formKey,

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Text(
              "> Create a new task.",
              style:
                  GoogleFonts.jetBrainsMono(
                color:
                    const Color(0xffFF8BA7),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 28),

            _buildLabel("TASK TITLE"),

            const SizedBox(height: 10),

            _buildTextField(
              controller:
                  _titleController,
              hintText:
                  "What needs to be done?",

              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return
                      "Task title is required";
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            _buildLabel("DESCRIPTION"),

            const SizedBox(height: 10),

            _buildTextField(
              controller:
                  _descriptionController,
              hintText:
                  "Describe the task...",
              maxLines: 5,
            ),

            const SizedBox(height: 24),

            _buildLabel("PROJECT"),

            const SizedBox(height: 10),

            _buildProjectSelector(
              projects,
            ),

            const SizedBox(height: 28),

            _buildLabel("TAGS"),

            const SizedBox(height: 10),

            if (tagProvider.isLoading)
              const Center(
                child:
                    CircularProgressIndicator(
                  color:
                      Color(0xffB388FF),
                  strokeWidth: 2,
                ),
              )
            else
              _buildTags(tags),

            const SizedBox(height: 36),

            SizedBox(
              width: double.infinity,
              height: 54,

              child: ElevatedButton(
                onPressed:
                    taskProvider.isLoading
                        ? null
                        : _createTask,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xffFF8BA7,
                  ),
                  disabledBackgroundColor:
                      Colors.white10,
                  foregroundColor:
                      const Color(
                    0xff121214,
                  ),
                  elevation: 0,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                ),

                child:
                    taskProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color:
                                  Color(
                                0xff121214,
                              ),
                            ),
                          )
                        : Text(
                            "CREATE TASK",
                            style:
                                GoogleFonts
                                    .pressStart2p(
                              fontSize: 12,
                            ),
                          ),
              ),
            ),

            const SizedBox(height: 18),

            Center(
              child: Text(
                "> one task at a time.",
                style:
                    GoogleFonts
                        .jetBrainsMono(
                  color:
                      Colors.white24,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectSelector(
    List projects,
  ) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 15,
      ),

      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(
          0.05,
        ),
        borderRadius:
            BorderRadius.circular(
          10,
        ),
        border: Border.all(
          color:
              _selectedProjectId != null
                  ? const Color(
                      0xffFF8BA7,
                    )
                  : Colors.white10,
        ),
      ),

      child:
          DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value:
              _selectedProjectId,

          isExpanded: true,

          dropdownColor:
              const Color(
            0xff1A1A1E,
          ),

          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white38,
          ),

          hint: Text(
            "Select a project",
            style:
                GoogleFonts
                    .jetBrainsMono(
              color:
                  Colors.white24,
              fontSize: 13,
            ),
          ),

          items: projects
              .map<
                  DropdownMenuItem<int>>(
            (project) {
              return DropdownMenuItem<int>(
                value:
                    project.id,

                child: Row(
                  children: [
                    const Icon(
                      Icons.folder_outlined,
                      color:
                          Color(
                        0xff6EE7A2,
                      ),
                      size: 18,
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      child: Text(
                        project.name,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            GoogleFonts
                                .jetBrainsMono(
                          color:
                              Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ).toList(),

          onChanged: (value) {
            setState(() {
              _selectedProjectId =
                  value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTags(
    List tags,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 9,

      children: [
        ...tags.map(
          (tag) {
            final selected =
                _selectedTagIds
                    .contains(tag.id);

            return GestureDetector(
              onTap: () {
                _toggleTag(
                  tag.id,
                );
              },

              child:
                  AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 160,
                ),

                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),

                decoration:
                    BoxDecoration(
                  color: selected
                      ? const Color(
                          0xffB388FF,
                        ).withOpacity(
                          0.16,
                        )
                      : Colors.white
                          .withOpacity(
                          0.04,
                        ),

                  borderRadius:
                      BorderRadius.circular(
                    8,
                  ),

                  border:
                      Border.all(
                    color: selected
                        ? const Color(
                            0xffB388FF,
                          )
                        : Colors.white10,
                  ),
                ),

                child: Row(
                  mainAxisSize:
                      MainAxisSize.min,

                  children: [
                    Icon(
                      selected
                          ? Icons.check
                          : Icons
                              .label_outline,
                      size: 14,
                      color: selected
                          ? const Color(
                              0xffB388FF,
                            )
                          : Colors.white38,
                    ),

                    const SizedBox(
                      width: 6,
                    ),

                    Text(
                      tag.name,
                      style:
                          GoogleFonts
                              .jetBrainsMono(
                        color: selected
                            ? Colors.white
                            : Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        GestureDetector(
          onTap:
              _createTagDialog,

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
              ).withOpacity(
                0.05,
              ),

              borderRadius:
                  BorderRadius.circular(
                8,
              ),

              border:
                  Border.all(
                color:
                    const Color(
                  0xffB388FF,
                ).withOpacity(
                  0.35,
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
                    0xffB388FF,
                  ),
                  size: 15,
                ),

                const SizedBox(
                  width: 5,
                ),

                Text(
                  "NEW TAG",
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
      ],
    );
  }

  Widget _buildLabel(
    String text,
  ) {
    return Text(
      text,
      style:
          GoogleFonts.jetBrainsMono(
        color:
            const Color(0xffF3C86A),
        fontSize: 12,
        fontWeight:
            FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController
        controller,
    required String hintText,
    String? Function(String?)?
        validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,

      style:
          GoogleFonts.jetBrainsMono(
        color: Colors.white,
        fontSize: 13,
      ),

      cursorColor:
          const Color(0xffFF8BA7),

      decoration:
          InputDecoration(
        hintText:
            hintText,

        hintStyle:
            GoogleFonts
                .jetBrainsMono(
          color:
              Colors.white24,
          fontSize: 13,
        ),

        filled: true,

        fillColor:
            Colors.white.withOpacity(
          0.05,
        ),

        contentPadding:
            const EdgeInsets.all(
          16,
        ),

        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            10,
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
            10,
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
            10,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(0xffFF8BA7),
          ),
        ),

        errorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            10,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(0xffFF8BA7),
          ),
        ),

        focusedErrorBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            10,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(0xffFF8BA7),
          ),
        ),
      ),
    );
  }
}

class _CreateTagDialog extends StatefulWidget {
  const _CreateTagDialog();

  @override
  State<_CreateTagDialog> createState() =>
      _CreateTagDialogState();
}

class _CreateTagDialogState
    extends State<_CreateTagDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();

    if (name.isEmpty) {
      return;
    }

    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          const Color(0xff1A1A1E),

      title: Text(
        "NEW TAG",
        style: GoogleFonts.pressStart2p(
          color: const Color(0xffB388FF),
          fontSize: 14,
        ),
      ),

      content: TextField(
        controller: _controller,
        autofocus: true,

        style: GoogleFonts.jetBrainsMono(
          color: Colors.white,
          fontSize: 13,
        ),

        cursorColor:
            const Color(0xffB388FF),

        decoration: InputDecoration(
          hintText: "Tag name",

          hintStyle:
              GoogleFonts.jetBrainsMono(
            color: Colors.white24,
            fontSize: 12,
          ),

          filled: true,

          fillColor:
              Colors.white.withOpacity(0.05),

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10),

            borderSide:
                const BorderSide(
              color: Colors.white10,
            ),
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10),

            borderSide:
                const BorderSide(
              color: Color(0xffB388FF),
            ),
          ),
        ),

        onSubmitted: (_) {
          _submit();
        },
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },

          child: Text(
            "CANCEL",

            style:
                GoogleFonts.jetBrainsMono(
              color: Colors.white38,
            ),
          ),
        ),

        TextButton(
          onPressed: _submit,

          child: Text(
            "CREATE",

            style:
                GoogleFonts.jetBrainsMono(
              color:
                  const Color(0xffB388FF),
            ),
          ),
        ),
      ],
    );
  }
}