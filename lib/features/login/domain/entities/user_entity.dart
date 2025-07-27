import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

/// 🧑‍💼 사용자 엔티티 (불변 객체)
/// 
/// 메모리 효율적인 사용자 정보 저장을 위한 불변 클래스
/// - 50바이트 이하의 가벼운 객체 설계
/// - JSON 직렬화 지원
/// - 타입 안전성 보장
@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String email,
    required String displayName,
    String? profileImageUrl,
    required AuthProvider authProvider,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isProfileComplete,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}

/// 🔐 인증 제공자 타입
enum AuthProvider {
  @JsonValue('email')
  email,
  
  @JsonValue('google')
  google,
  
  @JsonValue('apple')
  apple,
  
  @JsonValue('guest')
  guest,
  
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
      case AuthProvider.guest:
        return '게스트';
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
      case AuthProvider.guest:
        return 'person';
      case AuthProvider.anonymous:
        return 'visibility_off';
    }
  }
}

/// 🎯 사용자 엔티티 확장 메서드
extension UserEntityExtension on UserEntity {
  /// 프로필이 완성되었는지 확인
  bool get hasCompleteProfile {
    return displayName.isNotEmpty && 
           isEmailVerified && 
           isProfileComplete;
  }

  /// 신규 사용자인지 확인 (24시간 이내 가입)
  bool get isNewUser {
    if (createdAt == null) return false;
    final now = DateTime.now();
    final difference = now.difference(createdAt!);
    return difference.inHours < 24;
  }

  /// 프로필 이미지 URL (기본값 포함)
  String get safeProfileImageUrl {
    return profileImageUrl ?? 
           'https://ui-avatars.com/api/?name=${Uri.encodeComponent(displayName)}&background=6B73FF&color=fff';
  }

  /// 사용자 이니셜 (프로필 이미지 대체용)
  String get initials {
    final words = displayName.trim().split(' ');
    if (words.isEmpty) return 'U';
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    }
    return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}'.toUpperCase();
  }
}
