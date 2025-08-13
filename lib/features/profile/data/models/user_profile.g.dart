// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map json) => $checkedCreate(
      r'_$UserProfileImpl',
      json,
      ($checkedConvert) {
        final val = _$UserProfileImpl(
          id: $checkedConvert('id', (v) => v as String),
          nickname: $checkedConvert('nickname', (v) => v as String),
          prefix: $checkedConvert('prefix', (v) => v as String),
          profileImageUrl:
              $checkedConvert('profileImageUrl', (v) => v as String?),
          inkBalance:
              $checkedConvert('inkBalance', (v) => (v as num?)?.toInt() ?? 0),
          level: $checkedConvert('level', (v) => (v as num?)?.toInt() ?? 0),
          totalPosts:
              $checkedConvert('totalPosts', (v) => (v as num?)?.toInt() ?? 0),
          totalComments: $checkedConvert(
              'totalComments', (v) => (v as num?)?.toInt() ?? 0),
          bookmarksCount: $checkedConvert(
              'bookmarksCount', (v) => (v as num?)?.toInt() ?? 0),
          isDarkMode: $checkedConvert('isDarkMode', (v) => v as bool? ?? false),
          language: $checkedConvert('language', (v) => v as String? ?? 'ko'),
          notificationsEnabled: $checkedConvert(
              'notificationsEnabled', (v) => v as bool? ?? true),
          lastLoginAt: $checkedConvert('lastLoginAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
          createdAt: $checkedConvert('createdAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
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

_$InkTransactionImpl _$$InkTransactionImplFromJson(Map json) => $checkedCreate(
      r'_$InkTransactionImpl',
      json,
      ($checkedConvert) {
        final val = _$InkTransactionImpl(
          id: $checkedConvert('id', (v) => v as String),
          type: $checkedConvert(
              'type', (v) => $enumDecode(_$InkTransactionTypeEnumMap, v)),
          amount: $checkedConvert('amount', (v) => (v as num).toInt()),
          description: $checkedConvert('description', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
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

_$UserStatsImpl _$$UserStatsImplFromJson(Map json) => $checkedCreate(
      r'_$UserStatsImpl',
      json,
      ($checkedConvert) {
        final val = _$UserStatsImpl(
          postsThisMonth: $checkedConvert(
              'postsThisMonth', (v) => (v as num?)?.toInt() ?? 0),
          commentsThisMonth: $checkedConvert(
              'commentsThisMonth', (v) => (v as num?)?.toInt() ?? 0),
          inkEarnedThisMonth: $checkedConvert(
              'inkEarnedThisMonth', (v) => (v as num?)?.toInt() ?? 0),
          streakDays:
              $checkedConvert('streakDays', (v) => (v as num?)?.toInt() ?? 0),
          totalActiveDays: $checkedConvert(
              'totalActiveDays', (v) => (v as num?)?.toInt() ?? 0),
        );
        return val;
      },
    );

Map<String, dynamic> _$$UserStatsImplToJson(_$UserStatsImpl instance) =>
    <String, dynamic>{
      'postsThisMonth': instance.postsThisMonth,
      'commentsThisMonth': instance.commentsThisMonth,
      'inkEarnedThisMonth': instance.inkEarnedThisMonth,
      'streakDays': instance.streakDays,
      'totalActiveDays': instance.totalActiveDays,
    };
