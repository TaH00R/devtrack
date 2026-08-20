import 'package:devtrack/features/projects/add_project_screen.dart';
import 'package:devtrack/features/tasks/widgets/add_task_app_bar.dart';
import 'package:devtrack/features/tasks/widgets/add_task_form.dart';
import 'package:devtrack/features/tasks/widgets/create_tag_dialog.dart';
import 'package:devtrack/features/tasks/widgets/no_project_body.dart';

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

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

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
    if (!_formKey.currentState!.validate()) return;

    if (_selectedProjectId == null) {
      _showError('Please select a project.');
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

    Navigator.pop(context);
  }

  Future<void> _createProject() async {
    await Navigator.push(
      context,
      smoothRoute(const AddProjectScreen()),
    );

    if (!mounted) return;

    final projectProvider = context.read<ProjectProvider>();

    await projectProvider.getProjects();

    if (!mounted) return;

    if (projectProvider.projects.isNotEmpty) {
      setState(() {
        _selectedProjectId = projectProvider.projects.last.id;
      });
    }
  }

  Future<void> _createTag() async {
    final tagName = await showDialog<String>(
      context: context,
      builder: (_) => const CreateTagDialog(),
    );

    if (!mounted || tagName == null) return;

    final name = tagName.trim();

    if (name.isEmpty) return;

    final tagProvider = context.read<TagProvider>();

    await tagProvider.createTag(name);

    if (!mounted) return;

    if (tagProvider.error != null) {
      _showError(tagProvider.error!);
      return;
    }

    if (tagProvider.tags.isNotEmpty) {
      setState(() {
        _selectedTagIds.add(
          tagProvider.tags.last.id,
        );
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
        backgroundColor: const Color(0xff2A1A20),
        content: Text(
          message,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider =
        context.watch<ProjectProvider>();

    final projects = projectProvider.projects;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff121214),

        appBar: const AddTaskAppBar(),

        body: projectProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xffFF8BA7),
                  strokeWidth: 2,
                ),
              )
            : projects.isEmpty
                ? NoProjectsBody(
                    onCreateProject: _createProject,
                  )
                : AddTaskForm(
                    formKey: _formKey,
                    titleController: _titleController,
                    descriptionController:
                        _descriptionController,
                    selectedProjectId:
                        _selectedProjectId,
                    selectedTagIds:
                        _selectedTagIds,
                    projects: projects,
                    onProjectChanged: (value) {
                      setState(() {
                        _selectedProjectId = value;
                      });
                    },
                    onToggleTag: _toggleTag,
                    onCreateTag: _createTag,
                    onCreateTask: _createTask,
                  ),
      ),
    );
  }
}