// =============================================================
// 📁 lib/features/test/data/repositories/test_repository_impl.dart
// =============================================================

import 'package:dio/dio.dart';

import '../../../../../core/auth/token_manager.dart';
import '../../../../../core/utils/result.dart';
import '../../../../info/data/models/response/test_detail_response.dart';
import '../../../../psy_result/data/model/request/submit_test_request.dart';
import '../../../../psy_result/data/model/response/test_result_response.dart';
import '../../../../psytest/data/mappers/test_content_mapper.dart';
import '../../../../psytest/data/model/test_question.dart';
import '../../../domain/models/test_ranking_item.dart';
import '../../../domain/repositories/test_repository.dart';
import '../datasources/test_api_data_source.dart';
import '../request/subjective_test_submit_request.dart';



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
  Future<Result<TestDetailResponse>> getTestDetailByTag(String tag) async {
    try {
      final token = await _tokenManager.getValidAccessToken();
      if (token == null) return Result.failure('로그인이 필요합니다.');

      final response = await _testApiDataSource.getTestDetailByTag(tag, token);

      if (response.success && response.data != null) {
        return Result.success(response.data!);
      } else {
        return Result.failure(response.message ?? '상세 정보 조회 실패');
      }
    } catch (e) {
      return Result.failure('네트워크 오류: $e');
    }
  }


  @override
  Future<Result<void>> deleteTestResult(int resultId) async {
    try {
      // 1. 토큰 확인
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) return Result.failure('인증이 필요합니다', 'AUTH_REQUIRED');

      // 2. DELETE API 호출
      // 서버에서 ApiResponse<Void> 또는 ApiResponse<dynamic>을 반환할 텐데
      // Retrofit은 ApiResponse<void>도 잘 처리합니다.
      final apiResponse = await _testApiDataSource.deleteTestResult(resultId, validToken);

      // 3. 응답 결과 처리
      if (apiResponse.success) {
        return Result.success(null); // 성공 시 데이터 없으므로 null
      } else {
        return Result.failure(apiResponse.message ?? '결과 삭제에 실패했습니다');
      }
    } on DioException catch (e) {
      // 4. 네트워크 에러 처리 (로그 출력 추천)
      return Result.failure('네트워크 오류가 발생했습니다');
    } catch (e) {
      return Result.failure('알 수 없는 오류 발생: $e');
    }
  }

  @override
  Future<Result<TestResultResponse>> submitSubjectiveTest(
      SubjectiveTestSubmitRequest request,
      ) async {
    try {
      // 1️⃣ 클라이언트 측 검증 (확장 메서드 활용)
      if (!request.isValid) {
        return Result.failure(
          'VALIDATION_ERROR',
          '모든 문항에 답변을 입력해주세요.',
        );
      }

      // 2️⃣ 토큰 가져오기
      final token = await _tokenManager.getValidAccessToken();
      if (token == null) {
        return  Result.failure(
          'AUTHENTICATION_ERROR',
          '로그인이 필요합니다',
        );
      }

      // 3️⃣ API 호출 (AI 분석이라 시간이 좀 걸릴 수 있음)
      final apiResponse = await _testApiDataSource.submitSubjectiveTest(
        request,
        token, // Bearer prefix 처리는 TokenManager나 Interceptor에 있다고 가정
      );

      // 4️⃣ 응답 처리
      if (apiResponse.success) {
        return Result.success(
          apiResponse.data ?? const TestResultResponse(
            resultKey: "PENDING_AI", // ✅ 식별용 키 (가장 중요)
            resultTag: "분석 중...",
            briefDescription: "AI가 답변을 분석하고 있습니다.",
            backgroundColor: "FFFFFF", // 흰색 (오류 방지용 HEX)
          ),
          apiResponse.message ?? '분석이 시작되었습니다.',
        );
      } else {
        return Result.failure(
          apiResponse.message ?? 'UNKNOWN_ERROR',
          apiResponse.message ?? '알 수 없는 오류가 발생했습니다',
        );
      }
    } on DioException catch (e) {
      // 5️⃣ 네트워크 오류 처리
      // (기존 submitTest와 동일한 로직 재사용 가능)
      if (e.response?.statusCode == 400) {
        return Result.failure(
          'VALIDATION_ERROR',
          e.response?.data['message'] ?? '입력 정보가 올바르지 않습니다.',
        );
      } else if (e.response?.statusCode == 402) { // 💰 코인 부족 (402 Payment Required)
        return  Result.failure(
          'INSUFFICIENT_COIN',
          '코인이 부족하여 분석을 진행할 수 없습니다.',
        );
      } else if (e.response?.statusCode == 401) {
        return Result.failure(
          'AUTHENTICATION_ERROR',
          '인증이 만료되었습니다. 다시 로그인해주세요',
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return  Result.failure(
          'TIMEOUT_ERROR',
          'AI 분석 시간이 초과되었습니다. 잠시 후 다시 시도해주세요.',
        );
      } else {
        return Result.failure(
          'NETWORK_ERROR',
          '서버 통신 오류: ${e.message}',
        );
      }
    } catch (e) {
      // 6️⃣ 예상치 못한 오류
      return Result.failure(
        'UNKNOWN_ERROR',
        '시스템 오류가 발생했습니다: $e',
      );
    }
  }

  @override
  Future<Result<TestResultResponse>> submitTest(
      SubmitTestRequest request,
      ) async {
    try {
      // 1️⃣ 클라이언트 측 검증
      if (!request.isValid) {
        return Result.failure(
          'VALIDATION_ERROR',
          '답변 데이터가 유효하지 않습니다',
        );
      }

      // 2️⃣ 중복 검사
      if (request.hasDuplicateAnswers) {
        final duplicates = request.duplicateQuestionIds.join(', ');
        return Result.failure(
          'DUPLICATE_ANSWERS',
          '중복된 답변이 있습니다: $duplicates',
        );
      }

      // 3️⃣ 토큰 가져오기
      final token = await _tokenManager.getValidAccessToken();
      if (token == null) {
        return Result.failure(
          'AUTHENTICATION_ERROR',
          '로그인이 필요합니다',
        );
      }

      // 4️⃣ API 호출
      final apiResponse = await _testApiDataSource.submitTest(request, token);

      // 5️⃣ 응답 처리
      if (apiResponse.success && apiResponse.data != null) {
        return Result.success(
          apiResponse.data!,
          apiResponse.message ?? '테스트 제출이 완료되었습니다',
        );
      } else {
        return Result.failure(
          apiResponse.message ?? '알 수 없는 오류가 발생했습니다',
           'UNKNOWN_ERROR',
        );
      }
    } on DioException catch (e) {
      // 6️⃣ 네트워크 오류 처리
      if (e.response?.statusCode == 400) {
        return Result.failure(
          'VALIDATION_ERROR',
          e.response?.data['message'] ?? '잘못된 요청입니다',
        );
      } else if (e.response?.statusCode == 401) {
        return Result.failure(
          'AUTHENTICATION_ERROR',
          '인증이 만료되었습니다. 다시 로그인해주세요',
        );
      } else if (e.response?.statusCode == 404) {
        return Result.failure(
          'TEST_NOT_FOUND',
          '요청하신 테스트를 찾을 수 없습니다',
        );
      } else {
        return Result.failure(
          'NETWORK_ERROR',
          '네트워크 오류가 발생했습니다: ${e.message}',
        );
      }
    } catch (e) {
      // 7️⃣ 예상치 못한 오류
      return Result.failure(
        'UNKNOWN_ERROR',
        '알 수 없는 오류가 발생했습니다: $e',
      );
    }
  }

  @override
  Future<Result<List<List<TestQuestion>>>> getTestContent(int testId) async {
    try {
      // 유효한 토큰 확인
      final validToken = await _tokenManager.getValidAccessToken();

      if (validToken == null) {
        print('인증이 필요합니다 - 로그인 페이지로 이동 필요');
        return Result.failure('인증이 필요합니다', 'AUTHENTICATION_REQUIRED');
      }

      // API 호출
      final apiResponse = await _testApiDataSource.getTestContent(testId, validToken);

      // ApiResponse를 Result로 변환
      if (apiResponse.success && apiResponse.data != null) {
        // DTO → Domain Model 변환
        final domainModel = TestContentMapper.toDomainModel(apiResponse.data!);

        print('✅ 테스트 콘텐츠 조회 성공 - testId: $testId, pages: ${domainModel.length}');
        return Result.success(domainModel, '테스트 콘텐츠를 성공적으로 불러왔습니다');
      } else {
        final errorMessage = apiResponse.error?.message ??
            apiResponse.message ??
            '테스트 콘텐츠를 불러오는데 실패했습니다';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';

        print('❌ 테스트 콘텐츠 조회 실패 - $errorMessage');
        return Result.failure(errorMessage, errorCode);
      }
    } on DioException catch (e) {
      return _handleDioExceptionForContent(e);
    } catch (e) {
      print('예상치 못한 오류 발생: $e');
      return Result.failure('알 수 없는 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }

  /// Dio 예외를 Result로 변환 (콘텐츠 조회용)
  Result<List<List<TestQuestion>>> _handleDioExceptionForContent(DioException e) {
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

  @override
  Future<Result<TestResultResponse>> getTestResultDetail(int resultId) async {
    try {
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) return Result.failure('인증이 필요합니다', 'AUTH_REQUIRED');

      // ✅ getTestResult 호출
      final apiResponse = await _testApiDataSource.getTestResult(resultId, validToken);

      if (apiResponse.success && apiResponse.data != null) {
        return Result.success(apiResponse.data!);
      } else {
        return Result.failure(apiResponse.message ?? '결과를 불러오지 못했습니다');
      }
    } on DioException catch (e) {
      // 기존 에러 핸들러 재사용
      return Result.failure('네트워크 오류가 발생했습니다');
    } catch (e) {
      return Result.failure('알 수 없는 오류 발생: $e');
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