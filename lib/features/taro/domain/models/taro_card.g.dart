// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taro_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaroCardImpl _$$TaroCardImplFromJson(Map json) => $checkedCreate(
      r'_$TaroCardImpl',
      json,
      ($checkedConvert) {
        final val = _$TaroCardImpl(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          nameEn: $checkedConvert('nameEn', (v) => v as String),
          imagePath: $checkedConvert('imagePath', (v) => v as String),
          type: $checkedConvert(
              'type', (v) => $enumDecode(_$TaroCardTypeEnumMap, v)),
          description: $checkedConvert('description', (v) => v as String),
          isReversed: $checkedConvert('isReversed', (v) => v as bool? ?? false),
        );
        return val;
      },
    );

Map<String, dynamic> _$$TaroCardImplToJson(_$TaroCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameEn': instance.nameEn,
      'imagePath': instance.imagePath,
      'type': _$TaroCardTypeEnumMap[instance.type]!,
      'description': instance.description,
      'isReversed': instance.isReversed,
    };

const _$TaroCardTypeEnumMap = {
  TaroCardType.majorArcana: 'majorArcana',
  TaroCardType.cups: 'cups',
  TaroCardType.pentacles: 'pentacles',
  TaroCardType.swords: 'swords',
  TaroCardType.wands: 'wands',
};
