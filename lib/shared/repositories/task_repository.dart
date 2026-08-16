import 'package:devtrack/core/network/api_client.dart';
import 'package:devtrack/shared/models/task_request.dart';
import 'package:devtrack/shared/models/task_response.dart';

class TaskRepository {
  final ApiClient _apiClient;
  TaskRepository(this._apiClient);

  Future<TaskResponse> createTask(TaskRequest request) async {
    final response = await _apiClient.dio.post(
      '/api/tasks',
      data: request.toJson(),
    );

    return TaskResponse.fromJson(response.data);
  }

  Future<List<TaskResponse>> getTasks() async {
    final response = await _apiClient.dio.get(
      '/api/tasks',
    );

    return (response.data as List)
        .map((task) => TaskResponse.fromJson(task))
        .toList();
  }

  Future<TaskResponse> getTask(int taskId) async {
    final response = await _apiClient.dio.get(
      '/api/tasks/$taskId',
    );

    return TaskResponse.fromJson(response.data);
  }

  Future<TaskResponse> updateTask(
    int taskId,
    TaskRequest request,
  ) async {
    final response = await _apiClient.dio.patch(
      '/api/tasks/$taskId',
      data: request.toJson(),
    );

    return TaskResponse.fromJson(response.data);
  }

  Future<void> deleteTask(int taskId) async {
    await _apiClient.dio.delete(
      '/api/tasks/$taskId',
    );
  }
}