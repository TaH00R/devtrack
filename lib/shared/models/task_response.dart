import 'package:json_annotation/json_annotation.dart';

part 'task_response.g.dart';

@JsonSerializable()
class TaskResponse {
  final int id;
  final String title;
  final String? description;
  final bool? completed;
  final int projectId;
  final Set<int>? tagIds;

  TaskResponse({
    required this.id,
    required this.title,
    this.description,
    this.completed,
    required this.projectId,
    this.tagIds,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TaskResponseToJson(this);
}