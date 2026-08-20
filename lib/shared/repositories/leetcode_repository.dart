import 'dart:convert';

import 'package:devtrack/core/network/api_client.dart';
import 'package:devtrack/shared/models/leetcode_profile.dart';
import 'package:devtrack/shared/models/leetcode_live_data.dart';
import 'package:dio/dio.dart';

class LeetcodeRepository {
  final ApiClient _apiClient;
  final Dio _leetcodeApi = Dio();

  LeetcodeRepository(this._apiClient);

  Future<List<LeetcodeProfile>> getProfiles() async {
    final response = await _apiClient.dio.get(
      '/api/leetcode-profile',
    );

    return (response.data as List)
        .map(
          (profile) =>
              LeetcodeProfile.fromJson(profile),
        )
        .toList();
  }

  Future<LeetcodeProfile> getProfile(
    int profileId,
  ) async {
    final response = await _apiClient.dio.get(
      '/api/leetcode-profile/$profileId',
    );

    return LeetcodeProfile.fromJson(
      response.data,
    );
  }

  Future<LeetcodeProfile> createProfile(
    String username,
  ) async {
    final response = await _apiClient.dio.post(
      '/api/leetcode-profile',
      data: {
        'username': username,
      },
    );

    return LeetcodeProfile.fromJson(
      response.data,
    );
  }

  Future<LeetcodeProfile> updateProfile(
    int profileId,
    LeetcodeProfile profile,
  ) async {
    final response =
        await _apiClient.dio.patch(
      '/api/leetcode-profile/$profileId',
      data: {
        'username': profile.username,
      },
    );

    return LeetcodeProfile.fromJson(
      response.data,
    );
  }

  Future<void> deleteProfile(
    int profileId,
  ) async {
    await _apiClient.dio.delete(
      '/api/leetcode-profile/$profileId',
    );
  }

  Future<LeetcodeLiveData> getLiveData(
    String username,
  ) async {
    const query = r'''
      query getUserProfile($username: String!) {
        matchedUser(username: $username) {
          username
          profile {
            userAvatar
          }
          submitStats: submitStatsGlobal {
            acSubmissionNum {
              difficulty
              count
            }
          }
          userContestRanking {
            rating
          }
          submissionCalendar
        }
      }
    ''';

    final response =
        await _leetcodeApi.post(
      'https://leetcode.com/graphql/',
      data: {
        'query': query,
        'variables': {
          'username': username,
        },
      },
      options: Options(
        headers: {
          'Content-Type':
              'application/json',
          'Referer':
              'https://leetcode.com/',
        },
      ),
    );

    final root =
        Map<String, dynamic>.from(
      response.data,
    );

    final data =
        Map<String, dynamic>.from(
      root['data'] ?? {},
    );

    final matchedUser =
        data['matchedUser'];

    if (matchedUser == null) {
      throw Exception(
        'LeetCode user not found',
      );
    }

    final user =
        Map<String, dynamic>.from(
      matchedUser,
    );

    final stats =
        Map<String, dynamic>.from(
      user['submitStats'] ?? {},
    );

    final submissions =
        stats['acSubmissionNum'] as List? ??
            const [];

    int totalSolved = 0;
    int easySolved = 0;
    int mediumSolved = 0;
    int hardSolved = 0;

    for (final item in submissions) {
      if (item is! Map) continue;

      final difficulty =
          item['difficulty']
              ?.toString();

      final count =
          (item['count'] as num?)
                  ?.toInt() ??
              0;

      switch (difficulty) {
        case 'All':
          totalSolved = count;
          break;
        case 'Easy':
          easySolved = count;
          break;
        case 'Medium':
          mediumSolved = count;
          break;
        case 'Hard':
          hardSolved = count;
          break;
      }
    }

    final profile =
        user['profile'] is Map
            ? Map<String, dynamic>.from(
                user['profile'],
              )
            : <String, dynamic>{};

    final contest =
        user['userContestRanking'];

    double? rating;

    if (contest is Map &&
        contest['rating'] is num) {
      rating =
          (contest['rating'] as num)
              .toDouble();
    }

    final submissionCalendar =
        user['submissionCalendar'];

    final calendar =
        <DateTime, int>{};

    if (submissionCalendar is String) {
      try {
        final decoded =
            Map<String, dynamic>.from(
          _decodeJson(
            submissionCalendar,
          ),
        );

        for (final entry
            in decoded.entries) {
          final timestamp =
              int.tryParse(
            entry.key,
          );

          final count =
              (entry.value as num?)
                      ?.toInt() ??
                  0;

          if (timestamp == null) {
            continue;
          }

          final date =
              DateTime.fromMillisecondsSinceEpoch(
            timestamp * 1000,
            isUtc: true,
          ).toLocal();

          calendar[
              DateTime(
            date.year,
            date.month,
            date.day,
          )] = count;
        }
      } catch (_) {}
    }

    return LeetcodeLiveData(
      username:
          user['username'] ??
          username,
      avatarUrl:
          profile['userAvatar']
              ?.toString(),
      totalSolved:
          totalSolved,
      easySolved:
          easySolved,
      mediumSolved:
          mediumSolved,
      hardSolved:
          hardSolved,
      contestRating:
          rating,
      submissions:
          calendar,
    );
  }

  Map<String, dynamic> _decodeJson(
    String value,
  ) {
    return Map<String, dynamic>.from(
      _jsonDecode(value),
    );
  }

  dynamic _jsonDecode(
    String value,
  ) {
    return const JsonCodec().decode(value);
  }
}