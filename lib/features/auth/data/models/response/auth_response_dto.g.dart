// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map json) => $checkedCreate(
      r'_$AuthResponseImpl',
      json,
      ($checkedConvert) {
        final val = _$AuthResponseImpl(
          accessToken: $checkedConvert('access_token', (v) => v as String),
          refreshToken: $checkedConvert('refresh_token', (v) => v as String),
          accessExpiresIn: $checkedConvert(
              'access_expires_in', (v) => (v as num?)?.toInt() ?? 3600),
          refreshExpiresIn: $checkedConvert(
              'refresh_expires_in', (v) => (v as num?)?.toInt() ?? 1209600),
          tokenType:
              $checkedConvert('token_type', (v) => v as String? ?? 'Bearer'),
          nickname: $checkedConvert('nickname', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'accessToken': 'access_token',
        'refreshToken': 'refresh_token',
        'accessExpiresIn': 'access_expires_in',
        'refreshExpiresIn': 'refresh_expires_in',
        'tokenType': 'token_type'
      },
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'access_expires_in': instance.accessExpiresIn,
      'refresh_expires_in': instance.refreshExpiresIn,
      'token_type': instance.tokenType,
      'nickname': instance.nickname,
    };
