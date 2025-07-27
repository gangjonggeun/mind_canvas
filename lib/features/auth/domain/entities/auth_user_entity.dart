import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user_entity.freezed.dart';
// part 'auth_user_entity.g.dart';

/// 🧑‍💼 사용자 엔티티 (불변 객체)
/// 
/// 메모리 효율적인 사용자 정보 저장을 위한 불변 클래스
/// - 50바이트 이하의 가벼운 객체 설계
/// - JSON 직렬화 지원
/// - 타입 안전성 보장
@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    String? email,                     // 익명: null, 소셜: 있음
    String? nickname,                  // 로그인 후 설정
    String? profileImageUrl,           // 소셜에서 받아올 수 있음
    required AuthProvider authProvider,
    @Default(true) bool isEmailVerified,  // 소셜은 항상 true, 익명은 의미없음
    @Default(false) bool isProfileComplete, // 닉네임 설정 완료 여부
  }) = _AuthUser;


  // 익명 사용자 기본값
  factory AuthUser.anonymous() {
    return AuthUser(
      id: 'anonymous',
      authProvider: AuthProvider.anonymous,
      isEmailVerified: true,
      isProfileComplete: false,
    );
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

}

/// 🔐 인증 제공자 타입
enum AuthProvider {
  @JsonValue('email')
  email,
  
  @JsonValue('google')
  google,
  
  @JsonValue('apple')
  apple,
  

  
  @JsonValue('anonymous')
  anonymous;

  /// 제공자별 표시 이름
  String get displayName {
    switch (this) {
      case AuthProvider.email:
        return '이메일';
      case AuthProvider.google:
        return 'Google';
      case AuthProvider.apple:
        return 'Apple';
      case AuthProvider.anonymous:
        return '익명';
    }
  }

  /// 제공자별 아이콘 (Material Icons)
  String get iconName {
    switch (this) {
      case AuthProvider.email:
        return 'email';
      case AuthProvider.google:
        return 'g_mobiledata';
      case AuthProvider.apple:
        return 'apple';
      case AuthProvider.anonymous:
        return 'visibility_off';
    }
  }
}

/// 🎯 AuthUser 확장 메서드
extension AuthUserExtension on AuthUser {
  /// 익명 사용자인지 확인
  bool get isAnonymous => authProvider == AuthProvider.anonymous;
  
  /// 소셜 로그인 사용자인지 확인
  bool get isSocialLogin => !isAnonymous;
  
  /// 닉네임 설정이 필요한지 확인
  bool get needsNickname => nickname == null || nickname!.isEmpty;
  
  /// 프로필 이미지 URL (닉네임 기반)
  String get safeProfileImageUrl {
    if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      return profileImageUrl!;
    }
    final displayName = nickname ?? 'User';
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(displayName)}&background=6B73FF&color=fff';
  }
  
  /// 사용자 이니셜 (프로필 이미지 대체용)
  String get initials {
    final displayName = nickname ?? 'U';
    final words = displayName.trim().split(' ');
    if (words.isEmpty) return 'U';
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    }
    return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}'.toUpperCase();
  }
  
  /// 표시용 이름 (닉네임 또는 기본값)
  String get displayName => nickname ?? '사용자';
}
