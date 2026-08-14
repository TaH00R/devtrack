import 'package:json_annotation/json_annotation.dart';

part 'task_request.g.dart';

@JsonSerializable()
class TaskRequest {
  final String title;
  final String? description;
  final bool? completed;
  final int projectId;
  final Set<int>? tagIds;

  TaskRequest({
    required this.title,
    this.description,
    this.completed,
    required this.projectId,
    this.tagIds,
  });

  factory TaskRequest.fromJson(Map<String, dynamic> json) =>
      _$TaskRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TaskRequestToJson(this);
}