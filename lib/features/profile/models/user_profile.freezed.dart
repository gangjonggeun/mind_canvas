// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  String get prefix => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;
  int get inkBalance => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  int get totalPosts => throw _privateConstructorUsedError;
  int get totalComments => throw _privateConstructorUsedError;
  int get bookmarksCount => throw _privateConstructorUsedError;
  bool get isDarkMode => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String id,
      String nickname,
      String prefix,
      String? profileImageUrl,
      int inkBalance,
      int level,
      int totalPosts,
      int totalComments,
      int bookmarksCount,
      bool isDarkMode,
      String language,
      bool notificationsEnabled,
      DateTime? lastLoginAt,
      DateTime? createdAt});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? prefix = null,
    Object? profileImageUrl = freezed,
    Object? inkBalance = null,
    Object? level = null,
    Object? totalPosts = null,
    Object? totalComments = null,
    Object? bookmarksCount = null,
    Object? isDarkMode = null,
    Object? language = null,
    Object? notificationsEnabled = null,
    Object? lastLoginAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      prefix: null == prefix
          ? _value.prefix
          : prefix // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      inkBalance: null == inkBalance
          ? _value.inkBalance
          : inkBalance // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      totalPosts: null == totalPosts
          ? _value.totalPosts
          : totalPosts // ignore: cast_nullable_to_non_nullable
              as int,
      totalComments: null == totalComments
          ? _value.totalComments
          : totalComments // ignore: cast_nullable_to_non_nullable
              as int,
      bookmarksCount: null == bookmarksCount
          ? _value.bookmarksCount
          : bookmarksCount // ignore: cast_nullable_to_non_nullable
              as int,
      isDarkMode: null == isDarkMode
          ? _value.isDarkMode
          : isDarkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nickname,
      String prefix,
      String? profileImageUrl,
      int inkBalance,
      int level,
      int totalPosts,
      int totalComments,
      int bookmarksCount,
      bool isDarkMode,
      String language,
      bool notificationsEnabled,
      DateTime? lastLoginAt,
      DateTime? createdAt});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? prefix = null,
    Object? profileImageUrl = freezed,
    Object? inkBalance = null,
    Object? level = null,
    Object? totalPosts = null,
    Object? totalComments = null,
    Object? bookmarksCount = null,
    Object? isDarkMode = null,
    Object? language = null,
    Object? notificationsEnabled = null,
    Object? lastLoginAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$UserProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      prefix: null == prefix
          ? _value.prefix
          : prefix // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      inkBalance: null == inkBalance
          ? _value.inkBalance
          : inkBalance // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      totalPosts: null == totalPosts
          ? _value.totalPosts
          : totalPosts // ignore: cast_nullable_to_non_nullable
              as int,
      totalComments: null == totalComments
          ? _value.totalComments
          : totalComments // ignore: cast_nullable_to_non_nullable
              as int,
      bookmarksCount: null == bookmarksCount
          ? _value.bookmarksCount
          : bookmarksCount // ignore: cast_nullable_to_non_nullable
              as int,
      isDarkMode: null == isDarkMode
          ? _value.isDarkMode
          : isDarkMode // ignore: cast_nullable_to_non_nullable
              as bool,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.id,
      required this.nickname,
      required this.prefix,
      this.profileImageUrl,
      this.inkBalance = 0,
      this.level = 0,
      this.totalPosts = 0,
      this.totalComments = 0,
      this.bookmarksCount = 0,
      this.isDarkMode = false,
      this.language = 'ko',
      this.notificationsEnabled = true,
      this.lastLoginAt,
      this.createdAt});

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String nickname;
  @override
  final String prefix;
  @override
  final String? profileImageUrl;
  @override
  @JsonKey()
  final int inkBalance;
  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final int totalPosts;
  @override
  @JsonKey()
  final int totalComments;
  @override
  @JsonKey()
  final int bookmarksCount;
  @override
  @JsonKey()
  final bool isDarkMode;
  @override
  @JsonKey()
  final String language;
  @override
  @JsonKey()
  final bool notificationsEnabled;
  @override
  final DateTime? lastLoginAt;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'UserProfile(id: $id, nickname: $nickname, prefix: $prefix, profileImageUrl: $profileImageUrl, inkBalance: $inkBalance, level: $level, totalPosts: $totalPosts, totalComments: $totalComments, bookmarksCount: $bookmarksCount, isDarkMode: $isDarkMode, language: $language, notificationsEnabled: $notificationsEnabled, lastLoginAt: $lastLoginAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.prefix, prefix) || other.prefix == prefix) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.inkBalance, inkBalance) ||
                other.inkBalance == inkBalance) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.totalPosts, totalPosts) ||
                other.totalPosts == totalPosts) &&
            (identical(other.totalComments, totalComments) ||
                other.totalComments == totalComments) &&
            (identical(other.bookmarksCount, bookmarksCount) ||
                other.bookmarksCount == bookmarksCount) &&
            (identical(other.isDarkMode, isDarkMode) ||
                other.isDarkMode == isDarkMode) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nickname,
      prefix,
      profileImageUrl,
      inkBalance,
      level,
      totalPosts,
      totalComments,
      bookmarksCount,
      isDarkMode,
      language,
      notificationsEnabled,
      lastLoginAt,
      createdAt);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {required final String id,
      required final String nickname,
      required final String prefix,
      final String? profileImageUrl,
      final int inkBalance,
      final int level,
      final int totalPosts,
      final int totalComments,
      final int bookmarksCount,
      final bool isDarkMode,
      final String language,
      final bool notificationsEnabled,
      final DateTime? lastLoginAt,
      final DateTime? createdAt}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get nickname;
  @override
  String get prefix;
  @override
  String? get profileImageUrl;
  @override
  int get inkBalance;
  @override
  int get level;
  @override
  int get totalPosts;
  @override
  int get totalComments;
  @override
  int get bookmarksCount;
  @override
  bool get isDarkMode;
  @override
  String get language;
  @override
  bool get notificationsEnabled;
  @override
  DateTime? get lastLoginAt;
  @override
  DateTime? get createdAt;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InkTransaction _$InkTransactionFromJson(Map<String, dynamic> json) {
  return _InkTransaction.fromJson(json);
}

/// @nodoc
mixin _$InkTransaction {
  String get id => throw _privateConstructorUsedError;
  InkTransactionType get type => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this InkTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InkTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InkTransactionCopyWith<InkTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InkTransactionCopyWith<$Res> {
  factory $InkTransactionCopyWith(
          InkTransaction value, $Res Function(InkTransaction) then) =
      _$InkTransactionCopyWithImpl<$Res, InkTransaction>;
  @useResult
  $Res call(
      {String id,
      InkTransactionType type,
      int amount,
      String description,
      DateTime createdAt});
}

/// @nodoc
class _$InkTransactionCopyWithImpl<$Res, $Val extends InkTransaction>
    implements $InkTransactionCopyWith<$Res> {
  _$InkTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InkTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? description = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as InkTransactionType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InkTransactionImplCopyWith<$Res>
    implements $InkTransactionCopyWith<$Res> {
  factory _$$InkTransactionImplCopyWith(_$InkTransactionImpl value,
          $Res Function(_$InkTransactionImpl) then) =
      __$$InkTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      InkTransactionType type,
      int amount,
      String description,
      DateTime createdAt});
}

/// @nodoc
class __$$InkTransactionImplCopyWithImpl<$Res>
    extends _$InkTransactionCopyWithImpl<$Res, _$InkTransactionImpl>
    implements _$$InkTransactionImplCopyWith<$Res> {
  __$$InkTransactionImplCopyWithImpl(
      _$InkTransactionImpl _value, $Res Function(_$InkTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of InkTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? description = null,
    Object? createdAt = null,
  }) {
    return _then(_$InkTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as InkTransactionType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InkTransactionImpl implements _InkTransaction {
  const _$InkTransactionImpl(
      {required this.id,
      required this.type,
      required this.amount,
      required this.description,
      required this.createdAt});

  factory _$InkTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$InkTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final InkTransactionType type;
  @override
  final int amount;
  @override
  final String description;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'InkTransaction(id: $id, type: $type, amount: $amount, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InkTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, amount, description, createdAt);

  /// Create a copy of InkTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InkTransactionImplCopyWith<_$InkTransactionImpl> get copyWith =>
      __$$InkTransactionImplCopyWithImpl<_$InkTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InkTransactionImplToJson(
      this,
    );
  }
}

abstract class _InkTransaction implements InkTransaction {
  const factory _InkTransaction(
      {required final String id,
      required final InkTransactionType type,
      required final int amount,
      required final String description,
      required final DateTime createdAt}) = _$InkTransactionImpl;

  factory _InkTransaction.fromJson(Map<String, dynamic> json) =
      _$InkTransactionImpl.fromJson;

  @override
  String get id;
  @override
  InkTransactionType get type;
  @override
  int get amount;
  @override
  String get description;
  @override
  DateTime get createdAt;

  /// Create a copy of InkTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InkTransactionImplCopyWith<_$InkTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserStats _$UserStatsFromJson(Map<String, dynamic> json) {
  return _UserStats.fromJson(json);
}

/// @nodoc
mixin _$UserStats {
  int get postsThisMonth => throw _privateConstructorUsedError;
  int get commentsThisMonth => throw _privateConstructorUsedError;
  int get inkEarnedThisMonth => throw _privateConstructorUsedError;
  int get streakDays => throw _privateConstructorUsedError;
  int get totalActiveDays => throw _privateConstructorUsedError;

  /// Serializes this UserStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStatsCopyWith<UserStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsCopyWith<$Res> {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) then) =
      _$UserStatsCopyWithImpl<$Res, UserStats>;
  @useResult
  $Res call(
      {int postsThisMonth,
      int commentsThisMonth,
      int inkEarnedThisMonth,
      int streakDays,
      int totalActiveDays});
}

/// @nodoc
class _$UserStatsCopyWithImpl<$Res, $Val extends UserStats>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postsThisMonth = null,
    Object? commentsThisMonth = null,
    Object? inkEarnedThisMonth = null,
    Object? streakDays = null,
    Object? totalActiveDays = null,
  }) {
    return _then(_value.copyWith(
      postsThisMonth: null == postsThisMonth
          ? _value.postsThisMonth
          : postsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      commentsThisMonth: null == commentsThisMonth
          ? _value.commentsThisMonth
          : commentsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      inkEarnedThisMonth: null == inkEarnedThisMonth
          ? _value.inkEarnedThisMonth
          : inkEarnedThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      totalActiveDays: null == totalActiveDays
          ? _value.totalActiveDays
          : totalActiveDays // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserStatsImplCopyWith<$Res>
    implements $UserStatsCopyWith<$Res> {
  factory _$$UserStatsImplCopyWith(
          _$UserStatsImpl value, $Res Function(_$UserStatsImpl) then) =
      __$$UserStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int postsThisMonth,
      int commentsThisMonth,
      int inkEarnedThisMonth,
      int streakDays,
      int totalActiveDays});
}

/// @nodoc
class __$$UserStatsImplCopyWithImpl<$Res>
    extends _$UserStatsCopyWithImpl<$Res, _$UserStatsImpl>
    implements _$$UserStatsImplCopyWith<$Res> {
  __$$UserStatsImplCopyWithImpl(
      _$UserStatsImpl _value, $Res Function(_$UserStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postsThisMonth = null,
    Object? commentsThisMonth = null,
    Object? inkEarnedThisMonth = null,
    Object? streakDays = null,
    Object? totalActiveDays = null,
  }) {
    return _then(_$UserStatsImpl(
      postsThisMonth: null == postsThisMonth
          ? _value.postsThisMonth
          : postsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      commentsThisMonth: null == commentsThisMonth
          ? _value.commentsThisMonth
          : commentsThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      inkEarnedThisMonth: null == inkEarnedThisMonth
          ? _value.inkEarnedThisMonth
          : inkEarnedThisMonth // ignore: cast_nullable_to_non_nullable
              as int,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      totalActiveDays: null == totalActiveDays
          ? _value.totalActiveDays
          : totalActiveDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsImpl implements _UserStats {
  const _$UserStatsImpl(
      {this.postsThisMonth = 0,
      this.commentsThisMonth = 0,
      this.inkEarnedThisMonth = 0,
      this.streakDays = 0,
      this.totalActiveDays = 0});

  factory _$UserStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsImplFromJson(json);

  @override
  @JsonKey()
  final int postsThisMonth;
  @override
  @JsonKey()
  final int commentsThisMonth;
  @override
  @JsonKey()
  final int inkEarnedThisMonth;
  @override
  @JsonKey()
  final int streakDays;
  @override
  @JsonKey()
  final int totalActiveDays;

  @override
  String toString() {
    return 'UserStats(postsThisMonth: $postsThisMonth, commentsThisMonth: $commentsThisMonth, inkEarnedThisMonth: $inkEarnedThisMonth, streakDays: $streakDays, totalActiveDays: $totalActiveDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsImpl &&
            (identical(other.postsThisMonth, postsThisMonth) ||
                other.postsThisMonth == postsThisMonth) &&
            (identical(other.commentsThisMonth, commentsThisMonth) ||
                other.commentsThisMonth == commentsThisMonth) &&
            (identical(other.inkEarnedThisMonth, inkEarnedThisMonth) ||
                other.inkEarnedThisMonth == inkEarnedThisMonth) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.totalActiveDays, totalActiveDays) ||
                other.totalActiveDays == totalActiveDays));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, postsThisMonth,
      commentsThisMonth, inkEarnedThisMonth, streakDays, totalActiveDays);

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      __$$UserStatsImplCopyWithImpl<_$UserStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsImplToJson(
      this,
    );
  }
}

abstract class _UserStats implements UserStats {
  const factory _UserStats(
      {final int postsThisMonth,
      final int commentsThisMonth,
      final int inkEarnedThisMonth,
      final int streakDays,
      final int totalActiveDays}) = _$UserStatsImpl;

  factory _UserStats.fromJson(Map<String, dynamic> json) =
      _$UserStatsImpl.fromJson;

  @override
  int get postsThisMonth;
  @override
  int get commentsThisMonth;
  @override
  int get inkEarnedThisMonth;
  @override
  int get streakDays;
  @override
  int get totalActiveDays;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
