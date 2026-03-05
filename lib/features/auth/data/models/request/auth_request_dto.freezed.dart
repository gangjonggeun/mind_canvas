// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GoogleLoginRequest _$GoogleLoginRequestFromJson(Map<String, dynamic> json) {
  return _GoogleLoginRequest.fromJson(json);
}

/// @nodoc
mixin _$GoogleLoginRequest {
  @JsonKey(name: 'id_token')
  String get idToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'device_id')
  String? get deviceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fcm_token')
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
      {@JsonKey(name: 'id_token') String idToken,
      @JsonKey(name: 'device_id') String? deviceId,
      @JsonKey(name: 'fcm_token') String? fcmToken});
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
    Object? deviceId = freezed,
    Object? fcmToken = freezed,
  }) {
    return _then(_value.copyWith(
      idToken: null == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String,
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
      {@JsonKey(name: 'id_token') String idToken,
      @JsonKey(name: 'device_id') String? deviceId,
      @JsonKey(name: 'fcm_token') String? fcmToken});
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
    Object? deviceId = freezed,
    Object? fcmToken = freezed,
  }) {
    return _then(_$GoogleLoginRequestImpl(
      idToken: null == idToken
          ? _value.idToken
          : idToken // ignore: cast_nullable_to_non_nullable
              as String,
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
      {@JsonKey(name: 'id_token') required this.idToken,
      @JsonKey(name: 'device_id') this.deviceId,
      @JsonKey(name: 'fcm_token') this.fcmToken});

  factory _$GoogleLoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoogleLoginRequestImplFromJson(json);

  @override
  @JsonKey(name: 'id_token')
  final String idToken;
  @override
  @JsonKey(name: 'device_id')
  final String? deviceId;
  @override
  @JsonKey(name: 'fcm_token')
  final String? fcmToken;

  @override
  String toString() {
    return 'GoogleLoginRequest(idToken: $idToken, deviceId: $deviceId, fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoogleLoginRequestImpl &&
            (identical(other.idToken, idToken) || other.idToken == idToken) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, idToken, deviceId, fcmToken);

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
          {@JsonKey(name: 'id_token') required final String idToken,
          @JsonKey(name: 'device_id') final String? deviceId,
          @JsonKey(name: 'fcm_token') final String? fcmToken}) =
      _$GoogleLoginRequestImpl;

  factory _GoogleLoginRequest.fromJson(Map<String, dynamic> json) =
      _$GoogleLoginRequestImpl.fromJson;

  @override
  @JsonKey(name: 'id_token')
  String get idToken;
  @override
  @JsonKey(name: 'device_id')
  String? get deviceId;
  @override
  @JsonKey(name: 'fcm_token')
  String? get fcmToken;

  /// Create a copy of GoogleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoogleLoginRequestImplCopyWith<_$GoogleLoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppleLoginRequest _$AppleLoginRequestFromJson(Map<String, dynamic> json) {
  return _AppleLoginRequest.fromJson(json);
}

/// @nodoc
mixin _$AppleLoginRequest {
  String get identityToken =>
      throw _privateConstructorUsedError; // 🔥 필수: 애플이 준 JWT 토큰
  String? get fcmToken => throw _privateConstructorUsedError;
  String? get userJson => throw _privateConstructorUsedError;

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
  $Res call({String identityToken, String? fcmToken, String? userJson});
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
    Object? fcmToken = freezed,
    Object? userJson = freezed,
  }) {
    return _then(_value.copyWith(
      identityToken: null == identityToken
          ? _value.identityToken
          : identityToken // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      userJson: freezed == userJson
          ? _value.userJson
          : userJson // ignore: cast_nullable_to_non_nullable
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
  $Res call({String identityToken, String? fcmToken, String? userJson});
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
    Object? fcmToken = freezed,
    Object? userJson = freezed,
  }) {
    return _then(_$AppleLoginRequestImpl(
      identityToken: null == identityToken
          ? _value.identityToken
          : identityToken // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      userJson: freezed == userJson
          ? _value.userJson
          : userJson // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppleLoginRequestImpl implements _AppleLoginRequest {
  const _$AppleLoginRequestImpl(
      {required this.identityToken, this.fcmToken, this.userJson});

  factory _$AppleLoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppleLoginRequestImplFromJson(json);

  @override
  final String identityToken;
// 🔥 필수: 애플이 준 JWT 토큰
  @override
  final String? fcmToken;
  @override
  final String? userJson;

  @override
  String toString() {
    return 'AppleLoginRequest(identityToken: $identityToken, fcmToken: $fcmToken, userJson: $userJson)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppleLoginRequestImpl &&
            (identical(other.identityToken, identityToken) ||
                other.identityToken == identityToken) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.userJson, userJson) ||
                other.userJson == userJson));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, identityToken, fcmToken, userJson);

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
      final String? fcmToken,
      final String? userJson}) = _$AppleLoginRequestImpl;

  factory _AppleLoginRequest.fromJson(Map<String, dynamic> json) =
      _$AppleLoginRequestImpl.fromJson;

  @override
  String get identityToken; // 🔥 필수: 애플이 준 JWT 토큰
  @override
  String? get fcmToken;
  @override
  String? get userJson;

  /// Create a copy of AppleLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppleLoginRequestImplCopyWith<_$AppleLoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GuestLoginRequest _$GuestLoginRequestFromJson(Map<String, dynamic> json) {
  return _GuestLoginRequest.fromJson(json);
}

/// @nodoc
mixin _$GuestLoginRequest {
  String get deviceId =>
      throw _privateConstructorUsedError; // 🔥 필수: 서버에서 이걸로 기존 게스트 찾음
  String? get fcmToken => throw _privateConstructorUsedError;
  String? get language => throw _privateConstructorUsedError;

  /// Serializes this GuestLoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GuestLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GuestLoginRequestCopyWith<GuestLoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuestLoginRequestCopyWith<$Res> {
  factory $GuestLoginRequestCopyWith(
          GuestLoginRequest value, $Res Function(GuestLoginRequest) then) =
      _$GuestLoginRequestCopyWithImpl<$Res, GuestLoginRequest>;
  @useResult
  $Res call({String deviceId, String? fcmToken, String? language});
}

/// @nodoc
class _$GuestLoginRequestCopyWithImpl<$Res, $Val extends GuestLoginRequest>
    implements $GuestLoginRequestCopyWith<$Res> {
  _$GuestLoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GuestLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? fcmToken = freezed,
    Object? language = freezed,
  }) {
    return _then(_value.copyWith(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GuestLoginRequestImplCopyWith<$Res>
    implements $GuestLoginRequestCopyWith<$Res> {
  factory _$$GuestLoginRequestImplCopyWith(_$GuestLoginRequestImpl value,
          $Res Function(_$GuestLoginRequestImpl) then) =
      __$$GuestLoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String deviceId, String? fcmToken, String? language});
}

/// @nodoc
class __$$GuestLoginRequestImplCopyWithImpl<$Res>
    extends _$GuestLoginRequestCopyWithImpl<$Res, _$GuestLoginRequestImpl>
    implements _$$GuestLoginRequestImplCopyWith<$Res> {
  __$$GuestLoginRequestImplCopyWithImpl(_$GuestLoginRequestImpl _value,
      $Res Function(_$GuestLoginRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of GuestLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? fcmToken = freezed,
    Object? language = freezed,
  }) {
    return _then(_$GuestLoginRequestImpl(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GuestLoginRequestImpl implements _GuestLoginRequest {
  const _$GuestLoginRequestImpl(
      {required this.deviceId, this.fcmToken, this.language});

  factory _$GuestLoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$GuestLoginRequestImplFromJson(json);

  @override
  final String deviceId;
// 🔥 필수: 서버에서 이걸로 기존 게스트 찾음
  @override
  final String? fcmToken;
  @override
  final String? language;

  @override
  String toString() {
    return 'GuestLoginRequest(deviceId: $deviceId, fcmToken: $fcmToken, language: $language)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuestLoginRequestImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.language, language) ||
                other.language == language));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, deviceId, fcmToken, language);

  /// Create a copy of GuestLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GuestLoginRequestImplCopyWith<_$GuestLoginRequestImpl> get copyWith =>
      __$$GuestLoginRequestImplCopyWithImpl<_$GuestLoginRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GuestLoginRequestImplToJson(
      this,
    );
  }
}

abstract class _GuestLoginRequest implements GuestLoginRequest {
  const factory _GuestLoginRequest(
      {required final String deviceId,
      final String? fcmToken,
      final String? language}) = _$GuestLoginRequestImpl;

  factory _GuestLoginRequest.fromJson(Map<String, dynamic> json) =
      _$GuestLoginRequestImpl.fromJson;

  @override
  String get deviceId; // 🔥 필수: 서버에서 이걸로 기존 게스트 찾음
  @override
  String? get fcmToken;
  @override
  String? get language;

  /// Create a copy of GuestLoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GuestLoginRequestImplCopyWith<_$GuestLoginRequestImpl> get copyWith =>
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
