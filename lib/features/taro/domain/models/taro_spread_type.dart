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
      description: '시간의 흐름에 따른 상황 파악',
    ),
    TaroSpreadType(
      cardCount: 5,
      name: '십자가 스프레드',
      nameEn: 'Cross Spread',
      description: '현재 상황과 영향 요인들',
    ),
    TaroSpreadType(
      cardCount: 7,
      name: '호스슈 스프레드',
      nameEn: 'Horseshoe Spread',
      description: '종합적인 상황 분석',
    ),
    TaroSpreadType(
      cardCount: 10,
      name: '켈틱 크로스',
      nameEn: 'Celtic Cross',
      description: '가장 전문적이고 상세한 리딩',
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
