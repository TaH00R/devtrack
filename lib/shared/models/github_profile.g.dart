// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubProfile _$GithubProfileFromJson(Map<String, dynamic> json) =>
    GithubProfile(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      profileUrl: json['profileUrl'] as String?,
      publicRepos: (json['publicRepos'] as num?)?.toInt(),
      followers: (json['followers'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GithubProfileToJson(GithubProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
      'profileUrl': instance.profileUrl,
      'publicRepos': instance.publicRepos,
      'followers': instance.followers,
    };
