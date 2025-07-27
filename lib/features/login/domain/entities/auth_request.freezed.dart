// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EmailLoginRequest _$EmailLoginRequestFromJson(Map<String, dynamic> json) {
  return _EmailLoginRequest.fromJson(json);
}

/// @nodoc
mixin _$EmailLoginRequest {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  bool get rememberMe => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;

  /// Serializes this EmailLoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmailLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmailLoginRequestCopyWith<EmailLoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmailLoginRequestCopyWith<$Res> {
  factory $EmailLoginRequestCopyWith(
          EmailLoginRequest value, $Res Function(EmailLoginRequest) then) =
      _$EmailLoginRequestCopyWithImpl<$Res, EmailLoginRequest>;
  @useResult
  $Res call(
      {String email,
      String password,
      bool rememberMe,
      String? deviceId,
      String? fcmToken});
}

/// @nodoc
class _$EmailLoginRequestCopyWithImpl<$Res, $Val extends EmailLoginRequest>
    implements $EmailLoginRequestCopyWith<$Res> {
  _$EmailLoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmailLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? rememberMe = null,
    Object? deviceId = freezed,
    Object? fcmToken = freezed,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      rememberMe: null == rememberMe
          ? _value.rememberMe
          : rememberMe // ignore: cast_nullable_to_non_nullable
              as bool,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmailLoginRequestImplCopyWith<$Res>
    implements $EmailLoginRequestCopyWith<$Res> {
  factory _$$EmailLoginRequestImplCopyWith(_$EmailLoginRequestImpl value,
          $Res Function(_$EmailLoginRequestImpl) then) =
      __$$EmailLoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email,
      String password,
      bool rememberMe,
      String? deviceId,
      String? fcmToken});
}

/// @nodoc
class __$$EmailLoginRequestImplCopyWithImpl<$Res>
    extends _$EmailLoginRequestCopyWithImpl<$Res, _$EmailLoginRequestImpl>
    implements _$$EmailLoginRequestImplCopyWith<$Res> {
  __$$EmailLoginRequestImplCopyWithImpl(_$EmailLoginRequestImpl _value,
      $Res Function(_$EmailLoginRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmailLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? rememberMe = null,
    Object? deviceId = freezed,
    Object? fcmToken = freezed,
  }) {
    return _then(_$EmailLoginRequestImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      rememberMe: null == rememberMe
          ? _value.rememberMe
          : rememberMe // ignore: cast_nullable_to_non_nullable
              as bool,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmailLoginRequestImpl implements _EmailLoginRequest {
  const _$EmailLoginRequestImpl(
      {required this.email,
      required this.password,
      this.rememberMe = false,
      this.deviceId,
      this.fcmToken});

  factory _$EmailLoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmailLoginRequestImplFromJson(json);

  @override
  final String email;
  @override
  final String password;
  @override
  @JsonKey()
  final bool rememberMe;
  @override
  final String? deviceId;
  @override
  final String? fcmToken;

  @override
  String toString() {
    return 'EmailLoginRequest(email: $email, password: $password, rememberMe: $rememberMe, deviceId: $deviceId, fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailLoginRequestImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.rememberMe, rememberMe) ||
                other.rememberMe == rememberMe) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, password, rememberMe, deviceId, fcmToken);

  /// Create a copy of EmailLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmailLoginRequestImplCopyWith<_$EmailLoginRequestImpl> get copyWith =>
      __$$EmailLoginRequestImplCopyWithImpl<_$EmailLoginRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmailLoginRequestImplToJson(
      this,
    );
  }
}

abstract class _EmailLoginRequest implements EmailLoginRequest {
  const factory _EmailLoginRequest(
      {required final String email,
      required final String password,
      final bool rememberMe,
      final String? deviceId,
      final String? fcmToken}) = _$EmailLoginRequestImpl;

  factory _EmailLoginRequest.fromJson(Map<String, dynamic> json) =
      _$EmailLoginRequestImpl.fromJson;

  @override
  String get email;
  @override
  String get password;
  @override
  bool get rememberMe;
  @override
  String? get deviceId;
  @override
  String? get fcmToken;

  /// Create a copy of EmailLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmailLoginRequestImplCopyWith<_$EmailLoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppleLoginRequest _$AppleLoginRequestFromJson(Map<String, dynamic> json) {
  return _AppleLoginRequest.fromJson(json);
}

/// @nodoc
mixin _$AppleLoginRequest {
  String get identityToken => throw _privateConstructorUsedError;
  String get authorizationCode => throw _privateConstructorUsedError;
  String? get userIdentifier => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get fullName => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;

  /// Serializes this AppleLoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppleLoginRequestCopyWith<AppleLoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppleLoginRequestCopyWith<$Res> {
  factory $AppleLoginRequestCopyWith(
          AppleLoginRequest value, $Res Function(AppleLoginRequest) then) =
      _$AppleLoginRequestCopyWithImpl<$Res, AppleLoginRequest>;
  @useResult
  $Res call(
      {String identityToken,
      String authorizationCode,
      String? userIdentifier,
      String? email,
      String? fullName,
      String? deviceId,
      String? fcmToken});
}

/// @nodoc
class _$AppleLoginRequestCopyWithImpl<$Res, $Val extends AppleLoginRequest>
    implements $AppleLoginRequestCopyWith<$Res> {
  _$AppleLoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identityToken = null,
    Object? authorizationCode = null,
    Object? userIdentifier = freezed,
    Object? email = freezed,
    Object? fullName = freezed,
    Object? deviceId = freezed,
    Object? fcmToken = freezed,
  }) {
    return _then(_value.copyWith(
      identityToken: null == identityToken
          ? _value.identityToken
          : identityToken // ignore: cast_nullable_to_non_nullable
              as String,
      authorizationCode: null == authorizationCode
          ? _value.authorizationCode
          : authorizationCode // ignore: cast_nullable_to_non_nullable
              as String,
      userIdentifier: freezed == userIdentifier
          ? _value.userIdentifier
          : userIdentifier // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppleLoginRequestImplCopyWith<$Res>
    implements $AppleLoginRequestCopyWith<$Res> {
  factory _$$AppleLoginRequestImplCopyWith(_$AppleLoginRequestImpl value,
          $Res Function(_$AppleLoginRequestImpl) then) =
      __$$AppleLoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String identityToken,
      String authorizationCode,
      String? userIdentifier,
      String? email,
      String? fullName,
      String? deviceId,
      String? fcmToken});
}

/// @nodoc
class __$$AppleLoginRequestImplCopyWithImpl<$Res>
    extends _$AppleLoginRequestCopyWithImpl<$Res, _$AppleLoginRequestImpl>
    implements _$$AppleLoginRequestImplCopyWith<$Res> {
  __$$AppleLoginRequestImplCopyWithImpl(_$AppleLoginRequestImpl _value,
      $Res Function(_$AppleLoginRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identityToken = null,
    Object? authorizationCode = null,
    Object? userIdentifier = freezed,
    Object? email = freezed,
    Object? fullName = freezed,
    Object? deviceId = freezed,
    Object? fcmToken = freezed,
  }) {
    return _then(_$AppleLoginRequestImpl(
      identityToken: null == identityToken
          ? _value.identityToken
          : identityToken // ignore: cast_nullable_to_non_nullable
              as String,
      authorizationCode: null == authorizationCode
          ? _value.authorizationCode
          : authorizationCode // ignore: cast_nullable_to_non_nullable
              as String,
      userIdentifier: freezed == userIdentifier
          ? _value.userIdentifier
          : userIdentifier // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppleLoginRequestImpl implements _AppleLoginRequest {
  const _$AppleLoginRequestImpl(
      {required this.identityToken,
      required this.authorizationCode,
      this.userIdentifier,
      this.email,
      this.fullName,
      this.deviceId,
      this.fcmToken});

  factory _$AppleLoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppleLoginRequestImplFromJson(json);

  @override
  final String identityToken;
  @override
  final String authorizationCode;
  @override
  final String? userIdentifier;
  @override
  final String? email;
  @override
  final String? fullName;
  @override
  final String? deviceId;
  @override
  final String? fcmToken;

  @override
  String toString() {
    return 'AppleLoginRequest(identityToken: $identityToken, authorizationCode: $authorizationCode, userIdentifier: $userIdentifier, email: $email, fullName: $fullName, deviceId: $deviceId, fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppleLoginRequestImpl &&
            (identical(other.identityToken, identityToken) ||
                other.identityToken == identityToken) &&
            (identical(other.authorizationCode, authorizationCode) ||
                other.authorizationCode == authorizationCode) &&
            (identical(other.userIdentifier, userIdentifier) ||
                other.userIdentifier == userIdentifier) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, identityToken, authorizationCode,
      userIdentifier, email, fullName, deviceId, fcmToken);

  /// Create a copy of AppleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppleLoginRequestImplCopyWith<_$AppleLoginRequestImpl> get copyWith =>
      __$$AppleLoginRequestImplCopyWithImpl<_$AppleLoginRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppleLoginRequestImplToJson(
      this,
    );
  }
}

abstract class _AppleLoginRequest implements AppleLoginRequest {
  const factory _AppleLoginRequest(
      {required final String identityToken,
      required final String authorizationCode,
      final String? userIdentifier,
      final String? email,
      final String? fullName,
      final String? deviceId,
      final String? fcmToken}) = _$AppleLoginRequestImpl;

  factory _AppleLoginRequest.fromJson(Map<String, dynamic> json) =
      _$AppleLoginRequestImpl.fromJson;

  @override
  String get identityToken;
  @override
  String get authorizationCode;
  @override
  String? get userIdentifier;
  @override
  String? get email;
  @override
  String? get fullName;
  @override
  String? get deviceId;
  @override
  String? get fcmToken;

  /// Create a copy of AppleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppleLoginRequestImplCopyWith<_$AppleLoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GoogleLoginRequest _$GoogleLoginRequestFromJson(Map<String, dynamic> json) {
  return _GoogleLoginRequest.fromJson(json);
}

/// @nodoc
mixin _$GoogleLoginRequest {
  String get idToken => throw _privateConstructorUsedError;
  String get accessToken => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;

  /// Serializes this GoogleLoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GoogleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GoogleLoginRequestCopyWith<GoogleLoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoogleLoginRequestCopyWith<$Res> {
  factory $GoogleLoginRequestCopyWith(
          GoogleLoginRequest value, $Res Function(GoogleLoginRequest) then) =
      _$GoogleLoginRequestCopyWithImpl<$Res, GoogleLoginRequest>;
  @useResult
  $Res call(
      {String idToken,
      String accessToken,
      String? email,
      String? displayName,
      String? photoUrl,
      String? deviceId,
      String? fcmToken});
}

/// @nodoc
class _$GoogleLoginRequestCopyWithImpl<$Res, $Val extends GoogleLoginRequest>
    implements $GoogleLoginRequestCopyWith<$Res> {
  _$GoogleLoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoogleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idToken = null,
    Object? accessToken = null,
    Object? email = freezed,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? deviceId = freezed,
    Object? fcmToken = freezed,
  }) {
    return _then(_value.copyWith(
      idToken: null == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GoogleLoginRequestImplCopyWith<$Res>
    implements $GoogleLoginRequestCopyWith<$Res> {
  factory _$$GoogleLoginRequestImplCopyWith(_$GoogleLoginRequestImpl value,
          $Res Function(_$GoogleLoginRequestImpl) then) =
      __$$GoogleLoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String idToken,
      String accessToken,
      String? email,
      String? displayName,
      String? photoUrl,
      String? deviceId,
      String? fcmToken});
}

/// @nodoc
class __$$GoogleLoginRequestImplCopyWithImpl<$Res>
    extends _$GoogleLoginRequestCopyWithImpl<$Res, _$GoogleLoginRequestImpl>
    implements _$$GoogleLoginRequestImplCopyWith<$Res> {
  __$$GoogleLoginRequestImplCopyWithImpl(_$GoogleLoginRequestImpl _value,
      $Res Function(_$GoogleLoginRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoogleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idToken = null,
    Object? accessToken = null,
    Object? email = freezed,
    Object? displayName = freezed,
    Object? photoUrl = freezed,
    Object? deviceId = freezed,
    Object? fcmToken = freezed,
  }) {
    return _then(_$GoogleLoginRequestImpl(
      idToken: null == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String,
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoogleLoginRequestImpl implements _GoogleLoginRequest {
  const _$GoogleLoginRequestImpl(
      {required this.idToken,
      required this.accessToken,
      this.email,
      this.displayName,
      this.photoUrl,
      this.deviceId,
      this.fcmToken});

  factory _$GoogleLoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoogleLoginRequestImplFromJson(json);

  @override
  final String idToken;
  @override
  final String accessToken;
  @override
  final String? email;
  @override
  final String? displayName;
  @override
  final String? photoUrl;
  @override
  final String? deviceId;
  @override
  final String? fcmToken;

  @override
  String toString() {
    return 'GoogleLoginRequest(idToken: $idToken, accessToken: $accessToken, email: $email, displayName: $displayName, photoUrl: $photoUrl, deviceId: $deviceId, fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoogleLoginRequestImpl &&
            (identical(other.idToken, idToken) || other.idToken == idToken) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, idToken, accessToken, email,
      displayName, photoUrl, deviceId, fcmToken);

  /// Create a copy of GoogleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoogleLoginRequestImplCopyWith<_$GoogleLoginRequestImpl> get copyWith =>
      __$$GoogleLoginRequestImplCopyWithImpl<_$GoogleLoginRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoogleLoginRequestImplToJson(
      this,
    );
  }
}

abstract class _GoogleLoginRequest implements GoogleLoginRequest {
  const factory _GoogleLoginRequest(
      {required final String idToken,
      required final String accessToken,
      final String? email,
      final String? displayName,
      final String? photoUrl,
      final String? deviceId,
      final String? fcmToken}) = _$GoogleLoginRequestImpl;

  factory _GoogleLoginRequest.fromJson(Map<String, dynamic> json) =
      _$GoogleLoginRequestImpl.fromJson;

  @override
  String get idToken;
  @override
  String get accessToken;
  @override
  String? get email;
  @override
  String? get displayName;
  @override
  String? get photoUrl;
  @override
  String? get deviceId;
  @override
  String? get fcmToken;

  /// Create a copy of GoogleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoogleLoginRequestImplCopyWith<_$GoogleLoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) {
  return _RefreshTokenRequest.fromJson(json);
}

/// @nodoc
mixin _$RefreshTokenRequest {
  String get refreshToken => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;

  /// Serializes this RefreshTokenRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RefreshTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefreshTokenRequestCopyWith<RefreshTokenRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefreshTokenRequestCopyWith<$Res> {
  factory $RefreshTokenRequestCopyWith(
          RefreshTokenRequest value, $Res Function(RefreshTokenRequest) then) =
      _$RefreshTokenRequestCopyWithImpl<$Res, RefreshTokenRequest>;
  @useResult
  $Res call({String refreshToken, String? deviceId});
}

/// @nodoc
class _$RefreshTokenRequestCopyWithImpl<$Res, $Val extends RefreshTokenRequest>
    implements $RefreshTokenRequestCopyWith<$Res> {
  _$RefreshTokenRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefreshTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refreshToken = null,
    Object? deviceId = freezed,
  }) {
    return _then(_value.copyWith(
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefreshTokenRequestImplCopyWith<$Res>
    implements $RefreshTokenRequestCopyWith<$Res> {
  factory _$$RefreshTokenRequestImplCopyWith(_$RefreshTokenRequestImpl value,
          $Res Function(_$RefreshTokenRequestImpl) then) =
      __$$RefreshTokenRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String refreshToken, String? deviceId});
}

/// @nodoc
class __$$RefreshTokenRequestImplCopyWithImpl<$Res>
    extends _$RefreshTokenRequestCopyWithImpl<$Res, _$RefreshTokenRequestImpl>
    implements _$$RefreshTokenRequestImplCopyWith<$Res> {
  __$$RefreshTokenRequestImplCopyWithImpl(_$RefreshTokenRequestImpl _value,
      $Res Function(_$RefreshTokenRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of RefreshTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refreshToken = null,
    Object? deviceId = freezed,
  }) {
    return _then(_$RefreshTokenRequestImpl(
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RefreshTokenRequestImpl implements _RefreshTokenRequest {
  const _$RefreshTokenRequestImpl({required this.refreshToken, this.deviceId});

  factory _$RefreshTokenRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefreshTokenRequestImplFromJson(json);

  @override
  final String refreshToken;
  @override
  final String? deviceId;

  @override
  String toString() {
    return 'RefreshTokenRequest(refreshToken: $refreshToken, deviceId: $deviceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshTokenRequestImpl &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, refreshToken, deviceId);

  /// Create a copy of RefreshTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshTokenRequestImplCopyWith<_$RefreshTokenRequestImpl> get copyWith =>
      __$$RefreshTokenRequestImplCopyWithImpl<_$RefreshTokenRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefreshTokenRequestImplToJson(
      this,
    );
  }
}

abstract class _RefreshTokenRequest implements RefreshTokenRequest {
  const factory _RefreshTokenRequest(
      {required final String refreshToken,
      final String? deviceId}) = _$RefreshTokenRequestImpl;

  factory _RefreshTokenRequest.fromJson(Map<String, dynamic> json) =
      _$RefreshTokenRequestImpl.fromJson;

  @override
  String get refreshToken;
  @override
  String? get deviceId;

  /// Create a copy of RefreshTokenRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshTokenRequestImplCopyWith<_$RefreshTokenRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LogoutRequest _$LogoutRequestFromJson(Map<String, dynamic> json) {
  return _LogoutRequest.fromJson(json);
}

/// @nodoc
mixin _$LogoutRequest {
  String? get refreshToken => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  bool get logoutFromAllDevices => throw _privateConstructorUsedError;

  /// Serializes this LogoutRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LogoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogoutRequestCopyWith<LogoutRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogoutRequestCopyWith<$Res> {
  factory $LogoutRequestCopyWith(
          LogoutRequest value, $Res Function(LogoutRequest) then) =
      _$LogoutRequestCopyWithImpl<$Res, LogoutRequest>;
  @useResult
  $Res call(
      {String? refreshToken, String? deviceId, bool logoutFromAllDevices});
}

/// @nodoc
class _$LogoutRequestCopyWithImpl<$Res, $Val extends LogoutRequest>
    implements $LogoutRequestCopyWith<$Res> {
  _$LogoutRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refreshToken = freezed,
    Object? deviceId = freezed,
    Object? logoutFromAllDevices = null,
  }) {
    return _then(_value.copyWith(
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      logoutFromAllDevices: null == logoutFromAllDevices
          ? _value.logoutFromAllDevices
          : logoutFromAllDevices // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LogoutRequestImplCopyWith<$Res>
    implements $LogoutRequestCopyWith<$Res> {
  factory _$$LogoutRequestImplCopyWith(
          _$LogoutRequestImpl value, $Res Function(_$LogoutRequestImpl) then) =
      __$$LogoutRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? refreshToken, String? deviceId, bool logoutFromAllDevices});
}

/// @nodoc
class __$$LogoutRequestImplCopyWithImpl<$Res>
    extends _$LogoutRequestCopyWithImpl<$Res, _$LogoutRequestImpl>
    implements _$$LogoutRequestImplCopyWith<$Res> {
  __$$LogoutRequestImplCopyWithImpl(
      _$LogoutRequestImpl _value, $Res Function(_$LogoutRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of LogoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? refreshToken = freezed,
    Object? deviceId = freezed,
    Object? logoutFromAllDevices = null,
  }) {
    return _then(_$LogoutRequestImpl(
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      logoutFromAllDevices: null == logoutFromAllDevices
          ? _value.logoutFromAllDevices
          : logoutFromAllDevices // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LogoutRequestImpl implements _LogoutRequest {
  const _$LogoutRequestImpl(
      {this.refreshToken, this.deviceId, this.logoutFromAllDevices = false});

  factory _$LogoutRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LogoutRequestImplFromJson(json);

  @override
  final String? refreshToken;
  @override
  final String? deviceId;
  @override
  @JsonKey()
  final bool logoutFromAllDevices;

  @override
  String toString() {
    return 'LogoutRequest(refreshToken: $refreshToken, deviceId: $deviceId, logoutFromAllDevices: $logoutFromAllDevices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogoutRequestImpl &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.logoutFromAllDevices, logoutFromAllDevices) ||
                other.logoutFromAllDevices == logoutFromAllDevices));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, refreshToken, deviceId, logoutFromAllDevices);

  /// Create a copy of LogoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogoutRequestImplCopyWith<_$LogoutRequestImpl> get copyWith =>
      __$$LogoutRequestImplCopyWithImpl<_$LogoutRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LogoutRequestImplToJson(
      this,
    );
  }
}

abstract class _LogoutRequest implements LogoutRequest {
  const factory _LogoutRequest(
      {final String? refreshToken,
      final String? deviceId,
      final bool logoutFromAllDevices}) = _$LogoutRequestImpl;

  factory _LogoutRequest.fromJson(Map<String, dynamic> json) =
      _$LogoutRequestImpl.fromJson;

  @override
  String? get refreshToken;
  @override
  String? get deviceId;
  @override
  bool get logoutFromAllDevices;

  /// Create a copy of LogoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogoutRequestImplCopyWith<_$LogoutRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeviceInfoRequest _$DeviceInfoRequestFromJson(Map<String, dynamic> json) {
  return _DeviceInfoRequest.fromJson(json);
}

/// @nodoc
mixin _$DeviceInfoRequest {
  String get deviceId => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  String? get deviceName => throw _privateConstructorUsedError;
  String? get osVersion => throw _privateConstructorUsedError;
  String? get appVersion => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;

  /// Serializes this DeviceInfoRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeviceInfoRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeviceInfoRequestCopyWith<DeviceInfoRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceInfoRequestCopyWith<$Res> {
  factory $DeviceInfoRequestCopyWith(
          DeviceInfoRequest value, $Res Function(DeviceInfoRequest) then) =
      _$DeviceInfoRequestCopyWithImpl<$Res, DeviceInfoRequest>;
  @useResult
  $Res call(
      {String deviceId,
      String platform,
      String? deviceName,
      String? osVersion,
      String? appVersion,
      String? fcmToken});
}

/// @nodoc
class _$DeviceInfoRequestCopyWithImpl<$Res, $Val extends DeviceInfoRequest>
    implements $DeviceInfoRequestCopyWith<$Res> {
  _$DeviceInfoRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceInfoRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? platform = null,
    Object? deviceName = freezed,
    Object? osVersion = freezed,
    Object? appVersion = freezed,
    Object? fcmToken = freezed,
  }) {
    return _then(_value.copyWith(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: freezed == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      osVersion: freezed == osVersion
          ? _value.osVersion
          : osVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      appVersion: freezed == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceInfoRequestImplCopyWith<$Res>
    implements $DeviceInfoRequestCopyWith<$Res> {
  factory _$$DeviceInfoRequestImplCopyWith(_$DeviceInfoRequestImpl value,
          $Res Function(_$DeviceInfoRequestImpl) then) =
      __$$DeviceInfoRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String deviceId,
      String platform,
      String? deviceName,
      String? osVersion,
      String? appVersion,
      String? fcmToken});
}

/// @nodoc
class __$$DeviceInfoRequestImplCopyWithImpl<$Res>
    extends _$DeviceInfoRequestCopyWithImpl<$Res, _$DeviceInfoRequestImpl>
    implements _$$DeviceInfoRequestImplCopyWith<$Res> {
  __$$DeviceInfoRequestImplCopyWithImpl(_$DeviceInfoRequestImpl _value,
      $Res Function(_$DeviceInfoRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeviceInfoRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? platform = null,
    Object? deviceName = freezed,
    Object? osVersion = freezed,
    Object? appVersion = freezed,
    Object? fcmToken = freezed,
  }) {
    return _then(_$DeviceInfoRequestImpl(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: freezed == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      osVersion: freezed == osVersion
          ? _value.osVersion
          : osVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      appVersion: freezed == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceInfoRequestImpl implements _DeviceInfoRequest {
  const _$DeviceInfoRequestImpl(
      {required this.deviceId,
      required this.platform,
      this.deviceName,
      this.osVersion,
      this.appVersion,
      this.fcmToken});

  factory _$DeviceInfoRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceInfoRequestImplFromJson(json);

  @override
  final String deviceId;
  @override
  final String platform;
  @override
  final String? deviceName;
  @override
  final String? osVersion;
  @override
  final String? appVersion;
  @override
  final String? fcmToken;

  @override
  String toString() {
    return 'DeviceInfoRequest(deviceId: $deviceId, platform: $platform, deviceName: $deviceName, osVersion: $osVersion, appVersion: $appVersion, fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceInfoRequestImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.osVersion, osVersion) ||
                other.osVersion == osVersion) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, deviceId, platform, deviceName,
      osVersion, appVersion, fcmToken);

  /// Create a copy of DeviceInfoRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceInfoRequestImplCopyWith<_$DeviceInfoRequestImpl> get copyWith =>
      __$$DeviceInfoRequestImplCopyWithImpl<_$DeviceInfoRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceInfoRequestImplToJson(
      this,
    );
  }
}

abstract class _DeviceInfoRequest implements DeviceInfoRequest {
  const factory _DeviceInfoRequest(
      {required final String deviceId,
      required final String platform,
      final String? deviceName,
      final String? osVersion,
      final String? appVersion,
      final String? fcmToken}) = _$DeviceInfoRequestImpl;

  factory _DeviceInfoRequest.fromJson(Map<String, dynamic> json) =
      _$DeviceInfoRequestImpl.fromJson;

  @override
  String get deviceId;
  @override
  String get platform;
  @override
  String? get deviceName;
  @override
  String? get osVersion;
  @override
  String? get appVersion;
  @override
  String? get fcmToken;

  /// Create a copy of DeviceInfoRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceInfoRequestImplCopyWith<_$DeviceInfoRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
