import 'package:devtrack/core/network/api_client.dart';
import 'package:devtrack/shared/models/project_request.dart';
import 'package:devtrack/shared/models/project_response.dart';

class ProjectRepository {
  final ApiClient _apiClient;
  ProjectRepository(this._apiClient);

  Future<ProjectResponse> getProject(int projectId) async {
    final response = await _apiClient.dio.get(
      '/api/projects/$projectId',
    );

    return ProjectResponse.fromJson(response.data);
  }

  Future<List<ProjectResponse>> getProjects() async {
    final response = await _apiClient.dio.get(
      '/api/projects',
    );

    return (response.data as List)
        .map((project) => ProjectResponse.fromJson(project))
        .toList();
  }

  Future<ProjectResponse> createProject(ProjectRequest request) async {
    final response = await _apiClient.dio.post(
      '/api/projects',
      data: request.toJson(),
    );

    return ProjectResponse.fromJson(response.data);
  }

  Future<ProjectResponse> updateProject(
    int projectId,
    ProjectRequest request,
  ) async {
    final response = await _apiClient.dio.patch(
      '/api/projects/$projectId',
      data: request.toJson(),
    );

    return ProjectResponse.fromJson(response.data);
  }

  Future<void> deleteProject(int projectId) async {
    await _apiClient.dio.delete(
      '/api/projects/$projectId',
    );
  }
}