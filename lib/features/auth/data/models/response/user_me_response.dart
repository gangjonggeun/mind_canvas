import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/enums/login_type.dart';

part 'user_me_response.g.dart';

@JsonSerializable()
class UserMeResponse {
  final int userId;
  final String? nickname; // 닉네임은 미설정 상태일 수 있으므로 nullable
  @JsonKey(name: 'loginType')
  final LoginType loginType;

  UserMeResponse({
    required this.userId,
    this.nickname,
    required this.loginType,
  });

  factory UserMeResponse.fromJson(Map<String, dynamic> json) =>
      _$UserMeResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserMeResponseToJson(this);
}