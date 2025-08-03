// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_content_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendedContentEntityImpl _$$RecommendedContentEntityImplFromJson(
        Map json) =>
    $checkedCreate(
      r'_$RecommendedContentEntityImpl',
      json,
      ($checkedConvert) {
        final val = _$RecommendedContentEntityImpl(
          id: $checkedConvert('id', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          subtitle: $checkedConvert('subtitle', (v) => v as String),
          imageUrl: $checkedConvert('imageUrl', (v) => v as String),
          type: $checkedConvert(
              'type', (v) => $enumDecode(_$ContentTypeEnumMap, v)),
          rating: $checkedConvert('rating', (v) => v as String),
          tags: $checkedConvert(
              'tags',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                  const []),
          matchPercentage: $checkedConvert(
              'matchPercentage', (v) => (v as num?)?.toDouble() ?? 0.0),
          reason: $checkedConvert('reason', (v) => v as String? ?? ''),
          createdAt: $checkedConvert('createdAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
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

_$MbtiInfoImpl _$$MbtiInfoImplFromJson(Map json) => $checkedCreate(
      r'_$MbtiInfoImpl',
      json,
      ($checkedConvert) {
        final val = _$MbtiInfoImpl(
          type: $checkedConvert('type', (v) => v as String),
          description:
              $checkedConvert('description', (v) => v as String? ?? ''),
        );
        return val;
      },
    );

Map<String, dynamic> _$$MbtiInfoImplToJson(_$MbtiInfoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
    };

_$RecommendedContentStateImpl _$$RecommendedContentStateImplFromJson(
        Map json) =>
    $checkedCreate(
      r'_$RecommendedContentStateImpl',
      json,
      ($checkedConvert) {
        final val = _$RecommendedContentStateImpl(
          contents: $checkedConvert(
              'contents',
              (v) =>
                  (v as List<dynamic>?)
                      ?.map((e) => RecommendedContentEntity.fromJson(
                          Map<String, dynamic>.from(e as Map)))
                      .toList() ??
                  const []),
          selectedContentType: $checkedConvert(
              'selectedContentType',
              (v) =>
                  $enumDecodeNullable(_$ContentTypeEnumMap, v) ??
                  ContentType.movie),
          selectedContentMode: $checkedConvert(
              'selectedContentMode',
              (v) =>
                  $enumDecodeNullable(_$ContentModeEnumMap, v) ??
                  ContentMode.personal),
          userMbti: $checkedConvert(
              'userMbti',
              (v) => v == null
                  ? const MbtiInfo(type: 'ENFP')
                  : MbtiInfo.fromJson(Map<String, dynamic>.from(v as Map))),
          partnerMbti: $checkedConvert(
              'partnerMbti',
              (v) => v == null
                  ? const MbtiInfo(type: 'ISFJ')
                  : MbtiInfo.fromJson(Map<String, dynamic>.from(v as Map))),
          isLoading: $checkedConvert('isLoading', (v) => v as bool? ?? false),
          errorMessage:
              $checkedConvert('errorMessage', (v) => v as String? ?? null),
        );
        return val;
      },
    );

Map<String, dynamic> _$$RecommendedContentStateImplToJson(
        _$RecommendedContentStateImpl instance) =>
    <String, dynamic>{
      'contents': instance.contents.map((e) => e.toJson()).toList(),
      'selectedContentType':
          _$ContentTypeEnumMap[instance.selectedContentType]!,
      'selectedContentMode':
          _$ContentModeEnumMap[instance.selectedContentMode]!,
      'userMbti': instance.userMbti.toJson(),
      'partnerMbti': instance.partnerMbti.toJson(),
      'isLoading': instance.isLoading,
      'errorMessage': instance.errorMessage,
    };

const _$ContentModeEnumMap = {
  ContentMode.personal: 'personal',
  ContentMode.together: 'together',
};
