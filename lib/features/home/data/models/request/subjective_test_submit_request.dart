import 'package:freezed_annotation/freezed_annotation.dart';

part 'subjective_test_submit_request.freezed.dart';
part 'subjective_test_submit_request.g.dart';

@freezed
class SubjectiveTestSubmitRequest with _$SubjectiveTestSubmitRequest {
  factory SubjectiveTestSubmitRequest({
    /// 테스트 식별 태그 (예: AI_BIG5)
    required String testTag,

    /// 사용자가 입력한 주관식 답변 리스트 (순서대로)
    required List<String> answers,
  }) = _SubjectiveTestSubmitRequest;

  factory SubjectiveTestSubmitRequest.fromJson(Map<String, dynamic> json) =>
      _$SubjectiveTestSubmitRequestFromJson(json);
}

// 💡 확장 메서드로 유효성 검증 로직 추가 (Repository에서 사용)
extension SubjectiveTestSubmitRequestX on SubjectiveTestSubmitRequest {
  bool get isValid =>
      testTag.isNotEmpty &&
          answers.isNotEmpty &&
          answers.every((answer) => answer.trim().isNotEmpty); // 빈 답변이 없는지 확인
}