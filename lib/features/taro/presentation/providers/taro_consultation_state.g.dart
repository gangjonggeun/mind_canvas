// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taro_consultation_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaroConsultationStateImpl _$$TaroConsultationStateImplFromJson(Map json) =>
    $checkedCreate(
      r'_$TaroConsultationStateImpl',
      json,
      ($checkedConvert) {
        final val = _$TaroConsultationStateImpl(
          theme: $checkedConvert('theme', (v) => v as String? ?? ''),
          selectedSpreadType: $checkedConvert(
              'selectedSpreadType',
              (v) => v == null
                  ? null
                  : TaroSpreadType.fromJson(
                      Map<String, dynamic>.from(v as Map))),
          selectedCards: $checkedConvert(
              'selectedCards',
              (v) =>
                  (v as List<dynamic>?)?.map((e) => e as String?).toList() ??
                  const []),
          status: $checkedConvert(
              'status',
              (v) =>
                  $enumDecodeNullable(_$TaroStatusEnumMap, v) ??
                  TaroStatus.initial),
          result: $checkedConvert(
              'result',
              (v) => v == null
                  ? null
                  : TaroResult.fromJson(Map<String, dynamic>.from(v as Map))),
          interpretation:
              $checkedConvert('interpretation', (v) => v as String?),
          errorMessage: $checkedConvert('errorMessage', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$$TaroConsultationStateImplToJson(
        _$TaroConsultationStateImpl instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'selectedSpreadType': instance.selectedSpreadType?.toJson(),
      'selectedCards': instance.selectedCards,
      'status': _$TaroStatusEnumMap[instance.status]!,
      'result': instance.result?.toJson(),
      'interpretation': instance.interpretation,
      'errorMessage': instance.errorMessage,
    };

const _$TaroStatusEnumMap = {
  TaroStatus.initial: 'initial',
  TaroStatus.themeInput: 'themeInput',
  TaroStatus.spreadSelection: 'spreadSelection',
  TaroStatus.cardSelection: 'cardSelection',
  TaroStatus.loading: 'loading',
  TaroStatus.completed: 'completed',
  TaroStatus.error: 'error',
};
