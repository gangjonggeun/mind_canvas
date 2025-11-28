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

/// @nodoc
mixin _$TaroConsultationState {
  TaroStatus get status => throw _privateConstructorUsedError;
  String get theme => throw _privateConstructorUsedError;
  TaroSpreadType? get selectedSpreadType =>
      throw _privateConstructorUsedError; // ✅ [추가] 선택된 카드 목록 (API 요청용 Input 모델)
  List<TaroCardInput> get selectedCards => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

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
      {TaroStatus status,
      String theme,
      TaroSpreadType? selectedSpreadType,
      List<TaroCardInput> selectedCards,
      String? errorMessage});

  $TaroSpreadTypeCopyWith<$Res>? get selectedSpreadType;
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
    Object? status = null,
    Object? theme = null,
    Object? selectedSpreadType = freezed,
    Object? selectedCards = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaroStatus,
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
              as List<TaroCardInput>,
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
      {TaroStatus status,
      String theme,
      TaroSpreadType? selectedSpreadType,
      List<TaroCardInput> selectedCards,
      String? errorMessage});

  @override
  $TaroSpreadTypeCopyWith<$Res>? get selectedSpreadType;
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
    Object? status = null,
    Object? theme = null,
    Object? selectedSpreadType = freezed,
    Object? selectedCards = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$TaroConsultationStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaroStatus,
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
              as List<TaroCardInput>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TaroConsultationStateImpl extends _TaroConsultationState {
  const _$TaroConsultationStateImpl(
      {this.status = TaroStatus.initial,
      this.theme = '',
      this.selectedSpreadType,
      final List<TaroCardInput> selectedCards = const [],
      this.errorMessage})
      : _selectedCards = selectedCards,
        super._();

  @override
  @JsonKey()
  final TaroStatus status;
  @override
  @JsonKey()
  final String theme;
  @override
  final TaroSpreadType? selectedSpreadType;
// ✅ [추가] 선택된 카드 목록 (API 요청용 Input 모델)
  final List<TaroCardInput> _selectedCards;
// ✅ [추가] 선택된 카드 목록 (API 요청용 Input 모델)
  @override
  @JsonKey()
  List<TaroCardInput> get selectedCards {
    if (_selectedCards is EqualUnmodifiableListView) return _selectedCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedCards);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'TaroConsultationState(status: $status, theme: $theme, selectedSpreadType: $selectedSpreadType, selectedCards: $selectedCards, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaroConsultationStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.selectedSpreadType, selectedSpreadType) ||
                other.selectedSpreadType == selectedSpreadType) &&
            const DeepCollectionEquality()
                .equals(other._selectedCards, _selectedCards) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      theme,
      selectedSpreadType,
      const DeepCollectionEquality().hash(_selectedCards),
      errorMessage);

  /// Create a copy of TaroConsultationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaroConsultationStateImplCopyWith<_$TaroConsultationStateImpl>
      get copyWith => __$$TaroConsultationStateImplCopyWithImpl<
          _$TaroConsultationStateImpl>(this, _$identity);
}

abstract class _TaroConsultationState extends TaroConsultationState {
  const factory _TaroConsultationState(
      {final TaroStatus status,
      final String theme,
      final TaroSpreadType? selectedSpreadType,
      final List<TaroCardInput> selectedCards,
      final String? errorMessage}) = _$TaroConsultationStateImpl;
  const _TaroConsultationState._() : super._();

  @override
  TaroStatus get status;
  @override
  String get theme;
  @override
  TaroSpreadType? get selectedSpreadType; // ✅ [추가] 선택된 카드 목록 (API 요청용 Input 모델)
  @override
  List<TaroCardInput> get selectedCards;
  @override
  String? get errorMessage;

  /// Create a copy of TaroConsultationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaroConsultationStateImplCopyWith<_$TaroConsultationStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
