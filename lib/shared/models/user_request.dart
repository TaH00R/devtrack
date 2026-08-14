import 'package:json_annotation/json_annotation.dart';

part 'user_request.g.dart';

@JsonSerializable()
class UserRequest {
  final String userName;
  final String email;
  final String password;
  final String? displayName;

  UserRequest({
    required this.userName,
    required this.email,
    required this.password,
    this.displayName,
  });

  factory UserRequest.fromJson(Map<String, dynamic> json) =>
      _$UserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserRequestToJson(this);
}