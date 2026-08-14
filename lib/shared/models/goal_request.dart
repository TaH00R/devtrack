import 'package:json_annotation/json_annotation.dart';

part 'goal_request.g.dart';

@JsonSerializable()
class GoalRequest {
  final String title;
  final String? description;
  final bool? completed;
  final DateTime? deadline;
  final int userId;

  GoalRequest({
    required this.title,
    this.description,
    this.completed,
    this.deadline,
    required this.userId,
  });

  factory GoalRequest.fromJson(Map<String, dynamic> json) =>
      _$GoalRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GoalRequestToJson(this);
}