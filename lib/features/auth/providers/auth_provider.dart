import 'package:devtrack/features/auth/models/register_request.dart';
import 'package:flutter/foundation.dart';

import '../models/login_request.dart';
import '../repositories/auth_repository.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthStatus _status = AuthStatus.unknown;

  String? _errorMessage;

  bool _isLoading = false;

  int? _userId;

  AuthProvider(this._authRepository) {
    restoreSession();
  }

  AuthStatus get status => _status;

  String? get errorMessage => _errorMessage;

  bool get isAuthenticated {
    return _status == AuthStatus.authenticated;
  }

  bool get isLoading => _isLoading;

  int? get userId => _userId;

  Future<void> restoreSession() async {
    try {
      final token = await _authRepository.getToken();

      final userId = await _authRepository.getUserId();

      if (
          token != null &&
          token.isNotEmpty &&
          userId != null
      ) {
        _userId = userId;
        _status = AuthStatus.authenticated;
      } else {
        _userId = null;
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _userId = null;
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final request = LoginRequest(
        email: email,
        password: password,
      );

      final authResponse =
          await _authRepository.login(request);

      _userId = authResponse.userId;

      _status = AuthStatus.authenticated;
    } catch (e) {
      _status = AuthStatus.unauthenticated;

      _userId = null;

      _errorMessage = e.toString();
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> register({
    required String userName,
    required String email,
    required String password,
    String? displayName,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final request = RegisterRequest(
        userName: userName,
        email: email,
        password: password,
        displayName: displayName,
      );

      await _authRepository.register(request);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();

    _status = AuthStatus.unauthenticated;

    _userId = null;

    _errorMessage = null;

    notifyListeners();
  }
}