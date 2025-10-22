// lib/features/psytest/data/models/request/submit_test_request.dart

import 'package:freezed_annotation/freezed_annotation.dart';

import '../dto/test_answer.dart';

part 'submit_test_request.freezed.dart';
part 'submit_test_request.g.dart';

/// 🧠 심리 테스트 제출 요청 DTO (클라이언트)
///
/// 서버의 SubmitTestRequest와 정확히 일치하는 구조
///
/// **요청 예시:**
/// ```json
/// {
///   "testId": 1,
///   "answers": [
///     {
///       "questionId": "q1",
///       "selectedValue": "ACHIEVEMENT_A"
///     },
///     {
///       "questionId": "q30",
///       "selectedValue": "자유롭고 의미있는 삶"
///     }
///   ]
/// }
/// ```
@freezed
class SubmitTestRequest with _$SubmitTestRequest {
  const factory SubmitTestRequest({
    /// 📖 테스트 ID (PK)
    @JsonKey(name: 'testId') required int testId,

    /// ✅ 사용자 답변 목록 (1~100개)
    @JsonKey(name: 'answers') required List<TestAnswer> answers,
  }) = _SubmitTestRequest;

  /// 🏭 Factory: JSON → DTO
  factory SubmitTestRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitTestRequestFromJson(json);
}

/// 🔧 Extension: 비즈니스 로직 메서드
extension SubmitTestRequestX on SubmitTestRequest {
  /// 특정 질문의 답변 조회
  String? getAnswerValue(String questionId) {
    try {
      return answers
          .firstWhere((answer) => answer.questionId == questionId)
          .selectedValue;
    } catch (e) {
      return null;
    }
  }

  /// 모든 질문에 답변했는지 확인
  bool hasAllAnswers(int expectedQuestionCount) {
    return answers.length >= expectedQuestionCount;
  }

  /// 중복 답변 확인
  bool get hasDuplicateAnswers {
    final questionIds = answers.map((a) => a.questionId).toList();
    final uniqueIds = questionIds.toSet();
    return uniqueIds.length < questionIds.length;
  }

  /// 중복된 질문 ID 반환
  List<String> get duplicateQuestionIds {
    final seen = <String>{};
    final duplicates = <String>{};

    for (var answer in answers) {
      if (seen.contains(answer.questionId)) {
        duplicates.add(answer.questionId);
      }
      seen.add(answer.questionId);
    }

    return duplicates.toList();
  }

  /// 유효성 검사
  bool get isValid {
    // 1. 답변 개수 체크 (1~100개)
    if (answers.isEmpty || answers.length > 100) {
      return false;
    }

    // 2. 중복 답변 체크
    if (hasDuplicateAnswers) {
      return false;
    }

    // 3. 각 답변의 유효성 체크
    for (var answer in answers) {
      if (!answer.isValid) {
        return false;
      }
    }

    return true;
  }

  /// 주관식 답변만 추출
  List<TestAnswer> get subjectiveAnswers {
    return answers.where((a) => a.isSubjectiveAnswer).toList();
  }

  /// 선택형 답변만 추출
  List<TestAnswer> get choiceAnswers {
    return answers.where((a) => a.isChoiceAnswer).toList();
  }

  /// 답변 개수
  int get answerCount => answers.length;

  /// 디버깅용 문자열
  String get debugInfo {
    return 'SubmitTestRequest{'
        'testId: $testId, '
        'answerCount: ${answers.length}, '
        'hasChoiceAnswers: ${choiceAnswers.isNotEmpty}, '
        'hasSubjectiveAnswers: ${subjectiveAnswers.isNotEmpty}, '
        'hasDuplicates: $hasDuplicateAnswers'
        '}';
  }
}