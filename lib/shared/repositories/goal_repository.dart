import 'package:devtrack/core/network/api_client.dart';
import 'package:devtrack/shared/models/goal_request.dart';
import 'package:devtrack/shared/models/goal_response.dart';

class GoalRepository {
  final ApiClient _apiClient;

  GoalRepository(this._apiClient);

  Future<GoalResponse> createGoal(GoalRequest data) async {
    final response = await _apiClient.dio.post(
      '/api/goals',
      data: data.toJson(),
    );

    return GoalResponse.fromJson(response.data);
  }

  Future<List<GoalResponse>> getGoals() async {
    final response = await _apiClient.dio.get(
      '/api/goals',
    );

    return (response.data as List)
        .map((goal) => GoalResponse.fromJson(goal))
        .toList();
  }

  Future<GoalResponse> getGoal(int goalId) async {
    final response = await _apiClient.dio.get(
      '/api/goals/$goalId',
    );

    return GoalResponse.fromJson(response.data);
  }

  Future<GoalResponse> updateGoal(
    int goalId,
    GoalRequest data,
  ) async {
    final response = await _apiClient.dio.patch(
      '/api/goals/$goalId',
      data: data.toJson(),
    );

    return GoalResponse.fromJson(response.data);
  }

  Future<void> deleteGoal(int goalId) async {
    await _apiClient.dio.delete(
      '/api/goals/$goalId',
    );
  }
}