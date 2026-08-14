// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteResponse _$NoteResponseFromJson(Map<String, dynamic> json) => NoteResponse(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  content: json['content'] as String,
  userId: (json['userId'] as num).toInt(),
);

Map<String, dynamic> _$NoteResponseToJson(NoteResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'userId': instance.userId,
    };
