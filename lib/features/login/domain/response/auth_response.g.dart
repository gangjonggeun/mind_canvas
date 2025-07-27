// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResponseImpl _$$AuthResponseImplFromJson(Map<String, dynamic> json) =>
    _$AuthResponseImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 3600,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      scope: json['scope'] as String?,
      issuedAt: json['issuedAt'] == null
          ? null
          : DateTime.parse(json['issuedAt'] as String),
    );

Map<String, dynamic> _$$AuthResponseImplToJson(_$AuthResponseImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
      'expiresIn': instance.expiresIn,
      'tokenType': instance.tokenType,
      'scope': instance.scope,
      'issuedAt': instance.issuedAt?.toIso8601String(),
    };

_$UserResponseImpl _$$UserResponseImplFromJson(Map<String, dynamic> json) =>
    _$UserResponseImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      authProvider: json['authProvider'] as String,
      lastLoginAt: json['lastLoginAt'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserResponseImplToJson(_$UserResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'profileImageUrl': instance.profileImageUrl,
      'authProvider': instance.authProvider,
      'lastLoginAt': instance.lastLoginAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isEmailVerified': instance.isEmailVerified,
      'isProfileComplete': instance.isProfileComplete,
      'isActive': instance.isActive,
      'metadata': instance.metadata,
    };

_$RefreshTokenResponseImpl _$$RefreshTokenResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RefreshTokenResponseImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 3600,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      issuedAt: json['issuedAt'] == null
          ? null
          : DateTime.parse(json['issuedAt'] as String),
    );

Map<String, dynamic> _$$RefreshTokenResponseImplToJson(
        _$RefreshTokenResponseImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
      'tokenType': instance.tokenType,
      'issuedAt': instance.issuedAt?.toIso8601String(),
    };

_$LogoutResponseImpl _$$LogoutResponseImplFromJson(Map<String, dynamic> json) =>
    _$LogoutResponseImpl(
      success: json['success'] as bool,
      message: json['message'] as String?,
      loggedOutAt: json['loggedOutAt'] == null
          ? null
          : DateTime.parse(json['loggedOutAt'] as String),
    );

Map<String, dynamic> _$$LogoutResponseImplToJson(
        _$LogoutResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'loggedOutAt': instance.loggedOutAt?.toIso8601String(),
    };

_$ErrorResponseImpl _$$ErrorResponseImplFromJson(Map<String, dynamic> json) =>
    _$ErrorResponseImpl(
      error: json['error'] as String,
      errorDescription: json['errorDescription'] as String,
      errorCode: json['errorCode'] as String?,
      errorUri: json['errorUri'] as String?,
      details: json['details'] as Map<String, dynamic>?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$ErrorResponseImplToJson(_$ErrorResponseImpl instance) =>
    <String, dynamic>{
      'error': instance.error,
      'errorDescription': instance.errorDescription,
      'errorCode': instance.errorCode,
      'errorUri': instance.errorUri,
      'details': instance.details,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
