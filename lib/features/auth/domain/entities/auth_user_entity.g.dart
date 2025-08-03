// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthUserImpl _$$AuthUserImplFromJson(Map json) => $checkedCreate(
      r'_$AuthUserImpl',
      json,
      ($checkedConvert) {
        final val = _$AuthUserImpl(
          id: $checkedConvert('id', (v) => v as String),
          email: $checkedConvert('email', (v) => v as String?),
          nickname: $checkedConvert('nickname', (v) => v as String?),
          profileImageUrl:
              $checkedConvert('profileImageUrl', (v) => v as String?),
          loginType: $checkedConvert(
              'loginType', (v) => $enumDecode(_$LoginTypeEnumMap, v)),
          isEmailVerified:
              $checkedConvert('isEmailVerified', (v) => v as bool? ?? true),
          isProfileComplete:
              $checkedConvert('isProfileComplete', (v) => v as bool? ?? false),
        );
        return val;
      },
    );

Map<String, dynamic> _$$AuthUserImplToJson(_$AuthUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'loginType': _$LoginTypeEnumMap[instance.loginType]!,
      'isEmailVerified': instance.isEmailVerified,
      'isProfileComplete': instance.isProfileComplete,
    };

const _$LoginTypeEnumMap = {
  LoginType.google: 'google',
  LoginType.apple: 'apple',
  LoginType.guest: 'guest',
};
