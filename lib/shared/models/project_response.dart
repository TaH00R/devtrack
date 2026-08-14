import 'package:json_annotation/json_annotation.dart';

part 'project_response.g.dart';

@JsonSerializable()
class ProjectResponse {
  final int id;
  final String name;
  final String description;
  final String? githubUrl;
  final int userId;

  ProjectResponse({
    required this.id,
    required this.name,
    required this.description,
    this.githubUrl,
    required this.userId,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectResponseToJson(this);
}