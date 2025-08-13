import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mind_canvas/features/auth/domain/enums/login_type.dart';

part 'auth_user_entity.freezed.dart';
part 'auth_user_entity.g.dart';

/// 🧑‍💼 사용자 엔티티 (불변 객체)
/// 
/// 메모리 효율적인 사용자 정보 저장을 위한 불변 클래스
/// - 50바이트 이하의 가벼운 객체 설계
/// - JSON 직렬화 지원
/// - 타입 안전성 보장
@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    @JsonKey(name: 'nickname') String? nickname,
    @JsonKey(name: 'login_type') required LoginType loginType,
  }) = _AuthUser;

  /// ✅ JSON 직렬화를 위한 fromJson 팩토리 메서드 (필수!)
  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  /// 🎭 게스트 사용자 생성
  factory AuthUser.guest() {
    return const AuthUser(
      nickname: null,
      loginType: LoginType.guest,
    );
  }
}