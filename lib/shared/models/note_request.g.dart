// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteRequest _$NoteRequestFromJson(Map<String, dynamic> json) => NoteRequest(
  title: json['title'] as String,
  content: json['content'] as String,
  userId: (json['userId'] as num).toInt(),
);

Map<String, dynamic> _$NoteRequestToJson(NoteRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'userId': instance.userId,
    };
