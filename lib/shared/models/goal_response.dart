import 'package:json_annotation/json_annotation.dart';

part 'goal_response.g.dart';

@JsonSerializable()
class GoalResponse {
  final int id;
  final String title;
  final String? description;
  final bool? completed;
  final DateTime? deadline;
  final int userId;

  GoalResponse({
    required this.id,
    required this.title,
    this.description,
    this.completed,
    this.deadline,
    required this.userId,
  });

  factory GoalResponse.fromJson(Map<String, dynamic> json) =>
      _$GoalResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GoalResponseToJson(this);
}