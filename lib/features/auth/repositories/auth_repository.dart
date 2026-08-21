import 'package:devtrack/features/auth/models/register_request.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';
import '../models/auth_response.dart';
import '../models/login_request.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AuthRepository(
    this._apiClient,
    this._tokenStorage,
  );

  Future<String?> getToken() async {
    return await _tokenStorage.getToken();
  }

  Future<int?> getUserId() async {
    return await _tokenStorage.getUserId();
  }

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _apiClient.dio.post(
      '/api/auth/login',
      data: request.toJson(),
    );

    final authResponse = AuthResponse.fromJson(response.data);

    await _tokenStorage.saveToken(
      authResponse.token,
    );

    await _tokenStorage.saveUserId(
      authResponse.userId,
    );

    return authResponse;
  }

  Future<void> register(RegisterRequest request) async {
    await _apiClient.dio.post(
      '/api/auth/register',
      data: request.toJson(),
    );
  }

  Future<void> logout() async {
    await _tokenStorage.deleteToken();
  }
}