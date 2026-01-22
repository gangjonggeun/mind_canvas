import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/response/test_recommendation_response.dart';
import '../../domain/usecases/test_recommendation_usecase.dart';


part 'test_recommendation_notifier.freezed.dart';
part 'test_recommendation_notifier.g.dart';

// ==========================================================
// 📋 State Definition
// ==========================================================
@freezed
class TestRecommendationState with _$TestRecommendationState {
  const factory TestRecommendationState({
    @Default(true) bool isLoading,           // 로딩 상태 (Shimmer 효과용)
    @Default([]) List<TestRecommendationResponse> recommendations, // 데이터 리스트
    String? errorMessage,                    // 에러 메시지
    @Default(false) bool isEmpty,            // 데이터가 비어있는지 여부 (UI 분기용)
  }) = _TestRecommendationState;
}

// ==========================================================
// 📢 Notifier Implementation
// ==========================================================
@riverpod
class TestRecommendationNotifier extends _$TestRecommendationNotifier {
  late final TestRecommendationUseCase _useCase;

  @override
  TestRecommendationState build() {
    print('🔨 [Notifier] build() 메서드 실행됨'); // 1. 이게 찍혀야 함

    // UseCase 의존성 주입
    _useCase = ref.watch(testRecommendationUseCaseProvider);

    // ⚠️ [중요] build() 안에서 바로 함수를 호출하면 안 됨!
    // Future.microtask를 써서 빌드가 끝난 직후에 실행되도록 예약해야 함.
    Future.microtask(() {
      print('⏳ [Notifier] Microtask 진입 -> fetch 실행'); // 2. 이게 찍혀야 함
      fetchRecommendations();
    });

    // 초기 상태 반환 (isLoading: true)
    return const TestRecommendationState();
  }

  /// 🎁 추천 목록 불러오기
  Future<void> fetchRecommendations() async {
    print('🚀 [Notifier] fetchRecommendations() 시작'); // 3. 이게 찍혀야 함
    // 1. 로딩 시작
    state = state.copyWith(isLoading: true, errorMessage: null);

    // 2. UseCase 호출
    final result = await _useCase.getRecommendations();

    // 3. 결과 처리
    result.fold(
      onSuccess: (data) {
        if (data.isEmpty) {
          // 📭 데이터가 없을 때 (서버가 빈 리스트를 줌)
          state = state.copyWith(
            isLoading: false,
            recommendations: [],
            isEmpty: true, // UI에서 "추천할 테스트가 없어요" 등을 표시하도록 플래그 설정
          );
        } else {
          // 📦 데이터가 있을 때
          state = state.copyWith(
            isLoading: false,
            recommendations: data,
            isEmpty: false,
          );
        }
      },
      onFailure: (message,code) {
        // 🚨 에러 발생 시
        state = state.copyWith(
          isLoading: false,
          errorMessage: message,
          // 에러가 났어도 기존 데이터가 있으면 보여줄지, 비울지 결정 (여기선 유지)
        );
      },
    );
  }
}