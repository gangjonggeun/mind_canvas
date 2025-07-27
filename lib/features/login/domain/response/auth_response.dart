import 'package:freezed_annotation/freezed_annotation.dart';

part '../response/auth_response.freezed.dart';
part '../response/auth_response.g.dart';

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

/// ❌ 에러 응답 DTO
@freezed
class ErrorResponse with _$ErrorResponse {
  const factory ErrorResponse({
    required String error,
    required String errorDescription,
    String? errorCode,
    String? errorUri,
    Map<String, dynamic>? details,
    DateTime? timestamp,
  }) = _ErrorResponse;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
}

/// 📊 API 응답 래퍼 DTO
@freezed
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool success,
    T? data,
    String? message,
    ErrorResponse? error,
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
  }) = _ApiResponse<T>;

  // 🔄 제네릭 타입 때문에 fromJson 제거
  // 대신 각 타입별로 팩토리 메서드 사용
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

/// 🎯 ApiResponse 팩토리 메서드들
/// 
/// 제네릭 타입별로 안전한 생성자 제공
class ApiResponseFactory {
  /// AuthResponse용 팩토리
  static ApiResponse<AuthResponse> forAuth(Map<String, dynamic> json) {
    return ApiResponse<AuthResponse>(
      success: json['success'] ?? false,
      data: json['data'] != null ? AuthResponse.fromJson(json['data']) : null,
      message: json['message'],
      error: json['error'] != null ? ErrorResponse.fromJson(json['error']) : null,
      metadata: json['metadata'],
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
  }

  /// UserResponse용 팩토리
  static ApiResponse<UserResponse> forUser(Map<String, dynamic> json) {
    return ApiResponse<UserResponse>(
      success: json['success'] ?? false,
      data: json['data'] != null ? UserResponse.fromJson(json['data']) : null,
      message: json['message'],
      error: json['error'] != null ? ErrorResponse.fromJson(json['error']) : null,
      metadata: json['metadata'],
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
  }

  /// RefreshTokenResponse용 팩토리
  static ApiResponse<RefreshTokenResponse> forRefreshToken(Map<String, dynamic> json) {
    return ApiResponse<RefreshTokenResponse>(
      success: json['success'] ?? false,
      data: json['data'] != null ? RefreshTokenResponse.fromJson(json['data']) : null,
      message: json['message'],
      error: json['error'] != null ? ErrorResponse.fromJson(json['error']) : null,
      metadata: json['metadata'],
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
  }

  /// 제네릭 팩토리 (커스텀 fromJson 함수 사용)
  static ApiResponse<T> generic<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'],
      error: json['error'] != null ? ErrorResponse.fromJson(json['error']) : null,
      metadata: json['metadata'],
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
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
