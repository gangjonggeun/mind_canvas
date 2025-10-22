// =============================================================
// 📁 lib/features/test/data/datasources/test_api_data_source.dart
// =============================================================

import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../../../core/network/api_response_dto.dart';
import '../../../../info/data/models/response/test_detail_response.dart';
import '../../../../psy_result/data/model/request/submit_test_request.dart';
import '../../../../psy_result/data/model/response/test_result_response.dart';
import '../../../../psytest/data/model/response/test_content_response.dart';
import '../response/tests_response.dart';

part 'test_api_data_source.g.dart'; // build_runner가 생성할 파일

/// 🧠 테스트 API 데이터 소스 (Retrofit 기반)
///
/// 서버의 PsychologyTestController와 1:1 매핑되는 API 클라이언트
/// 메모리 최적화를 위한 페이징 처리 및 선택적 인증 지원
@RestApi()
abstract class TestApiDataSource {
  factory TestApiDataSource(Dio dio, {String baseUrl}) = _TestApiDataSource;

  /// 🎯 심리 테스트 제출 및 결과 반환
  ///
  /// <p><strong>핵심 특징:</strong></p>
  /// - ✅ 답변 유효성 검증 (클라이언트 + 서버)
  /// - 🎯 테스트별 자동 채점 (GenericScorer)
  /// - 📊 차원별 점수 계산 및 결과 결정
  /// - 🏆 결과 즉시 반환
  /// - 🔒 인증 필수 (로그인한 사용자만)
  ///
  /// <p><strong>요청 예시:</strong></p>
  /// ```dart
  /// final request = SubmitTestRequest(
  ///   testId: 1,
  ///   answers: [
  ///     TestAnswer(
  ///       questionId: 'q1',
  ///       selectedValue: 'ACHIEVEMENT_A',
  ///     ),
  ///     TestAnswer(
  ///       questionId: 'q30',
  ///       selectedValue: '자유롭고 의미있는 삶',
  ///     ),
  ///   ],
  /// );
  ///
  /// final result = await testApi.submitTest(
  ///   request,
  ///   'Bearer $accessToken',
  /// );
  /// ```
  ///
  /// 서버 엔드포인트: POST /api/v1/tests/submit
  ///
  /// @param request 테스트 제출 요청 (testId + answers)
  /// @param authorization JWT 토큰 (Bearer {token})
  /// @return 채점 결과 (resultKey, dimensionScores, resultDetails 등)
  @POST('/tests/submit')
  Future<ApiResponse<TestResultResponse>> submitTest(
      @Body() SubmitTestRequest request,
      @Header('Authorization') String authorization,
      );

  /// 📋 테스트 콘텐츠 조회 (문제/선택지)
  ///
  /// 서버 엔드포인트: GET /api/v1/tests/{testId}/content
  /// 인증: 필수 (비회원도 게스트 토큰 사용)
  @GET('/tests/{testId}/content')
  Future<ApiResponse<TestContentResponse>> getTestContent(
      @Path('testId') int testId,
      @Header('Authorization') String authorization,);

  /// 🔍 테스트 상세 정보 조회
  ///
  /// 서버 엔드포인트: GET /api/v1/tests/{testId}/detail
  /// 인증: 선택사항 (비회원도 조회 가능, 회원은 조회수 증가)
  /// 🔍 테스트 상세 정보 조회
  ///
  /// 서버 엔드포인트: GET /api/v1/tests/{testId}/detail
  /// 인증: 필수 (비회원도 게스트 토큰 사용)
  @GET('/tests/{testId}/detail')
  Future<ApiResponse<TestDetailResponse>> getTestDetail(
      @Path('testId') int testId,
      @Header('Authorization') String authorization,  // 위치 매개변수로 수정
   );

  // =============================================================
  // 📋 테스트 목록 조회 API들
  // =============================================================

  /// 🔥 인기도 기준 테스트 목록 조회 (페이징)
  ///
  /// 서버 엔드포인트: GET /api/v1/tests/popular-list
  /// 인증: 필수 (비회원도 게스트 토큰 사용)
  @GET('/tests/popular-list')
  Future<ApiResponse<TestsResponse>> getPopularTestsList(
      @Query('page') int page,
      @Query('size') int size,
      @Header('Authorization') String authorization,
      );

  /// 🌟 최신순 테스트 목록 조회 (페이징)
  ///
  /// 서버 엔드포인트: GET /api/v1/tests/latest
  /// 인증: 필수 (비회원도 게스트 토큰 사용)
  @GET('/tests/latest')
  Future<ApiResponse<TestsResponse>> getLatestTests(
      @Query('page') int page,
      @Query('size') int size,
      @Header('Authorization') String authorization,
      );

  /// 🔥 홈 화면용 인기 테스트 TOP 5 조회
  ///
  /// 서버 엔드포인트: GET /api/v1/tests/popular
  /// 인증: 필수 (비회원도 게스트 토큰 사용)
  /// 페이징 없음 (고정 5개)
  @GET('/tests/popular')
  Future<ApiResponse<TestsResponse>> getPopularTests(
      @Header('Authorization') String authorization,
      );

  /// 👁️ 조회수 기준 테스트 목록 조회 (페이징)
  ///
  /// 서버 엔드포인트: GET /api/v1/tests/most-viewed
  /// 인증: 필수 (비회원도 게스트 토큰 사용)
  @GET('/tests/most-viewed')
  Future<ApiResponse<TestsResponse>> getMostViewedTests(
      @Query('page') int page,
      @Query('size') int size,
      @Header('Authorization') String authorization,
      );

  /// 📈 트렌딩 테스트 목록 조회 (7일간 급상승)
  ///
  /// 서버 엔드포인트: GET /api/v1/tests/trending
  /// 인증: 필수 (비회원도 게스트 토큰 사용)
  @GET('/tests/trending')
  Future<ApiResponse<TestsResponse>> getTrendingTests(
      @Query('page') int page,
      @Query('size') int size,
      @Header('Authorization') String authorization,
      );

  /// 🔤 가나다순 테스트 목록 조회 (페이징)
  ///
  /// 서버 엔드포인트: GET /api/v1/tests/alphabetical
  /// 인증: 필수 (비회원도 게스트 토큰 사용)
  @GET('/tests/alphabetical')
  Future<ApiResponse<TestsResponse>> getAlphabeticalTests(
      @Query('page') int page,
      @Query('size') int size,
      @Header('Authorization') String authorization,
      );

  // =============================================================
  // 🔍 개별 테스트 관련 API들 (추후 구현 예정)
  // =============================================================

  /// 🔍 테스트 상세 정보 조회
  ///
  /// 서버 엔드포인트: GET /api/v1/tests/{testId}
  /// 인증: 선택사항
  // @GET('/tests/{testId}')
  // Future<ApiResponse<TestDetailResponse>> getTestDetail(
  //   @Path('testId') int testId, {
  //   @Header('Authorization') String? authorization,
  // });

  /// 📊 테스트 시작 (응답 세션 생성)
  ///
  /// 서버 엔드포인트: POST /api/v1/tests/{testId}/start
  /// 인증: 필수
  // @POST('/tests/{testId}/start')
  // Future<ApiResponse<TestSessionResponse>> startTest(
  //   @Path('testId') int testId,
  //   @Header('Authorization') String authorization,
  // );

  /// 📝 테스트 응답 제출
  ///
  /// 서버 엔드포인트: POST /api/v1/tests/{testId}/submit
  /// 인증: 필수
  // @POST('/tests/{testId}/submit')
  // Future<ApiResponse<TestResultResponse>> submitTest(
  //   @Path('testId') int testId,
  //   @Body() TestSubmissionRequest request,
  //   @Header('Authorization') String authorization,
  // );

  /// 🏆 테스트 결과 조회
  ///
  /// 서버 엔드포인트: GET /api/v1/tests/{testId}/result
  /// 인증: 필수
  // @GET('/tests/{testId}/result')
  // Future<ApiResponse<TestResultResponse>> getTestResult(
  //   @Path('testId') int testId,
  //   @Header('Authorization') String authorization,
  // );

  // =============================================================
  // 🏥 헬스체크 API
  // =============================================================

  /// 🏥 컨트롤러 헬스체크
  ///
  /// 서버 엔드포인트: GET /api/v1/tests/health
  /// 인증: 불필요
  @GET('/tests/health')
  Future<ApiResponse<String>> healthCheck();
}

// =============================================================
// 📝 사용 예시 (주석)
// =============================================================

/*
// Repository에서 사용하는 방법:

class TestRepositoryImpl implements TestRepository {
  final TestApiDataSource _apiDataSource;
  final TokenManager _tokenManager;

  const TestRepositoryImpl(this._apiDataSource, this._tokenManager);

  @override
  Future<Result<TestsResponse>> getPopularTests({int page = 0, int size = 20}) async {
    try {
      // 🎫 토큰 가져오기 (필수 - 비회원도 게스트 토큰 사용)
      final token = await _tokenManager.getValidAccessToken();

      if (token == null) {
        return Result.failure('인증 토큰을 가져올 수 없습니다');
      }

      // 🌐 API 호출
      final response = await _apiDataSource.getPopularTestsList(
        page,
        size,
        token, // 항상 토큰 필요
      );

      // ✅ 성공 시 Result.success 반환
      if (response.isSuccess && response.data != null) {
        return Result.success(response.data!);
      } else {
        return Result.failure(response.errorMessage ?? '테스트 목록 조회 실패');
      }
    } on DioException catch (e) {
      // 🚨 네트워크 에러 처리
      return Result.failure(_handleDioError(e));
    } catch (e) {
      // 🚨 기타 에러 처리
      return Result.failure('예상치 못한 오류: $e');
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return '연결 시간 초과';
      case DioExceptionType.receiveTimeout:
        return '응답 시간 초과';
      case DioExceptionType.badResponse:
        return '서버 오류 (${e.response?.statusCode})';
      default:
        return '네트워크 오류';
    }
  }
}

// Provider에서 등록하는 방법:

@riverpod
TestApiDataSource testApiDataSource(TestApiDataSourceRef ref) {
  final dio = ref.watch(dioProvider);
  return TestApiDataSource(dio);
}
*/