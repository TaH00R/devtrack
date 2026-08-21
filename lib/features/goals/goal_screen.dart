import 'package:devtrack/features/auth/providers/auth_provider.dart';
import 'package:devtrack/shared/models/goal_request.dart';
import 'package:devtrack/shared/providers/goal_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'widgets/deadline_selector.dart';
import 'widgets/goal_label.dart';
import 'widgets/goal_text_field.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _deadline;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xffB388FF),
              surface: Color(0xff1A1A1E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null) return;

    setState(() {
      _deadline = selectedDate;
    });
  }

  Future<void> _createGoal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userId = context.read<AuthProvider>().userId;

    if (userId == null) {
      _showError("User not authenticated.");
      return;
    }

    final goalProvider = context.read<GoalProvider>();

    final request = GoalRequest(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      completed: false,
      deadline: _deadline,
      userId: userId,
    );

    await goalProvider.createGoal(request);

    if (!mounted) return;

    if (goalProvider.error != null) {
      _showError(goalProvider.error!);
      return;
    }

    _titleController.clear();
    _descriptionController.clear();

    setState(() {
      _deadline = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Goal created successfully.",
          style: GoogleFonts.jetBrainsMono(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        backgroundColor: const Color(0xff17251D),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.jetBrainsMono(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        backgroundColor: const Color(0xff2A1A20),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final goalProvider = context.watch<GoalProvider>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff121214),
        appBar: AppBar(
          backgroundColor: const Color(0xff121214),
          elevation: 0,
          title: Text(
            "ADD GOAL",
            style: GoogleFonts.pressStart2p(
              color: const Color(0xffB388FF),
              fontSize: 18,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "> New objective.",
                  style: GoogleFonts.jetBrainsMono(
                    color: const Color(0xff6EE7A2),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 28),

                const GoalLabel("GOAL TITLE"),

                const SizedBox(height: 10),

                GoalTextField(
                  controller: _titleController,
                  hintText: "What do you want to achieve?",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Goal title is required";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                const GoalLabel("DESCRIPTION"),

                const SizedBox(height: 10),

                GoalTextField(
                  controller: _descriptionController,
                  hintText: "Describe your goal...",
                  maxLines: 5,
                ),

                const SizedBox(height: 24),

                const GoalLabel("DEADLINE"),

                const SizedBox(height: 10),

                DeadlineSelector(
                  deadline: _deadline,
                  onTap: _selectDeadline,
                  formatDate: _formatDate,
                ),

                const SizedBox(height: 36),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed:
                        goalProvider.isLoading ? null : _createGoal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffB388FF),
                      disabledBackgroundColor: Colors.white10,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: goalProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "CREATE GOAL",
                            style: GoogleFonts.pressStart2p(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 18),

                Center(
                  child: Text(
                    "> one goal at a time.",
                    style: GoogleFonts.jetBrainsMono(
                      color: const Color.fromARGB(
                        143,
                        255,
                        255,
                        255,
                      ),
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
}