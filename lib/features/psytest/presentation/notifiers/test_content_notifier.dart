// lib/features/psytest/presentation/notifiers/test_content_notifier.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/presentation/notifier/user_notifier.dart';
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
  Future<void> submitTest({
    required int testId,
    required Map<String, dynamic> userAnswers,
    // required int cost, // ✅ 추가됨
  }) async {
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

          // if (cost > 0) {
          //   ref.read(userNotifierProvider.notifier).deductCoinsLocal(cost);
          //   print('💸 로컬 코인 차감 완료: -$cost');
          // }

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
  /// 🧠 주관식(AI) 테스트 제출 ✅ 추가
  Future<void> submitSubjectiveTest({
    required String testTag,
    required Map<String, dynamic> userAnswers,
    // int cost = 15, // AI 테스트는 보통 비용이 더 높음
  }) async {
    print('🚀 submitSubjectiveTest 시작: Tag=$testTag, 답변 수=${userAnswers.length}');

    // 1. 로딩 상태 시작
    state = state.copyWith(
      isSubmitting: true,
      isCompleted: false,
      errorMessage: null,
      errorCode: null,
    );

    try {
      // 2. 답변 데이터 전처리 (Map -> Ordered List)
      // state.questionPages에 있는 질문 순서대로 답변을 추출해야 함!
      final allQuestions = state.questionPages?.expand((page) => page).toList() ?? [];

      final List<String> orderedAnswers = [];
      for (var question in allQuestions) {
        final answer = userAnswers[question.id]?.toString() ?? "";
        orderedAnswers.add(answer);
      }

      // 3. UseCase 호출
      final testContentUseCase = ref.read(testContentUseCaseProvider);
      final result = await testContentUseCase.submitSubjectiveTest(
        testTag,
        orderedAnswers,
      );

      result.fold(
        onSuccess: (testResult) {
          print('✅ Notifier: AI 분석 완료');

          // 4. (선택) 코인 차감 UI 반영
          // if (cost > 0) {
          //   ref.read(userNotifierProvider.notifier).deductCoinsLocal(cost);
          //   print('💸 로컬 코인 차감 완료: -$cost');
          // }

          // 5. 성공 상태 업데이트 (State 재사용!)
          state = state.copyWith(
            isSubmitting: false,
            isCompleted: true,
            testResult: testResult,
            errorMessage: null,
            errorCode: null,
          );
        },
        onFailure: (errorCode, message) {
          print('❌ Notifier: 분석 실패 - $message');
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
        errorMessage: '시스템 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
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