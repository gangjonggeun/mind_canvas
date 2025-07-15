// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'taro_consultation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaroConsultation _$TaroConsultationFromJson(Map<String, dynamic> json) {
  return _TaroConsultation.fromJson(json);
}

/// @nodoc
mixin _$TaroConsultation {
  String get id => throw _privateConstructorUsedError;
  String get theme => throw _privateConstructorUsedError;
  TaroSpreadType get spreadType => throw _privateConstructorUsedError;
  List<String> get selectedCardIds => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  TaroResult? get result => throw _privateConstructorUsedError;

  /// Serializes this TaroConsultation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaroConsultation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaroConsultationCopyWith<TaroConsultation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaroConsultationCopyWith<$Res> {
  factory $TaroConsultationCopyWith(
          TaroConsultation value, $Res Function(TaroConsultation) then) =
      _$TaroConsultationCopyWithImpl<$Res, TaroConsultation>;
  @useResult
  $Res call(
      {String id,
      String theme,
      TaroSpreadType spreadType,
      List<String> selectedCardIds,
      DateTime? createdAt,
      TaroResult? result});

  $TaroSpreadTypeCopyWith<$Res> get spreadType;
  $TaroResultCopyWith<$Res>? get result;
}

/// @nodoc
class _$TaroConsultationCopyWithImpl<$Res, $Val extends TaroConsultation>
    implements $TaroConsultationCopyWith<$Res> {
  _$TaroConsultationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaroConsultation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theme = null,
    Object? spreadType = null,
    Object? selectedCardIds = null,
    Object? createdAt = freezed,
    Object? result = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      spreadType: null == spreadType
          ? _value.spreadType
          : spreadType // ignore: cast_nullable_to_non_nullable
              as TaroSpreadType,
      selectedCardIds: null == selectedCardIds
          ? _value.selectedCardIds
          : selectedCardIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as TaroResult?,
    ) as $Val);
  }

  /// Create a copy of TaroConsultation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaroSpreadTypeCopyWith<$Res> get spreadType {
    return $TaroSpreadTypeCopyWith<$Res>(_value.spreadType, (value) {
      return _then(_value.copyWith(spreadType: value) as $Val);
    });
  }

  /// Create a copy of TaroConsultation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaroResultCopyWith<$Res>? get result {
    if (_value.result == null) {
      return null;
    }

    return $TaroResultCopyWith<$Res>(_value.result!, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaroConsultationImplCopyWith<$Res>
    implements $TaroConsultationCopyWith<$Res> {
  factory _$$TaroConsultationImplCopyWith(_$TaroConsultationImpl value,
          $Res Function(_$TaroConsultationImpl) then) =
      __$$TaroConsultationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String theme,
      TaroSpreadType spreadType,
      List<String> selectedCardIds,
      DateTime? createdAt,
      TaroResult? result});

  @override
  $TaroSpreadTypeCopyWith<$Res> get spreadType;
  @override
  $TaroResultCopyWith<$Res>? get result;
}

/// @nodoc
class __$$TaroConsultationImplCopyWithImpl<$Res>
    extends _$TaroConsultationCopyWithImpl<$Res, _$TaroConsultationImpl>
    implements _$$TaroConsultationImplCopyWith<$Res> {
  __$$TaroConsultationImplCopyWithImpl(_$TaroConsultationImpl _value,
      $Res Function(_$TaroConsultationImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaroConsultation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? theme = null,
    Object? spreadType = null,
    Object? selectedCardIds = null,
    Object? createdAt = freezed,
    Object? result = freezed,
  }) {
    return _then(_$TaroConsultationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      spreadType: null == spreadType
          ? _value.spreadType
          : spreadType // ignore: cast_nullable_to_non_nullable
              as TaroSpreadType,
      selectedCardIds: null == selectedCardIds
          ? _value._selectedCardIds
          : selectedCardIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as TaroResult?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaroConsultationImpl implements _TaroConsultation {
  const _$TaroConsultationImpl(
      {required this.id,
      required this.theme,
      required this.spreadType,
      final List<String> selectedCardIds = const [],
      this.createdAt,
      this.result})
      : _selectedCardIds = selectedCardIds;

  factory _$TaroConsultationImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaroConsultationImplFromJson(json);

  @override
  final String id;
  @override
  final String theme;
  @override
  final TaroSpreadType spreadType;
  final List<String> _selectedCardIds;
  @override
  @JsonKey()
  List<String> get selectedCardIds {
    if (_selectedCardIds is EqualUnmodifiableListView) return _selectedCardIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedCardIds);
  }

  @override
  final DateTime? createdAt;
  @override
  final TaroResult? result;

  @override
  String toString() {
    return 'TaroConsultation(id: $id, theme: $theme, spreadType: $spreadType, selectedCardIds: $selectedCardIds, createdAt: $createdAt, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaroConsultationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.spreadType, spreadType) ||
                other.spreadType == spreadType) &&
            const DeepCollectionEquality()
                .equals(other._selectedCardIds, _selectedCardIds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.result, result) || other.result == result));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, theme, spreadType,
      const DeepCollectionEquality().hash(_selectedCardIds), createdAt, result);

  /// Create a copy of TaroConsultation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaroConsultationImplCopyWith<_$TaroConsultationImpl> get copyWith =>
      __$$TaroConsultationImplCopyWithImpl<_$TaroConsultationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaroConsultationImplToJson(
      this,
    );
  }
}

abstract class _TaroConsultation implements TaroConsultation {
  const factory _TaroConsultation(
      {required final String id,
      required final String theme,
      required final TaroSpreadType spreadType,
      final List<String> selectedCardIds,
      final DateTime? createdAt,
      final TaroResult? result}) = _$TaroConsultationImpl;

  factory _TaroConsultation.fromJson(Map<String, dynamic> json) =
      _$TaroConsultationImpl.fromJson;

  @override
  String get id;
  @override
  String get theme;
  @override
  TaroSpreadType get spreadType;
  @override
  List<String> get selectedCardIds;
  @override
  DateTime? get createdAt;
  @override
  TaroResult? get result;

  /// Create a copy of TaroConsultation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaroConsultationImplCopyWith<_$TaroConsultationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaroResult _$TaroResultFromJson(Map<String, dynamic> json) {
  return _TaroResult.fromJson(json);
}

/// @nodoc
mixin _$TaroResult {
  String get id => throw _privateConstructorUsedError;
  String get interpretation => throw _privateConstructorUsedError;
  List<TaroCardReading> get cardReadings => throw _privateConstructorUsedError;
  DateTime? get generatedAt => throw _privateConstructorUsedError;

  /// Serializes this TaroResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaroResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaroResultCopyWith<TaroResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaroResultCopyWith<$Res> {
  factory $TaroResultCopyWith(
          TaroResult value, $Res Function(TaroResult) then) =
      _$TaroResultCopyWithImpl<$Res, TaroResult>;
  @useResult
  $Res call(
      {String id,
      String interpretation,
      List<TaroCardReading> cardReadings,
      DateTime? generatedAt});
}

/// @nodoc
class _$TaroResultCopyWithImpl<$Res, $Val extends TaroResult>
    implements $TaroResultCopyWith<$Res> {
  _$TaroResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaroResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? interpretation = null,
    Object? cardReadings = null,
    Object? generatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      interpretation: null == interpretation
          ? _value.interpretation
          : interpretation // ignore: cast_nullable_to_non_nullable
              as String,
      cardReadings: null == cardReadings
          ? _value.cardReadings
          : cardReadings // ignore: cast_nullable_to_non_nullable
              as List<TaroCardReading>,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaroResultImplCopyWith<$Res>
    implements $TaroResultCopyWith<$Res> {
  factory _$$TaroResultImplCopyWith(
          _$TaroResultImpl value, $Res Function(_$TaroResultImpl) then) =
      __$$TaroResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String interpretation,
      List<TaroCardReading> cardReadings,
      DateTime? generatedAt});
}

/// @nodoc
class __$$TaroResultImplCopyWithImpl<$Res>
    extends _$TaroResultCopyWithImpl<$Res, _$TaroResultImpl>
    implements _$$TaroResultImplCopyWith<$Res> {
  __$$TaroResultImplCopyWithImpl(
      _$TaroResultImpl _value, $Res Function(_$TaroResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaroResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? interpretation = null,
    Object? cardReadings = null,
    Object? generatedAt = freezed,
  }) {
    return _then(_$TaroResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      interpretation: null == interpretation
          ? _value.interpretation
          : interpretation // ignore: cast_nullable_to_non_nullable
              as String,
      cardReadings: null == cardReadings
          ? _value._cardReadings
          : cardReadings // ignore: cast_nullable_to_non_nullable
              as List<TaroCardReading>,
      generatedAt: freezed == generatedAt
          ? _value.generatedAt
          : generatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaroResultImpl implements _TaroResult {
  const _$TaroResultImpl(
      {required this.id,
      required this.interpretation,
      required final List<TaroCardReading> cardReadings,
      this.generatedAt})
      : _cardReadings = cardReadings;

  factory _$TaroResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaroResultImplFromJson(json);

  @override
  final String id;
  @override
  final String interpretation;
  final List<TaroCardReading> _cardReadings;
  @override
  List<TaroCardReading> get cardReadings {
    if (_cardReadings is EqualUnmodifiableListView) return _cardReadings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cardReadings);
  }

  @override
  final DateTime? generatedAt;

  @override
  String toString() {
    return 'TaroResult(id: $id, interpretation: $interpretation, cardReadings: $cardReadings, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaroResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.interpretation, interpretation) ||
                other.interpretation == interpretation) &&
            const DeepCollectionEquality()
                .equals(other._cardReadings, _cardReadings) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, interpretation,
      const DeepCollectionEquality().hash(_cardReadings), generatedAt);

  /// Create a copy of TaroResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaroResultImplCopyWith<_$TaroResultImpl> get copyWith =>
      __$$TaroResultImplCopyWithImpl<_$TaroResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaroResultImplToJson(
      this,
    );
  }
}

abstract class _TaroResult implements TaroResult {
  const factory _TaroResult(
      {required final String id,
      required final String interpretation,
      required final List<TaroCardReading> cardReadings,
      final DateTime? generatedAt}) = _$TaroResultImpl;

  factory _TaroResult.fromJson(Map<String, dynamic> json) =
      _$TaroResultImpl.fromJson;

  @override
  String get id;
  @override
  String get interpretation;
  @override
  List<TaroCardReading> get cardReadings;
  @override
  DateTime? get generatedAt;

  /// Create a copy of TaroResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaroResultImplCopyWith<_$TaroResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaroCardReading _$TaroCardReadingFromJson(Map<String, dynamic> json) {
  return _TaroCardReading.fromJson(json);
}

/// @nodoc
mixin _$TaroCardReading {
  String get cardId => throw _privateConstructorUsedError;
  String get cardName => throw _privateConstructorUsedError;
  String get meaning => throw _privateConstructorUsedError;
  String get position => throw _privateConstructorUsedError;
  int get positionIndex => throw _privateConstructorUsedError;
  bool get isReversed => throw _privateConstructorUsedError;

  /// Serializes this TaroCardReading to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaroCardReading
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaroCardReadingCopyWith<TaroCardReading> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaroCardReadingCopyWith<$Res> {
  factory $TaroCardReadingCopyWith(
          TaroCardReading value, $Res Function(TaroCardReading) then) =
      _$TaroCardReadingCopyWithImpl<$Res, TaroCardReading>;
  @useResult
  $Res call(
      {String cardId,
      String cardName,
      String meaning,
      String position,
      int positionIndex,
      bool isReversed});
}

/// @nodoc
class _$TaroCardReadingCopyWithImpl<$Res, $Val extends TaroCardReading>
    implements $TaroCardReadingCopyWith<$Res> {
  _$TaroCardReadingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaroCardReading
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
    Object? cardName = null,
    Object? meaning = null,
    Object? position = null,
    Object? positionIndex = null,
    Object? isReversed = null,
  }) {
    return _then(_value.copyWith(
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
      cardName: null == cardName
          ? _value.cardName
          : cardName // ignore: cast_nullable_to_non_nullable
              as String,
      meaning: null == meaning
          ? _value.meaning
          : meaning // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String,
      positionIndex: null == positionIndex
          ? _value.positionIndex
          : positionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isReversed: null == isReversed
          ? _value.isReversed
          : isReversed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaroCardReadingImplCopyWith<$Res>
    implements $TaroCardReadingCopyWith<$Res> {
  factory _$$TaroCardReadingImplCopyWith(_$TaroCardReadingImpl value,
          $Res Function(_$TaroCardReadingImpl) then) =
      __$$TaroCardReadingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String cardId,
      String cardName,
      String meaning,
      String position,
      int positionIndex,
      bool isReversed});
}

/// @nodoc
class __$$TaroCardReadingImplCopyWithImpl<$Res>
    extends _$TaroCardReadingCopyWithImpl<$Res, _$TaroCardReadingImpl>
    implements _$$TaroCardReadingImplCopyWith<$Res> {
  __$$TaroCardReadingImplCopyWithImpl(
      _$TaroCardReadingImpl _value, $Res Function(_$TaroCardReadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaroCardReading
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
    Object? cardName = null,
    Object? meaning = null,
    Object? position = null,
    Object? positionIndex = null,
    Object? isReversed = null,
  }) {
    return _then(_$TaroCardReadingImpl(
      cardId: null == cardId
          ? _value.cardId
          : cardId // ignore: cast_nullable_to_non_nullable
              as String,
      cardName: null == cardName
          ? _value.cardName
          : cardName // ignore: cast_nullable_to_non_nullable
              as String,
      meaning: null == meaning
          ? _value.meaning
          : meaning // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String,
      positionIndex: null == positionIndex
          ? _value.positionIndex
          : positionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isReversed: null == isReversed
          ? _value.isReversed
          : isReversed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaroCardReadingImpl implements _TaroCardReading {
  const _$TaroCardReadingImpl(
      {required this.cardId,
      required this.cardName,
      required this.meaning,
      required this.position,
      required this.positionIndex,
      this.isReversed = false});

  factory _$TaroCardReadingImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaroCardReadingImplFromJson(json);

  @override
  final String cardId;
  @override
  final String cardName;
  @override
  final String meaning;
  @override
  final String position;
  @override
  final int positionIndex;
  @override
  @JsonKey()
  final bool isReversed;

  @override
  String toString() {
    return 'TaroCardReading(cardId: $cardId, cardName: $cardName, meaning: $meaning, position: $position, positionIndex: $positionIndex, isReversed: $isReversed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaroCardReadingImpl &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            (identical(other.cardName, cardName) ||
                other.cardName == cardName) &&
            (identical(other.meaning, meaning) || other.meaning == meaning) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.positionIndex, positionIndex) ||
                other.positionIndex == positionIndex) &&
            (identical(other.isReversed, isReversed) ||
                other.isReversed == isReversed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, cardId, cardName, meaning,
      position, positionIndex, isReversed);

  /// Create a copy of TaroCardReading
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaroCardReadingImplCopyWith<_$TaroCardReadingImpl> get copyWith =>
      __$$TaroCardReadingImplCopyWithImpl<_$TaroCardReadingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaroCardReadingImplToJson(
      this,
    );
  }
}

abstract class _TaroCardReading implements TaroCardReading {
  const factory _TaroCardReading(
      {required final String cardId,
      required final String cardName,
      required final String meaning,
      required final String position,
      required final int positionIndex,
      final bool isReversed}) = _$TaroCardReadingImpl;

  factory _TaroCardReading.fromJson(Map<String, dynamic> json) =
      _$TaroCardReadingImpl.fromJson;

  @override
  String get cardId;
  @override
  String get cardName;
  @override
  String get meaning;
  @override
  String get position;
  @override
  int get positionIndex;
  @override
  bool get isReversed;

  /// Create a copy of TaroCardReading
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaroCardReadingImplCopyWith<_$TaroCardReadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
