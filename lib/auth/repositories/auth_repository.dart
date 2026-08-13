import '../../core/network/api_client.dart';
import '../models/auth_response.dart';
import '../models/login_request.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _apiClient.dio.post(
      '/api/auth/login',
      data: request.toJson(),
    );

    return AuthResponse.fromJson(response.data);
  }
}