// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setup_profile_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SetupProfileResponse _$SetupProfileResponseFromJson(Map<String, dynamic> json) {
  return _SetupProfileResponse.fromJson(json);
}

/// @nodoc
mixin _$SetupProfileResponse {
  /// 설정된 닉네임
  @JsonKey(name: 'nickname')
  String get nickname => throw _privateConstructorUsedError;

  /// 프로필 이미지 URL (nullable)
  @JsonKey(name: 'profileImageUrl')
  String? get profileImageUrl => throw _privateConstructorUsedError;

  /// 프로필 완성 여부 (실시간 계산값)
  @JsonKey(name: 'isProfileComplete')
  bool get isProfileComplete => throw _privateConstructorUsedError;

  /// 업데이트 시간 (ISO 8601 형식)
  @JsonKey(name: 'updatedAt')
  String get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SetupProfileResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SetupProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetupProfileResponseCopyWith<SetupProfileResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetupProfileResponseCopyWith<$Res> {
  factory $SetupProfileResponseCopyWith(SetupProfileResponse value,
          $Res Function(SetupProfileResponse) then) =
      _$SetupProfileResponseCopyWithImpl<$Res, SetupProfileResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'nickname') String nickname,
      @JsonKey(name: 'profileImageUrl') String? profileImageUrl,
      @JsonKey(name: 'isProfileComplete') bool isProfileComplete,
      @JsonKey(name: 'updatedAt') String updatedAt});
}

/// @nodoc
class _$SetupProfileResponseCopyWithImpl<$Res,
        $Val extends SetupProfileResponse>
    implements $SetupProfileResponseCopyWith<$Res> {
  _$SetupProfileResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SetupProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? isProfileComplete = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isProfileComplete: null == isProfileComplete
          ? _value.isProfileComplete
          : isProfileComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SetupProfileResponseImplCopyWith<$Res>
    implements $SetupProfileResponseCopyWith<$Res> {
  factory _$$SetupProfileResponseImplCopyWith(_$SetupProfileResponseImpl value,
          $Res Function(_$SetupProfileResponseImpl) then) =
      __$$SetupProfileResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'nickname') String nickname,
      @JsonKey(name: 'profileImageUrl') String? profileImageUrl,
      @JsonKey(name: 'isProfileComplete') bool isProfileComplete,
      @JsonKey(name: 'updatedAt') String updatedAt});
}

/// @nodoc
class __$$SetupProfileResponseImplCopyWithImpl<$Res>
    extends _$SetupProfileResponseCopyWithImpl<$Res, _$SetupProfileResponseImpl>
    implements _$$SetupProfileResponseImplCopyWith<$Res> {
  __$$SetupProfileResponseImplCopyWithImpl(_$SetupProfileResponseImpl _value,
      $Res Function(_$SetupProfileResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SetupProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? isProfileComplete = null,
    Object? updatedAt = null,
  }) {
    return _then(_$SetupProfileResponseImpl(
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isProfileComplete: null == isProfileComplete
          ? _value.isProfileComplete
          : isProfileComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetupProfileResponseImpl implements _SetupProfileResponse {
  const _$SetupProfileResponseImpl(
      {@JsonKey(name: 'nickname') required this.nickname,
      @JsonKey(name: 'profileImageUrl') this.profileImageUrl,
      @JsonKey(name: 'isProfileComplete') required this.isProfileComplete,
      @JsonKey(name: 'updatedAt') required this.updatedAt});

  factory _$SetupProfileResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SetupProfileResponseImplFromJson(json);

  /// 설정된 닉네임
  @override
  @JsonKey(name: 'nickname')
  final String nickname;

  /// 프로필 이미지 URL (nullable)
  @override
  @JsonKey(name: 'profileImageUrl')
  final String? profileImageUrl;

  /// 프로필 완성 여부 (실시간 계산값)
  @override
  @JsonKey(name: 'isProfileComplete')
  final bool isProfileComplete;

  /// 업데이트 시간 (ISO 8601 형식)
  @override
  @JsonKey(name: 'updatedAt')
  final String updatedAt;

  @override
  String toString() {
    return 'SetupProfileResponse(nickname: $nickname, profileImageUrl: $profileImageUrl, isProfileComplete: $isProfileComplete, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetupProfileResponseImpl &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.isProfileComplete, isProfileComplete) ||
                other.isProfileComplete == isProfileComplete) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, nickname, profileImageUrl, isProfileComplete, updatedAt);

  /// Create a copy of SetupProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetupProfileResponseImplCopyWith<_$SetupProfileResponseImpl>
      get copyWith =>
          __$$SetupProfileResponseImplCopyWithImpl<_$SetupProfileResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetupProfileResponseImplToJson(
      this,
    );
  }
}

abstract class _SetupProfileResponse implements SetupProfileResponse {
  const factory _SetupProfileResponse(
      {@JsonKey(name: 'nickname') required final String nickname,
      @JsonKey(name: 'profileImageUrl') final String? profileImageUrl,
      @JsonKey(name: 'isProfileComplete') required final bool isProfileComplete,
      @JsonKey(name: 'updatedAt')
      required final String updatedAt}) = _$SetupProfileResponseImpl;

  factory _SetupProfileResponse.fromJson(Map<String, dynamic> json) =
      _$SetupProfileResponseImpl.fromJson;

  /// 설정된 닉네임
  @override
  @JsonKey(name: 'nickname')
  String get nickname;

  /// 프로필 이미지 URL (nullable)
  @override
  @JsonKey(name: 'profileImageUrl')
  String? get profileImageUrl;

  /// 프로필 완성 여부 (실시간 계산값)
  @override
  @JsonKey(name: 'isProfileComplete')
  bool get isProfileComplete;

  /// 업데이트 시간 (ISO 8601 형식)
  @override
  @JsonKey(name: 'updatedAt')
  String get updatedAt;

  /// Create a copy of SetupProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetupProfileResponseImplCopyWith<_$SetupProfileResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
