// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectRequest _$ProjectRequestFromJson(Map<String, dynamic> json) =>
    ProjectRequest(
      name: json['name'] as String,
      description: json['description'] as String,
      githubUrl: json['githubUrl'] as String?,
      userId: (json['userId'] as num).toInt(),
    );

Map<String, dynamic> _$ProjectRequestToJson(ProjectRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'githubUrl': instance.githubUrl,
      'userId': instance.userId,
    };
