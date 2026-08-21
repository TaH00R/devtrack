import 'package:devtrack/features/auth/providers/auth_provider.dart';
import 'package:devtrack/features/projects/widgets/project_form_field.dart';
import 'package:devtrack/features/projects/widgets/project_form_label.dart';
import 'package:devtrack/shared/models/project_request.dart';
import 'package:devtrack/shared/providers/project_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() =>
      _AddProjectScreenState();
}

class _AddProjectScreenState
    extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _descriptionController =
      TextEditingController();

  final _githubController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _githubController.dispose();

    super.dispose();
  }

  Future<void> _createProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userId =
        context.read<AuthProvider>().userId;

    if (userId == null) {
      _showError("User not authenticated.");

      return;
    }

    final projectProvider =
        context.read<ProjectProvider>();

    final request = ProjectRequest(
      name: _nameController.text.trim(),

      description:
          _descriptionController.text.trim(),

      githubUrl:
          _githubController.text.trim().isEmpty
              ? null
              : _githubController.text.trim(),

      userId: userId,
    );

    await projectProvider.createProject(request);

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

        backgroundColor:
            const Color(0xff2A1A20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider =
        context.watch<ProjectProvider>();

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            const Color(0xff121214),

        appBar: AppBar(
          backgroundColor:
              const Color(0xff121214),

          elevation: 0,

          leading: IconButton(
            onPressed: () => Navigator.pop(context),

            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white70,
            ),
          ),

          title: Text(
            "ADD PROJECT",

            style: GoogleFonts.pressStart2p(
              color:
                  const Color(0xff6EE7A2),

              fontSize: 17,
            ),
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
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
                  "> Initialize new project.",

                  style: GoogleFonts.jetBrainsMono(
                    color:
                        const Color(0xff6EE7A2),

                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 28),

                const ProjectFormLabel(
                  text: "PROJECT NAME",
                ),

                const SizedBox(height: 10),

                ProjectFormField(
                  controller: _nameController,

                  hintText:
                      "What are you building?",

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Project name is required";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                const ProjectFormLabel(
                  text: "DESCRIPTION",
                ),

                const SizedBox(height: 10),

                ProjectFormField(
                  controller:
                      _descriptionController,

                  hintText:
                      "Describe your project...",

                  maxLines: 5,

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Description is required";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                const ProjectFormLabel(
                  text: "GITHUB URL",
                ),

                const SizedBox(height: 10),

                ProjectFormField(
                  controller: _githubController,

                  hintText:
                      "https://github.com/username/project",

                  keyboardType:
                      TextInputType.url,
                ),

                const SizedBox(height: 36),

                SizedBox(
                  width: double.infinity,
                  height: 54,

                  child: ElevatedButton(
                    onPressed:
                        projectProvider.isLoading
                            ? null
                            : _createProject,

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xff6EE7A2),

                      disabledBackgroundColor:
                          Colors.white10,

                      foregroundColor:
                          const Color(0xff121214),

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
                        projectProvider.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,

                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,

                                  color: Color(
                                    0xff121214,
                                  ),
                                ),
                              )
                            : Text(
                                "CREATE PROJECT",

                                style: GoogleFonts
                                    .pressStart2p(
                                  fontSize: 12,
                                ),
                              ),
                  ),
                ),

                const SizedBox(height: 18),

                Center(
                  child: Text(
                    "> build something worth shipping.",

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
      ),
    );
  }
}