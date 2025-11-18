// lib/features/psytest/presentation/notifiers/test_content_notifier.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/usecases/test_content_use_case.dart';
import 'test_content_state.dart';

// part 'test_content_notifier.freezed.dart';
part 'test_content_notifier.g.dart';

/// 테스트 콘텐츠 Notifier
@riverpod
class TestContentNotifier extends _$TestContentNotifier {
  @override
  TestContentState build() {
    return TestContentState.initial();
  }

  /// 📤 테스트 제출 ✅ 추가
  Future<void> submitTest(int testId, Map<String, dynamic> userAnswers) async {
    print('🚀 submitTest 시작: testId=$testId, 답변 수=${userAnswers.length}');

    // 제출 중 상태로 변경
    state = state.copyWith(
      isSubmitting: true,
      isCompleted: false,
      errorMessage: null,
      errorCode: null,
    );

    try {
      final testContentUseCase = ref.read(testContentUseCaseProvider);
      final result = await testContentUseCase.submitTest(testId, userAnswers);

      result.fold(
        onSuccess: (testResult) {
          print('✅ Notifier: 제출 성공 - ${testResult.resultKey}');
          // print('📊 차원별 점수: ${testResult.dimensionScores}');

          state = state.copyWith(
            isSubmitting: false,
            isCompleted: true,
            testResult: testResult,
            errorMessage: null,
            errorCode: null,
          );
        },
        onFailure: (errorCode, message) {
          print('❌ Notifier: 제출 실패 - $message');

          state = state.copyWith(
            isSubmitting: false,
            isCompleted: false,
            testResult: null,
            errorMessage: message,
            errorCode: errorCode,
          );
        },
      );
    } catch (e) {
      print('💥 Notifier 예외 발생: $e');

      state = state.copyWith(
        isSubmitting: false,
        isCompleted: false,
        errorMessage: '테스트 제출 중 오류가 발생했습니다',
        errorCode: 'UNKNOWN_ERROR',
      );
    }
  }

  /// 테스트 콘텐츠 로드
  Future<void> loadTestContent(int testId) async {
    print('🔍 loadTestContent 시작: $testId');

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      errorCode: null,
    );

    try {
      final testContentUseCase = ref.read(testContentUseCaseProvider);
      final result = await testContentUseCase.getTestContent(testId);

      result.fold(
        onSuccess: (questionPages) {
          print('✅ Notifier: 콘텐츠 로드 성공 - ${questionPages.length}페이지');
          state = state.copyWith(
            isLoading: false,
            questionPages: questionPages,
            errorMessage: null,
            errorCode: null,
          );
        },
        onFailure: (message, errorCode) {
          print('❌ Notifier: 콘텐츠 로드 실패 - $message');
          state = state.copyWith(
            isLoading: false,
            questionPages: null,
            errorMessage: message,
            errorCode: errorCode,
          );
        },
      );
    } catch (e) {
      print('💥 Notifier 예외 발생: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: '테스트 콘텐츠를 불러오는 중 오류가 발생했습니다',
        errorCode: 'UNKNOWN_ERROR',
      );
    }
  }

  /// 상태 초기화
  void reset() {
    state = TestContentState.initial();
  }

  /// 에러 클리어
  void clearError() {
    state = state.copyWith(
      errorMessage: null,
      errorCode: null,
    );
  }
}