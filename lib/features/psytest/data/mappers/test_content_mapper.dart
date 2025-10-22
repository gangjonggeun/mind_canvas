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
        return QuestionType.text; // 또는 적절한 타입
      case 'text':
      case 'textarea':
        return QuestionType.subjective;
      case 'drawing':
        return QuestionType.subjective; // 그림 그리기
      default:
        return QuestionType.text;
    }
  }
}