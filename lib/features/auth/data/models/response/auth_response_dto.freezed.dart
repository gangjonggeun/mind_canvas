// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) {
  return _AuthResponse.fromJson(json);
}

/// @nodoc
mixin _$AuthResponse {
  @JsonKey(name: 'access_token')
  String get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token')
  String get refreshToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'access_expires_in')
  int get accessExpiresIn => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_expires_in')
  int get refreshExpiresIn => throw _privateConstructorUsedError;
  @JsonKey(name: 'token_type')
  String get tokenType => throw _privateConstructorUsedError;
  @JsonKey(name: 'nickname')
  String? get nickname =>
      throw _privateConstructorUsedError; // 클라이언트에서 추가하는 필드들 (서버에서 안옴)
  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime? get issuedAt => throw _privateConstructorUsedError;

  /// Serializes this AuthResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthResponseCopyWith<AuthResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseCopyWith<$Res> {
  factory $AuthResponseCopyWith(
          AuthResponse value, $Res Function(AuthResponse) then) =
      _$AuthResponseCopyWithImpl<$Res, AuthResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'refresh_token') String refreshToken,
      @JsonKey(name: 'access_expires_in') int accessExpiresIn,
      @JsonKey(name: 'refresh_expires_in') int refreshExpiresIn,
      @JsonKey(name: 'token_type') String tokenType,
      @JsonKey(name: 'nickname') String? nickname,
      @JsonKey(includeFromJson: false, includeToJson: false)
      DateTime? issuedAt});
}

/// @nodoc
class _$AuthResponseCopyWithImpl<$Res, $Val extends AuthResponse>
    implements $AuthResponseCopyWith<$Res> {
  _$AuthResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? accessExpiresIn = null,
    Object? refreshExpiresIn = null,
    Object? tokenType = null,
    Object? nickname = freezed,
    Object? issuedAt = freezed,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      accessExpiresIn: null == accessExpiresIn
          ? _value.accessExpiresIn
          : accessExpiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      refreshExpiresIn: null == refreshExpiresIn
          ? _value.refreshExpiresIn
          : refreshExpiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      issuedAt: freezed == issuedAt
          ? _value.issuedAt
          : issuedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthResponseImplCopyWith<$Res>
    implements $AuthResponseCopyWith<$Res> {
  factory _$$AuthResponseImplCopyWith(
          _$AuthResponseImpl value, $Res Function(_$AuthResponseImpl) then) =
      __$$AuthResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'refresh_token') String refreshToken,
      @JsonKey(name: 'access_expires_in') int accessExpiresIn,
      @JsonKey(name: 'refresh_expires_in') int refreshExpiresIn,
      @JsonKey(name: 'token_type') String tokenType,
      @JsonKey(name: 'nickname') String? nickname,
      @JsonKey(includeFromJson: false, includeToJson: false)
      DateTime? issuedAt});
}

/// @nodoc
class __$$AuthResponseImplCopyWithImpl<$Res>
    extends _$AuthResponseCopyWithImpl<$Res, _$AuthResponseImpl>
    implements _$$AuthResponseImplCopyWith<$Res> {
  __$$AuthResponseImplCopyWithImpl(
      _$AuthResponseImpl _value, $Res Function(_$AuthResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? accessExpiresIn = null,
    Object? refreshExpiresIn = null,
    Object? tokenType = null,
    Object? nickname = freezed,
    Object? issuedAt = freezed,
  }) {
    return _then(_$AuthResponseImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      accessExpiresIn: null == accessExpiresIn
          ? _value.accessExpiresIn
          : accessExpiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      refreshExpiresIn: null == refreshExpiresIn
          ? _value.refreshExpiresIn
          : refreshExpiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      issuedAt: freezed == issuedAt
          ? _value.issuedAt
          : issuedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResponseImpl implements _AuthResponse {
  const _$AuthResponseImpl(
      {@JsonKey(name: 'access_token') required this.accessToken,
      @JsonKey(name: 'refresh_token') required this.refreshToken,
      @JsonKey(name: 'access_expires_in') this.accessExpiresIn = 3600,
      @JsonKey(name: 'refresh_expires_in') this.refreshExpiresIn = 1209600,
      @JsonKey(name: 'token_type') this.tokenType = 'Bearer',
      @JsonKey(name: 'nickname') this.nickname,
      @JsonKey(includeFromJson: false, includeToJson: false) this.issuedAt});

  factory _$AuthResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseImplFromJson(json);

  @override
  @JsonKey(name: 'access_token')
  final String accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @override
  @JsonKey(name: 'access_expires_in')
  final int accessExpiresIn;
  @override
  @JsonKey(name: 'refresh_expires_in')
  final int refreshExpiresIn;
  @override
  @JsonKey(name: 'token_type')
  final String tokenType;
  @override
  @JsonKey(name: 'nickname')
  final String? nickname;
// 클라이언트에서 추가하는 필드들 (서버에서 안옴)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final DateTime? issuedAt;

  @override
  String toString() {
    return 'AuthResponse(accessToken: $accessToken, refreshToken: $refreshToken, accessExpiresIn: $accessExpiresIn, refreshExpiresIn: $refreshExpiresIn, tokenType: $tokenType, nickname: $nickname, issuedAt: $issuedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.accessExpiresIn, accessExpiresIn) ||
                other.accessExpiresIn == accessExpiresIn) &&
            (identical(other.refreshExpiresIn, refreshExpiresIn) ||
                other.refreshExpiresIn == refreshExpiresIn) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.issuedAt, issuedAt) ||
                other.issuedAt == issuedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken, refreshToken,
      accessExpiresIn, refreshExpiresIn, tokenType, nickname, issuedAt);

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      __$$AuthResponseImplCopyWithImpl<_$AuthResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResponseImplToJson(
      this,
    );
  }
}

abstract class _AuthResponse implements AuthResponse {
  const factory _AuthResponse(
      {@JsonKey(name: 'access_token') required final String accessToken,
      @JsonKey(name: 'refresh_token') required final String refreshToken,
      @JsonKey(name: 'access_expires_in') final int accessExpiresIn,
      @JsonKey(name: 'refresh_expires_in') final int refreshExpiresIn,
      @JsonKey(name: 'token_type') final String tokenType,
      @JsonKey(name: 'nickname') final String? nickname,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final DateTime? issuedAt}) = _$AuthResponseImpl;

  factory _AuthResponse.fromJson(Map<String, dynamic> json) =
      _$AuthResponseImpl.fromJson;

  @override
  @JsonKey(name: 'access_token')
  String get accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  String get refreshToken;
  @override
  @JsonKey(name: 'access_expires_in')
  int get accessExpiresIn;
  @override
  @JsonKey(name: 'refresh_expires_in')
  int get refreshExpiresIn;
  @override
  @JsonKey(name: 'token_type')
  String get tokenType;
  @override
  @JsonKey(name: 'nickname')
  String? get nickname; // 클라이언트에서 추가하는 필드들 (서버에서 안옴)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  DateTime? get issuedAt;

  /// Create a copy of AuthResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthResponseImplCopyWith<_$AuthResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
