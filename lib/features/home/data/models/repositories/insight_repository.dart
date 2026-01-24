import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/auth/token_manager.dart';
import '../../../../../core/auth/token_manager_provider.dart';
import '../../../../../core/utils/result.dart';
import '../datasources/insight_api_data_source.dart';
import '../response/insight_response.dart';


// Provider
final insightRepositoryProvider = Provider<InsightRepository>((ref) {
  final tokenManager = ref.watch(tokenManagerProvider);
  return InsightRepositoryImpl(ref.watch(insightApiDataSourceProvider), tokenManager);
});

// Interface
abstract class InsightRepository {
  Future<Result<List<InsightResponse>>> getRandomInsights(int count);
}

// Implementation
class InsightRepositoryImpl implements InsightRepository {
  final InsightApiDataSource _dataSource;
  final TokenManager _tokenManager;

  InsightRepositoryImpl(this._dataSource, this._tokenManager);

  @override
  Future<Result<List<InsightResponse>>> getRandomInsights(int count) async {
    try {

      final validToken = await _tokenManager.getValidAccessToken();

      if (validToken == null) {
        return Result.failure('로그인이 필요한 서비스입니다.');
      }

      // 2. 토큰 실어서 보내기
      final response = await _dataSource.getRandomInsights(validToken, count);

      if (response.success && response.data != null) {
        return Result.success(response.data!);
      }
      return Result.failure(response.message ?? '데이터 없음');
    } catch (e) {
      return Result.failure('네트워크 오류: $e');
    }
  }
}