// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthUserImpl _$$AuthUserImplFromJson(Map<String, dynamic> json) =>
    _$AuthUserImpl(
      id: json['id'] as String,
      email: json['email'] as String?,
      nickname: json['nickname'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      authProvider: $enumDecode(_$AuthProviderEnumMap, json['authProvider']),
      isEmailVerified: json['isEmailVerified'] as bool? ?? true,
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
    );

Map<String, dynamic> _$$AuthUserImplToJson(_$AuthUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'authProvider': _$AuthProviderEnumMap[instance.authProvider]!,
      'isEmailVerified': instance.isEmailVerified,
      'isProfileComplete': instance.isProfileComplete,
    };

const _$AuthProviderEnumMap = {
  AuthProvider.email: 'email',
  AuthProvider.google: 'google',
  AuthProvider.apple: 'apple',
  AuthProvider.anonymous: 'anonymous',
};
