// lib/features/psytest/data/mappers/test_content_mapper.dart

import '../model/response/test_content_response.dart';
import '../model/test_question.dart';

class TestContentMapper {
  /// DTO → Domain Model 변환
  static List<List<TestQuestion>> toDomainModel(TestContentResponse dto) {
    final List<List<TestQuestion>> pages = [];

    for (var pageDto in dto.pages) {
      final List<TestQuestion> questions = [];

      for (var questionDto in pageDto.questions) {
        questions.add(TestQuestion(
          id: questionDto.questionId,
          text: questionDto.questionText,
          type: _mapInputTypeToQuestionType(questionDto.inputType),
          imageUrl: questionDto.imageUrl,
          options: questionDto.options?.map((optDto) => QuestionOption(
            id: optDto.value, // 서버의 value를 id로 사용
            text: optDto.text,
            value: optDto.value,
            imageUrl: null, // 서버에는 옵션 이미지 없음
          )).toList(),
        ));
      }

      pages.add(questions);
    }

    return pages;
  }

  /// inputType String → QuestionType enum 변환
  static QuestionType _mapInputTypeToQuestionType(String inputType) {
    switch (inputType) {
      case 'choice':
        return QuestionType.choice; // ✅ 객관식은 choice로!
      case 'text':
        return QuestionType.text;   // ✅ 한 줄 입력
      case 'textarea':
        return QuestionType.textarea; // ✅ 여러 줄 입력
      case 'drawing':
        return QuestionType.drawing;  // ✅ 그림
      default:
      // 기본값은 안전하게 text(한 줄) 또는 choice로 처리
        return QuestionType.text;
    }
  }
}