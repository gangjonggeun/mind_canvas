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
    state = const TaroConsultationState(); // 🚀 수정됨
    // 필요하다면 API 상태도 초기화
    ref.read(taroAnalysisProvider.notifier).reset();
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

    // 1. 상태를 '분석 중'으로 변경
    state = state.copyWith(status: TaroStatus.analyzing);

    // 2. Request DTO 생성
    final request = SubmitTaroRequest(
      theme: state.theme,
      spreadType: state.selectedSpreadType!.name, // 예: "3", "CELTIC"
      cards: state.selectedCards,
    );

    // 3. API 호출 노티파이어(TaroAnalysis) 실행
    // ref.read를 통해 다른 프로바이더의 함수를 실행합니다.
    final resultEntity = await ref
        .read(taroAnalysisProvider.notifier)
        .analyzeTaro(request);

    // 4. 결과에 따른 상태 업데이트
    if (resultEntity != null) {
      state = state.copyWith(status: TaroStatus.completed);
    } else {
      // 에러 메시지는 TaroAnalysis 상태에서 가져오거나 별도로 처리
      state = state.copyWith(
        status: TaroStatus.error,
        errorMessage: '분석에 실패했습니다. 다시 시도해주세요.',
      );
    }
  }


}