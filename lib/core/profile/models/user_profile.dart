import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String nickname,
    required String prefix,
    String? profileImageUrl,
    @Default(0) int inkBalance,
    @Default(0) int level,
    @Default(0) int totalPosts,
    @Default(0) int totalComments,
    @Default(0) int bookmarksCount,
    @Default(false) bool isDarkMode,
    @Default('ko') String language,
    @Default(true) bool notificationsEnabled,
    DateTime? lastLoginAt,
    DateTime? createdAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

@freezed
class InkTransaction with _$InkTransaction {
  const factory InkTransaction({
    required String id,
    required InkTransactionType type,
    required int amount,
    required String description,
    required DateTime createdAt,
  }) = _InkTransaction;

  factory InkTransaction.fromJson(Map<String, dynamic> json) =>
      _$InkTransactionFromJson(json);
}

enum InkTransactionType {
  @JsonValue('purchase')
  purchase,
  @JsonValue('earned')
  earned,
  @JsonValue('spent')
  spent,
  @JsonValue('bonus')
  bonus,
}

@freezed
class UserStats with _$UserStats {
  const factory UserStats({
    @Default(0) int postsThisMonth,
    @Default(0) int commentsThisMonth,
    @Default(0) int inkEarnedThisMonth,
    @Default(0) int streakDays,
    @Default(0) int totalActiveDays,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}
