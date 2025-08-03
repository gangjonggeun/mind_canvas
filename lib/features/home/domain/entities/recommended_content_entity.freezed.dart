// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommended_content_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecommendedContentEntity _$RecommendedContentEntityFromJson(
    Map<String, dynamic> json) {
  return _RecommendedContentEntity.fromJson(json);
}

/// @nodoc
mixin _$RecommendedContentEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get subtitle => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  ContentType get type => throw _privateConstructorUsedError;
  String get rating => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  List<Color> get gradientColors => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  double get matchPercentage => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RecommendedContentEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendedContentEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendedContentEntityCopyWith<RecommendedContentEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendedContentEntityCopyWith<$Res> {
  factory $RecommendedContentEntityCopyWith(RecommendedContentEntity value,
          $Res Function(RecommendedContentEntity) then) =
      _$RecommendedContentEntityCopyWithImpl<$Res, RecommendedContentEntity>;
  @useResult
  $Res call(
      {String id,
      String title,
      String subtitle,
      String imageUrl,
      ContentType type,
      String rating,
      @JsonKey(ignore: true) List<Color> gradientColors,
      List<String> tags,
      double matchPercentage,
      String reason,
      DateTime? createdAt});
}

/// @nodoc
class _$RecommendedContentEntityCopyWithImpl<$Res,
        $Val extends RecommendedContentEntity>
    implements $RecommendedContentEntityCopyWith<$Res> {
  _$RecommendedContentEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendedContentEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = null,
    Object? imageUrl = null,
    Object? type = null,
    Object? rating = null,
    Object? gradientColors = null,
    Object? tags = null,
    Object? matchPercentage = null,
    Object? reason = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ContentType,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as String,
      gradientColors: null == gradientColors
          ? _value.gradientColors
          : gradientColors // ignore: cast_nullable_to_non_nullable
              as List<Color>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      matchPercentage: null == matchPercentage
          ? _value.matchPercentage
          : matchPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecommendedContentEntityImplCopyWith<$Res>
    implements $RecommendedContentEntityCopyWith<$Res> {
  factory _$$RecommendedContentEntityImplCopyWith(
          _$RecommendedContentEntityImpl value,
          $Res Function(_$RecommendedContentEntityImpl) then) =
      __$$RecommendedContentEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String subtitle,
      String imageUrl,
      ContentType type,
      String rating,
      @JsonKey(ignore: true) List<Color> gradientColors,
      List<String> tags,
      double matchPercentage,
      String reason,
      DateTime? createdAt});
}

/// @nodoc
class __$$RecommendedContentEntityImplCopyWithImpl<$Res>
    extends _$RecommendedContentEntityCopyWithImpl<$Res,
        _$RecommendedContentEntityImpl>
    implements _$$RecommendedContentEntityImplCopyWith<$Res> {
  __$$RecommendedContentEntityImplCopyWithImpl(
      _$RecommendedContentEntityImpl _value,
      $Res Function(_$RecommendedContentEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendedContentEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = null,
    Object? imageUrl = null,
    Object? type = null,
    Object? rating = null,
    Object? gradientColors = null,
    Object? tags = null,
    Object? matchPercentage = null,
    Object? reason = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$RecommendedContentEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: null == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ContentType,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as String,
      gradientColors: null == gradientColors
          ? _value._gradientColors
          : gradientColors // ignore: cast_nullable_to_non_nullable
              as List<Color>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      matchPercentage: null == matchPercentage
          ? _value.matchPercentage
          : matchPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendedContentEntityImpl
    with DiagnosticableTreeMixin
    implements _RecommendedContentEntity {
  const _$RecommendedContentEntityImpl(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.imageUrl,
      required this.type,
      required this.rating,
      @JsonKey(ignore: true) final List<Color> gradientColors = const [
        const Color(0xFF667EEA),
        const Color(0xFF764BA2)
      ],
      final List<String> tags = const [],
      this.matchPercentage = 0.0,
      this.reason = '',
      this.createdAt})
      : _gradientColors = gradientColors,
        _tags = tags;

  factory _$RecommendedContentEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendedContentEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String subtitle;
  @override
  final String imageUrl;
  @override
  final ContentType type;
  @override
  final String rating;
  final List<Color> _gradientColors;
  @override
  @JsonKey(ignore: true)
  List<Color> get gradientColors {
    if (_gradientColors is EqualUnmodifiableListView) return _gradientColors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gradientColors);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final double matchPercentage;
  @override
  @JsonKey()
  final String reason;
  @override
  final DateTime? createdAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RecommendedContentEntity(id: $id, title: $title, subtitle: $subtitle, imageUrl: $imageUrl, type: $type, rating: $rating, gradientColors: $gradientColors, tags: $tags, matchPercentage: $matchPercentage, reason: $reason, createdAt: $createdAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RecommendedContentEntity'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('subtitle', subtitle))
      ..add(DiagnosticsProperty('imageUrl', imageUrl))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('rating', rating))
      ..add(DiagnosticsProperty('gradientColors', gradientColors))
      ..add(DiagnosticsProperty('tags', tags))
      ..add(DiagnosticsProperty('matchPercentage', matchPercentage))
      ..add(DiagnosticsProperty('reason', reason))
      ..add(DiagnosticsProperty('createdAt', createdAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendedContentEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            const DeepCollectionEquality()
                .equals(other._gradientColors, _gradientColors) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.matchPercentage, matchPercentage) ||
                other.matchPercentage == matchPercentage) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      subtitle,
      imageUrl,
      type,
      rating,
      const DeepCollectionEquality().hash(_gradientColors),
      const DeepCollectionEquality().hash(_tags),
      matchPercentage,
      reason,
      createdAt);

  /// Create a copy of RecommendedContentEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendedContentEntityImplCopyWith<_$RecommendedContentEntityImpl>
      get copyWith => __$$RecommendedContentEntityImplCopyWithImpl<
          _$RecommendedContentEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendedContentEntityImplToJson(
      this,
    );
  }
}

abstract class _RecommendedContentEntity implements RecommendedContentEntity {
  const factory _RecommendedContentEntity(
      {required final String id,
      required final String title,
      required final String subtitle,
      required final String imageUrl,
      required final ContentType type,
      required final String rating,
      @JsonKey(ignore: true) final List<Color> gradientColors,
      final List<String> tags,
      final double matchPercentage,
      final String reason,
      final DateTime? createdAt}) = _$RecommendedContentEntityImpl;

  factory _RecommendedContentEntity.fromJson(Map<String, dynamic> json) =
      _$RecommendedContentEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get subtitle;
  @override
  String get imageUrl;
  @override
  ContentType get type;
  @override
  String get rating;
  @override
  @JsonKey(ignore: true)
  List<Color> get gradientColors;
  @override
  List<String> get tags;
  @override
  double get matchPercentage;
  @override
  String get reason;
  @override
  DateTime? get createdAt;

  /// Create a copy of RecommendedContentEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendedContentEntityImplCopyWith<_$RecommendedContentEntityImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MbtiInfo _$MbtiInfoFromJson(Map<String, dynamic> json) {
  return _MbtiInfo.fromJson(json);
}

/// @nodoc
mixin _$MbtiInfo {
  String get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this MbtiInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MbtiInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MbtiInfoCopyWith<MbtiInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MbtiInfoCopyWith<$Res> {
  factory $MbtiInfoCopyWith(MbtiInfo value, $Res Function(MbtiInfo) then) =
      _$MbtiInfoCopyWithImpl<$Res, MbtiInfo>;
  @useResult
  $Res call({String type, String description});
}

/// @nodoc
class _$MbtiInfoCopyWithImpl<$Res, $Val extends MbtiInfo>
    implements $MbtiInfoCopyWith<$Res> {
  _$MbtiInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MbtiInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MbtiInfoImplCopyWith<$Res>
    implements $MbtiInfoCopyWith<$Res> {
  factory _$$MbtiInfoImplCopyWith(
          _$MbtiInfoImpl value, $Res Function(_$MbtiInfoImpl) then) =
      __$$MbtiInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String description});
}

/// @nodoc
class __$$MbtiInfoImplCopyWithImpl<$Res>
    extends _$MbtiInfoCopyWithImpl<$Res, _$MbtiInfoImpl>
    implements _$$MbtiInfoImplCopyWith<$Res> {
  __$$MbtiInfoImplCopyWithImpl(
      _$MbtiInfoImpl _value, $Res Function(_$MbtiInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of MbtiInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? description = null,
  }) {
    return _then(_$MbtiInfoImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MbtiInfoImpl with DiagnosticableTreeMixin implements _MbtiInfo {
  const _$MbtiInfoImpl({required this.type, this.description = ''});

  factory _$MbtiInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MbtiInfoImplFromJson(json);

  @override
  final String type;
  @override
  @JsonKey()
  final String description;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MbtiInfo(type: $type, description: $description)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MbtiInfo'))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('description', description));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MbtiInfoImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, description);

  /// Create a copy of MbtiInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MbtiInfoImplCopyWith<_$MbtiInfoImpl> get copyWith =>
      __$$MbtiInfoImplCopyWithImpl<_$MbtiInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MbtiInfoImplToJson(
      this,
    );
  }
}

abstract class _MbtiInfo implements MbtiInfo {
  const factory _MbtiInfo(
      {required final String type, final String description}) = _$MbtiInfoImpl;

  factory _MbtiInfo.fromJson(Map<String, dynamic> json) =
      _$MbtiInfoImpl.fromJson;

  @override
  String get type;
  @override
  String get description;

  /// Create a copy of MbtiInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MbtiInfoImplCopyWith<_$MbtiInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecommendedContentState _$RecommendedContentStateFromJson(
    Map<String, dynamic> json) {
  return _RecommendedContentState.fromJson(json);
}

/// @nodoc
mixin _$RecommendedContentState {
  List<RecommendedContentEntity> get contents =>
      throw _privateConstructorUsedError;
  ContentType get selectedContentType => throw _privateConstructorUsedError;
  ContentMode get selectedContentMode => throw _privateConstructorUsedError;
  MbtiInfo get userMbti => throw _privateConstructorUsedError;
  MbtiInfo get partnerMbti => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this RecommendedContentState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendedContentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendedContentStateCopyWith<RecommendedContentState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendedContentStateCopyWith<$Res> {
  factory $RecommendedContentStateCopyWith(RecommendedContentState value,
          $Res Function(RecommendedContentState) then) =
      _$RecommendedContentStateCopyWithImpl<$Res, RecommendedContentState>;
  @useResult
  $Res call(
      {List<RecommendedContentEntity> contents,
      ContentType selectedContentType,
      ContentMode selectedContentMode,
      MbtiInfo userMbti,
      MbtiInfo partnerMbti,
      bool isLoading,
      String? errorMessage});

  $MbtiInfoCopyWith<$Res> get userMbti;
  $MbtiInfoCopyWith<$Res> get partnerMbti;
}

/// @nodoc
class _$RecommendedContentStateCopyWithImpl<$Res,
        $Val extends RecommendedContentState>
    implements $RecommendedContentStateCopyWith<$Res> {
  _$RecommendedContentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendedContentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contents = null,
    Object? selectedContentType = null,
    Object? selectedContentMode = null,
    Object? userMbti = null,
    Object? partnerMbti = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      contents: null == contents
          ? _value.contents
          : contents // ignore: cast_nullable_to_non_nullable
              as List<RecommendedContentEntity>,
      selectedContentType: null == selectedContentType
          ? _value.selectedContentType
          : selectedContentType // ignore: cast_nullable_to_non_nullable
              as ContentType,
      selectedContentMode: null == selectedContentMode
          ? _value.selectedContentMode
          : selectedContentMode // ignore: cast_nullable_to_non_nullable
              as ContentMode,
      userMbti: null == userMbti
          ? _value.userMbti
          : userMbti // ignore: cast_nullable_to_non_nullable
              as MbtiInfo,
      partnerMbti: null == partnerMbti
          ? _value.partnerMbti
          : partnerMbti // ignore: cast_nullable_to_non_nullable
              as MbtiInfo,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of RecommendedContentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MbtiInfoCopyWith<$Res> get userMbti {
    return $MbtiInfoCopyWith<$Res>(_value.userMbti, (value) {
      return _then(_value.copyWith(userMbti: value) as $Val);
    });
  }

  /// Create a copy of RecommendedContentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MbtiInfoCopyWith<$Res> get partnerMbti {
    return $MbtiInfoCopyWith<$Res>(_value.partnerMbti, (value) {
      return _then(_value.copyWith(partnerMbti: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecommendedContentStateImplCopyWith<$Res>
    implements $RecommendedContentStateCopyWith<$Res> {
  factory _$$RecommendedContentStateImplCopyWith(
          _$RecommendedContentStateImpl value,
          $Res Function(_$RecommendedContentStateImpl) then) =
      __$$RecommendedContentStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<RecommendedContentEntity> contents,
      ContentType selectedContentType,
      ContentMode selectedContentMode,
      MbtiInfo userMbti,
      MbtiInfo partnerMbti,
      bool isLoading,
      String? errorMessage});

  @override
  $MbtiInfoCopyWith<$Res> get userMbti;
  @override
  $MbtiInfoCopyWith<$Res> get partnerMbti;
}

/// @nodoc
class __$$RecommendedContentStateImplCopyWithImpl<$Res>
    extends _$RecommendedContentStateCopyWithImpl<$Res,
        _$RecommendedContentStateImpl>
    implements _$$RecommendedContentStateImplCopyWith<$Res> {
  __$$RecommendedContentStateImplCopyWithImpl(
      _$RecommendedContentStateImpl _value,
      $Res Function(_$RecommendedContentStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendedContentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contents = null,
    Object? selectedContentType = null,
    Object? selectedContentMode = null,
    Object? userMbti = null,
    Object? partnerMbti = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$RecommendedContentStateImpl(
      contents: null == contents
          ? _value._contents
          : contents // ignore: cast_nullable_to_non_nullable
              as List<RecommendedContentEntity>,
      selectedContentType: null == selectedContentType
          ? _value.selectedContentType
          : selectedContentType // ignore: cast_nullable_to_non_nullable
              as ContentType,
      selectedContentMode: null == selectedContentMode
          ? _value.selectedContentMode
          : selectedContentMode // ignore: cast_nullable_to_non_nullable
              as ContentMode,
      userMbti: null == userMbti
          ? _value.userMbti
          : userMbti // ignore: cast_nullable_to_non_nullable
              as MbtiInfo,
      partnerMbti: null == partnerMbti
          ? _value.partnerMbti
          : partnerMbti // ignore: cast_nullable_to_non_nullable
              as MbtiInfo,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecommendedContentStateImpl
    with DiagnosticableTreeMixin
    implements _RecommendedContentState {
  const _$RecommendedContentStateImpl(
      {final List<RecommendedContentEntity> contents = const [],
      this.selectedContentType = ContentType.movie,
      this.selectedContentMode = ContentMode.personal,
      this.userMbti = const MbtiInfo(type: 'ENFP'),
      this.partnerMbti = const MbtiInfo(type: 'ISFJ'),
      this.isLoading = false,
      this.errorMessage = null})
      : _contents = contents;

  factory _$RecommendedContentStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendedContentStateImplFromJson(json);

  final List<RecommendedContentEntity> _contents;
  @override
  @JsonKey()
  List<RecommendedContentEntity> get contents {
    if (_contents is EqualUnmodifiableListView) return _contents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contents);
  }

  @override
  @JsonKey()
  final ContentType selectedContentType;
  @override
  @JsonKey()
  final ContentMode selectedContentMode;
  @override
  @JsonKey()
  final MbtiInfo userMbti;
  @override
  @JsonKey()
  final MbtiInfo partnerMbti;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String? errorMessage;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RecommendedContentState(contents: $contents, selectedContentType: $selectedContentType, selectedContentMode: $selectedContentMode, userMbti: $userMbti, partnerMbti: $partnerMbti, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RecommendedContentState'))
      ..add(DiagnosticsProperty('contents', contents))
      ..add(DiagnosticsProperty('selectedContentType', selectedContentType))
      ..add(DiagnosticsProperty('selectedContentMode', selectedContentMode))
      ..add(DiagnosticsProperty('userMbti', userMbti))
      ..add(DiagnosticsProperty('partnerMbti', partnerMbti))
      ..add(DiagnosticsProperty('isLoading', isLoading))
      ..add(DiagnosticsProperty('errorMessage', errorMessage));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendedContentStateImpl &&
            const DeepCollectionEquality().equals(other._contents, _contents) &&
            (identical(other.selectedContentType, selectedContentType) ||
                other.selectedContentType == selectedContentType) &&
            (identical(other.selectedContentMode, selectedContentMode) ||
                other.selectedContentMode == selectedContentMode) &&
            (identical(other.userMbti, userMbti) ||
                other.userMbti == userMbti) &&
            (identical(other.partnerMbti, partnerMbti) ||
                other.partnerMbti == partnerMbti) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_contents),
      selectedContentType,
      selectedContentMode,
      userMbti,
      partnerMbti,
      isLoading,
      errorMessage);

  /// Create a copy of RecommendedContentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendedContentStateImplCopyWith<_$RecommendedContentStateImpl>
      get copyWith => __$$RecommendedContentStateImplCopyWithImpl<
          _$RecommendedContentStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendedContentStateImplToJson(
      this,
    );
  }
}

abstract class _RecommendedContentState implements RecommendedContentState {
  const factory _RecommendedContentState(
      {final List<RecommendedContentEntity> contents,
      final ContentType selectedContentType,
      final ContentMode selectedContentMode,
      final MbtiInfo userMbti,
      final MbtiInfo partnerMbti,
      final bool isLoading,
      final String? errorMessage}) = _$RecommendedContentStateImpl;

  factory _RecommendedContentState.fromJson(Map<String, dynamic> json) =
      _$RecommendedContentStateImpl.fromJson;

  @override
  List<RecommendedContentEntity> get contents;
  @override
  ContentType get selectedContentType;
  @override
  ContentMode get selectedContentMode;
  @override
  MbtiInfo get userMbti;
  @override
  MbtiInfo get partnerMbti;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of RecommendedContentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendedContentStateImplCopyWith<_$RecommendedContentStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
