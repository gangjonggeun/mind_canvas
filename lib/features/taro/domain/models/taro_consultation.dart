import 'package:freezed_annotation/freezed_annotation.dart';
import 'taro_spread_type.dart';

part 'taro_consultation.freezed.dart';
part 'taro_consultation.g.dart';

/// 타로 상담 세션
@freezed
class TaroConsultation with _$TaroConsultation {
  const factory TaroConsultation({
    required String id,
    required String theme,
    required TaroSpreadType spreadType,
    @Default([]) List<String> selectedCardIds,
    DateTime? createdAt,
    TaroResult? result,
  }) = _TaroConsultation;

  factory TaroConsultation.fromJson(Map<String, dynamic> json) =>
      _$TaroConsultationFromJson(json);
}

/// 타로 결과
@freezed
class TaroResult with _$TaroResult {
  const factory TaroResult({
    required String id,
    required String interpretation,
    required List<TaroCardReading> cardReadings,
    DateTime? generatedAt,
  }) = _TaroResult;

  factory TaroResult.fromJson(Map<String, dynamic> json) =>
      _$TaroResultFromJson(json);
}

/// 개별 카드 해석
@freezed
class TaroCardReading with _$TaroCardReading {
  const factory TaroCardReading({
    required String cardId,
    required String cardName,
    required String meaning,
    required String position,
    required int positionIndex,
    @Default(false) bool isReversed,
  }) = _TaroCardReading;

  factory TaroCardReading.fromJson(Map<String, dynamic> json) =>
      _$TaroCardReadingFromJson(json);
}
