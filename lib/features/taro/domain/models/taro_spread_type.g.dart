// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taro_spread_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaroSpreadTypeImpl _$$TaroSpreadTypeImplFromJson(Map json) => $checkedCreate(
      r'_$TaroSpreadTypeImpl',
      json,
      ($checkedConvert) {
        final val = _$TaroSpreadTypeImpl(
          cardCount: $checkedConvert('cardCount', (v) => (v as num).toInt()),
          name: $checkedConvert('name', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String),
          nameEn: $checkedConvert('nameEn', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$$TaroSpreadTypeImplToJson(
        _$TaroSpreadTypeImpl instance) =>
    <String, dynamic>{
      'cardCount': instance.cardCount,
      'name': instance.name,
      'description': instance.description,
      'nameEn': instance.nameEn,
    };
