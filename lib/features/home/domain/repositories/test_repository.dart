
import '../../../../core/utils/result.dart';
import '../models/test_ranking_item.dart';

/// 테스트 Repository 인터페이스
abstract class TestRepository {
  /// 최신 테스트 목록 조회 (페이징)
  Future<Result<TestListResult>> getLatestTests({
    required int page,
    required int size,
  });
}

/// 테스트 목록 결과 모델
class TestListResult {
  final List<TestRankingItem> tests;
  final bool hasMore;

  const TestListResult({
    required this.tests,
    required this.hasMore,
  });
}
