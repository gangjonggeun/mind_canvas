// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_content_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendedContentEntityImpl _$$RecommendedContentEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendedContentEntityImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      imageUrl: json['imageUrl'] as String,
      type: $enumDecode(_$ContentTypeEnumMap, json['type']),
      rating: json['rating'] as String,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      matchPercentage: (json['matchPercentage'] as num?)?.toDouble() ?? 0.0,
      reason: json['reason'] as String? ?? '',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$RecommendedContentEntityImplToJson(
        _$RecommendedContentEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'imageUrl': instance.imageUrl,
      'type': _$ContentTypeEnumMap[instance.type]!,
      'rating': instance.rating,
      'tags': instance.tags,
      'matchPercentage': instance.matchPercentage,
      'reason': instance.reason,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$ContentTypeEnumMap = {
  ContentType.movie: 'movie',
  ContentType.drama: 'drama',
  ContentType.music: 'music',
};

_$MbtiInfoImpl _$$MbtiInfoImplFromJson(Map<String, dynamic> json) =>
    _$MbtiInfoImpl(
      type: json['type'] as String,
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$$MbtiInfoImplToJson(_$MbtiInfoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
    };

_$RecommendedContentStateImpl _$$RecommendedContentStateImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendedContentStateImpl(
      contents: (json['contents'] as List<dynamic>?)
              ?.map((e) =>
                  RecommendedContentEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      selectedContentType: $enumDecodeNullable(
              _$ContentTypeEnumMap, json['selectedContentType']) ??
          ContentType.movie,
      selectedContentMode: $enumDecodeNullable(
              _$ContentModeEnumMap, json['selectedContentMode']) ??
          ContentMode.personal,
      userMbti: json['userMbti'] == null
          ? const MbtiInfo(type: 'ENFP')
          : MbtiInfo.fromJson(json['userMbti'] as Map<String, dynamic>),
      partnerMbti: json['partnerMbti'] == null
          ? const MbtiInfo(type: 'ISFJ')
          : MbtiInfo.fromJson(json['partnerMbti'] as Map<String, dynamic>),
      isLoading: json['isLoading'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String? ?? null,
    );

Map<String, dynamic> _$$RecommendedContentStateImplToJson(
        _$RecommendedContentStateImpl instance) =>
    <String, dynamic>{
      'contents': instance.contents,
      'selectedContentType':
          _$ContentTypeEnumMap[instance.selectedContentType]!,
      'selectedContentMode':
          _$ContentModeEnumMap[instance.selectedContentMode]!,
      'userMbti': instance.userMbti,
      'partnerMbti': instance.partnerMbti,
      'isLoading': instance.isLoading,
      'errorMessage': instance.errorMessage,
    };

const _$ContentModeEnumMap = {
  ContentMode.personal: 'personal',
  ContentMode.together: 'together',
};
