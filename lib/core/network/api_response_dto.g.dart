// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiResponseImpl<T> _$$ApiResponseImplFromJson<T>(
  Map json,
  T Function(Object? json) fromJsonT,
) =>
    $checkedCreate(
      r'_$ApiResponseImpl',
      json,
      ($checkedConvert) {
        final val = _$ApiResponseImpl<T>(
          success: $checkedConvert('success', (v) => v as bool),
          data: $checkedConvert(
              'data', (v) => _$nullableGenericFromJson(v, fromJsonT)),
          message: $checkedConvert('message', (v) => v as String?),
          error: $checkedConvert(
              'error',
              (v) => v == null
                  ? null
                  : ErrorInfo.fromJson(Map<String, dynamic>.from(v as Map))),
          metadata: $checkedConvert(
              'metadata',
              (v) => (v as Map?)?.map(
                    (k, e) => MapEntry(k as String, e),
                  )),
          timestamp: $checkedConvert('timestamp',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$$ApiResponseImplToJson<T>(
  _$ApiResponseImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.success,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'message': instance.message,
      'error': instance.error?.toJson(),
      'metadata': instance.metadata,
      'timestamp': instance.timestamp?.toIso8601String(),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

_$ErrorInfoImpl _$$ErrorInfoImplFromJson(Map json) => $checkedCreate(
      r'_$ErrorInfoImpl',
      json,
      ($checkedConvert) {
        final val = _$ErrorInfoImpl(
          code: $checkedConvert('code', (v) => v as String),
          message: $checkedConvert('message', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$$ErrorInfoImplToJson(_$ErrorInfoImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
