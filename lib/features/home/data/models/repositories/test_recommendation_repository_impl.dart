import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_canvas/features/home/data/models/datasources/test_recommendation_api_data_source.dart';

import '../../../../../core/auth/token_manager.dart';
import '../../../../../core/auth/token_manager_provider.dart';
import '../../../../../core/utils/result.dart';
import '../response/test_recommendation_response.dart';


// --- Provider ---
final testRecommendationRepositoryProvider = Provider<TestRecommendationRepository>((ref) {
  final apiDataSource = ref.watch(testRecommendationApiDataSourceProvider);
  final tokenManager = ref.watch(tokenManagerProvider);
  return TestRecommendationRepositoryImpl(apiDataSource, tokenManager);
});

// --- Interface ---
abstract class TestRecommendationRepository {
  Future<Result<List<TestRecommendationResponse>>> getRecommendations();
}

// --- Implementation ---
class TestRecommendationRepositoryImpl implements TestRecommendationRepository {
  final TestRecommendationApiDataSource _apiDataSource;
  final TokenManager _tokenManager;

  TestRecommendationRepositoryImpl(this._apiDataSource, this._tokenManager);

  @override
  Future<Result<List<TestRecommendationResponse>>> getRecommendations() async {
    try {
      // 1. 토큰 획득 (로그인 유저 맞춤 추천이므로 토큰 필요하다고 가정)
      // 만약 비로그인 허용 시 token을 null로 보내는 로직으로 변경 가능
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) {
        // 비로그인 상태면 빈 리스트를 줄지, 에러를 줄지 정책 결정 필요.
        // 여기서는 "인증 필요" 에러로 처리하거나, null을 보내서 서버가 인기순을 주게 할 수 있음.
        // 현재는 기존 스타일대로 에러 처리 (로그인 필수)
        return Result.failure('로그인이 필요한 서비스입니다.');
      }

      print('🎁 [Repo] 추천 테스트 목록 요청');

      // 2. API 호출
      final response = await _apiDataSource.getRecommendations(validToken);

      // 3. 응답 처리
      if (response.success && response.data != null) {
        print('✅ [Repo] 추천 목록 수신: ${response.data!.length}개');
        return Result.success(response.data!);
      } else {
        print('❌ [Repo] 추천 목록 실패: ${response.message}');
        return Result.failure(response.message ?? '데이터를 불러오지 못했습니다.');
      }
    } catch (e) {
      print('❌ [Repo] 추천 API 오류: $e');
      return Result.failure('네트워크 오류가 발생했습니다.');
    }
  }
}