// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_profile_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SetupProfileRequestImpl _$$SetupProfileRequestImplFromJson(Map json) =>
    $checkedCreate(
      r'_$SetupProfileRequestImpl',
      json,
      ($checkedConvert) {
        final val = _$SetupProfileRequestImpl(
          nickname: $checkedConvert('nickname', (v) => v as String),
          profileImageUrl:
              $checkedConvert('profileImageUrl', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$$SetupProfileRequestImplToJson(
        _$SetupProfileRequestImpl instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
    };
