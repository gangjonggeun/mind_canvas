import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_request.freezed.dart';
part 'auth_request.g.dart';

/// 📧 이메일 로그인 요청 DTO
@freezed
class EmailLoginRequest with _$EmailLoginRequest {
  const factory EmailLoginRequest({
    required String email,
    required String password,
    @Default(false) bool rememberMe,
    String? deviceId,
    String? fcmToken,
  }) = _EmailLoginRequest;

  factory EmailLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$EmailLoginRequestFromJson(json);
}

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

/// 🎯 Request DTO 확장 메서드들
extension EmailLoginRequestExtension on EmailLoginRequest {
  /// 유효성 검사
  bool get isValid {
    return email.isNotEmpty && 
           email.contains('@') && 
           password.length >= 6;
  }

  /// 이메일 형식 검사
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// API 전송용 Map으로 변환
  Map<String, dynamic> toApiJson() {
    return {
      'email': email.trim().toLowerCase(),
      'password': password,
      'remember_me': rememberMe,
      if (deviceId != null) 'device_id': deviceId,
      if (fcmToken != null) 'fcm_token': fcmToken,
    };
  }
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
