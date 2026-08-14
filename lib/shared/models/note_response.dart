import 'package:json_annotation/json_annotation.dart';

part 'note_response.g.dart';

@JsonSerializable()
class NoteResponse {
  final int id;
  final String title;
  final String content;
  final int userId;

  NoteResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
  });

  factory NoteResponse.fromJson(Map<String, dynamic> json) =>
      _$NoteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NoteResponseToJson(this);
}