import 'package:devtrack/core/network/api_client.dart';
import 'package:devtrack/core/storage/token_storage.dart';
import 'package:devtrack/features/auth/providers/auth_provider.dart';
import 'package:devtrack/features/auth/repositories/auth_repository.dart';
import 'package:devtrack/features/auth/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final tokenStorage = TokenStorage();
  final apiClient = ApiClient(tokenStorage);
  final authRepository = AuthRepository(
    apiClient,
    tokenStorage,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository),
        ),
      ],
      child: const AuthScreen(),
    ),
  );
}