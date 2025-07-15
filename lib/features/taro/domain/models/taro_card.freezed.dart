// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'taro_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaroCard _$TaroCardFromJson(Map<String, dynamic> json) {
  return _TaroCard.fromJson(json);
}

/// @nodoc
mixin _$TaroCard {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  TaroCardType get type => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  bool get isReversed => throw _privateConstructorUsedError;

  /// Serializes this TaroCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaroCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaroCardCopyWith<TaroCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaroCardCopyWith<$Res> {
  factory $TaroCardCopyWith(TaroCard value, $Res Function(TaroCard) then) =
      _$TaroCardCopyWithImpl<$Res, TaroCard>;
  @useResult
  $Res call(
      {String id,
      String name,
      String nameEn,
      String imagePath,
      TaroCardType type,
      String description,
      bool isReversed});
}

/// @nodoc
class _$TaroCardCopyWithImpl<$Res, $Val extends TaroCard>
    implements $TaroCardCopyWith<$Res> {
  _$TaroCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaroCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameEn = null,
    Object? imagePath = null,
    Object? type = null,
    Object? description = null,
    Object? isReversed = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TaroCardType,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isReversed: null == isReversed
          ? _value.isReversed
          : isReversed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaroCardImplCopyWith<$Res>
    implements $TaroCardCopyWith<$Res> {
  factory _$$TaroCardImplCopyWith(
          _$TaroCardImpl value, $Res Function(_$TaroCardImpl) then) =
      __$$TaroCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String nameEn,
      String imagePath,
      TaroCardType type,
      String description,
      bool isReversed});
}

/// @nodoc
class __$$TaroCardImplCopyWithImpl<$Res>
    extends _$TaroCardCopyWithImpl<$Res, _$TaroCardImpl>
    implements _$$TaroCardImplCopyWith<$Res> {
  __$$TaroCardImplCopyWithImpl(
      _$TaroCardImpl _value, $Res Function(_$TaroCardImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaroCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameEn = null,
    Object? imagePath = null,
    Object? type = null,
    Object? description = null,
    Object? isReversed = null,
  }) {
    return _then(_$TaroCardImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TaroCardType,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isReversed: null == isReversed
          ? _value.isReversed
          : isReversed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaroCardImpl implements _TaroCard {
  const _$TaroCardImpl(
      {required this.id,
      required this.name,
      required this.nameEn,
      required this.imagePath,
      required this.type,
      required this.description,
      this.isReversed = false});

  factory _$TaroCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaroCardImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String nameEn;
  @override
  final String imagePath;
  @override
  final TaroCardType type;
  @override
  final String description;
  @override
  @JsonKey()
  final bool isReversed;

  @override
  String toString() {
    return 'TaroCard(id: $id, name: $name, nameEn: $nameEn, imagePath: $imagePath, type: $type, description: $description, isReversed: $isReversed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaroCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isReversed, isReversed) ||
                other.isReversed == isReversed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, nameEn, imagePath, type, description, isReversed);

  /// Create a copy of TaroCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaroCardImplCopyWith<_$TaroCardImpl> get copyWith =>
      __$$TaroCardImplCopyWithImpl<_$TaroCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaroCardImplToJson(
      this,
    );
  }
}

abstract class _TaroCard implements TaroCard {
  const factory _TaroCard(
      {required final String id,
      required final String name,
      required final String nameEn,
      required final String imagePath,
      required final TaroCardType type,
      required final String description,
      final bool isReversed}) = _$TaroCardImpl;

  factory _TaroCard.fromJson(Map<String, dynamic> json) =
      _$TaroCardImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get nameEn;
  @override
  String get imagePath;
  @override
  TaroCardType get type;
  @override
  String get description;
  @override
  bool get isReversed;

  /// Create a copy of TaroCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaroCardImplCopyWith<_$TaroCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
