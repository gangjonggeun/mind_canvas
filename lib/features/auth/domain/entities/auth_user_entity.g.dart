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
          userId: $checkedConvert('user_id', (v) => (v as num).toInt()),
          nickname: $checkedConvert('nickname', (v) => v as String?),
          loginType: $checkedConvert(
              'login_type', (v) => $enumDecode(_$LoginTypeEnumMap, v)),
        );
        return val;
      },
      fieldKeyMap: const {'userId': 'user_id', 'loginType': 'login_type'},
    );

Map<String, dynamic> _$$AuthUserImplToJson(_$AuthUserImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'nickname': instance.nickname,
      'login_type': _$LoginTypeEnumMap[instance.loginType]!,
    };

const _$LoginTypeEnumMap = {
  LoginType.google: 'GOOGLE',
  LoginType.apple: 'APPLE',
  LoginType.guest: 'GUEST',
};
