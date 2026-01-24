import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/response/insight_response.dart';
import '../../domain/usecases/insight_use_case.dart';


part 'insight_notifier.freezed.dart';
part 'insight_notifier.g.dart';

@freezed
class InsightState with _$InsightState {
  const factory InsightState({
    @Default(true) bool isLoading,
    @Default([]) List<InsightResponse> insights,
    String? errorMessage,
  }) = _InsightState;
}

@riverpod
class InsightNotifier extends _$InsightNotifier {
  @override
  InsightState build() {
    // 🔥 빌드 직후 실행
    Future.microtask(() => fetchInsights());
    return const InsightState(); // 초기값: isLoading = true
  }

  Future<void> fetchInsights() async {
    // 1. 로딩 시작 (기존 데이터가 있어도 로딩 표시를 원하면 true, 아니면 false)
    state = state.copyWith(isLoading: true);

    try {
      final result = await ref.read(insightUseCaseProvider).getInsights();

      result.fold(
        onSuccess: (data) {
          print('✅ [InsightNotifier] 데이터 수신: ${data.length}개');
          // 🔥 여기서 state를 완전히 새로운 객체로 교체해야 UI가 갱신됨
          state = state.copyWith(
            isLoading: false,
            insights: data,
            errorMessage: null, // 에러 메시지 초기화
          );
        },
        onFailure: (msg, _) {
          print('❌ [InsightNotifier] 실패: $msg');
          state = state.copyWith(
            isLoading: false,
            errorMessage: msg,
          );
        },
      );
    } catch (e) {
      print('💀 [InsightNotifier] 예외 발생: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: '알 수 없는 오류가 발생했습니다.',
      );
    }
  }
}