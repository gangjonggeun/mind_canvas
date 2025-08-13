// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SetupProfileResponseImpl _$$SetupProfileResponseImplFromJson(Map json) =>
    $checkedCreate(
      r'_$SetupProfileResponseImpl',
      json,
      ($checkedConvert) {
        final val = _$SetupProfileResponseImpl(
          nickname: $checkedConvert('nickname', (v) => v as String),
          profileImageUrl:
              $checkedConvert('profileImageUrl', (v) => v as String?),
          isProfileComplete:
              $checkedConvert('isProfileComplete', (v) => v as bool),
          updatedAt: $checkedConvert('updatedAt', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$$SetupProfileResponseImplToJson(
        _$SetupProfileResponseImpl instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'isProfileComplete': instance.isProfileComplete,
      'updatedAt': instance.updatedAt,
    };
