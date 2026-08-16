import 'package:json_annotation/json_annotation.dart';

part 'leetcode_profile.g.dart';

@JsonSerializable()
class LeetcodeProfile {
  final int id;
  final String username;
  final int? totalSolved;
  final int? easySolved;
  final int? mediumSolved;
  final int? hardSolved;
  final int? contestRatings;

  LeetcodeProfile({
    required this.id,
    required this.username,
    this.totalSolved,
    this.easySolved,
    this.mediumSolved,
    this.hardSolved,
    this.contestRatings,
  });

  factory LeetcodeProfile.fromJson(Map<String, dynamic> json) =>
      _$LeetcodeProfileFromJson(json);

  Map<String, dynamic> toJson() => _$LeetcodeProfileToJson(this);
}