
import 'package:dio/dio.dart';


import '../../../../../core/auth/token_manager.dart';
import '../../../../../core/utils/result.dart';
import '../../../domain/models/test_ranking_item.dart';
import '../../../domain/repositories/test_repository.dart';
import '../datasources/test_api_data_source.dart';

/// 테스트 Repository 구현체
class TestRepositoryImpl implements TestRepository {
  final TestApiDataSource _testApiDataSource;
  final TokenManager _tokenManager;

  const TestRepositoryImpl({
    required TestApiDataSource testApiDataSource,
    required TokenManager tokenManager,
  }) : _testApiDataSource = testApiDataSource,
        _tokenManager = tokenManager;

  @override
  Future<Result<TestListResult>> getLatestTests({
    required int page,
    required int size,
  }) async {
    try {
      // 유효한 토큰 확인
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) {
        print('인증이 필요합니다 - 로그인 페이지로 이동 필요');
        return Result.failure('인증이 필요합니다', 'AUTHENTICATION_REQUIRED');
      }

      // API 호출
      final apiResponse = await _testApiDataSource.getLatestTests(page, size, validToken);

      // ApiResponse를 Result로 변환 (직접 프로퍼티 접근)
      if (apiResponse.success && apiResponse.data != null) {
        // DTO를 Domain Model로 변환
        final testItems = _convertToTestRankingItems(apiResponse.data!);

        final result = TestListResult(
          tests: testItems,
          hasMore: apiResponse.data!.hasMore,
        );

        print('최신 테스트 목록 조회 성공 - ${testItems.length}개, hasMore: ${apiResponse.data!.hasMore}');
        return Result.success(result, '테스트 목록을 성공적으로 불러왔습니다');
      } else {
        // API 응답에서 에러 메시지 추출
        final errorMessage = apiResponse.error?.message ?? apiResponse.message ?? '테스트 목록을 불러오는데 실패했습니다';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';

        print('최신 테스트 목록 조회 실패 - $errorMessage');
        return Result.failure(errorMessage, errorCode);
      }

    } on DioException catch (e) {
      // 네트워크 에러 처리
      return _handleDioException(e);
    } catch (e) {
      // 기타 예외 처리
      print('예상치 못한 오류 발생: $e');
      return Result.failure('알 수 없는 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }

  /// Dio 예외를 Result로 변환
  Result<TestListResult> _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Result.failure('서버 연결 시간이 초과되었습니다', 'TIMEOUT_ERROR');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 401:
            return Result.failure('인증이 만료되었습니다', 'AUTHENTICATION_EXPIRED');
          case 403:
            return Result.failure('접근 권한이 없습니다', 'ACCESS_DENIED');
          case 404:
            return Result.failure('요청한 데이터를 찾을 수 없습니다', 'NOT_FOUND');
          case 500:
            return Result.failure('서버 내부 오류가 발생했습니다', 'SERVER_ERROR');
          default:
            return Result.failure('서버 요청 중 오류가 발생했습니다', 'HTTP_ERROR');
        }

      case DioExceptionType.cancel:
        return Result.failure('요청이 취소되었습니다', 'REQUEST_CANCELLED');

      case DioExceptionType.unknown:
      default:
        if (e.error.toString().contains('SocketException')) {
          return Result.failure('네트워크 연결을 확인해주세요', 'NETWORK_ERROR');
        }
        return Result.failure('네트워크 오류가 발생했습니다', 'NETWORK_ERROR');
    }
  }

  /// TestsResponse를 TestRankingItem 리스트로 변환
  List<TestRankingItem> _convertToTestRankingItems(dynamic testsResponse) {
    final tests = testsResponse.tests as List;

    return tests.asMap().entries.map((entry) {
      final index = entry.key;
      final test = entry.value;

      return TestRankingItem(
        id: test.testId.toString(),
        title: test.title,
        subtitle: test.subtitle ?? '심리테스트',
        imagePath: _getImagePath(test.thumbnailUrl),
        participantCount: test.viewCount,
        popularityScore: _calculatePopularityScore(test.viewCount, index),
      );
    }).toList();
  }

  /// 썸네일 URL을 이미지 경로로 변환
  String _getImagePath(String? thumbnailUrl) {
    if (thumbnailUrl == null || thumbnailUrl.isEmpty) {
      return 'assets/images/default_test_card.png';
    }

    if (thumbnailUrl.startsWith('http')) {
      return thumbnailUrl;
    }

    return thumbnailUrl;
  }

  /// 조회수 기반 인기도 점수 계산
  double _calculatePopularityScore(int viewCount, int index) {
    double baseScore = (viewCount / 1000).clamp(0, 100).toDouble();
    double rankBonus = (10 - index).clamp(0, 10).toDouble();
    return (baseScore + rankBonus).clamp(0, 100);
  }
}