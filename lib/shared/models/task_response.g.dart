// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskResponse _$TaskResponseFromJson(Map<String, dynamic> json) => TaskResponse(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
  completed: json['completed'] as bool?,
  projectId: (json['projectId'] as num).toInt(),
  tagIds: (json['tagIds'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toSet(),
);

Map<String, dynamic> _$TaskResponseToJson(TaskResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'completed': instance.completed,
      'projectId': instance.projectId,
      'tagIds': instance.tagIds?.toList(),
    };
