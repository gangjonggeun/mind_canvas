import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/dto/request/submit_taro_request.dart';
import '../../domain/models/taro_consultation.dart';
import '../../domain/models/taro_spread_type.dart';
part 'taro_consultation_state.freezed.dart';

enum TaroStatus { initial, cardSelection, analyzing, completed, error }

@freezed
class TaroConsultationState with _$TaroConsultationState {
  const factory TaroConsultationState({
    @Default(TaroStatus.initial) TaroStatus status,
    @Default('') String theme,
    TaroSpreadType? selectedSpreadType,

    // ✅ [추가] 선택된 카드 목록 (API 요청용 Input 모델)
    @Default([]) List<TaroCardInput> selectedCards,

    String? errorMessage,
  }) = _TaroConsultationState;

  const TaroConsultationState._();

  // "카드 선택하기" 버튼 활성화 조건
  bool get canProceedToCardSelection =>
      theme.isNotEmpty && selectedSpreadType != null;

  // "결과 보기" 버튼 활성화 조건 (카드 선택 화면용)
  bool get canAnalyze =>
      selectedSpreadType != null &&
          selectedCards.length == selectedSpreadType!.cardCount;
}