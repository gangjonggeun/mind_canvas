// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TestDetailResponseImpl _$$TestDetailResponseImplFromJson(Map json) =>
    $checkedCreate(
      r'_$TestDetailResponseImpl',
      json,
      ($checkedConvert) {
        final val = _$TestDetailResponseImpl(
          testId: $checkedConvert('testId', (v) => (v as num).toInt()),
          imagePath: $checkedConvert('imagePath', (v) => v as String?),
          psychologyTag: $checkedConvert('psychologyTag', (v) => v as String?),
          title: $checkedConvert('title', (v) => v as String),
          subtitle: $checkedConvert('subtitle', (v) => v as String?),
          estimatedTime:
              $checkedConvert('estimatedTime', (v) => (v as num).toInt()),
          difficulty: $checkedConvert('difficulty', (v) => v as String),
          introduction: $checkedConvert('introduction', (v) => v as String?),
          instructions: $checkedConvert('instructions',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          backgroundGradient:
              $checkedConvert('backgroundGradient', (v) => v as String?),
          darkModeGradient:
              $checkedConvert('darkModeGradient', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$$TestDetailResponseImplToJson(
        _$TestDetailResponseImpl instance) =>
    <String, dynamic>{
      'testId': instance.testId,
      'imagePath': instance.imagePath,
      'psychologyTag': instance.psychologyTag,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'estimatedTime': instance.estimatedTime,
      'difficulty': instance.difficulty,
      'introduction': instance.introduction,
      'instructions': instance.instructions,
      'backgroundGradient': instance.backgroundGradient,
      'darkModeGradient': instance.darkModeGradient,
    };