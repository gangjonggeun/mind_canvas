import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_request_dto.freezed.dart';

part 'auth_request_dto.g.dart';

/// 🌐 Google 로그인 요청 DTO - 간소화
@freezed
class GoogleLoginRequest with _$GoogleLoginRequest {
  const factory GoogleLoginRequest({
    @JsonKey(name: 'id_token') required String idToken,
    @JsonKey(name: 'device_id') String? deviceId,
    @JsonKey(name: 'fcm_token') String? fcmToken,
  }) = _GoogleLoginRequest;

  factory GoogleLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$GoogleLoginRequestFromJson(json);
}

/// 🍎 Apple 로그인 요청 DTO
@freezed
class AppleLoginRequest with _$AppleLoginRequest {
  const factory AppleLoginRequest({
    required String idToken, // 🔑 핵심! 서버에서 검증할 토큰
    String? deviceId, // 📱 기기 식별 (선택)
    String? fcmToken,
  }) = _AppleLoginRequest;

  factory AppleLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$AppleLoginRequestFromJson(json);
}

/// 🔄 토큰 갱신 요청 DTO
@freezed
class RefreshTokenRequest with _$RefreshTokenRequest {
  const factory RefreshTokenRequest({
    required String refreshToken,
    String? deviceId,
  }) = _RefreshTokenRequest;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);
}

/// 🚪 로그아웃 요청 DTO
@freezed
class LogoutRequest with _$LogoutRequest {
  const factory LogoutRequest({
    String? refreshToken,
    String? deviceId,
    @Default(false) bool logoutFromAllDevices,
  }) = _LogoutRequest;

  factory LogoutRequest.fromJson(Map<String, dynamic> json) =>
      _$LogoutRequestFromJson(json);
}

/// 📱 기기 정보 DTO
@freezed
class DeviceInfoRequest with _$DeviceInfoRequest {
  const factory DeviceInfoRequest({
    required String deviceId,
    required String platform,
    String? deviceName,
    String? osVersion,
    String? appVersion,
    String? fcmToken,
  }) = _DeviceInfoRequest;

  factory DeviceInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoRequestFromJson(json);
}

// Extension 메서드들
extension GoogleLoginRequestExtension on GoogleLoginRequest {
  /// Google 로그인 유효성 검사
  bool get isValid {
    return idToken.isNotEmpty;
  }

}

extension AppleLoginRequestExtension on AppleLoginRequest {
  /// apple 로그인 유효성 검사
  bool get isValid {
    return idToken.isNotEmpty;
  }

  /// API 전송용 Map으로 변환
  Map<String, dynamic> toApiJson() {
    return {
      'id_token': idToken,
      if (deviceId != null) 'device_id': deviceId,
      if (fcmToken != null) 'fcm_token': fcmToken,
    };
  }
}
