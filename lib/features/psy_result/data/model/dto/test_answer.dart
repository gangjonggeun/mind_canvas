// lib/features/psytest/data/models/request/test_answer.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_answer.freezed.dart';
part 'test_answer.g.dart';

/// 📝 개별 질문 답변 DTO (클라이언트)
///
/// 서버의 TestAnswer와 정확히 일치하는 구조
///
/// **예시:**
/// ```json
/// {
///   "questionId": "q1",
///   "selectedValue": "ACHIEVEMENT_A"
/// }
/// ```
@freezed
class TestAnswer with _$TestAnswer {
  const factory TestAnswer({
    /// ❓ 질문 ID (예: "q1", "q2", "q30")
    @JsonKey(name: 'questionId') required String questionId,

    /// 🎯 선택된 답변 값
    ///
    /// - 선택형: "ACHIEVEMENT_A", "POWER_B" 등
    /// - 주관식: 사용자가 입력한 텍스트
    @JsonKey(name: 'selectedValue') required String selectedValue,
  }) = _TestAnswer;

  /// 🏭 Factory: JSON → DTO
  factory TestAnswer.fromJson(Map<String, dynamic> json) =>
      _$TestAnswerFromJson(json);
}

/// 🔧 Extension: 유틸리티 메서드
extension TestAnswerX on TestAnswer {
  /// 선택형 답변인지 확인 (대문자 + 언더스코어 패턴)
  bool get isChoiceAnswer {
    return RegExp(r'^[A-Z_]+$').hasMatch(selectedValue);
  }

  /// 주관식 답변인지 확인
  bool get isSubjectiveAnswer => !isChoiceAnswer;

  /// 답변이 비어있는지 확인
  bool get isEmpty => selectedValue.trim().isEmpty;

  /// 답변이 유효한지 확인
  bool get isValid {
    return questionId.isNotEmpty &&
        selectedValue.isNotEmpty &&
        selectedValue.length <= 500;
  }
}