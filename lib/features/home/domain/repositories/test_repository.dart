// =============================================================
// 📁 lib/features/test/domain/repositories/test_repository.dart
// =============================================================

import '../../../../core/utils/result.dart';
import '../../../info/data/models/response/test_detail_response.dart';
import '../../../psy_result/data/model/request/submit_test_request.dart';
import '../../../psy_result/data/model/response/test_result_response.dart';
import '../../../psytest/data/model/test_question.dart';
import '../../data/models/request/subjective_test_submit_request.dart';
import '../models/test_ranking_item.dart';

/// 🧠 테스트 Repository 인터페이스 (확장 버전)
abstract class TestRepository {
  Future<Result<void>> deleteTestResult(int resultId);

  Future<Result<TestResultResponse>> submitSubjectiveTest(
      SubjectiveTestSubmitRequest request,
      );

  Future<Result<TestResultResponse>> getTestResultDetail(int resultId);

  /// 🎯 심리 테스트 제출
  ///
  /// @param request 테스트 제출 요청 (testId + answers)
  /// @return 채점 결과 (resultKey, dimensionScores 등)
  Future<Result<TestResultResponse>> submitTest(SubmitTestRequest request,);
  /// 📋 테스트 콘텐츠 조회 (문제/선택지)
  ///
  /// 서버에서 받은 DTO를 Domain Model로 변환하여 반환
  Future<Result<List<List<TestQuestion>>>> getTestContent(int testId);

  /// 🔍 테스트 상세 정보 조회
  ///
  /// 테스트 클릭 시 상세 정보를 가져오며, 서버에서 조회수가 자동 증가됩니다.
  ///
  /// @param testId 조회할 테스트 ID
  /// @return Result<TestDetailResponse> 성공 시 상세 정보, 실패 시 에러 메시지
  Future<Result<TestDetailResponse>> getTestDetail(int testId);

  /// 🌟 최신 테스트 목록 조회 (페이징) - 기존
  Future<Result<TestListResult>> getLatestTests({
    required int page,
    required int size,
  });

  /// 🔥 인기도 기준 테스트 목록 조회 (페이징)
  Future<Result<TestListResult>> getPopularTestsList({
    required int page,
    required int size,
  });

  /// 🔥 홈 화면용 인기 테스트 TOP 5 조회
  Future<Result<TestListResult>> getPopularTests();

  /// 👁️ 조회수 기준 테스트 목록 조회 (페이징)
  Future<Result<TestListResult>> getMostViewedTests({
    required int page,
    required int size,
  });

  /// 📈 트렌딩 테스트 목록 조회 (7일간 급상승)
  Future<Result<TestListResult>> getTrendingTests({
    required int page,
    required int size,
  });

  /// 🔤 가나다순 테스트 목록 조회 (페이징)
  Future<Result<TestListResult>> getAlphabeticalTests({
    required int page,
    required int size,
  });

  /// 🏥 서비스 상태 확인
  Future<Result<String>> healthCheck();
}

/// 🗂️ 테스트 목록 결과 모델 (기존 유지)
class TestListResult {
  final List<TestRankingItem> tests;
  final bool hasMore;

  const TestListResult({
    required this.tests,
    required this.hasMore,
  });

  /// 빈 결과 생성
  factory TestListResult.empty() {
    return const TestListResult(
      tests: [],
      hasMore: false,
    );
  }

  /// 디버깅용 정보
  String get debugInfo =>
      'TestListResult(tests: ${tests.length}, hasMore: $hasMore)';

  @override
  String toString() => debugInfo;
}