// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'taro_consultation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaroConsultationState _$TaroConsultationStateFromJson(
    Map<String, dynamic> json) {
  return _TaroConsultationState.fromJson(json);
}

/// @nodoc
mixin _$TaroConsultationState {
  String get theme => throw _privateConstructorUsedError;
  TaroSpreadType? get selectedSpreadType => throw _privateConstructorUsedError;
  List<String?> get selectedCards =>
      throw _privateConstructorUsedError; // null = 빈 위치
  TaroStatus get status => throw _privateConstructorUsedError;
  TaroResult? get result => throw _privateConstructorUsedError;
  String? get interpretation => throw _privateConstructorUsedError; // 해석 결과 추가
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this TaroConsultationState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaroConsultationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaroConsultationStateCopyWith<TaroConsultationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaroConsultationStateCopyWith<$Res> {
  factory $TaroConsultationStateCopyWith(TaroConsultationState value,
          $Res Function(TaroConsultationState) then) =
      _$TaroConsultationStateCopyWithImpl<$Res, TaroConsultationState>;
  @useResult
  $Res call(
      {String theme,
      TaroSpreadType? selectedSpreadType,
      List<String?> selectedCards,
      TaroStatus status,
      TaroResult? result,
      String? interpretation,
      String? errorMessage});

  $TaroSpreadTypeCopyWith<$Res>? get selectedSpreadType;
  $TaroResultCopyWith<$Res>? get result;
}

/// @nodoc
class _$TaroConsultationStateCopyWithImpl<$Res,
        $Val extends TaroConsultationState>
    implements $TaroConsultationStateCopyWith<$Res> {
  _$TaroConsultationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaroConsultationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? selectedSpreadType = freezed,
    Object? selectedCards = null,
    Object? status = null,
    Object? result = freezed,
    Object? interpretation = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      selectedSpreadType: freezed == selectedSpreadType
          ? _value.selectedSpreadType
          : selectedSpreadType // ignore: cast_nullable_to_non_nullable
              as TaroSpreadType?,
      selectedCards: null == selectedCards
          ? _value.selectedCards
          : selectedCards // ignore: cast_nullable_to_non_nullable
              as List<String?>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaroStatus,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as TaroResult?,
      interpretation: freezed == interpretation
          ? _value.interpretation
          : interpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of TaroConsultationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaroSpreadTypeCopyWith<$Res>? get selectedSpreadType {
    if (_value.selectedSpreadType == null) {
      return null;
    }

    return $TaroSpreadTypeCopyWith<$Res>(_value.selectedSpreadType!, (value) {
      return _then(_value.copyWith(selectedSpreadType: value) as $Val);
    });
  }

  /// Create a copy of TaroConsultationState
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
abstract class _$$TaroConsultationStateImplCopyWith<$Res>
    implements $TaroConsultationStateCopyWith<$Res> {
  factory _$$TaroConsultationStateImplCopyWith(
          _$TaroConsultationStateImpl value,
          $Res Function(_$TaroConsultationStateImpl) then) =
      __$$TaroConsultationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String theme,
      TaroSpreadType? selectedSpreadType,
      List<String?> selectedCards,
      TaroStatus status,
      TaroResult? result,
      String? interpretation,
      String? errorMessage});

  @override
  $TaroSpreadTypeCopyWith<$Res>? get selectedSpreadType;
  @override
  $TaroResultCopyWith<$Res>? get result;
}

/// @nodoc
class __$$TaroConsultationStateImplCopyWithImpl<$Res>
    extends _$TaroConsultationStateCopyWithImpl<$Res,
        _$TaroConsultationStateImpl>
    implements _$$TaroConsultationStateImplCopyWith<$Res> {
  __$$TaroConsultationStateImplCopyWithImpl(_$TaroConsultationStateImpl _value,
      $Res Function(_$TaroConsultationStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaroConsultationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? selectedSpreadType = freezed,
    Object? selectedCards = null,
    Object? status = null,
    Object? result = freezed,
    Object? interpretation = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$TaroConsultationStateImpl(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as String,
      selectedSpreadType: freezed == selectedSpreadType
          ? _value.selectedSpreadType
          : selectedSpreadType // ignore: cast_nullable_to_non_nullable
              as TaroSpreadType?,
      selectedCards: null == selectedCards
          ? _value._selectedCards
          : selectedCards // ignore: cast_nullable_to_non_nullable
              as List<String?>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaroStatus,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as TaroResult?,
      interpretation: freezed == interpretation
          ? _value.interpretation
          : interpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaroConsultationStateImpl implements _TaroConsultationState {
  const _$TaroConsultationStateImpl(
      {this.theme = '',
      this.selectedSpreadType,
      final List<String?> selectedCards = const [],
      this.status = TaroStatus.initial,
      this.result,
      this.interpretation,
      this.errorMessage})
      : _selectedCards = selectedCards;

  factory _$TaroConsultationStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaroConsultationStateImplFromJson(json);

  @override
  @JsonKey()
  final String theme;
  @override
  final TaroSpreadType? selectedSpreadType;
  final List<String?> _selectedCards;
  @override
  @JsonKey()
  List<String?> get selectedCards {
    if (_selectedCards is EqualUnmodifiableListView) return _selectedCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedCards);
  }

// null = 빈 위치
  @override
  @JsonKey()
  final TaroStatus status;
  @override
  final TaroResult? result;
  @override
  final String? interpretation;
// 해석 결과 추가
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'TaroConsultationState(theme: $theme, selectedSpreadType: $selectedSpreadType, selectedCards: $selectedCards, status: $status, result: $result, interpretation: $interpretation, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaroConsultationStateImpl &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.selectedSpreadType, selectedSpreadType) ||
                other.selectedSpreadType == selectedSpreadType) &&
            const DeepCollectionEquality()
                .equals(other._selectedCards, _selectedCards) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.interpretation, interpretation) ||
                other.interpretation == interpretation) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      theme,
      selectedSpreadType,
      const DeepCollectionEquality().hash(_selectedCards),
      status,
      result,
      interpretation,
      errorMessage);

  /// Create a copy of TaroConsultationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaroConsultationStateImplCopyWith<_$TaroConsultationStateImpl>
      get copyWith => __$$TaroConsultationStateImplCopyWithImpl<
          _$TaroConsultationStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaroConsultationStateImplToJson(
      this,
    );
  }
}

abstract class _TaroConsultationState implements TaroConsultationState {
  const factory _TaroConsultationState(
      {final String theme,
      final TaroSpreadType? selectedSpreadType,
      final List<String?> selectedCards,
      final TaroStatus status,
      final TaroResult? result,
      final String? interpretation,
      final String? errorMessage}) = _$TaroConsultationStateImpl;

  factory _TaroConsultationState.fromJson(Map<String, dynamic> json) =
      _$TaroConsultationStateImpl.fromJson;

  @override
  String get theme;
  @override
  TaroSpreadType? get selectedSpreadType;
  @override
  List<String?> get selectedCards; // null = 빈 위치
  @override
  TaroStatus get status;
  @override
  TaroResult? get result;
  @override
  String? get interpretation; // 해석 결과 추가
  @override
  String? get errorMessage;

  /// Create a copy of TaroConsultationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaroConsultationStateImplCopyWith<_$TaroConsultationStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
