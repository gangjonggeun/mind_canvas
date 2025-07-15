import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/taro_consultation.dart';
import '../../domain/models/taro_spread_type.dart';

part 'taro_consultation_state.freezed.dart';
part 'taro_consultation_state.g.dart';

@freezed
class TaroConsultationState with _$TaroConsultationState {
  const factory TaroConsultationState({
    @Default('') String theme,
    TaroSpreadType? selectedSpreadType,
    @Default([]) List<String?> selectedCards, // null = 빈 위치
    @Default(TaroStatus.initial) TaroStatus status,
    TaroResult? result,
    String? interpretation, // 해석 결과 추가
    String? errorMessage,
  }) = _TaroConsultationState;

  factory TaroConsultationState.fromJson(Map<String, dynamic> json) =>
      _$TaroConsultationStateFromJson(json);
}

enum TaroStatus {
  initial,          // 초기 상태
  themeInput,       // 테마 입력 중
  spreadSelection,  // 스프레드 선택 중
  cardSelection,    // 카드 선택 중
  loading,          // 결과 로딩 중
  completed,        // 완료
  error,            // 에러
}

/// 상태 확장 메서드
extension TaroConsultationStateX on TaroConsultationState {
  /// 다음 단계로 진행 가능한지
  bool get canProceedToCardSelection =>
      theme.trim().isNotEmpty && selectedSpreadType != null;
  
  /// 카드 선택이 완료되었는지
  bool get isCardSelectionComplete =>
      selectedSpreadType != null &&
      selectedCards.length == selectedSpreadType!.cardCount &&
      !selectedCards.contains(null);
  
  /// 결과 요청 가능한지
  bool get canRequestResult => isCardSelectionComplete;
  
  /// 특정 위치에 카드가 있는지
  bool hasCardAtPosition(int position) =>
      position < selectedCards.length && selectedCards[position] != null;
  
  /// 빈 위치 개수
  int get emptyPositionsCount =>
      selectedCards.where((card) => card == null).length;
}
