import 'package:devtrack/core/network/api_client.dart';
import 'package:devtrack/shared/models/user_response.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  Future<UserResponse> getUser(int userId) async {
    final response = await _apiClient.dio.get(
      '/api/users/$userId',
    );

    return UserResponse.fromJson(response.data);
  }

  Future<UserResponse> getCurrentUser() async {
    final response = await _apiClient.dio.get(
      '/api/users/me',
    );

    return UserResponse.fromJson(response.data);
  }

  Future<UserResponse> updateUser(
    int userId,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.dio.put(
      '/api/users/$userId',
      data: data,
    );

    return UserResponse.fromJson(response.data);
  }

  Future<void> deleteUser(int userId) async {
    await _apiClient.dio.delete(
      '/api/users/$userId',
    );
  }
}