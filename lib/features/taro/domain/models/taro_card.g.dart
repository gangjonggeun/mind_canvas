// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taro_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaroCardImpl _$$TaroCardImplFromJson(Map<String, dynamic> json) =>
    _$TaroCardImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['nameEn'] as String,
      imagePath: json['imagePath'] as String,
      type: $enumDecode(_$TaroCardTypeEnumMap, json['type']),
      description: json['description'] as String,
      isReversed: json['isReversed'] as bool? ?? false,
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
