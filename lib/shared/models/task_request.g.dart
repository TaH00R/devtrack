// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskRequest _$TaskRequestFromJson(Map<String, dynamic> json) => TaskRequest(
  title: json['title'] as String,
  description: json['description'] as String?,
  completed: json['completed'] as bool?,
  projectId: (json['projectId'] as num).toInt(),
  tagIds: (json['tagIds'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toSet(),
);

Map<String, dynamic> _$TaskRequestToJson(TaskRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'completed': instance.completed,
      'projectId': instance.projectId,
      'tagIds': instance.tagIds?.toList(),
    };
