import 'dart:convert';

import 'package:devtrack/core/network/api_client.dart';
import 'package:devtrack/shared/models/leetcode_live_data.dart';
import 'package:devtrack/shared/models/leetcode_profile.dart';
import 'package:dio/dio.dart';

class LeetcodeRepository {
  final ApiClient _apiClient;

  final Dio _leetcodeDio = Dio(
    BaseOptions(
      baseUrl: 'https://leetcode.com',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Origin': 'https://leetcode.com',
        'Referer': 'https://leetcode.com/',
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 Chrome/120.0.0.0 Mobile Safari/537.36',
      },
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );

  LeetcodeRepository(this._apiClient);

  Future<List<LeetcodeProfile>> getProfiles() async {
    final response = await _apiClient.dio.get(
      '/api/leetcode-profile',
    );

    return (response.data as List)
        .map(
          (profile) => LeetcodeProfile.fromJson(
            Map<String, dynamic>.from(profile),
          ),
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
      Map<String, dynamic>.from(response.data),
    );
  }

  Future<LeetcodeProfile> createProfile(
    String username,
  ) async {
    final response = await _apiClient.dio.post(
      '/api/leetcode-profile',
      data: {
        'username': username.trim(),
      },
    );

    return LeetcodeProfile.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }

  Future<LeetcodeProfile> updateProfile(
    int profileId,
    LeetcodeProfile profile,
  ) async {
    final response = await _apiClient.dio.patch(
      '/api/leetcode-profile/$profileId',
      data: profile.toJson(),
    );

    return LeetcodeProfile.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }

  Future<void> deleteProfile(
    int profileId,
  ) async {
    await _apiClient.dio.delete(
      '/api/leetcode-profile/$profileId',
    );
  }

  Future<Map<String, dynamic>> _postQuery({
    required String operationName,
    required String query,
    required Map<String, dynamic> variables,
  }) async {
    final response = await _leetcodeDio.post(
      '/graphql/',
      data: jsonEncode({
        'operationName': operationName,
        'query': query,
        'variables': variables,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'LeetCode request failed: ${response.statusCode}\n${response.data}',
      );
    }

    final rawData = response.data;

    final Map<String, dynamic> body;

    if (rawData is String) {
      body = Map<String, dynamic>.from(
        jsonDecode(rawData),
      );
    } else {
      body = Map<String, dynamic>.from(rawData);
    }

    if (body['errors'] != null) {
      throw Exception(
        body['errors'].toString(),
      );
    }

    final data = body['data'];

    if (data == null) {
      throw Exception(
        'LeetCode returned no data.',
      );
    }

    return Map<String, dynamic>.from(data);
  }

  Future<LeetcodeLiveData> getLiveData(
    String username,
  ) async {
    final cleanUsername = username.trim();

    if (cleanUsername.isEmpty) {
      throw Exception(
        'LeetCode username is empty.',
      );
    }

    const profileQuery = r'''
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
  }
}
''';

    const contestQuery = r'''
query userContestRankingInfo($username: String!) {
  userContestRanking(username: $username) {
    rating
  }
}
''';

    const calendarQuery = r'''
query userProfileCalendar($username: String!, $year: Int) {
  matchedUser(username: $username) {
    userCalendar(year: $year) {
      submissionCalendar
    }
  }
}
''';

    final profileData = await _postQuery(
      operationName: 'getUserProfile',
      query: profileQuery,
      variables: {
        'username': cleanUsername,
      },
    );

    final matchedUser = profileData['matchedUser'];

    if (matchedUser == null) {
      throw Exception(
        'LeetCode user "$cleanUsername" not found.',
      );
    }

    final user = Map<String, dynamic>.from(
      matchedUser,
    );

    String? avatarUrl;

    final profile = user['profile'];

    if (profile is Map) {
      final avatar = profile['userAvatar'];

      if (avatar is String && avatar.isNotEmpty) {
        avatarUrl = avatar;
      }
    }

    int totalSolved = 0;
    int easySolved = 0;
    int mediumSolved = 0;
    int hardSolved = 0;

    final submitStats = user['submitStats'];

    if (submitStats is Map) {
      final submissionList =
          submitStats['acSubmissionNum'];

      if (submissionList is List) {
        for (final item in submissionList) {
          if (item is! Map) {
            continue;
          }

          final difficulty =
              item['difficulty']?.toString();

          final countValue = item['count'];

          final count = countValue is num
              ? countValue.toInt()
              : int.tryParse(
                    countValue?.toString() ?? '0',
                  ) ??
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
      }
    }

    double? contestRating;

    try {
      final contestData = await _postQuery(
        operationName: 'userContestRankingInfo',
        query: contestQuery,
        variables: {
          'username': cleanUsername,
        },
      );

      final ranking =
          contestData['userContestRanking'];

      if (ranking is Map) {
        final rating = ranking['rating'];

        if (rating is num) {
          contestRating = rating.toDouble();
        }
      }
    } catch (_) {}

    Map<DateTime, int> submissions = {};

    try {
      final calendarData = await _postQuery(
        operationName: 'userProfileCalendar',
        query: calendarQuery,
        variables: {
          'username': cleanUsername,
          'year': DateTime.now().year,
        },
      );

      final calendarUser =
          calendarData['matchedUser'];

      if (calendarUser is Map) {
        final userCalendar =
            calendarUser['userCalendar'];

        if (userCalendar is Map) {
          final rawCalendar =
              userCalendar['submissionCalendar'];

          if (rawCalendar is String &&
              rawCalendar.isNotEmpty) {
            final decoded =
                jsonDecode(rawCalendar);

            if (decoded is Map) {
              final result =
                  <DateTime, int>{};

              decoded.forEach((key, value) {
                final timestamp =
                    int.tryParse(key.toString());

                if (timestamp == null) {
                  return;
                }

                final date =
                    DateTime.fromMillisecondsSinceEpoch(
                  timestamp * 1000,
                  isUtc: true,
                ).toLocal();

                final count = value is num
                    ? value.toInt()
                    : int.tryParse(
                          value.toString(),
                        ) ??
                        0;

                result[
                  DateTime(
                    date.year,
                    date.month,
                    date.day,
                  )
                ] = count;
              });

              submissions = result;
            }
          }
        }
      }
    } catch (_) {}

    return LeetcodeLiveData(
      username:
          user['username']?.toString() ??
              cleanUsername,
      avatarUrl: avatarUrl,
      totalSolved: totalSolved,
      easySolved: easySolved,
      mediumSolved: mediumSolved,
      hardSolved: hardSolved,
      contestRating: contestRating,
      submissions: submissions,
    );
  }
}