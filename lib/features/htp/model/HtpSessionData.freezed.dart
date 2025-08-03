// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'HtpSessionData.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HtpSession _$HtpSessionFromJson(Map<String, dynamic> json) {
  return _HtpSession.fromJson(json);
}

/// @nodoc
mixin _$HtpSession {
  String get sessionId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get startTime =>
      throw _privateConstructorUsedError; // Unix timestamp (밀리초)
  int? get endTime => throw _privateConstructorUsedError;
  List<HtpDrawing> get drawings => throw _privateConstructorUsedError;
  bool get supportsPressure => throw _privateConstructorUsedError;

  /// Serializes this HtpSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HtpSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HtpSessionCopyWith<HtpSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HtpSessionCopyWith<$Res> {
  factory $HtpSessionCopyWith(
          HtpSession value, $Res Function(HtpSession) then) =
      _$HtpSessionCopyWithImpl<$Res, HtpSession>;
  @useResult
  $Res call(
      {String sessionId,
      String userId,
      int startTime,
      int? endTime,
      List<HtpDrawing> drawings,
      bool supportsPressure});
}

/// @nodoc
class _$HtpSessionCopyWithImpl<$Res, $Val extends HtpSession>
    implements $HtpSessionCopyWith<$Res> {
  _$HtpSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HtpSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? drawings = null,
    Object? supportsPressure = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as int,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as int?,
      drawings: null == drawings
          ? _value.drawings
          : drawings // ignore: cast_nullable_to_non_nullable
              as List<HtpDrawing>,
      supportsPressure: null == supportsPressure
          ? _value.supportsPressure
          : supportsPressure // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HtpSessionImplCopyWith<$Res>
    implements $HtpSessionCopyWith<$Res> {
  factory _$$HtpSessionImplCopyWith(
          _$HtpSessionImpl value, $Res Function(_$HtpSessionImpl) then) =
      __$$HtpSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String userId,
      int startTime,
      int? endTime,
      List<HtpDrawing> drawings,
      bool supportsPressure});
}

/// @nodoc
class __$$HtpSessionImplCopyWithImpl<$Res>
    extends _$HtpSessionCopyWithImpl<$Res, _$HtpSessionImpl>
    implements _$$HtpSessionImplCopyWith<$Res> {
  __$$HtpSessionImplCopyWithImpl(
      _$HtpSessionImpl _value, $Res Function(_$HtpSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of HtpSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? drawings = null,
    Object? supportsPressure = null,
  }) {
    return _then(_$HtpSessionImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as int,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as int?,
      drawings: null == drawings
          ? _value._drawings
          : drawings // ignore: cast_nullable_to_non_nullable
              as List<HtpDrawing>,
      supportsPressure: null == supportsPressure
          ? _value.supportsPressure
          : supportsPressure // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HtpSessionImpl implements _HtpSession {
  const _$HtpSessionImpl(
      {required this.sessionId,
      required this.userId,
      required this.startTime,
      this.endTime,
      required final List<HtpDrawing> drawings,
      required this.supportsPressure})
      : _drawings = drawings;

  factory _$HtpSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$HtpSessionImplFromJson(json);

  @override
  final String sessionId;
  @override
  final String userId;
  @override
  final int startTime;
// Unix timestamp (밀리초)
  @override
  final int? endTime;
  final List<HtpDrawing> _drawings;
  @override
  List<HtpDrawing> get drawings {
    if (_drawings is EqualUnmodifiableListView) return _drawings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_drawings);
  }

  @override
  final bool supportsPressure;

  @override
  String toString() {
    return 'HtpSession(sessionId: $sessionId, userId: $userId, startTime: $startTime, endTime: $endTime, drawings: $drawings, supportsPressure: $supportsPressure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HtpSessionImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            const DeepCollectionEquality().equals(other._drawings, _drawings) &&
            (identical(other.supportsPressure, supportsPressure) ||
                other.supportsPressure == supportsPressure));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      userId,
      startTime,
      endTime,
      const DeepCollectionEquality().hash(_drawings),
      supportsPressure);

  /// Create a copy of HtpSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HtpSessionImplCopyWith<_$HtpSessionImpl> get copyWith =>
      __$$HtpSessionImplCopyWithImpl<_$HtpSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HtpSessionImplToJson(
      this,
    );
  }
}

abstract class _HtpSession implements HtpSession {
  const factory _HtpSession(
      {required final String sessionId,
      required final String userId,
      required final int startTime,
      final int? endTime,
      required final List<HtpDrawing> drawings,
      required final bool supportsPressure}) = _$HtpSessionImpl;

  factory _HtpSession.fromJson(Map<String, dynamic> json) =
      _$HtpSessionImpl.fromJson;

  @override
  String get sessionId;
  @override
  String get userId;
  @override
  int get startTime; // Unix timestamp (밀리초)
  @override
  int? get endTime;
  @override
  List<HtpDrawing> get drawings;
  @override
  bool get supportsPressure;

  /// Create a copy of HtpSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HtpSessionImplCopyWith<_$HtpSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HtpDrawing _$HtpDrawingFromJson(Map<String, dynamic> json) {
  return _HtpDrawing.fromJson(json);
}

/// @nodoc
mixin _$HtpDrawing {
  HtpType get type => throw _privateConstructorUsedError; // house, tree, person
  int get startTime => throw _privateConstructorUsedError;
  int? get endTime => throw _privateConstructorUsedError;
  int get strokeCount => throw _privateConstructorUsedError; // 총 스트로크 수
  int get modificationCount =>
      throw _privateConstructorUsedError; // 총 수정 횟수 (undo + 지우개 + 초기화)
  double get averagePressure =>
      throw _privateConstructorUsedError; // 평균 필압 (실제 또는 추정)
  int get orderIndex => throw _privateConstructorUsedError;

  /// Serializes this HtpDrawing to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HtpDrawing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HtpDrawingCopyWith<HtpDrawing> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HtpDrawingCopyWith<$Res> {
  factory $HtpDrawingCopyWith(
          HtpDrawing value, $Res Function(HtpDrawing) then) =
      _$HtpDrawingCopyWithImpl<$Res, HtpDrawing>;
  @useResult
  $Res call(
      {HtpType type,
      int startTime,
      int? endTime,
      int strokeCount,
      int modificationCount,
      double averagePressure,
      int orderIndex});
}

/// @nodoc
class _$HtpDrawingCopyWithImpl<$Res, $Val extends HtpDrawing>
    implements $HtpDrawingCopyWith<$Res> {
  _$HtpDrawingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HtpDrawing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? strokeCount = null,
    Object? modificationCount = null,
    Object? averagePressure = null,
    Object? orderIndex = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as HtpType,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as int,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as int?,
      strokeCount: null == strokeCount
          ? _value.strokeCount
          : strokeCount // ignore: cast_nullable_to_non_nullable
              as int,
      modificationCount: null == modificationCount
          ? _value.modificationCount
          : modificationCount // ignore: cast_nullable_to_non_nullable
              as int,
      averagePressure: null == averagePressure
          ? _value.averagePressure
          : averagePressure // ignore: cast_nullable_to_non_nullable
              as double,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HtpDrawingImplCopyWith<$Res>
    implements $HtpDrawingCopyWith<$Res> {
  factory _$$HtpDrawingImplCopyWith(
          _$HtpDrawingImpl value, $Res Function(_$HtpDrawingImpl) then) =
      __$$HtpDrawingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {HtpType type,
      int startTime,
      int? endTime,
      int strokeCount,
      int modificationCount,
      double averagePressure,
      int orderIndex});
}

/// @nodoc
class __$$HtpDrawingImplCopyWithImpl<$Res>
    extends _$HtpDrawingCopyWithImpl<$Res, _$HtpDrawingImpl>
    implements _$$HtpDrawingImplCopyWith<$Res> {
  __$$HtpDrawingImplCopyWithImpl(
      _$HtpDrawingImpl _value, $Res Function(_$HtpDrawingImpl) _then)
      : super(_value, _then);

  /// Create a copy of HtpDrawing
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? strokeCount = null,
    Object? modificationCount = null,
    Object? averagePressure = null,
    Object? orderIndex = null,
  }) {
    return _then(_$HtpDrawingImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as HtpType,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as int,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as int?,
      strokeCount: null == strokeCount
          ? _value.strokeCount
          : strokeCount // ignore: cast_nullable_to_non_nullable
              as int,
      modificationCount: null == modificationCount
          ? _value.modificationCount
          : modificationCount // ignore: cast_nullable_to_non_nullable
              as int,
      averagePressure: null == averagePressure
          ? _value.averagePressure
          : averagePressure // ignore: cast_nullable_to_non_nullable
              as double,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HtpDrawingImpl implements _HtpDrawing {
  const _$HtpDrawingImpl(
      {required this.type,
      required this.startTime,
      this.endTime,
      required this.strokeCount,
      required this.modificationCount,
      required this.averagePressure,
      this.orderIndex = -1});

  factory _$HtpDrawingImpl.fromJson(Map<String, dynamic> json) =>
      _$$HtpDrawingImplFromJson(json);

  @override
  final HtpType type;
// house, tree, person
  @override
  final int startTime;
  @override
  final int? endTime;
  @override
  final int strokeCount;
// 총 스트로크 수
  @override
  final int modificationCount;
// 총 수정 횟수 (undo + 지우개 + 초기화)
  @override
  final double averagePressure;
// 평균 필압 (실제 또는 추정)
  @override
  @JsonKey()
  final int orderIndex;

  @override
  String toString() {
    return 'HtpDrawing(type: $type, startTime: $startTime, endTime: $endTime, strokeCount: $strokeCount, modificationCount: $modificationCount, averagePressure: $averagePressure, orderIndex: $orderIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HtpDrawingImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.strokeCount, strokeCount) ||
                other.strokeCount == strokeCount) &&
            (identical(other.modificationCount, modificationCount) ||
                other.modificationCount == modificationCount) &&
            (identical(other.averagePressure, averagePressure) ||
                other.averagePressure == averagePressure) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, startTime, endTime,
      strokeCount, modificationCount, averagePressure, orderIndex);

  /// Create a copy of HtpDrawing
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HtpDrawingImplCopyWith<_$HtpDrawingImpl> get copyWith =>
      __$$HtpDrawingImplCopyWithImpl<_$HtpDrawingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HtpDrawingImplToJson(
      this,
    );
  }
}

abstract class _HtpDrawing implements HtpDrawing {
  const factory _HtpDrawing(
      {required final HtpType type,
      required final int startTime,
      final int? endTime,
      required final int strokeCount,
      required final int modificationCount,
      required final double averagePressure,
      final int orderIndex}) = _$HtpDrawingImpl;

  factory _HtpDrawing.fromJson(Map<String, dynamic> json) =
      _$HtpDrawingImpl.fromJson;

  @override
  HtpType get type; // house, tree, person
  @override
  int get startTime;
  @override
  int? get endTime;
  @override
  int get strokeCount; // 총 스트로크 수
  @override
  int get modificationCount; // 총 수정 횟수 (undo + 지우개 + 초기화)
  @override
  double get averagePressure; // 평균 필압 (실제 또는 추정)
  @override
  int get orderIndex;

  /// Create a copy of HtpDrawing
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HtpDrawingImplCopyWith<_$HtpDrawingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HtpAnalysisData _$HtpAnalysisDataFromJson(Map<String, dynamic> json) {
  return _HtpAnalysisData.fromJson(json);
}

/// @nodoc
mixin _$HtpAnalysisData {
  String get sessionId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get totalDurationSeconds =>
      throw _privateConstructorUsedError; // 총 소요 시간 (초)
  List<int> get drawingOrder =>
      throw _privateConstructorUsedError; // 그린 순서 [0=house, 1=tree, 2=person]
  List<int> get drawingDurations =>
      throw _privateConstructorUsedError; // 각 그림별 소요시간 (초)
  List<double> get averagePressures =>
      throw _privateConstructorUsedError; // 각 그림별 평균 필압
  int get totalModifications => throw _privateConstructorUsedError; // 총 수정 횟수
  bool get hasPressureData => throw _privateConstructorUsedError;

  /// Serializes this HtpAnalysisData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HtpAnalysisData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HtpAnalysisDataCopyWith<HtpAnalysisData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HtpAnalysisDataCopyWith<$Res> {
  factory $HtpAnalysisDataCopyWith(
          HtpAnalysisData value, $Res Function(HtpAnalysisData) then) =
      _$HtpAnalysisDataCopyWithImpl<$Res, HtpAnalysisData>;
  @useResult
  $Res call(
      {String sessionId,
      String userId,
      int totalDurationSeconds,
      List<int> drawingOrder,
      List<int> drawingDurations,
      List<double> averagePressures,
      int totalModifications,
      bool hasPressureData});
}

/// @nodoc
class _$HtpAnalysisDataCopyWithImpl<$Res, $Val extends HtpAnalysisData>
    implements $HtpAnalysisDataCopyWith<$Res> {
  _$HtpAnalysisDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HtpAnalysisData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userId = null,
    Object? totalDurationSeconds = null,
    Object? drawingOrder = null,
    Object? drawingDurations = null,
    Object? averagePressures = null,
    Object? totalModifications = null,
    Object? hasPressureData = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalDurationSeconds: null == totalDurationSeconds
          ? _value.totalDurationSeconds
          : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      drawingOrder: null == drawingOrder
          ? _value.drawingOrder
          : drawingOrder // ignore: cast_nullable_to_non_nullable
              as List<int>,
      drawingDurations: null == drawingDurations
          ? _value.drawingDurations
          : drawingDurations // ignore: cast_nullable_to_non_nullable
              as List<int>,
      averagePressures: null == averagePressures
          ? _value.averagePressures
          : averagePressures // ignore: cast_nullable_to_non_nullable
              as List<double>,
      totalModifications: null == totalModifications
          ? _value.totalModifications
          : totalModifications // ignore: cast_nullable_to_non_nullable
              as int,
      hasPressureData: null == hasPressureData
          ? _value.hasPressureData
          : hasPressureData // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HtpAnalysisDataImplCopyWith<$Res>
    implements $HtpAnalysisDataCopyWith<$Res> {
  factory _$$HtpAnalysisDataImplCopyWith(_$HtpAnalysisDataImpl value,
          $Res Function(_$HtpAnalysisDataImpl) then) =
      __$$HtpAnalysisDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      String userId,
      int totalDurationSeconds,
      List<int> drawingOrder,
      List<int> drawingDurations,
      List<double> averagePressures,
      int totalModifications,
      bool hasPressureData});
}

/// @nodoc
class __$$HtpAnalysisDataImplCopyWithImpl<$Res>
    extends _$HtpAnalysisDataCopyWithImpl<$Res, _$HtpAnalysisDataImpl>
    implements _$$HtpAnalysisDataImplCopyWith<$Res> {
  __$$HtpAnalysisDataImplCopyWithImpl(
      _$HtpAnalysisDataImpl _value, $Res Function(_$HtpAnalysisDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of HtpAnalysisData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? userId = null,
    Object? totalDurationSeconds = null,
    Object? drawingOrder = null,
    Object? drawingDurations = null,
    Object? averagePressures = null,
    Object? totalModifications = null,
    Object? hasPressureData = null,
  }) {
    return _then(_$HtpAnalysisDataImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalDurationSeconds: null == totalDurationSeconds
          ? _value.totalDurationSeconds
          : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      drawingOrder: null == drawingOrder
          ? _value._drawingOrder
          : drawingOrder // ignore: cast_nullable_to_non_nullable
              as List<int>,
      drawingDurations: null == drawingDurations
          ? _value._drawingDurations
          : drawingDurations // ignore: cast_nullable_to_non_nullable
              as List<int>,
      averagePressures: null == averagePressures
          ? _value._averagePressures
          : averagePressures // ignore: cast_nullable_to_non_nullable
              as List<double>,
      totalModifications: null == totalModifications
          ? _value.totalModifications
          : totalModifications // ignore: cast_nullable_to_non_nullable
              as int,
      hasPressureData: null == hasPressureData
          ? _value.hasPressureData
          : hasPressureData // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HtpAnalysisDataImpl implements _HtpAnalysisData {
  const _$HtpAnalysisDataImpl(
      {required this.sessionId,
      required this.userId,
      required this.totalDurationSeconds,
      required final List<int> drawingOrder,
      required final List<int> drawingDurations,
      required final List<double> averagePressures,
      required this.totalModifications,
      required this.hasPressureData})
      : _drawingOrder = drawingOrder,
        _drawingDurations = drawingDurations,
        _averagePressures = averagePressures;

  factory _$HtpAnalysisDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$HtpAnalysisDataImplFromJson(json);

  @override
  final String sessionId;
  @override
  final String userId;
  @override
  final int totalDurationSeconds;
// 총 소요 시간 (초)
  final List<int> _drawingOrder;
// 총 소요 시간 (초)
  @override
  List<int> get drawingOrder {
    if (_drawingOrder is EqualUnmodifiableListView) return _drawingOrder;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_drawingOrder);
  }

// 그린 순서 [0=house, 1=tree, 2=person]
  final List<int> _drawingDurations;
// 그린 순서 [0=house, 1=tree, 2=person]
  @override
  List<int> get drawingDurations {
    if (_drawingDurations is EqualUnmodifiableListView)
      return _drawingDurations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_drawingDurations);
  }

// 각 그림별 소요시간 (초)
  final List<double> _averagePressures;
// 각 그림별 소요시간 (초)
  @override
  List<double> get averagePressures {
    if (_averagePressures is EqualUnmodifiableListView)
      return _averagePressures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_averagePressures);
  }

// 각 그림별 평균 필압
  @override
  final int totalModifications;
// 총 수정 횟수
  @override
  final bool hasPressureData;

  @override
  String toString() {
    return 'HtpAnalysisData(sessionId: $sessionId, userId: $userId, totalDurationSeconds: $totalDurationSeconds, drawingOrder: $drawingOrder, drawingDurations: $drawingDurations, averagePressures: $averagePressures, totalModifications: $totalModifications, hasPressureData: $hasPressureData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HtpAnalysisDataImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.totalDurationSeconds, totalDurationSeconds) ||
                other.totalDurationSeconds == totalDurationSeconds) &&
            const DeepCollectionEquality()
                .equals(other._drawingOrder, _drawingOrder) &&
            const DeepCollectionEquality()
                .equals(other._drawingDurations, _drawingDurations) &&
            const DeepCollectionEquality()
                .equals(other._averagePressures, _averagePressures) &&
            (identical(other.totalModifications, totalModifications) ||
                other.totalModifications == totalModifications) &&
            (identical(other.hasPressureData, hasPressureData) ||
                other.hasPressureData == hasPressureData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      userId,
      totalDurationSeconds,
      const DeepCollectionEquality().hash(_drawingOrder),
      const DeepCollectionEquality().hash(_drawingDurations),
      const DeepCollectionEquality().hash(_averagePressures),
      totalModifications,
      hasPressureData);

  /// Create a copy of HtpAnalysisData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HtpAnalysisDataImplCopyWith<_$HtpAnalysisDataImpl> get copyWith =>
      __$$HtpAnalysisDataImplCopyWithImpl<_$HtpAnalysisDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HtpAnalysisDataImplToJson(
      this,
    );
  }
}

abstract class _HtpAnalysisData implements HtpAnalysisData {
  const factory _HtpAnalysisData(
      {required final String sessionId,
      required final String userId,
      required final int totalDurationSeconds,
      required final List<int> drawingOrder,
      required final List<int> drawingDurations,
      required final List<double> averagePressures,
      required final int totalModifications,
      required final bool hasPressureData}) = _$HtpAnalysisDataImpl;

  factory _HtpAnalysisData.fromJson(Map<String, dynamic> json) =
      _$HtpAnalysisDataImpl.fromJson;

  @override
  String get sessionId;
  @override
  String get userId;
  @override
  int get totalDurationSeconds; // 총 소요 시간 (초)
  @override
  List<int> get drawingOrder; // 그린 순서 [0=house, 1=tree, 2=person]
  @override
  List<int> get drawingDurations; // 각 그림별 소요시간 (초)
  @override
  List<double> get averagePressures; // 각 그림별 평균 필압
  @override
  int get totalModifications; // 총 수정 횟수
  @override
  bool get hasPressureData;

  /// Create a copy of HtpAnalysisData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HtpAnalysisDataImplCopyWith<_$HtpAnalysisDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
