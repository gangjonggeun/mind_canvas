import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/auth/token_manager.dart';
import '../../../../core/auth/token_manager_provider.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/TaroResultEntity.dart';

import '../../domain/repositories/taro_repository.dart';
import '../datasources/taro_api_data_source.dart';
import '../dto/request/submit_taro_request.dart';
import '../dto/response/taro_result_response.dart';

part 'taro_repository_impl.g.dart'; // build_runner 생성 파일

// =============================================================
// 🧩 Riverpod Provider
// =============================================================

@riverpod
TaroRepository taroRepository(TaroRepositoryRef ref) {
  final taroApiDataSource = ref.watch(taroApiDataSourceProvider);
  final tokenManager = ref.watch(tokenManagerProvider);

  return TaroRepositoryImpl(
    taroApiDataSource: taroApiDataSource,
    tokenManager: tokenManager,
  );
}

// =============================================================
// 🏭 Repository Implementation
// =============================================================

class TaroRepositoryImpl implements TaroRepository {
  final TaroApiDataSource _taroApiDataSource;
  final TokenManager _tokenManager;

  const TaroRepositoryImpl({
    required TaroApiDataSource taroApiDataSource,
    required TokenManager tokenManager,
  }) : _taroApiDataSource = taroApiDataSource,
       _tokenManager = tokenManager;

  @override
  Future<Result<TaroResultEntity>> getTarotResultDetail(int resultId) async {
    try {
      final token = await _tokenManager.getValidAccessToken();
      if (token == null) return Result.failure('인증 필요', 'AUTH_REQUIRED');

      // ✅ 서버 API: GET /api/v1/taro/results/{resultId}
      final apiResponse = await _taroApiDataSource.getTarotResult(resultId, token);

      if (apiResponse.success && apiResponse.data != null) {
        return Result.success(apiResponse.data!.toEntity());
      }
      return Result.failure('결과를 찾을 수 없습니다.');
    } catch (e) {
      return Result.failure('데이터 로드 실패: $e');
    }
  }


  @override
  Future<Result<TaroResultEntity>> analyzeTaro(
    SubmitTaroRequest request,
  ) async {
    try {
      // 1. 유효한 토큰 확인 (예시 코드와 동일 로직)
      final validToken = await _tokenManager.getValidAccessToken();

      if (validToken == null) {
        // print('인증이 필요합니다 - 로그인 페이지로 이동 필요'); // 필요 시 주석 해제
        return Result.failure('인증이 필요합니다', 'AUTHENTICATION_REQUIRED');
      }

      // 2. API 호출

      final apiResponse = await _taroApiDataSource.analyzeTaro(
        request,
        validToken,
      );

      // 3. ApiResponse를 Result로 변환 (예시 코드와 동일 구조)
      if (apiResponse.success) {
        // ✅ 서버 응답이 성공인데 데이터가 null이면 "PENDING" 엔티티를 수동 생성해서 반환해야 함
        final entity = apiResponse.data?.toEntity() ?? TaroResultEntity(
          id: "PENDING", // 👈 이게 있어야 리스너가 감지함
          overallInterpretation: "",
          cardInterpretations: [],
          theme: "",
          date: DateTime.now(), spreadName: '',
        );

        return Result.success(entity);
      }else {
        final errorMessage =
            apiResponse.error?.message ??
            apiResponse.message ??
            '타로 상담 결과를 받아오지 못했습니다';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';

        // print('❌ 타로 분석 실패 - $errorMessage'); // 필요 시 주석 해제
        return Result.failure(errorMessage, errorCode);
      }
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      // print('예상치 못한 오류 발생: $e'); // 필요 시 주석 해제
      return Result.failure('알 수 없는 오류가 발생했습니다: $e', 'UNKNOWN_ERROR');
    }
  }



  /// 🔧 DioException 핸들링 (공통 로직)
  Result<TaroResultEntity> _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Result.failure(
          '서버 연결 시간이 초과되었습니다. 네트워크 상태를 확인해주세요 (Server connection timed out. Please check your network status)',
          'TIMEOUT_ERROR',
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final errorMsg = e.response?.data['message'] ?? '서버 오류가 발생했습니다';

        switch (statusCode) {
          case 400:
            return Result.failure(errorMsg, 'BAD_REQUEST');
          case 401:
            return Result.failure(
              '인증이 만료되었습니다. 다시 로그인해주세요 (Authentication expired. Please log in again)',
              'AUTHENTICATION_EXPIRED',
            );
          case 403:
            return Result.failure('접근 권한이 없습니다 (Access denied)', 'ACCESS_DENIED');
          case 429:
            return Result.failure(
              '잠시 후 다시 시도해주세요 (요청 과다)  (Internal server error. Please try again later)',
              'TOO_MANY_REQUESTS',
            );
          case 500:
            return Result.failure(
              '서버 내부 오류가 발생했습니다. 잠시 후 다시 시도해주세요 (A server error occurred)',
              'SERVER_ERROR',
            );
          default:
            return Result.failure(errorMsg, 'HTTP_ERROR_$statusCode');
        }

      case DioExceptionType.connectionError:
        return Result.failure('인터넷 연결을 확인해주세요 (Please check your internet connection)', 'NETWORK_DISCONNECTED');

      default:
        return Result.failure('네트워크 오류가 발생했습니다 (A network error occurred)', 'NETWORK_ERROR');
    }
  }
}
