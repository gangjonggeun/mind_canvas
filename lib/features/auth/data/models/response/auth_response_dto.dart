import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/network/api_response_dto.dart';

part 'auth_response_dto.freezed.dart';
part 'auth_response_dto.g.dart';

/// 🔑 인증 응답 DTO
@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String accessToken,
    required String refreshToken,
    required UserResponse user,
    @Default(3600) int expiresIn,
    @Default('Bearer') String tokenType,
    String? scope,
    DateTime? issuedAt,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

/// 👤 사용자 정보 응답 DTO
@freezed
class UserResponse with _$UserResponse {
  const factory UserResponse({
    required String id,
    required String email,
    required String displayName,
    String? profileImageUrl,
    required String authProvider,
    String? lastLoginAt,
    String? createdAt,
    String? updatedAt,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isProfileComplete,
    @Default(true) bool isActive,
    Map<String, dynamic>? metadata,
  }) = _UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}

/// 🔄 토큰 갱신 응답 DTO
@freezed
class RefreshTokenResponse with _$RefreshTokenResponse {
  const factory RefreshTokenResponse({
    required String accessToken,
    required String refreshToken,
    @Default(3600) int expiresIn,
    @Default('Bearer') String tokenType,
    DateTime? issuedAt,
    @Default(UserRole.user) UserRole role,
  }) = _RefreshTokenResponse;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}

/// 🚪 로그아웃 응답 DTO
@freezed
class LogoutResponse with _$LogoutResponse {
  const factory LogoutResponse({
    required bool success,
    String? message,
    DateTime? loggedOutAt,
  }) = _LogoutResponse;

  factory LogoutResponse.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseFromJson(json);
}


/// 🎯 Response DTO 확장 메서드들
extension AuthResponseExtension on AuthResponse {
  /// 토큰 만료 시간 계산
  DateTime get expiresAt {
    final now = issuedAt ?? DateTime.now();
    return now.add(Duration(seconds: expiresIn));
  }

  /// 토큰이 곧 만료되는지 확인 (10분 이내)
  bool get isTokenExpiringSoon {
    final now = DateTime.now();
    final expiry = expiresAt;
    final difference = expiry.difference(now);
    return difference.inMinutes <= 10;
  }

  /// 토큰이 이미 만료되었는지 확인
  bool get isTokenExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  /// Authorization 헤더용 토큰 문자열
  String get authorizationHeader {
    return '$tokenType $accessToken';
  }

  /// 토큰 정보를 안전하게 로깅용으로 변환 (민감정보 제거)
  Map<String, dynamic> toSafeLogMap() {
    return {
      'token_type': tokenType,
      'expires_in': expiresIn,
      'expires_at': expiresAt.toIso8601String(),
      'user_id': user.id,
      'user_email': user.email.replaceRange(2, user.email.indexOf('@'), '***'),
      'auth_provider': user.authProvider,
    };
  }
}



extension UserResponseExtension on UserResponse {
  /// 프로필이 완성되었는지 확인
  bool get hasCompleteProfile {
    return displayName.isNotEmpty && 
           isEmailVerified && 
           isProfileComplete;
  }

  /// 신규 사용자인지 확인 (24시간 이내 가입)
  bool get isNewUser {
    if (createdAt == null) return false;
    final createdDate = DateTime.tryParse(createdAt!);
    if (createdDate == null) return false;
    
    final now = DateTime.now();
    final difference = now.difference(createdDate);
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

  /// 마지막 로그인 시간 파싱
  DateTime? get lastLoginDateTime {
    return lastLoginAt != null ? DateTime.tryParse(lastLoginAt!) : null;
  }

  /// 계정 생성 시간 파싱
  DateTime? get createdDateTime {
    return createdAt != null ? DateTime.tryParse(createdAt!) : null;
  }

  /// 안전한 로깅용 맵 (민감정보 제거)
  Map<String, dynamic> toSafeLogMap() {
    return {
      'id': id,
      'email_masked': email.replaceRange(2, email.indexOf('@'), '***'),
      'display_name': displayName,
      'auth_provider': authProvider,
      'is_email_verified': isEmailVerified,
      'is_profile_complete': isProfileComplete,
      'is_active': isActive,
      'created_at': createdAt,
    };
  }
}

extension ApiResponseExtension<T> on ApiResponse<T> {
  /// 성공적이고 데이터가 있는지 확인
  bool get hasData => success && data != null;

  /// 에러 메시지 반환 (에러가 있으면 에러 메시지, 없으면 일반 메시지)
  String? get errorMessage => error?.errorDescription ?? message;

  /// 에러 코드 반환
  String? get errorCode => error?.errorCode;
}

enum UserRole {
  @JsonValue('USER')
  user,

  @JsonValue('ADMIN')
  admin,
}