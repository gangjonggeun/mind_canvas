import 'package:freezed_annotation/freezed_annotation.dart';

part 'submit_taro_request.freezed.dart';
part 'submit_taro_request.g.dart';

/// 🔮 타로 상담 요청 DTO
@freezed
class SubmitTaroRequest with _$SubmitTaroRequest {
  const factory SubmitTaroRequest({
    /// 🗣 상담 주제
    required String theme,

    /// 🃏 스프레드 종류 (예: 'THREE_CARD', 'CELTIC_CROSS')
    required String spreadType,

    /// 🎴 선택된 카드 목록
    required List<TaroCardInput> cards,
  }) = _SubmitTaroRequest;

  factory SubmitTaroRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitTaroRequestFromJson(json);
}

/// 📥 개별 카드 입력 정보
@freezed
class TaroCardInput with _$TaroCardInput {
  const factory TaroCardInput({
    /// 카드 ID (예: 'major_01')
    required String cardId,

    /// 배치된 위치 인덱스 (0, 1, 2...)
    required int positionIndex,

    /// 역방향 여부
    required bool isReversed,
  }) = _TaroCardInput;

  factory TaroCardInput.fromJson(Map<String, dynamic> json) =>
      _$TaroCardInputFromJson(json);
}