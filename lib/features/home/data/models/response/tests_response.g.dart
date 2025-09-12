// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tests_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TestsResponseImpl _$$TestsResponseImplFromJson(Map json) => $checkedCreate(
      r'_$TestsResponseImpl',
      json,
      ($checkedConvert) {
        final val = _$TestsResponseImpl(
          tests: $checkedConvert(
              'tests',
              (v) => (v as List<dynamic>)
                  .map((e) => TestSummaryDto.fromJson(
                      Map<String, dynamic>.from(e as Map)))
                  .toList()),
          hasMore: $checkedConvert('hasMore', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$$TestsResponseImplToJson(_$TestsResponseImpl instance) =>
    <String, dynamic>{
      'tests': instance.tests.map((e) => e.toJson()).toList(),
      'hasMore': instance.hasMore,
    };

_$TestSummaryDtoImpl _$$TestSummaryDtoImplFromJson(Map json) => $checkedCreate(
      r'_$TestSummaryDtoImpl',
      json,
      ($checkedConvert) {
        final val = _$TestSummaryDtoImpl(
          testId: $checkedConvert('testId', (v) => (v as num).toInt()),
          title: $checkedConvert('title', (v) => v as String),
          subtitle: $checkedConvert('subtitle', (v) => v as String?),
          thumbnailUrl: $checkedConvert('thumbnailUrl', (v) => v as String?),
          viewCount:
              $checkedConvert('viewCount', (v) => (v as num?)?.toInt() ?? 0),
        );
        return val;
      },
    );

Map<String, dynamic> _$$TestSummaryDtoImplToJson(
        _$TestSummaryDtoImpl instance) =>
    <String, dynamic>{
      'testId': instance.testId,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'thumbnailUrl': instance.thumbnailUrl,
      'viewCount': instance.viewCount,
    };
