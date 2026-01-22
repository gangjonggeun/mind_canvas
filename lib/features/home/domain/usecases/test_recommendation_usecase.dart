import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/result.dart';
// import 경로는 프로젝트 구조에 맞게 유지하세요
import '../../data/models/repositories/test_recommendation_repository_impl.dart';
import '../../data/models/response/test_recommendation_response.dart';

// ✅ Provider 이름 오타 수정 (tes -> test)
final testRecommendationUseCaseProvider = Provider<TestRecommendationUseCase>((ref) {
  return TestRecommendationUseCase(ref.watch(testRecommendationRepositoryProvider));
});

class TestRecommendationUseCase {
  final TestRecommendationRepository _repository;

  // ✅ [수정됨] 생성자 이름은 클래스 이름과 같아야 합니다 (오타 제거)
  TestRecommendationUseCase(this._repository);

  /// 추천 테스트 목록 가져오기
  Future<Result<List<TestRecommendationResponse>>> getRecommendations() {
    return _repository.getRecommendations();
  }
}