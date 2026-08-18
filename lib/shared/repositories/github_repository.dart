import 'package:devtrack/core/network/api_client.dart';
import 'package:devtrack/shared/models/github_profile.dart';

class GithubRepository {
  final ApiClient _apiClient;

  GithubRepository(this._apiClient);

  Future<List<GithubProfile>> getProfiles() async {
    final response = await _apiClient.dio.get(
      '/api/github-profile',
    );

    return (response.data as List)
        .map(
          (profile) => GithubProfile.fromJson(profile),
        )
        .toList();
  }

  Future<GithubProfile> getProfile(int profileId) async {
    final response = await _apiClient.dio.get(
      '/api/github-profile/$profileId',
    );

    return GithubProfile.fromJson(response.data);
  }

  Future<GithubProfile> createProfile(
    GithubProfile profile,
  ) async {
    final response = await _apiClient.dio.post(
      '/api/github-profile',
      data: profile.toJson(),
    );

    return GithubProfile.fromJson(response.data);
  }

  Future<GithubProfile> updateProfile(
    int profileId,
    GithubProfile profile,
  ) async {
    final response = await _apiClient.dio.patch(
      '/api/github-profile/$profileId',
      data: profile.toJson(),
    );

    return GithubProfile.fromJson(response.data);
  }

  Future<void> deleteProfile(int profileId) async {
    await _apiClient.dio.delete(
      '/api/github-profile/$profileId',
    );
  }
}