// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmailLoginRequestImpl _$$EmailLoginRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$EmailLoginRequestImpl(
      email: json['email'] as String,
      password: json['password'] as String,
      rememberMe: json['rememberMe'] as bool? ?? false,
      deviceId: json['deviceId'] as String?,
      fcmToken: json['fcmToken'] as String?,
    );

Map<String, dynamic> _$$EmailLoginRequestImplToJson(
        _$EmailLoginRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'rememberMe': instance.rememberMe,
      'deviceId': instance.deviceId,
      'fcmToken': instance.fcmToken,
    };

_$AppleLoginRequestImpl _$$AppleLoginRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AppleLoginRequestImpl(
      identityToken: json['identityToken'] as String,
      authorizationCode: json['authorizationCode'] as String,
      userIdentifier: json['userIdentifier'] as String?,
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      deviceId: json['deviceId'] as String?,
      fcmToken: json['fcmToken'] as String?,
    );

Map<String, dynamic> _$$AppleLoginRequestImplToJson(
        _$AppleLoginRequestImpl instance) =>
    <String, dynamic>{
      'identityToken': instance.identityToken,
      'authorizationCode': instance.authorizationCode,
      'userIdentifier': instance.userIdentifier,
      'email': instance.email,
      'fullName': instance.fullName,
      'deviceId': instance.deviceId,
      'fcmToken': instance.fcmToken,
    };

_$GoogleLoginRequestImpl _$$GoogleLoginRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$GoogleLoginRequestImpl(
      idToken: json['idToken'] as String,
      accessToken: json['accessToken'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      deviceId: json['deviceId'] as String?,
      fcmToken: json['fcmToken'] as String?,
    );

Map<String, dynamic> _$$GoogleLoginRequestImplToJson(
        _$GoogleLoginRequestImpl instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
      'accessToken': instance.accessToken,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'deviceId': instance.deviceId,
      'fcmToken': instance.fcmToken,
    };

_$RefreshTokenRequestImpl _$$RefreshTokenRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RefreshTokenRequestImpl(
      refreshToken: json['refreshToken'] as String,
      deviceId: json['deviceId'] as String?,
    );

Map<String, dynamic> _$$RefreshTokenRequestImplToJson(
        _$RefreshTokenRequestImpl instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
      'deviceId': instance.deviceId,
    };

_$LogoutRequestImpl _$$LogoutRequestImplFromJson(Map<String, dynamic> json) =>
    _$LogoutRequestImpl(
      refreshToken: json['refreshToken'] as String?,
      deviceId: json['deviceId'] as String?,
      logoutFromAllDevices: json['logoutFromAllDevices'] as bool? ?? false,
    );

Map<String, dynamic> _$$LogoutRequestImplToJson(_$LogoutRequestImpl instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
      'deviceId': instance.deviceId,
      'logoutFromAllDevices': instance.logoutFromAllDevices,
    };

_$DeviceInfoRequestImpl _$$DeviceInfoRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$DeviceInfoRequestImpl(
      deviceId: json['deviceId'] as String,
      platform: json['platform'] as String,
      deviceName: json['deviceName'] as String?,
      osVersion: json['osVersion'] as String?,
      appVersion: json['appVersion'] as String?,
      fcmToken: json['fcmToken'] as String?,
    );

Map<String, dynamic> _$$DeviceInfoRequestImplToJson(
        _$DeviceInfoRequestImpl instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'platform': instance.platform,
      'deviceName': instance.deviceName,
      'osVersion': instance.osVersion,
      'appVersion': instance.appVersion,
      'fcmToken': instance.fcmToken,
    };
