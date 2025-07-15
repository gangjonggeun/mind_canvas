// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'taro_spread_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaroSpreadType _$TaroSpreadTypeFromJson(Map<String, dynamic> json) {
  return _TaroSpreadType.fromJson(json);
}

/// @nodoc
mixin _$TaroSpreadType {
  int get cardCount => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;

  /// Serializes this TaroSpreadType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaroSpreadType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaroSpreadTypeCopyWith<TaroSpreadType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaroSpreadTypeCopyWith<$Res> {
  factory $TaroSpreadTypeCopyWith(
          TaroSpreadType value, $Res Function(TaroSpreadType) then) =
      _$TaroSpreadTypeCopyWithImpl<$Res, TaroSpreadType>;
  @useResult
  $Res call({int cardCount, String name, String description, String nameEn});
}

/// @nodoc
class _$TaroSpreadTypeCopyWithImpl<$Res, $Val extends TaroSpreadType>
    implements $TaroSpreadTypeCopyWith<$Res> {
  _$TaroSpreadTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaroSpreadType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardCount = null,
    Object? name = null,
    Object? description = null,
    Object? nameEn = null,
  }) {
    return _then(_value.copyWith(
      cardCount: null == cardCount
          ? _value.cardCount
          : cardCount // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaroSpreadTypeImplCopyWith<$Res>
    implements $TaroSpreadTypeCopyWith<$Res> {
  factory _$$TaroSpreadTypeImplCopyWith(_$TaroSpreadTypeImpl value,
          $Res Function(_$TaroSpreadTypeImpl) then) =
      __$$TaroSpreadTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int cardCount, String name, String description, String nameEn});
}

/// @nodoc
class __$$TaroSpreadTypeImplCopyWithImpl<$Res>
    extends _$TaroSpreadTypeCopyWithImpl<$Res, _$TaroSpreadTypeImpl>
    implements _$$TaroSpreadTypeImplCopyWith<$Res> {
  __$$TaroSpreadTypeImplCopyWithImpl(
      _$TaroSpreadTypeImpl _value, $Res Function(_$TaroSpreadTypeImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaroSpreadType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardCount = null,
    Object? name = null,
    Object? description = null,
    Object? nameEn = null,
  }) {
    return _then(_$TaroSpreadTypeImpl(
      cardCount: null == cardCount
          ? _value.cardCount
          : cardCount // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaroSpreadTypeImpl implements _TaroSpreadType {
  const _$TaroSpreadTypeImpl(
      {required this.cardCount,
      required this.name,
      required this.description,
      required this.nameEn});

  factory _$TaroSpreadTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaroSpreadTypeImplFromJson(json);

  @override
  final int cardCount;
  @override
  final String name;
  @override
  final String description;
  @override
  final String nameEn;

  @override
  String toString() {
    return 'TaroSpreadType(cardCount: $cardCount, name: $name, description: $description, nameEn: $nameEn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaroSpreadTypeImpl &&
            (identical(other.cardCount, cardCount) ||
                other.cardCount == cardCount) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, cardCount, name, description, nameEn);

  /// Create a copy of TaroSpreadType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaroSpreadTypeImplCopyWith<_$TaroSpreadTypeImpl> get copyWith =>
      __$$TaroSpreadTypeImplCopyWithImpl<_$TaroSpreadTypeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaroSpreadTypeImplToJson(
      this,
    );
  }
}

abstract class _TaroSpreadType implements TaroSpreadType {
  const factory _TaroSpreadType(
      {required final int cardCount,
      required final String name,
      required final String description,
      required final String nameEn}) = _$TaroSpreadTypeImpl;

  factory _TaroSpreadType.fromJson(Map<String, dynamic> json) =
      _$TaroSpreadTypeImpl.fromJson;

  @override
  int get cardCount;
  @override
  String get name;
  @override
  String get description;
  @override
  String get nameEn;

  /// Create a copy of TaroSpreadType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaroSpreadTypeImplCopyWith<_$TaroSpreadTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
