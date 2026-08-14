import 'package:json_annotation/json_annotation.dart';

part 'note_request.g.dart';

@JsonSerializable()
class NoteRequest {
  final String title;
  final String content;
  final int userId;

  NoteRequest({
    required this.title,
    required this.content,
    required this.userId,
  });

  factory NoteRequest.fromJson(Map<String, dynamic> json) =>
      _$NoteRequestFromJson(json);

  Map<String, dynamic> toJson() => _$NoteRequestToJson(this);
}