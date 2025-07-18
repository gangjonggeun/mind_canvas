// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HtpSessionData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HtpSessionImpl _$$HtpSessionImplFromJson(Map<String, dynamic> json) =>
    _$HtpSessionImpl(
      sessionId: json['sessionId'] as String,
      userId: json['userId'] as String,
      startTime: (json['startTime'] as num).toInt(),
      endTime: (json['endTime'] as num?)?.toInt(),
      drawings: (json['drawings'] as List<dynamic>)
          .map((e) => HtpDrawing.fromJson(e as Map<String, dynamic>))
          .toList(),
      supportsPressure: json['supportsPressure'] as bool,
    );

Map<String, dynamic> _$$HtpSessionImplToJson(_$HtpSessionImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'userId': instance.userId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'drawings': instance.drawings,
      'supportsPressure': instance.supportsPressure,
    };

_$HtpDrawingImpl _$$HtpDrawingImplFromJson(Map<String, dynamic> json) =>
    _$HtpDrawingImpl(
      type: $enumDecode(_$HtpTypeEnumMap, json['type']),
      startTime: (json['startTime'] as num).toInt(),
      endTime: (json['endTime'] as num?)?.toInt(),
      strokeCount: (json['strokeCount'] as num).toInt(),
      modificationCount: (json['modificationCount'] as num).toInt(),
      averagePressure: (json['averagePressure'] as num).toDouble(),
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? -1,
    );

Map<String, dynamic> _$$HtpDrawingImplToJson(_$HtpDrawingImpl instance) =>
    <String, dynamic>{
      'type': _$HtpTypeEnumMap[instance.type]!,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'strokeCount': instance.strokeCount,
      'modificationCount': instance.modificationCount,
      'averagePressure': instance.averagePressure,
      'orderIndex': instance.orderIndex,
    };

const _$HtpTypeEnumMap = {
  HtpType.house: 'house',
  HtpType.tree: 'tree',
  HtpType.person: 'person',
};

_$HtpAnalysisDataImpl _$$HtpAnalysisDataImplFromJson(
        Map<String, dynamic> json) =>
    _$HtpAnalysisDataImpl(
      sessionId: json['sessionId'] as String,
      userId: json['userId'] as String,
      totalDurationSeconds: (json['totalDurationSeconds'] as num).toInt(),
      drawingOrder: (json['drawingOrder'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      drawingDurations: (json['drawingDurations'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      averagePressures: (json['averagePressures'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      totalModifications: (json['totalModifications'] as num).toInt(),
      hasPressureData: json['hasPressureData'] as bool,
    );

Map<String, dynamic> _$$HtpAnalysisDataImplToJson(
        _$HtpAnalysisDataImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'userId': instance.userId,
      'totalDurationSeconds': instance.totalDurationSeconds,
      'drawingOrder': instance.drawingOrder,
      'drawingDurations': instance.drawingDurations,
      'averagePressures': instance.averagePressures,
      'totalModifications': instance.totalModifications,
      'hasPressureData': instance.hasPressureData,
    };
