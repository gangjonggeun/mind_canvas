// lib/features/psytest/domain/usecases/test_content_use_case.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../../home/data/models/request/subjective_test_submit_request.dart';
import '../../../home/domain/repositories/test_repository.dart';
import '../../../home/data/repositories/test_repository_provider.dart';
import '../../../psy_result/data/model/dto/test_answer.dart';
import '../../../psy_result/data/model/request/submit_test_request.dart';
import '../../../psy_result/data/model/response/test_result_response.dart';
import '../../data/model/test_question.dart';

part 'test_content_use_case.g.dart';

/// 🏭 TestContentUseCase Provider
@riverpod
TestContentUseCase testContentUseCase(TestContentUseCaseRef ref) {
  final repository = ref.read(testRepositoryProvider);
  return TestContentUseCase(repository);
}

/// 🧠 테스트 콘텐츠 관련 비즈니스 로직
class TestContentUseCase {
  final TestRepository _repository;

  TestContentUseCase(this._repository);
  /// 🧠 주관식(AI) 테스트 제출
  ///
  /// @param testTag 테스트 태그 (예: AI_BIG5)
  /// @param orderedAnswers 질문 순서대로 정렬된 답변 리스트
  /// @return AI 분석 결과
  Future<Result<TestResultResponse>> submitSubjectiveTest(
      String testTag,
      List<String> orderedAnswers,
      ) async {
    try {
      // 1. 비즈니스 규칙 검증
      if (testTag.isEmpty) {
        return Result.failure(
          'INVALID_TAG',
          '테스트 태그가 올바르지 않습니다',
        );
      }

      if (orderedAnswers.isEmpty || orderedAnswers.any((a) => a.trim().isEmpty)) {
        return  Result.failure(
          'EMPTY_ANSWERS',
          '모든 질문에 답변을 입력해주세요',
        );
      }

      print('🎯 UseCase: 주관식 AI 제출 시작 - Tag: $testTag, 답변 수: ${orderedAnswers.length}');

      // 2. Request 생성 (서버 DTO와 매핑)
      final request = SubjectiveTestSubmitRequest(
        testTag: testTag,
        answers: orderedAnswers,
      );

      // 3. 클라이언트 검증
      if (!request.isValid) {
        return Result.failure(
          'VALIDATION_ERROR',
          '유효하지 않은 답변 데이터입니다.',
        );
      }

      // 4. Repository 호출 (새로 만든 함수 호출)
      final result = await _repository.submitSubjectiveTest(request);

      return result.fold(
        onSuccess: (testResult) {
          print('✅ UseCase: AI 분석 성공 - 결과: ${testResult.resultKey}');
          return Result.success(
            testResult,
            'AI 분석이 완료되었습니다.',
          );
        },
        onFailure: (errorCode, message) {
          print('❌ UseCase: AI 분석 실패 - $message');
          return Result.failure(errorCode, message);
        },
      );
    } catch (e) {
      print('💥 UseCase 예외 발생: $e');
      return Result.failure(
        'USECASE_ERROR',
        '분석 요청 중 오류가 발생했습니다: $e',
      );
    }
  }

  /// 테스트 제출
  ///
  /// @param testId 테스트 ID
  /// @param userAnswers 사용자 답변 맵 (questionId -> selectedValue)
  /// @return 채점 결과
  Future<Result<TestResultResponse>> submitTest(
      int testId,
      Map<String, dynamic> userAnswers,
      ) async {
    try {
      // 1. 비즈니스 규칙 검증
      if (testId <= 0) {
        return Result.failure(
          'INVALID_TEST_ID',
          '잘못된 테스트 ID입니다',
        );
      }

      if (userAnswers.isEmpty) {
        return Result.failure(
          'EMPTY_ANSWERS',
          '답변이 비어있습니다',
        );
      }

      print('🎯 UseCase: 테스트 제출 시작 - testId: $testId, 답변 수: ${userAnswers.length}');

      // 2. Request 생성
      final answers = userAnswers.entries
          .map((entry) => TestAnswer(
        questionId: entry.key,
        selectedValue: entry.value.toString(),
      ))
          .toList();

      final request = SubmitTestRequest(
        testId: testId,
        answers: answers,
      );

      // 3. 클라이언트 측 검증
      if (!request.isValid) {
        return Result.failure(
          'VALIDATION_ERROR',
          '답변 데이터가 유효하지 않습니다',
        );
      }

      if (request.hasDuplicateAnswers) {
        final duplicates = request.duplicateQuestionIds.join(', ');
        return Result.failure(
          'DUPLICATE_ANSWERS',
          '중복된 답변이 있습니다: $duplicates',
        );
      }

      // 4. Repository 호출
      final result = await _repository.submitTest(request);

      return result.fold(
        onSuccess: (testResult) {
          print('✅ UseCase: 테스트 제출 성공 - 결과: ${testResult.resultKey}');
          return Result.success(
            testResult,
            '테스트가 성공적으로 제출되었습니다',
          );
        },
        onFailure: (errorCode, message) {
          print('❌ UseCase: 테스트 제출 실패 - $message');
          return Result.failure(errorCode, message);
        },
      );
    } catch (e) {
      print('💥 UseCase 예외 발생: $e');
      return Result.failure(
        'USECASE_ERROR',
        '테스트 제출 중 오류가 발생했습니다: $e',
      );
    }
  }

  /// 테스트 콘텐츠 조회
  Future<Result<List<List<TestQuestion>>>> getTestContent(int testId) async {
    try {
      // 비즈니스 규칙 검증
      if (testId <= 0) {
        return Result.failure('잘못된 테스트 ID입니다', 'INVALID_TEST_ID');
      }

      // Repository 호출
      final result = await _repository.getTestContent(testId);

      return result.fold(
        onSuccess: (questionPages) {
          // 비즈니스 로직: 빈 페이지 검증
          if (questionPages.isEmpty) {
            return Result.failure('테스트 콘텐츠가 비어있습니다', 'EMPTY_CONTENT');
          }

          // 각 페이지의 질문 검증
          for (var page in questionPages) {
            if (page.isEmpty) {
              return Result.failure('빈 페이지가 존재합니다', 'INVALID_PAGE');
            }
          }

          print('✅ UseCase: 테스트 콘텐츠 검증 완료 - ${questionPages.length}페이지');
          return Result.success(
            questionPages,
            '테스트 콘텐츠를 성공적으로 불러왔습니다',
          );
        },
        onFailure: (message, errorCode) {
          return Result.failure(message, errorCode);
        },
      );
    } catch (e) {
      print('❌ UseCase 오류: $e');
      return Result.failure(
        '테스트 콘텐츠를 불러오는 중 오류가 발생했습니다',
        'USECASE_ERROR',
      );
    }
  }
}