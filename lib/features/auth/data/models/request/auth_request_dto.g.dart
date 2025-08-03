// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoogleLoginRequestImpl _$$GoogleLoginRequestImplFromJson(Map json) =>
    $checkedCreate(
      r'_$GoogleLoginRequestImpl',
      json,
      ($checkedConvert) {
        final val = _$GoogleLoginRequestImpl(
          idToken: $checkedConvert('id_token', (v) => v as String),
          deviceId: $checkedConvert('device_id', (v) => v as String?),
          fcmToken: $checkedConvert('fcm_token', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'idToken': 'id_token',
        'deviceId': 'device_id',
        'fcmToken': 'fcm_token'
      },
    );

Map<String, dynamic> _$$GoogleLoginRequestImplToJson(
        _$GoogleLoginRequestImpl instance) =>
    <String, dynamic>{
      'id_token': instance.idToken,
      'device_id': instance.deviceId,
      'fcm_token': instance.fcmToken,
    };

_$AppleLoginRequestImpl _$$AppleLoginRequestImplFromJson(Map json) =>
    $checkedCreate(
      r'_$AppleLoginRequestImpl',
      json,
      ($checkedConvert) {
        final val = _$AppleLoginRequestImpl(
          idToken: $checkedConvert('idToken', (v) => v as String),
          deviceId: $checkedConvert('deviceId', (v) => v as String?),
          fcmToken: $checkedConvert('fcmToken', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$$AppleLoginRequestImplToJson(
        _$AppleLoginRequestImpl instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
      'deviceId': instance.deviceId,
      'fcmToken': instance.fcmToken,
    };

_$RefreshTokenRequestImpl _$$RefreshTokenRequestImplFromJson(Map json) =>
    $checkedCreate(
      r'_$RefreshTokenRequestImpl',
      json,
      ($checkedConvert) {
        final val = _$RefreshTokenRequestImpl(
          refreshToken: $checkedConvert('refreshToken', (v) => v as String),
          deviceId: $checkedConvert('deviceId', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$$RefreshTokenRequestImplToJson(
        _$RefreshTokenRequestImpl instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
      'deviceId': instance.deviceId,
    };

_$LogoutRequestImpl _$$LogoutRequestImplFromJson(Map json) => $checkedCreate(
      r'_$LogoutRequestImpl',
      json,
      ($checkedConvert) {
        final val = _$LogoutRequestImpl(
          refreshToken: $checkedConvert('refreshToken', (v) => v as String?),
          deviceId: $checkedConvert('deviceId', (v) => v as String?),
          logoutFromAllDevices: $checkedConvert(
              'logoutFromAllDevices', (v) => v as bool? ?? false),
        );
        return val;
      },
    );

Map<String, dynamic> _$$LogoutRequestImplToJson(_$LogoutRequestImpl instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
      'deviceId': instance.deviceId,
      'logoutFromAllDevices': instance.logoutFromAllDevices,
    };

_$DeviceInfoRequestImpl _$$DeviceInfoRequestImplFromJson(Map json) =>
    $checkedCreate(
      r'_$DeviceInfoRequestImpl',
      json,
      ($checkedConvert) {
        final val = _$DeviceInfoRequestImpl(
          deviceId: $checkedConvert('deviceId', (v) => v as String),
          platform: $checkedConvert('platform', (v) => v as String),
          deviceName: $checkedConvert('deviceName', (v) => v as String?),
          osVersion: $checkedConvert('osVersion', (v) => v as String?),
          appVersion: $checkedConvert('appVersion', (v) => v as String?),
          fcmToken: $checkedConvert('fcmToken', (v) => v as String?),
        );
        return val;
      },
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
