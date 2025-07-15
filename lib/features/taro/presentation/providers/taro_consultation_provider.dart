import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../../domain/models/taro_card.dart';
import '../../domain/models/taro_spread_type.dart';
import 'taro_consultation_state.dart';

/// 타로 상담 상태 관리 StateNotifier
class TaroConsultationNotifier extends StateNotifier<TaroConsultationState> {
  final Logger _logger = Logger();

  TaroConsultationNotifier() : super(const TaroConsultationState()) {
    _logger.d('TaroConsultationNotifier initialized');
  }

  /// 테마 변경
  void updateTheme(String theme) {
    _logger.d('Theme updated: $theme');
    
    state = state.copyWith(
      theme: theme,
      status: theme.trim().isEmpty 
          ? TaroStatus.initial 
          : TaroStatus.themeInput,
      errorMessage: null,
    );
  }

  /// 스프레드 타입 선택
  void selectSpreadType(TaroSpreadType spreadType) {
    _logger.d('Spread type selected: ${spreadType.name}');
    
    // 새로운 스프레드 타입에 맞게 카드 배열 초기화
    final newSelectedCards = List<String?>.filled(spreadType.cardCount, null);
    
    state = state.copyWith(
      selectedSpreadType: spreadType,
      selectedCards: newSelectedCards,
      status: TaroStatus.spreadSelection,
      errorMessage: null,
    );
  }

  /// 상담 시작 (카드 선택 단계로 이동)
  void startConsultation() {
    if (!state.canProceedToCardSelection) {
      _logger.w('Cannot proceed to card selection: theme or spread type missing');
      state = state.copyWith(
        status: TaroStatus.error,
        errorMessage: '테마와 스프레드를 모두 선택해주세요.',
      );
      return;
    }

    _logger.i('Starting consultation: ${state.theme} with ${state.selectedSpreadType?.name}');
    state = state.copyWith(
      status: TaroStatus.cardSelection,
      errorMessage: null,
    );
  }

  /// 카드 선택
  void selectCard(String cardId, int position) {
    if (state.selectedSpreadType == null) {
      _logger.w('No spread type selected');
      return;
    }

    if (position < 0 || position >= state.selectedSpreadType!.cardCount) {
      _logger.w('Invalid position: $position');
      return;
    }

    // 같은 카드가 이미 다른 위치에 있는지 확인
    if (state.selectedCards.contains(cardId)) {
      _logger.w('Card $cardId already selected');
      return;
    }

    final newSelectedCards = List<String?>.from(state.selectedCards);
    newSelectedCards[position] = cardId;

    _logger.d('Card selected: $cardId at position $position');
    
    state = state.copyWith(
      selectedCards: newSelectedCards,
      status: TaroStatus.cardSelection,
      errorMessage: null,
    );
  }

  /// 카드 제거
  void removeCard(int position) {
    if (position < 0 || position >= state.selectedCards.length) {
      _logger.w('Invalid position for removal: $position');
      return;
    }

    final newSelectedCards = List<String?>.from(state.selectedCards);
    final removedCard = newSelectedCards[position];
    newSelectedCards[position] = null;

    _logger.d('Card removed: $removedCard from position $position');
    
    state = state.copyWith(
      selectedCards: newSelectedCards,
      status: TaroStatus.cardSelection,
      errorMessage: null,
    );
  }

  /// 카드 교체
  void replaceCard(int fromPosition, int toPosition) {
    if (fromPosition < 0 || 
        fromPosition >= state.selectedCards.length ||
        toPosition < 0 || 
        toPosition >= state.selectedCards.length) {
      _logger.w('Invalid positions for replacement: $fromPosition -> $toPosition');
      return;
    }

    final newSelectedCards = List<String?>.from(state.selectedCards);
    final fromCard = newSelectedCards[fromPosition];
    final toCard = newSelectedCards[toPosition];
    
    newSelectedCards[fromPosition] = toCard;
    newSelectedCards[toPosition] = fromCard;

    _logger.d('Cards replaced: position $fromPosition <-> $toPosition');
    
    state = state.copyWith(
      selectedCards: newSelectedCards,
      status: TaroStatus.cardSelection,
      errorMessage: null,
    );
  }

  /// 결과 요청
  Future<void> requestResult() async {
    if (!state.canRequestResult) {
      _logger.w('Cannot request result: cards not fully selected');
      state = state.copyWith(
        status: TaroStatus.error,
        errorMessage: '모든 카드를 선택해주세요.',
      );
      return;
    }

    _logger.i('Requesting result for consultation');
    state = state.copyWith(status: TaroStatus.loading);
    
    try {
      // 임시 딜레이 (실제로는 서버 API 호출)
      await Future.delayed(const Duration(seconds: 2));
      
      // 임시 해석 결과 생성
      final interpretation = _generateMockInterpretation();
      
      state = state.copyWith(
        status: TaroStatus.completed,
        interpretation: interpretation,
      );
      
    } catch (error, stackTrace) {
      _logger.e('Error requesting result', error: error, stackTrace: stackTrace);
      state = state.copyWith(
        status: TaroStatus.error,
        errorMessage: '결과를 가져오는 중 오류가 발생했습니다.',
      );
    }
  }

  /// 임시 해석 결과 생성 (실제로는 AI API 호출)
  String _generateMockInterpretation() {
    final selectedCardNames = state.selectedCards
        .where((cardId) => cardId != null)
        .map((cardId) => TaroCards.findById(cardId!)?.name ?? '알 수 없는 카드')
        .join(', ');
    
    return '선택하신 카드들($selectedCardNames)은 현재 당신의 상황에서 '
           '새로운 변화와 기회가 다가오고 있음을 의미합니다. '
           '과거의 경험을 바탕으로 현재의 선택을 신중히 하시고, '
           '미래에 대한 희망을 가지시기 바랍니다. '
           '주제: "${state.theme}"에 대한 답변이 곧 명확해질 것입니다.';
  }

  /// 상담 리셋
  void reset() {
    _logger.i('Resetting consultation');
    state = const TaroConsultationState();
  }

  /// 에러 클리어
  void clearError() {
    if (state.status == TaroStatus.error) {
      state = state.copyWith(
        status: state.theme.trim().isEmpty 
            ? TaroStatus.initial 
            : TaroStatus.themeInput,
        errorMessage: null,
      );
    }
  }
}

/// 메인 Provider
final taroConsultationNotifierProvider = 
    StateNotifierProvider<TaroConsultationNotifier, TaroConsultationState>(
  (ref) => TaroConsultationNotifier(),
);

/// 편의 Provider들

/// 현재 선택된 스프레드 타입
final selectedSpreadTypeProvider = Provider<TaroSpreadType?>((ref) {
  return ref.watch(taroConsultationNotifierProvider).selectedSpreadType;
});

/// 카드 선택 완료 여부
final isCardSelectionCompleteProvider = Provider<bool>((ref) {
  return ref.watch(taroConsultationNotifierProvider).isCardSelectionComplete;
});

/// 다음 단계 진행 가능 여부
final canProceedToCardSelectionProvider = Provider<bool>((ref) {
  return ref.watch(taroConsultationNotifierProvider).canProceedToCardSelection;
});
