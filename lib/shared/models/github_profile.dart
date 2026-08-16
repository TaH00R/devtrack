import 'package:json_annotation/json_annotation.dart';

part 'github_profile.g.dart';

@JsonSerializable()
class GithubProfile {
  final int id;
  final String username;
  final String? profileUrl;
  final int? publicRepos;
  final int? followers;

  GithubProfile({
    required this.id,
    required this.username,
    this.profileUrl,
    this.publicRepos,
    this.followers,
  });

  factory GithubProfile.fromJson(Map<String, dynamic> json) =>
      _$GithubProfileFromJson(json);

  Map<String, dynamic> toJson() => _$GithubProfileToJson(this);
}