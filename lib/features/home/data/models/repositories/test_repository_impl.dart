// =============================================================
// 📁 lib/features/test/data/repositories/test_repository_impl.dart
// =============================================================

import 'package:dio/dio.dart';

import '../../../../../core/auth/token_manager.dart';
import '../../../../../core/utils/result.dart';
import '../../../../info/data/models/response/test_detail_response.dart';
import '../../../domain/models/test_ranking_item.dart';
import '../../../domain/repositories/test_repository.dart';
import '../datasources/test_api_data_source.dart';



/// 🧠 테스트 Repository 구현체 (기존 패턴 확장)
class TestRepositoryImpl implements TestRepository {
  final TestApiDataSource _testApiDataSource;
  final TokenManager _tokenManager;

  const TestRepositoryImpl({
    required TestApiDataSource testApiDataSource,
    required TokenManager tokenManager,
  }) : _testApiDataSource = testApiDataSource,
        _tokenManager = tokenManager;


  @override
  Future<Result<TestDetailResponse>> getTestDetail(int testId) async {
    try {
      // 유효한 토큰 확인
      final validToken = await _tokenManager.getValidAccessToken();

      if (validToken == null) {
        print('인증이 필요합니다 - 로그인 페이지로 이동 필요');
        return Result.failure('인증이 필요합니다', 'AUTHENTICATION_REQUIRED');
      }

      // API 호출
      final apiResponse = await _testApiDataSource.getTestDetail(testId, validToken);

      // ApiResponse를 Result로 변환
      if (apiResponse.success && apiResponse.data != null) {
        print('테스트 상세 정보 조회 성공 - testId: $testId, title: ${apiResponse.data!.title}');
        return Result.success(apiResponse.data!, '테스트 상세 정보를 성공적으로 불러왔습니다');
      } else {
        final errorMessage = apiResponse.error?.message ?? apiResponse.message ?? '테스트 상세 정보를 불러오는데 실패했습니다';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';

        print('테스트 상세 정보 조회 실패 - $errorMessage');
        return Result.failure(errorMessage, errorCode);
      }
    } on DioException catch (e) {
      return _handleDioExceptionForDetail(e);
    } catch (e) {
      print('예상치 못한 오류 발생: $e');
      return Result.failure('알 수 없는 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }


  // =============================================================
  // 🌟 최신순 테스트 목록 조회 (기존 구현)
  // =============================================================

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

      // ApiResponse를 Result로 변환
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
        final errorMessage = apiResponse.error?.message ?? apiResponse.message ?? '테스트 목록을 불러오는데 실패했습니다';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';

        print('최신 테스트 목록 조회 실패 - $errorMessage');
        return Result.failure(errorMessage, errorCode);
      }
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      print('예상치 못한 오류 발생: $e');
      return Result.failure('알 수 없는 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }

  // =============================================================
  // 🔥 인기도 기준 테스트 목록 조회 (페이징)
  // =============================================================

  @override
  Future<Result<TestListResult>> getPopularTestsList({
    required int page,
    required int size,
  }) async {
    try {
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) {
        print('인증이 필요합니다 - 로그인 페이지로 이동 필요');
        return Result.failure('인증이 필요합니다', 'AUTHENTICATION_REQUIRED');
      }

      final apiResponse = await _testApiDataSource.getPopularTestsList(page, size, validToken);

      if (apiResponse.success && apiResponse.data != null) {
        final testItems = _convertToTestRankingItems(apiResponse.data!);

        final result = TestListResult(
          tests: testItems,
          hasMore: apiResponse.data!.hasMore,
        );

        print('인기 테스트 목록 조회 성공 - ${testItems.length}개, hasMore: ${apiResponse.data!.hasMore}');
        return Result.success(result, '인기 테스트 목록을 성공적으로 불러왔습니다');
      } else {
        final errorMessage = apiResponse.error?.message ?? apiResponse.message ?? '인기 테스트 목록을 불러오는데 실패했습니다';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';

        print('인기 테스트 목록 조회 실패 - $errorMessage');
        return Result.failure(errorMessage, errorCode);
      }
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      print('예상치 못한 오류 발생: $e');
      return Result.failure('알 수 없는 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }

  // =============================================================
  // 🔥 홈 화면용 인기 테스트 TOP 5 조회
  // =============================================================

  @override
  Future<Result<TestListResult>> getPopularTests() async {
    try {
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) {
        print('인증이 필요합니다 - 로그인 페이지로 이동 필요');
        return Result.failure('인증이 필요합니다', 'AUTHENTICATION_REQUIRED');
      }

      final apiResponse = await _testApiDataSource.getPopularTests(validToken);

      if (apiResponse.success && apiResponse.data != null) {
        final testItems = _convertToTestRankingItems(apiResponse.data!);

        // TOP 5는 hasMore가 항상 false
        final result = TestListResult(
          tests: testItems,
          hasMore: false,
        );

        print('홈 화면 인기 테스트 조회 성공 - ${testItems.length}개');
        return Result.success(result, '인기 테스트를 성공적으로 불러왔습니다');
      } else {
        final errorMessage = apiResponse.error?.message ?? apiResponse.message ?? '인기 테스트를 불러오는데 실패했습니다';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';

        print('홈 화면 인기 테스트 조회 실패 - $errorMessage');
        return Result.failure(errorMessage, errorCode);
      }
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      print('예상치 못한 오류 발생: $e');
      return Result.failure('알 수 없는 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }

  // =============================================================
  // 👁️ 조회수 기준 테스트 목록 조회
  // =============================================================

  @override
  Future<Result<TestListResult>> getMostViewedTests({
    required int page,
    required int size,
  }) async {
    try {
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) {
        print('인증이 필요합니다 - 로그인 페이지로 이동 필요');
        return Result.failure('인증이 필요합니다', 'AUTHENTICATION_REQUIRED');
      }

      final apiResponse = await _testApiDataSource.getMostViewedTests(page, size, validToken);

      if (apiResponse.success && apiResponse.data != null) {
        final testItems = _convertToTestRankingItems(apiResponse.data!);

        final result = TestListResult(
          tests: testItems,
          hasMore: apiResponse.data!.hasMore,
        );

        print('조회수 기준 테스트 목록 조회 성공 - ${testItems.length}개, hasMore: ${apiResponse.data!.hasMore}');
        return Result.success(result, '조회수 기준 테스트 목록을 성공적으로 불러왔습니다');
      } else {
        final errorMessage = apiResponse.error?.message ?? apiResponse.message ?? '조회수 기준 테스트 목록을 불러오는데 실패했습니다';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';

        print('조회수 기준 테스트 목록 조회 실패 - $errorMessage');
        return Result.failure(errorMessage, errorCode);
      }
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      print('예상치 못한 오류 발생: $e');
      return Result.failure('알 수 없는 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }

  // =============================================================
  // 📈 트렌딩 테스트 목록 조회
  // =============================================================

  @override
  Future<Result<TestListResult>> getTrendingTests({
    required int page,
    required int size,
  }) async {
    try {
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) {
        print('인증이 필요합니다 - 로그인 페이지로 이동 필요');
        return Result.failure('인증이 필요합니다', 'AUTHENTICATION_REQUIRED');
      }

      final apiResponse = await _testApiDataSource.getTrendingTests(page, size, validToken);

      if (apiResponse.success && apiResponse.data != null) {
        final testItems = _convertToTestRankingItems(apiResponse.data!);

        final result = TestListResult(
          tests: testItems,
          hasMore: apiResponse.data!.hasMore,
        );

        print('트렌딩 테스트 목록 조회 성공 - ${testItems.length}개, hasMore: ${apiResponse.data!.hasMore}');
        return Result.success(result, '트렌딩 테스트 목록을 성공적으로 불러왔습니다');
      } else {
        final errorMessage = apiResponse.error?.message ?? apiResponse.message ?? '트렌딩 테스트 목록을 불러오는데 실패했습니다';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';

        print('트렌딩 테스트 목록 조회 실패 - $errorMessage');
        return Result.failure(errorMessage, errorCode);
      }
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      print('예상치 못한 오류 발생: $e');
      return Result.failure('알 수 없는 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }

  // =============================================================
  // 🔤 가나다순 테스트 목록 조회
  // =============================================================

  @override
  Future<Result<TestListResult>> getAlphabeticalTests({
    required int page,
    required int size,
  }) async {
    try {
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) {
        print('인증이 필요합니다 - 로그인 페이지로 이동 필요');
        return Result.failure('인증이 필요합니다', 'AUTHENTICATION_REQUIRED');
      }

      final apiResponse = await _testApiDataSource.getAlphabeticalTests(page, size, validToken);

      if (apiResponse.success && apiResponse.data != null) {
        final testItems = _convertToTestRankingItems(apiResponse.data!);

        final result = TestListResult(
          tests: testItems,
          hasMore: apiResponse.data!.hasMore,
        );

        print('가나다순 테스트 목록 조회 성공 - ${testItems.length}개, hasMore: ${apiResponse.data!.hasMore}');
        return Result.success(result, '가나다순 테스트 목록을 성공적으로 불러왔습니다');
      } else {
        final errorMessage = apiResponse.error?.message ?? apiResponse.message ?? '가나다순 테스트 목록을 불러오는데 실패했습니다';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';

        print('가나다순 테스트 목록 조회 실패 - $errorMessage');
        return Result.failure(errorMessage, errorCode);
      }
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      print('예상치 못한 오류 발생: $e');
      return Result.failure('알 수 없는 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }

  // =============================================================
  // 🏥 헬스체크 (추가)
  // =============================================================

  @override
  Future<Result<String>> healthCheck() async {
    try {
      final apiResponse = await _testApiDataSource.healthCheck();

      if (apiResponse.success && apiResponse.data != null) {
        print('헬스체크 성공');
        return Result.success(apiResponse.data!, '서비스가 정상 동작 중입니다');
      } else {
        final errorMessage = apiResponse.error?.message ?? apiResponse.message ?? '헬스체크 실패';
        final errorCode = apiResponse.error?.code ?? 'HEALTH_CHECK_ERROR';

        print('헬스체크 실패 - $errorMessage');
        return Result.failure(errorMessage, errorCode);
      }
    } on DioException catch (e) {
      // 헬스체크는 String 타입 반환이므로 별도 처리
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Result.failure('서버 연결 시간이 초과되었습니다', 'TIMEOUT_ERROR');
        case DioExceptionType.connectionError:
          return Result.failure('네트워크 연결을 확인해주세요', 'NETWORK_ERROR');
        default:
          return Result.failure('헬스체크 중 네트워크 오류가 발생했습니다', 'NETWORK_ERROR');
      }
    } catch (e) {
      print('헬스체크 중 예상치 못한 오류 발생: $e');
      return Result.failure('알 수 없는 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }

  // =============================================================
  // 🔧 내부 헬퍼 메서드들 (기존 유지)
  // =============================================================

  /// Dio 예외를 TestDetailResponse Result로 변환 (테스트 상세용)
  Result<TestDetailResponse> _handleDioExceptionForDetail(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Result.failure('연결 시간 초과입니다. 네트워크를 확인해주세요');
      case DioExceptionType.receiveTimeout:
        return Result.failure('응답 시간 초과입니다. 다시 시도해주세요');
      case DioExceptionType.sendTimeout:
        return Result.failure('요청 전송 시간이 초과되었습니다');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 401:
            return Result.failure('인증이 만료되었습니다', 'AUTHENTICATION_EXPIRED');
          case 403:
            return Result.failure('현재 공개되지 않은 테스트입니다', 'FORBIDDEN_ACCESS');
          case 404:
            return Result.failure('요청하신 테스트를 찾을 수 없습니다', 'TEST_NOT_FOUND');
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

  /// Dio 예외를 Result로 변환
  Result<TestListResult> _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Result.failure('연결 시간 초과입니다. 네트워크를 확인해주세요');
      case DioExceptionType.receiveTimeout:
        return Result.failure('응답 시간 초과입니다. 다시 시도해주세요');
      case DioExceptionType.sendTimeout:
        return Result.failure('요청 전송 시간이 초과되었습니다');

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

  /// TestsResponse를 TestRankingItem 리스트로 변환 (기존 유지)
  List<TestRankingItem> _convertToTestRankingItems(dynamic testsResponse) {
    final tests = testsResponse.tests as List;

    return tests.asMap().entries.map((entry) {
      final index = entry.key;
      final test = entry.value;

      return TestRankingItem(
        id: test.testId,
        title: test.title,
        subtitle: test.subtitle ?? '심리테스트',
        imagePath: _getImagePath(test.thumbnailUrl),
        viewCount: test.viewCount,
      );
    }).toList();
  }

  /// 썸네일 URL을 이미지 경로로 변환 (기존 유지)
  String _getImagePath(String? thumbnailUrl) {
    if (thumbnailUrl == null || thumbnailUrl.isEmpty) {
      return 'assets/images/default_test_card.png';
    }

    if (thumbnailUrl.startsWith('http')) {
      return thumbnailUrl;
    }

    return thumbnailUrl;
  }

  /// 조회수 기반 인기도 점수 계산 (기존 유지)
  double _calculatePopularityScore(int viewCount, int index) {
    double baseScore = (viewCount / 1000).clamp(0, 100).toDouble();
    double rankBonus = (10 - index).clamp(0, 10).toDouble();
    return (baseScore + rankBonus).clamp(0, 100);
  }
}



// =============================================================
// 📝 사용 예시 (주석)
// =============================================================

/*
// Provider에서 사용:
@riverpod
TestRepository testRepository(TestRepositoryRef ref) {
  final testApiDataSource = ref.watch(testApiDataSourceProvider);
  final tokenManager = ref.watch(tokenManagerProvider);
  
  return TestRepositoryImpl(
    testApiDataSource: testApiDataSource,
    tokenManager: tokenManager,
  );
}

// Controller에서 사용:
class TestListController extends StateNotifier<TestListState> {
  final TestRepository _testRepository;

  TestListController(this._testRepository) : super(TestListState.initial());

  Future<void> loadPopularTests() async {
    state = state.copyWith(isLoading: true);

    final result = await _testRepository.getPopularTests();

    result.fold(
      onSuccess: (testListResult) {
        state = state.copyWith(
          isLoading: false,
          tests: testListResult.tests,
          hasMore: testListResult.hasMore,
        );
      },
      onFailure: (message, errorCode) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: message,
          errorCode: errorCode,
        );
      },
    );
  }
}
*/