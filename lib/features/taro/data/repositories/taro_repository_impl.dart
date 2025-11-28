
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/auth/token_manager.dart';
import '../../../../core/auth/token_manager_provider.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/TaroResultEntity.dart';

import '../../domain/repositories/taro_repository.dart';
import '../datasources/taro_api_data_source.dart';
import '../dto/request/submit_taro_request.dart';

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
  })  : _taroApiDataSource = taroApiDataSource,
        _tokenManager = tokenManager;

  @override
  Future<Result<TaroResultEntity>> analyzeTaro(
      SubmitTaroRequest request,
      ) async {
    try {
      // 1️⃣ 토큰 가져오기 (필수)
      final token = await _tokenManager.getValidAccessToken();
      if (token == null) {
        return Result.failure(
          '로그인이 필요합니다',
          'AUTHENTICATION_REQUIRED',
        );
      }

      // 2️⃣ API 호출
      final apiResponse = await _taroApiDataSource.analyzeTaro(request, token);

      // 3️⃣ 응답 처리
      if (apiResponse.success && apiResponse.data != null) {
        // DTO -> Entity 변환
        final entity = apiResponse.data!.toEntity();

        return Result.success(
          entity,
          apiResponse.message ?? '타로 상담이 완료되었습니다',
        );
      } else {
        return Result.failure(
          apiResponse.message ?? '타로 상담 결과를 받아오지 못했습니다',
          apiResponse.error?.code ?? 'UNKNOWN_ERROR',
        );
      }
    } on DioException catch (e) {
      // 4️⃣ 네트워크 오류 처리
      return _handleDioException(e);
    } catch (e) {
      // 5️⃣ 예상치 못한 오류
      return Result.failure(
        '알 수 없는 오류가 발생했습니다: $e',
        'UNKNOWN_ERROR',
      );
    }
  }

  /// 🔧 DioException 핸들링 (공통 로직)
  Result<TaroResultEntity> _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Result.failure(
          '서버 연결 시간이 초과되었습니다. 네트워크 상태를 확인해주세요',
          'TIMEOUT_ERROR',
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final errorMsg = e.response?.data['message'] ?? '서버 오류가 발생했습니다';

        switch (statusCode) {
          case 400:
            return Result.failure(errorMsg, 'BAD_REQUEST');
          case 401:
            return Result.failure('인증이 만료되었습니다. 다시 로그인해주세요', 'AUTHENTICATION_EXPIRED');
          case 403:
            return Result.failure('접근 권한이 없습니다', 'ACCESS_DENIED');
          case 429:
            return Result.failure('잠시 후 다시 시도해주세요 (요청 과다)', 'TOO_MANY_REQUESTS');
          case 500:
            return Result.failure('서버 내부 오류가 발생했습니다. 잠시 후 다시 시도해주세요', 'SERVER_ERROR');
          default:
            return Result.failure(errorMsg, 'HTTP_ERROR_$statusCode');
        }

      case DioExceptionType.connectionError:
        return Result.failure(
          '인터넷 연결을 확인해주세요',
          'NETWORK_DISCONNECTED',
        );

      default:
        return Result.failure(
          '네트워크 오류가 발생했습니다',
          'NETWORK_ERROR',
        );
    }
  }
}