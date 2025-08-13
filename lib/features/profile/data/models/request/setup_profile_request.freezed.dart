// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setup_profile_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SetupProfileRequest _$SetupProfileRequestFromJson(Map<String, dynamic> json) {
  return _SetupProfileRequest.fromJson(json);
}

/// @nodoc
mixin _$SetupProfileRequest {
  @JsonKey(name: 'nickname')
  String get nickname => throw _privateConstructorUsedError; // 추가 필드들 (필요시)
  @JsonKey(name: 'profileImageUrl')
  String? get profileImageUrl => throw _privateConstructorUsedError;

  /// Serializes this SetupProfileRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SetupProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SetupProfileRequestCopyWith<SetupProfileRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetupProfileRequestCopyWith<$Res> {
  factory $SetupProfileRequestCopyWith(
          SetupProfileRequest value, $Res Function(SetupProfileRequest) then) =
      _$SetupProfileRequestCopyWithImpl<$Res, SetupProfileRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'nickname') String nickname,
      @JsonKey(name: 'profileImageUrl') String? profileImageUrl});
}

/// @nodoc
class _$SetupProfileRequestCopyWithImpl<$Res, $Val extends SetupProfileRequest>
    implements $SetupProfileRequestCopyWith<$Res> {
  _$SetupProfileRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SetupProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nickname = null,
    Object? profileImageUrl = freezed,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SetupProfileRequestImplCopyWith<$Res>
    implements $SetupProfileRequestCopyWith<$Res> {
  factory _$$SetupProfileRequestImplCopyWith(_$SetupProfileRequestImpl value,
          $Res Function(_$SetupProfileRequestImpl) then) =
      __$$SetupProfileRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'nickname') String nickname,
      @JsonKey(name: 'profileImageUrl') String? profileImageUrl});
}

/// @nodoc
class __$$SetupProfileRequestImplCopyWithImpl<$Res>
    extends _$SetupProfileRequestCopyWithImpl<$Res, _$SetupProfileRequestImpl>
    implements _$$SetupProfileRequestImplCopyWith<$Res> {
  __$$SetupProfileRequestImplCopyWithImpl(_$SetupProfileRequestImpl _value,
      $Res Function(_$SetupProfileRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SetupProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nickname = null,
    Object? profileImageUrl = freezed,
  }) {
    return _then(_$SetupProfileRequestImpl(
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SetupProfileRequestImpl implements _SetupProfileRequest {
  const _$SetupProfileRequestImpl(
      {@JsonKey(name: 'nickname') required this.nickname,
      @JsonKey(name: 'profileImageUrl') this.profileImageUrl});

  factory _$SetupProfileRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SetupProfileRequestImplFromJson(json);

  @override
  @JsonKey(name: 'nickname')
  final String nickname;
// 추가 필드들 (필요시)
  @override
  @JsonKey(name: 'profileImageUrl')
  final String? profileImageUrl;

  @override
  String toString() {
    return 'SetupProfileRequest(nickname: $nickname, profileImageUrl: $profileImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SetupProfileRequestImpl &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, nickname, profileImageUrl);

  /// Create a copy of SetupProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SetupProfileRequestImplCopyWith<_$SetupProfileRequestImpl> get copyWith =>
      __$$SetupProfileRequestImplCopyWithImpl<_$SetupProfileRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SetupProfileRequestImplToJson(
      this,
    );
  }
}

abstract class _SetupProfileRequest implements SetupProfileRequest {
  const factory _SetupProfileRequest(
          {@JsonKey(name: 'nickname') required final String nickname,
          @JsonKey(name: 'profileImageUrl') final String? profileImageUrl}) =
      _$SetupProfileRequestImpl;

  factory _SetupProfileRequest.fromJson(Map<String, dynamic> json) =
      _$SetupProfileRequestImpl.fromJson;

  @override
  @JsonKey(name: 'nickname')
  String get nickname; // 추가 필드들 (필요시)
  @override
  @JsonKey(name: 'profileImageUrl')
  String? get profileImageUrl;

  /// Create a copy of SetupProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SetupProfileRequestImplCopyWith<_$SetupProfileRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
