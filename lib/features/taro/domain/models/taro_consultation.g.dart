// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taro_consultation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaroConsultationImpl _$$TaroConsultationImplFromJson(
        Map<String, dynamic> json) =>
    _$TaroConsultationImpl(
      id: json['id'] as String,
      theme: json['theme'] as String,
      spreadType:
          TaroSpreadType.fromJson(json['spreadType'] as Map<String, dynamic>),
      selectedCardIds: (json['selectedCardIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      result: json['result'] == null
          ? null
          : TaroResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TaroConsultationImplToJson(
        _$TaroConsultationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theme': instance.theme,
      'spreadType': instance.spreadType,
      'selectedCardIds': instance.selectedCardIds,
      'createdAt': instance.createdAt?.toIso8601String(),
      'result': instance.result,
    };

_$TaroResultImpl _$$TaroResultImplFromJson(Map<String, dynamic> json) =>
    _$TaroResultImpl(
      id: json['id'] as String,
      interpretation: json['interpretation'] as String,
      cardReadings: (json['cardReadings'] as List<dynamic>)
          .map((e) => TaroCardReading.fromJson(e as Map<String, dynamic>))
          .toList(),
      generatedAt: json['generatedAt'] == null
          ? null
          : DateTime.parse(json['generatedAt'] as String),
    );

Map<String, dynamic> _$$TaroResultImplToJson(_$TaroResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'interpretation': instance.interpretation,
      'cardReadings': instance.cardReadings,
      'generatedAt': instance.generatedAt?.toIso8601String(),
    };

_$TaroCardReadingImpl _$$TaroCardReadingImplFromJson(
        Map<String, dynamic> json) =>
    _$TaroCardReadingImpl(
      cardId: json['cardId'] as String,
      cardName: json['cardName'] as String,
      meaning: json['meaning'] as String,
      position: json['position'] as String,
      positionIndex: (json['positionIndex'] as num).toInt(),
      isReversed: json['isReversed'] as bool? ?? false,
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
