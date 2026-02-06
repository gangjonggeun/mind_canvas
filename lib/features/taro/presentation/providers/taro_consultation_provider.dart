// lib/features/taro/presentation/providers/taro_consultation_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/dto/request/submit_taro_request.dart';
import '../../domain/models/taro_spread_type.dart';
import 'taro_analysis_notifier.dart'; // 아까 만든 API 호출용 노티파이어
import 'taro_consultation_state.dart';

part 'taro_consultation_provider.g.dart';

@riverpod
class TaroConsultationNotifier extends _$TaroConsultationNotifier {
  @override
  TaroConsultationState build() {
    return const TaroConsultationState();
  }

  void updateTheme(String theme) {
    state = state.copyWith(theme: theme);
  }

  void selectSpreadType(TaroSpreadType type) {
    state = state.copyWith(selectedSpreadType: type);
  }

  /// 1단계: 설정 완료 후 카드 선택 화면으로 이동
  void startConsultation() {
    if (state.canProceedToCardSelection) {
      state = state.copyWith(
        status: TaroStatus.cardSelection,
        selectedCards: [], // 🚀 핵심: 진입 시 카드 선택 내역 초기화
      );
    }
  }

  void reset() {
    state = const TaroConsultationState(); // 초기 상태로
  }

  void removeCard(int positionIndex) {
    final currentCards = List<TaroCardInput>.from(state.selectedCards);
    currentCards.removeWhere((card) => card.positionIndex == positionIndex);
    state = state.copyWith(selectedCards: currentCards);
  }

  // ✅ [추가] 카드 선택/해제 로직 (카드 선택 페이지에서 사용)
  void toggleCardSelection(TaroCardInput card) {
    final currentCards = List<TaroCardInput>.from(state.selectedCards);

    // 이미 선택된 위치인지 확인 (같은 위치면 교체, 아니면 추가)
    final index = currentCards.indexWhere((c) => c.positionIndex == card.positionIndex);

    if (index != -1) {
      currentCards[index] = card; // 교체
    } else {
      currentCards.add(card); // 추가
    }

    state = state.copyWith(selectedCards: currentCards);
  }

  // ✅ [핵심] 최종 분석 요청 (카드 선택 완료 후 호출)
  Future<void> submitAnalysis() async {
    if (!state.canAnalyze) return;

    state = state.copyWith(status: TaroStatus.analyzing);

    final request = SubmitTaroRequest(
      theme: state.theme,
      spreadType: state.selectedSpreadType!.name,
      cards: state.selectedCards,
    );

    // 1. 분석 요청 실행
    await ref.read(taroAnalysisProvider.notifier).analyzeTaro(request);

    // 2. 실행 후 분석 노티파이어의 상태를 확인
    final analysisState = ref.read(taroAnalysisProvider);

    if (analysisState.isCompleted) {
      state = state.copyWith(status: TaroStatus.completed);
    } else if (analysisState.errorMessage != null) {
      state = state.copyWith(
        status: TaroStatus.error,
        errorMessage: analysisState.errorMessage,
      );
    }
  }

}