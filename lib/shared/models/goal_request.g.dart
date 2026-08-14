// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalRequest _$GoalRequestFromJson(Map<String, dynamic> json) => GoalRequest(
  title: json['title'] as String,
  description: json['description'] as String?,
  completed: json['completed'] as bool?,
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
  userId: (json['userId'] as num).toInt(),
);

Map<String, dynamic> _$GoalRequestToJson(GoalRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'completed': instance.completed,
      'deadline': instance.deadline?.toIso8601String(),
      'userId': instance.userId,
    };
