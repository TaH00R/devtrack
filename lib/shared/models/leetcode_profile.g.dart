// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leetcode_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeetcodeProfile _$LeetcodeProfileFromJson(Map<String, dynamic> json) =>
    LeetcodeProfile(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      totalSolved: (json['totalSolved'] as num?)?.toInt(),
      easySolved: (json['easySolved'] as num?)?.toInt(),
      mediumSolved: (json['mediumSolved'] as num?)?.toInt(),
      hardSolved: (json['hardSolved'] as num?)?.toInt(),
      contestRatings: (json['contestRatings'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LeetcodeProfileToJson(LeetcodeProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'totalSolved': instance.totalSolved,
      'easySolved': instance.easySolved,
      'mediumSolved': instance.mediumSolved,
      'hardSolved': instance.hardSolved,
      'contestRatings': instance.contestRatings,
    };
