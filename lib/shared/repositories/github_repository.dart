import 'package:devtrack/core/network/api_client.dart';
import 'package:devtrack/shared/models/github_profile.dart';
import 'package:devtrack/shared/models/github_live_data.dart';
import 'package:dio/dio.dart';

class GithubRepository {
  final ApiClient _apiClient;
  final Dio _githubApi = Dio();

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

  Future<GithubProfile> getProfile(
    int profileId,
  ) async {
    final response = await _apiClient.dio.get(
      '/api/github-profile/$profileId',
    );

    return GithubProfile.fromJson(
      response.data,
    );
  }

  Future<GithubProfile> createProfile(
    String username,
  ) async {
    final response = await _apiClient.dio.post(
      '/api/github-profile',
      data: {
        'username': username,
      },
    );

    return GithubProfile.fromJson(
      response.data,
    );
  }

  Future<GithubProfile> updateProfile(
    int profileId,
    GithubProfile profile,
  ) async {
    final response = await _apiClient.dio.patch(
      '/api/github-profile/$profileId',
      data: {
        'username': profile.username,
      },
    );

    return GithubProfile.fromJson(
      response.data,
    );
  }

  Future<void> deleteProfile(
    int profileId,
  ) async {
    await _apiClient.dio.delete(
      '/api/github-profile/$profileId',
    );
  }

  Future<GithubLiveData> getLiveData(
    String username,
  ) async {
    final profileResponse =
        await _githubApi.get(
      'https://api.github.com/users/$username',
      options: Options(
        headers: {
          'Accept':
              'application/vnd.github+json',
          'X-GitHub-Api-Version':
              '2026-03-10',
        },
      ),
    );

    final profile =
        Map<String, dynamic>.from(
      profileResponse.data,
    );

    final contributionResponse =
        await _githubApi.get(
      'https://github-contributions-api.jogruber.de/v4/$username',
    );

    final contributionData =
        Map<String, dynamic>.from(
      contributionResponse.data,
    );

    final contributions =
        <DateTime, int>{};

    final rawContributions =
        contributionData['contributions'];

    if (rawContributions is List) {
      for (final item
          in rawContributions) {
        if (item is! Map) continue;

        final dateValue =
            item['date'];

        final countValue =
            item['count'];

        if (dateValue is String &&
            countValue is num) {
          final date =
              DateTime.tryParse(
            dateValue,
          );

          if (date != null) {
            contributions[
                DateTime(
              date.year,
              date.month,
              date.day,
            )] = countValue.toInt();
          }
        }
      }
    }

    return GithubLiveData(
      username:
          profile['login'] ??
          username,
      avatarUrl:
          profile['avatar_url'] ??
          '',
      profileUrl:
          profile['html_url'] ??
          'https://github.com/$username',
      publicRepos:
          (profile['public_repos'] as num?)
                  ?.toInt() ??
              0,
      followers:
          (profile['followers'] as num?)
                  ?.toInt() ??
              0,
      contributions:
          contributions,
    );
  }
}