import 'package:devtrack/core/network/api_client.dart';
import 'package:devtrack/shared/models/leetcode_profile.dart';

class LeetcodeRepository {
  final ApiClient _apiClient;

  LeetcodeRepository(this._apiClient);

  Future<List<LeetcodeProfile>> getProfiles() async {
    final response = await _apiClient.dio.get(
      '/api/leetcode-profile',
    );

    return (response.data as List)
        .map(
          (profile) => LeetcodeProfile.fromJson(profile),
        )
        .toList();
  }

  Future<LeetcodeProfile> getProfile(int profileId) async {
    final response = await _apiClient.dio.get(
      '/api/leetcode-profile/$profileId',
    );

    return LeetcodeProfile.fromJson(response.data);
  }

  Future<LeetcodeProfile> createProfile(
    LeetcodeProfile profile,
  ) async {
    final response = await _apiClient.dio.post(
      '/api/leetcode-profile',
      data: profile.toJson(),
    );

    return LeetcodeProfile.fromJson(response.data);
  }

  Future<LeetcodeProfile> updateProfile(
    int profileId,
    LeetcodeProfile profile,
  ) async {
    final response = await _apiClient.dio.patch(
      '/api/leetcode-profile/$profileId',
      data: profile.toJson(),
    );

    return LeetcodeProfile.fromJson(response.data);
  }

  Future<void> deleteProfile(int profileId) async {
    await _apiClient.dio.delete(
      '/api/leetcode-profile/$profileId',
    );
  }
}