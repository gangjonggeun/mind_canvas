// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      prefix: json['prefix'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      inkBalance: (json['inkBalance'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 0,
      totalPosts: (json['totalPosts'] as num?)?.toInt() ?? 0,
      totalComments: (json['totalComments'] as num?)?.toInt() ?? 0,
      bookmarksCount: (json['bookmarksCount'] as num?)?.toInt() ?? 0,
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      language: json['language'] as String? ?? 'ko',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'prefix': instance.prefix,
      'profileImageUrl': instance.profileImageUrl,
      'inkBalance': instance.inkBalance,
      'level': instance.level,
      'totalPosts': instance.totalPosts,
      'totalComments': instance.totalComments,
      'bookmarksCount': instance.bookmarksCount,
      'isDarkMode': instance.isDarkMode,
      'language': instance.language,
      'notificationsEnabled': instance.notificationsEnabled,
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$InkTransactionImpl _$$InkTransactionImplFromJson(Map<String, dynamic> json) =>
    _$InkTransactionImpl(
      id: json['id'] as String,
      type: $enumDecode(_$InkTransactionTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toInt(),
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$InkTransactionImplToJson(
        _$InkTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$InkTransactionTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$InkTransactionTypeEnumMap = {
  InkTransactionType.purchase: 'purchase',
  InkTransactionType.earned: 'earned',
  InkTransactionType.spent: 'spent',
  InkTransactionType.bonus: 'bonus',
};

_$UserStatsImpl _$$UserStatsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsImpl(
      postsThisMonth: (json['postsThisMonth'] as num?)?.toInt() ?? 0,
      commentsThisMonth: (json['commentsThisMonth'] as num?)?.toInt() ?? 0,
      inkEarnedThisMonth: (json['inkEarnedThisMonth'] as num?)?.toInt() ?? 0,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      totalActiveDays: (json['totalActiveDays'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UserStatsImplToJson(_$UserStatsImpl instance) =>
    <String, dynamic>{
      'postsThisMonth': instance.postsThisMonth,
      'commentsThisMonth': instance.commentsThisMonth,
      'inkEarnedThisMonth': instance.inkEarnedThisMonth,
      'streakDays': instance.streakDays,
      'totalActiveDays': instance.totalActiveDays,
    };
