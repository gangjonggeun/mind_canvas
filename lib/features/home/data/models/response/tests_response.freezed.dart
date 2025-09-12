// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tests_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TestsResponse _$TestsResponseFromJson(Map<String, dynamic> json) {
  return _TestsResponse.fromJson(json);
}

/// @nodoc
mixin _$TestsResponse {
  @JsonKey(name: 'tests')
  List<TestSummaryDto> get tests => throw _privateConstructorUsedError;
  @JsonKey(name: 'hasMore')
  bool get hasMore => throw _privateConstructorUsedError;

  /// Serializes this TestsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TestsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TestsResponseCopyWith<TestsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestsResponseCopyWith<$Res> {
  factory $TestsResponseCopyWith(
          TestsResponse value, $Res Function(TestsResponse) then) =
      _$TestsResponseCopyWithImpl<$Res, TestsResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'tests') List<TestSummaryDto> tests,
      @JsonKey(name: 'hasMore') bool hasMore});
}

/// @nodoc
class _$TestsResponseCopyWithImpl<$Res, $Val extends TestsResponse>
    implements $TestsResponseCopyWith<$Res> {
  _$TestsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TestsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tests = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      tests: null == tests
          ? _value.tests
          : tests // ignore: cast_nullable_to_non_nullable
              as List<TestSummaryDto>,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TestsResponseImplCopyWith<$Res>
    implements $TestsResponseCopyWith<$Res> {
  factory _$$TestsResponseImplCopyWith(
          _$TestsResponseImpl value, $Res Function(_$TestsResponseImpl) then) =
      __$$TestsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'tests') List<TestSummaryDto> tests,
      @JsonKey(name: 'hasMore') bool hasMore});
}

/// @nodoc
class __$$TestsResponseImplCopyWithImpl<$Res>
    extends _$TestsResponseCopyWithImpl<$Res, _$TestsResponseImpl>
    implements _$$TestsResponseImplCopyWith<$Res> {
  __$$TestsResponseImplCopyWithImpl(
      _$TestsResponseImpl _value, $Res Function(_$TestsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of TestsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tests = null,
    Object? hasMore = null,
  }) {
    return _then(_$TestsResponseImpl(
      tests: null == tests
          ? _value._tests
          : tests // ignore: cast_nullable_to_non_nullable
              as List<TestSummaryDto>,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestsResponseImpl implements _TestsResponse {
  const _$TestsResponseImpl(
      {@JsonKey(name: 'tests') required final List<TestSummaryDto> tests,
      @JsonKey(name: 'hasMore') required this.hasMore})
      : _tests = tests;

  factory _$TestsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TestsResponseImplFromJson(json);

  final List<TestSummaryDto> _tests;
  @override
  @JsonKey(name: 'tests')
  List<TestSummaryDto> get tests {
    if (_tests is EqualUnmodifiableListView) return _tests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tests);
  }

  @override
  @JsonKey(name: 'hasMore')
  final bool hasMore;

  @override
  String toString() {
    return 'TestsResponse(tests: $tests, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestsResponseImpl &&
            const DeepCollectionEquality().equals(other._tests, _tests) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_tests), hasMore);

  /// Create a copy of TestsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TestsResponseImplCopyWith<_$TestsResponseImpl> get copyWith =>
      __$$TestsResponseImplCopyWithImpl<_$TestsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TestsResponseImplToJson(
      this,
    );
  }
}

abstract class _TestsResponse implements TestsResponse {
  const factory _TestsResponse(
          {@JsonKey(name: 'tests') required final List<TestSummaryDto> tests,
          @JsonKey(name: 'hasMore') required final bool hasMore}) =
      _$TestsResponseImpl;

  factory _TestsResponse.fromJson(Map<String, dynamic> json) =
      _$TestsResponseImpl.fromJson;

  @override
  @JsonKey(name: 'tests')
  List<TestSummaryDto> get tests;
  @override
  @JsonKey(name: 'hasMore')
  bool get hasMore;

  /// Create a copy of TestsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TestsResponseImplCopyWith<_$TestsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TestSummaryDto _$TestSummaryDtoFromJson(Map<String, dynamic> json) {
  return _TestSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$TestSummaryDto {
  @JsonKey(name: 'testId')
  int get testId => throw _privateConstructorUsedError;
  @JsonKey(name: 'title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'subtitle')
  String? get subtitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'thumbnailUrl')
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'viewCount')
  int get viewCount => throw _privateConstructorUsedError;

  /// Serializes this TestSummaryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TestSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TestSummaryDtoCopyWith<TestSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestSummaryDtoCopyWith<$Res> {
  factory $TestSummaryDtoCopyWith(
          TestSummaryDto value, $Res Function(TestSummaryDto) then) =
      _$TestSummaryDtoCopyWithImpl<$Res, TestSummaryDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'testId') int testId,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'subtitle') String? subtitle,
      @JsonKey(name: 'thumbnailUrl') String? thumbnailUrl,
      @JsonKey(name: 'viewCount') int viewCount});
}

/// @nodoc
class _$TestSummaryDtoCopyWithImpl<$Res, $Val extends TestSummaryDto>
    implements $TestSummaryDtoCopyWith<$Res> {
  _$TestSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TestSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? testId = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? thumbnailUrl = freezed,
    Object? viewCount = null,
  }) {
    return _then(_value.copyWith(
      testId: null == testId
          ? _value.testId
          : testId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TestSummaryDtoImplCopyWith<$Res>
    implements $TestSummaryDtoCopyWith<$Res> {
  factory _$$TestSummaryDtoImplCopyWith(_$TestSummaryDtoImpl value,
          $Res Function(_$TestSummaryDtoImpl) then) =
      __$$TestSummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'testId') int testId,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'subtitle') String? subtitle,
      @JsonKey(name: 'thumbnailUrl') String? thumbnailUrl,
      @JsonKey(name: 'viewCount') int viewCount});
}

/// @nodoc
class __$$TestSummaryDtoImplCopyWithImpl<$Res>
    extends _$TestSummaryDtoCopyWithImpl<$Res, _$TestSummaryDtoImpl>
    implements _$$TestSummaryDtoImplCopyWith<$Res> {
  __$$TestSummaryDtoImplCopyWithImpl(
      _$TestSummaryDtoImpl _value, $Res Function(_$TestSummaryDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TestSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? testId = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? thumbnailUrl = freezed,
    Object? viewCount = null,
  }) {
    return _then(_$TestSummaryDtoImpl(
      testId: null == testId
          ? _value.testId
          : testId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestSummaryDtoImpl implements _TestSummaryDto {
  const _$TestSummaryDtoImpl(
      {@JsonKey(name: 'testId') required this.testId,
      @JsonKey(name: 'title') required this.title,
      @JsonKey(name: 'subtitle') this.subtitle,
      @JsonKey(name: 'thumbnailUrl') this.thumbnailUrl,
      @JsonKey(name: 'viewCount') this.viewCount = 0});

  factory _$TestSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TestSummaryDtoImplFromJson(json);

  @override
  @JsonKey(name: 'testId')
  final int testId;
  @override
  @JsonKey(name: 'title')
  final String title;
  @override
  @JsonKey(name: 'subtitle')
  final String? subtitle;
  @override
  @JsonKey(name: 'thumbnailUrl')
  final String? thumbnailUrl;
  @override
  @JsonKey(name: 'viewCount')
  final int viewCount;

  @override
  String toString() {
    return 'TestSummaryDto(testId: $testId, title: $title, subtitle: $subtitle, thumbnailUrl: $thumbnailUrl, viewCount: $viewCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestSummaryDtoImpl &&
            (identical(other.testId, testId) || other.testId == testId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, testId, title, subtitle, thumbnailUrl, viewCount);

  /// Create a copy of TestSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TestSummaryDtoImplCopyWith<_$TestSummaryDtoImpl> get copyWith =>
      __$$TestSummaryDtoImplCopyWithImpl<_$TestSummaryDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TestSummaryDtoImplToJson(
      this,
    );
  }
}

abstract class _TestSummaryDto implements TestSummaryDto {
  const factory _TestSummaryDto(
      {@JsonKey(name: 'testId') required final int testId,
      @JsonKey(name: 'title') required final String title,
      @JsonKey(name: 'subtitle') final String? subtitle,
      @JsonKey(name: 'thumbnailUrl') final String? thumbnailUrl,
      @JsonKey(name: 'viewCount') final int viewCount}) = _$TestSummaryDtoImpl;

  factory _TestSummaryDto.fromJson(Map<String, dynamic> json) =
      _$TestSummaryDtoImpl.fromJson;

  @override
  @JsonKey(name: 'testId')
  int get testId;
  @override
  @JsonKey(name: 'title')
  String get title;
  @override
  @JsonKey(name: 'subtitle')
  String? get subtitle;
  @override
  @JsonKey(name: 'thumbnailUrl')
  String? get thumbnailUrl;
  @override
  @JsonKey(name: 'viewCount')
  int get viewCount;

  /// Create a copy of TestSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TestSummaryDtoImplCopyWith<_$TestSummaryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
