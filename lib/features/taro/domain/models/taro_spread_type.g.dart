// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taro_spread_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaroSpreadTypeImpl _$$TaroSpreadTypeImplFromJson(Map<String, dynamic> json) =>
    _$TaroSpreadTypeImpl(
      cardCount: (json['cardCount'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      nameEn: json['nameEn'] as String,
    );

Map<String, dynamic> _$$TaroSpreadTypeImplToJson(
        _$TaroSpreadTypeImpl instance) =>
    <String, dynamic>{
      'cardCount': instance.cardCount,
      'name': instance.name,
      'description': instance.description,
      'nameEn': instance.nameEn,
    };
