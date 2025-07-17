import 'package:freezed_annotation/freezed_annotation.dart';

part 'taro_spread_type.freezed.dart';
part 'taro_spread_type.g.dart';

/// 타로 스프레드 타입
@freezed
class TaroSpreadType with _$TaroSpreadType {
  const factory TaroSpreadType({
    required int cardCount,
    required String name,
    required String description,
    required String nameEn,
  }) = _TaroSpreadType;

  factory TaroSpreadType.fromJson(Map<String, dynamic> json) =>
      _$TaroSpreadTypeFromJson(json);

}

/// 사전 정의된 스프레드 타입들
class TaroSpreadTypes {
  static const List<TaroSpreadType> all = [
    TaroSpreadType(
      cardCount: 3,
      name: '과거-현재-미래',
      nameEn: 'Past-Present-Future',
      description: '시간의 흐름에 따른 상황 분석',
    ),
    TaroSpreadType(
      cardCount: 5,
      name: '십자가 스프레드',
      nameEn: 'Cross Spread',
      description: '원인, 과정, 결과에대한 분석',
    ),
    TaroSpreadType(
      cardCount: 7,
      name: '매직넘버 스프레드',
      nameEn: 'MagicNumber Spread',
      description: '소원 성취를 위한 매직넘버 분석', // 한 줄로 단순화
    ),
    TaroSpreadType(
      cardCount: 10,
      name: '켈틱 크로스',
      nameEn: 'Celtic Cross',
      description: '가장 심층적이고 깊은 분석 및 통찰 상세한 리딩', // 한 줄로 단순화
    ),
  ];

  static TaroSpreadType? getByCardCount(int count) {
    try {
      return all.firstWhere((spread) => spread.cardCount == count);
    } catch (e) {
      return null;
    }
  }
}
