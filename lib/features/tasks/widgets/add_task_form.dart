import 'package:devtrack/features/tasks/widgets/create_task_button.dart';
import 'package:devtrack/features/tasks/widgets/project_selector.dart';
import 'package:devtrack/features/tasks/widgets/tag_selector.dart';
import 'package:devtrack/features/tasks/widgets/task_label.dart';
import 'package:devtrack/features/tasks/widgets/task_text_field.dart';

import 'package:devtrack/shared/providers/tag_provider.dart';
import 'package:devtrack/shared/providers/task_provider.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddTaskForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController titleController;
  final TextEditingController descriptionController;

  final int? selectedProjectId;
  final Set<int> selectedTagIds;

  final List projects;

  final ValueChanged<int?> onProjectChanged;
  final ValueChanged<int> onToggleTag;

  final VoidCallback onCreateTag;
  final VoidCallback onCreateTask;

  const AddTaskForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.selectedProjectId,
    required this.selectedTagIds,
    required this.projects,
    required this.onProjectChanged,
    required this.onToggleTag,
    required this.onCreateTag,
    required this.onCreateTask,
  });

  @override
  Widget build(BuildContext context) {
    final tagProvider = context.watch<TagProvider>();
    final taskProvider = context.watch<TaskProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        22,
        18,
        22,
        30,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              '> Create a new task.',
              style: GoogleFonts.jetBrainsMono(
                color: const Color(0xffFF8BA7),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 28),

            const TaskLabel(text: 'TASK TITLE'),

            const SizedBox(height: 10),

            TaskTextField(
              controller: titleController,
              hintText: 'What needs to be done?',
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Task title is required';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            const TaskLabel(text: 'DESCRIPTION'),

            const SizedBox(height: 10),

            TaskTextField(
              controller: descriptionController,
              hintText: 'Describe the task...',
              maxLines: 5,
            ),

            const SizedBox(height: 24),

            const TaskLabel(text: 'PROJECT'),

            const SizedBox(height: 10),

            BuildProjectSelection(
              selectedProjectId:
                  selectedProjectId,
              projects: projects,
              onChanged: onProjectChanged,
            ),

            const SizedBox(height: 28),

            const TaskLabel(text: 'TAGS'),

            const SizedBox(height: 10),

            if (tagProvider.isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xffB388FF),
                  strokeWidth: 2,
                ),
              )
            else
              TagSelector(
                tags: tagProvider.tags,
                selectedTagIds:
                    selectedTagIds,
                onToggleTag: onToggleTag,
                onCreateTag: onCreateTag,
              ),

            const SizedBox(height: 36),

            CreateTaskButton(
              isLoading: taskProvider.isLoading,
              onPressed: onCreateTask,
            ),

            const SizedBox(height: 18),

            Center(
              child: Text(
                '> one task at a time.',
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white24,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}