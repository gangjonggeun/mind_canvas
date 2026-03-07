// auth_user_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mind_canvas/features/auth/domain/enums/login_type.dart';

part 'auth_user_entity.freezed.dart';
part 'auth_user_entity.g.dart';

@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    @JsonKey(name: 'user_id') required int userId, // ✨ 핵심: userId 추가!
    @JsonKey(name: 'nickname') String? nickname,
    @JsonKey(name: 'login_type') required LoginType loginType,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);

  /// 🎭 게스트 사용자 더미 생성 (필요시 사용, 보통은 서버에서 발급된 ID를 넣음)
  factory AuthUser.guest({required int generatedUserId}) {
    return AuthUser(
      userId: generatedUserId,
      nickname: null,
      loginType: LoginType.guest,
    );
  }
}