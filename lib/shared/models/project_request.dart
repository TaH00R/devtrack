import 'package:json_annotation/json_annotation.dart';

part 'project_request.g.dart';

@JsonSerializable()
class ProjectRequest {
  final String name;
  final String description;
  final String? githubUrl;
  final int userId;

  ProjectRequest({
    required this.name,
    required this.description,
    this.githubUrl,
    required this.userId,
  });

  factory ProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$ProjectRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectRequestToJson(this);
}