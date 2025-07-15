// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taro_consultation_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaroConsultationStateImpl _$$TaroConsultationStateImplFromJson(
        Map<String, dynamic> json) =>
    _$TaroConsultationStateImpl(
      theme: json['theme'] as String? ?? '',
      selectedSpreadType: json['selectedSpreadType'] == null
          ? null
          : TaroSpreadType.fromJson(
              json['selectedSpreadType'] as Map<String, dynamic>),
      selectedCards: (json['selectedCards'] as List<dynamic>?)
              ?.map((e) => e as String?)
              .toList() ??
          const [],
      status: $enumDecodeNullable(_$TaroStatusEnumMap, json['status']) ??
          TaroStatus.initial,
      result: json['result'] == null
          ? null
          : TaroResult.fromJson(json['result'] as Map<String, dynamic>),
      interpretation: json['interpretation'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$TaroConsultationStateImplToJson(
        _$TaroConsultationStateImpl instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'selectedSpreadType': instance.selectedSpreadType,
      'selectedCards': instance.selectedCards,
      'status': _$TaroStatusEnumMap[instance.status]!,
      'result': instance.result,
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
