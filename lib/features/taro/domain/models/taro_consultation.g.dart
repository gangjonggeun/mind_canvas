// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taro_consultation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaroConsultationImpl _$$TaroConsultationImplFromJson(Map json) =>
    $checkedCreate(
      r'_$TaroConsultationImpl',
      json,
      ($checkedConvert) {
        final val = _$TaroConsultationImpl(
          id: $checkedConvert('id', (v) => v as String),
          theme: $checkedConvert('theme', (v) => v as String),
          spreadType: $checkedConvert(
              'spreadType',
              (v) =>
                  TaroSpreadType.fromJson(Map<String, dynamic>.from(v as Map))),
          selectedCardIds: $checkedConvert(
              'selectedCardIds',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                  const []),
          createdAt: $checkedConvert('createdAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
          result: $checkedConvert(
              'result',
              (v) => v == null
                  ? null
                  : TaroResult.fromJson(Map<String, dynamic>.from(v as Map))),
        );
        return val;
      },
    );

Map<String, dynamic> _$$TaroConsultationImplToJson(
        _$TaroConsultationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theme': instance.theme,
      'spreadType': instance.spreadType.toJson(),
      'selectedCardIds': instance.selectedCardIds,
      'createdAt': instance.createdAt?.toIso8601String(),
      'result': instance.result?.toJson(),
    };

_$TaroResultImpl _$$TaroResultImplFromJson(Map json) => $checkedCreate(
      r'_$TaroResultImpl',
      json,
      ($checkedConvert) {
        final val = _$TaroResultImpl(
          id: $checkedConvert('id', (v) => v as String),
          interpretation: $checkedConvert('interpretation', (v) => v as String),
          cardReadings: $checkedConvert(
              'cardReadings',
              (v) => (v as List<dynamic>)
                  .map((e) => TaroCardReading.fromJson(
                      Map<String, dynamic>.from(e as Map)))
                  .toList()),
          generatedAt: $checkedConvert('generatedAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$$TaroResultImplToJson(_$TaroResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'interpretation': instance.interpretation,
      'cardReadings': instance.cardReadings.map((e) => e.toJson()).toList(),
      'generatedAt': instance.generatedAt?.toIso8601String(),
    };

_$TaroCardReadingImpl _$$TaroCardReadingImplFromJson(Map json) =>
    $checkedCreate(
      r'_$TaroCardReadingImpl',
      json,
      ($checkedConvert) {
        final val = _$TaroCardReadingImpl(
          cardId: $checkedConvert('cardId', (v) => v as String),
          cardName: $checkedConvert('cardName', (v) => v as String),
          meaning: $checkedConvert('meaning', (v) => v as String),
          position: $checkedConvert('position', (v) => v as String),
          positionIndex:
              $checkedConvert('positionIndex', (v) => (v as num).toInt()),
          isReversed: $checkedConvert('isReversed', (v) => v as bool? ?? false),
        );
        return val;
      },
    );

Map<String, dynamic> _$$TaroCardReadingImplToJson(
        _$TaroCardReadingImpl instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
      'cardName': instance.cardName,
      'meaning': instance.meaning,
      'position': instance.position,
      'positionIndex': instance.positionIndex,
      'isReversed': instance.isReversed,
    };
