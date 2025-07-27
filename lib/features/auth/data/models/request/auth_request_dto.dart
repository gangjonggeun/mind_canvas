import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_request_dto.freezed.dart';
part 'auth_request_dto.g.dart';




/// 🍎 Apple 로그인 요청 DTO
@freezed
class AppleLoginRequest with _$AppleLoginRequest {
  const factory AppleLoginRequest({
    required String identityToken,
    required String authorizationCode,
    String? userIdentifier,
    String? email,
    String? fullName,
    String? deviceId,
    String? fcmToken,
  }) = _AppleLoginRequest;

  factory AppleLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$AppleLoginRequestFromJson(json);
}

/// 🌐 Google 로그인 요청 DTO
@freezed
class GoogleLoginRequest with _$GoogleLoginRequest {
  const factory GoogleLoginRequest({
    required String idToken,
    required String accessToken,
    String? email,
    String? displayName,
    String? photoUrl,
    String? deviceId,
    String? fcmToken,
  }) = _GoogleLoginRequest;

  factory GoogleLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$GoogleLoginRequestFromJson(json);
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


extension AppleLoginRequestExtension on AppleLoginRequest {
  /// Apple 로그인 유효성 검사
  bool get isValid {
    return identityToken.isNotEmpty && authorizationCode.isNotEmpty;
  }

  /// API 전송용 Map으로 변환
  Map<String, dynamic> toApiJson() {
    return {
      'identity_token': identityToken,
      'authorization_code': authorizationCode,
      if (userIdentifier != null) 'user_identifier': userIdentifier,
      if (email != null) 'email': email,
      if (fullName != null) 'full_name': fullName,
      if (deviceId != null) 'device_id': deviceId,
      if (fcmToken != null) 'fcm_token': fcmToken,
    };
  }
}

extension GoogleLoginRequestExtension on GoogleLoginRequest {
  /// Google 로그인 유효성 검사
  bool get isValid {
    return idToken.isNotEmpty && accessToken.isNotEmpty;
  }

  /// API 전송용 Map으로 변환
  Map<String, dynamic> toApiJson() {
    return {
      'id_token': idToken,
      'access_token': accessToken,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (deviceId != null) 'device_id': deviceId,
      if (fcmToken != null) 'fcm_token': fcmToken,
    };
  }
}
