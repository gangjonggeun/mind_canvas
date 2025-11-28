import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/TaroResultEntity.dart';

part 'taro_result_response.freezed.dart';
part 'taro_result_response.g.dart';

/// ✨ 타로 상담 결과 응답 DTO
@freezed
class TaroResultResponse with _$TaroResultResponse {
  const TaroResultResponse._(); // 메서드 추가를 위한 private 생성자

  const factory TaroResultResponse({
    required String id,
    required DateTime date,
    required String theme,
    required String spreadName,
    required String overallInterpretation,
    required List<InterpretedCardDto> cardInterpretations,
  }) = _TaroResultResponse;

  factory TaroResultResponse.fromJson(Map<String, dynamic> json) =>
      _$TaroResultResponseFromJson(json);

  /// 🔄 DTO -> Entity 변환 메서드
  TaroResultEntity toEntity() {
    return TaroResultEntity(
      id: id,
      date: date,
      theme: theme,
      spreadName: spreadName,
      overallInterpretation: overallInterpretation,
      cardInterpretations: cardInterpretations
          .map((dto) => dto.toEntity())
          .toList(),
    );
  }
}

/// 📖 해석된 카드 정보 DTO
@freezed
class InterpretedCardDto with _$InterpretedCardDto {
  const InterpretedCardDto._();

  const factory InterpretedCardDto({
    required String cardId,
    required String cardName,
    required String positionName,
    required bool isReversed,
    required String subtitle,
    required String detailedText,
  }) = _InterpretedCardDto;

  factory InterpretedCardDto.fromJson(Map<String, dynamic> json) =>
      _$InterpretedCardDtoFromJson(json);

  /// 🔄 DTO -> Entity (InterpretedCard) 변환
  InterpretedCard toEntity() {
    return InterpretedCard(
      cardId: cardId,
      cardName: cardName,
      positionName: positionName,
      isReversed: isReversed,
      subtitle: subtitle,
      detailedText: detailedText,
    );
  }
}