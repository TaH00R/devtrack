import 'package:devtrack/features/auth/auth_screen.dart';
import 'package:devtrack/features/auth/providers/auth_provider.dart';
import 'package:devtrack/features/homepage/homepage.dart';
import 'package:devtrack/shared/providers/user_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevTrack',
      debugShowCheckedModeBanner: false,

      home: Consumer<AuthProvider>(
        builder: (
          context,
          authProvider,
          child,
        ) {
          switch (authProvider.status) {
            case AuthStatus.unknown:
              return const LoadingScreen();

            case AuthStatus.authenticated:
              return const SessionLoader();

            case AuthStatus.unauthenticated:
              return const AuthScreen();
          }
        },
      ),
    );
  }
}

class SessionLoader extends StatefulWidget {
  const SessionLoader({super.key});

  @override
  State<SessionLoader> createState() =>
      _SessionLoaderState();
}

class _SessionLoaderState extends State<SessionLoader> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    await context.read<UserProvider>().getCurrentUser();

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingScreen();
    }

    return const HomeScreen();
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff121214),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}