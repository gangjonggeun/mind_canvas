// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HtpSessionData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HtpSessionImpl _$$HtpSessionImplFromJson(Map json) => $checkedCreate(
      r'_$HtpSessionImpl',
      json,
      ($checkedConvert) {
        final val = _$HtpSessionImpl(
          sessionId: $checkedConvert('sessionId', (v) => v as String),
          userId: $checkedConvert('userId', (v) => v as String),
          startTime: $checkedConvert('startTime', (v) => (v as num).toInt()),
          endTime: $checkedConvert('endTime', (v) => (v as num?)?.toInt()),
          drawings: $checkedConvert(
              'drawings',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      HtpDrawing.fromJson(Map<String, dynamic>.from(e as Map)))
                  .toList()),
          supportsPressure:
              $checkedConvert('supportsPressure', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$$HtpSessionImplToJson(_$HtpSessionImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'userId': instance.userId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'drawings': instance.drawings.map((e) => e.toJson()).toList(),
      'supportsPressure': instance.supportsPressure,
    };

_$HtpDrawingImpl _$$HtpDrawingImplFromJson(Map json) => $checkedCreate(
      r'_$HtpDrawingImpl',
      json,
      ($checkedConvert) {
        final val = _$HtpDrawingImpl(
          type:
              $checkedConvert('type', (v) => $enumDecode(_$HtpTypeEnumMap, v)),
          startTime: $checkedConvert('startTime', (v) => (v as num).toInt()),
          endTime: $checkedConvert('endTime', (v) => (v as num?)?.toInt()),
          strokeCount:
              $checkedConvert('strokeCount', (v) => (v as num).toInt()),
          modificationCount:
              $checkedConvert('modificationCount', (v) => (v as num).toInt()),
          averagePressure:
              $checkedConvert('averagePressure', (v) => (v as num).toDouble()),
          orderIndex:
              $checkedConvert('orderIndex', (v) => (v as num?)?.toInt() ?? -1),
        );
        return val;
      },
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

_$HtpAnalysisDataImpl _$$HtpAnalysisDataImplFromJson(Map json) =>
    $checkedCreate(
      r'_$HtpAnalysisDataImpl',
      json,
      ($checkedConvert) {
        final val = _$HtpAnalysisDataImpl(
          sessionId: $checkedConvert('sessionId', (v) => v as String),
          userId: $checkedConvert('userId', (v) => v as String),
          totalDurationSeconds: $checkedConvert(
              'totalDurationSeconds', (v) => (v as num).toInt()),
          drawingOrder: $checkedConvert(
              'drawingOrder',
              (v) =>
                  (v as List<dynamic>).map((e) => (e as num).toInt()).toList()),
          drawingDurations: $checkedConvert(
              'drawingDurations',
              (v) =>
                  (v as List<dynamic>).map((e) => (e as num).toInt()).toList()),
          averagePressures: $checkedConvert(
              'averagePressures',
              (v) => (v as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList()),
          totalModifications:
              $checkedConvert('totalModifications', (v) => (v as num).toInt()),
          hasPressureData: $checkedConvert('hasPressureData', (v) => v as bool),
        );
        return val;
      },
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
