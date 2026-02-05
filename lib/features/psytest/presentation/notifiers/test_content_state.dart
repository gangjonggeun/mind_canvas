import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../psy_result/data/model/response/test_result_response.dart';
import '../../data/model/test_question.dart';

part 'test_content_state.freezed.dart';

/// 테스트 콘텐츠 상태

@freezed
class TestContentState with _$TestContentState {
  const factory TestContentState({
    // 📋 콘텐츠 로드 관련
    @Default(false) bool isLoading,
    List<List<TestQuestion>>? questionPages,

    // 📤 제출 관련 ✅ 추가
    @Default(false) bool isSubmitting,
    @Default(false) bool isCompleted,
    TestResultResponse? testResult,

    // ❌ 에러
    String? errorMessage,
    String? errorCode,
  }) = _TestContentState;

  factory TestContentState.initial() => const TestContentState();
}


extension TestContentStateX on TestContentState {
  /// 현재 결과가 AI 분석 대기 상태인지 확인
  bool get isAiPending =>
      isCompleted && testResult?.resultKey == "PENDING_AI";

  /// 일반적인 결과 도출 상태인지 확인
  bool get hasActualResult =>
      isCompleted && testResult != null && testResult?.resultKey != "PENDING_AI";
}