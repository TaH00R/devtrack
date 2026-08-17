import 'package:devtrack/app/app.dart';
import 'package:devtrack/core/network/api_client.dart';
import 'package:devtrack/core/storage/token_storage.dart';
import 'package:devtrack/features/auth/providers/auth_provider.dart';
import 'package:devtrack/features/auth/repositories/auth_repository.dart';
import 'package:devtrack/shared/providers/goal_provider.dart';
import 'package:devtrack/shared/providers/note_provider.dart';
import 'package:devtrack/shared/providers/project_provider.dart';
import 'package:devtrack/shared/providers/tag_provider.dart';
import 'package:devtrack/shared/providers/task_provider.dart';
import 'package:devtrack/shared/providers/user_provider.dart';
import 'package:devtrack/shared/repositories/goal_repository.dart';
import 'package:devtrack/shared/repositories/note_repository.dart';
import 'package:devtrack/shared/repositories/project_repository.dart';
import 'package:devtrack/shared/repositories/tag_repository.dart';
import 'package:devtrack/shared/repositories/task_repository.dart';
import 'package:devtrack/shared/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final tokenStorage = TokenStorage();
  final apiClient = ApiClient(tokenStorage);
  final authRepository = AuthRepository(
    apiClient,
    tokenStorage,
  );
  final goalRepository = GoalRepository(apiClient);
  final noteRepository = NoteRepository(apiClient);
  final projectRepository = ProjectRepository(apiClient);
  final taskRepository = TaskRepository(apiClient);
  final userRepository = UserRepository(apiClient);
  final tagRepository = TagRepository(apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => GoalProvider(goalRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => NoteProvider(noteRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ProjectProvider(projectRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskProvider(taskRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(userRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => TagProvider(tagRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}