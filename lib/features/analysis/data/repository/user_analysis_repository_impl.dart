import 'package:dio/dio.dart';
import '../../../../core/auth/token_manager.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repository/user_analysis_repository.dart';
import '../data_source/user_analysis_data_source.dart';
import '../dto/psychological_profile_response.dart';

class UserAnalysisRepositoryImpl implements UserAnalysisRepository {
  final UserAnalysisDataSource _dataSource;
  final TokenManager _tokenManager;

  UserAnalysisRepositoryImpl(this._dataSource, this._tokenManager);

  @override
  Future<Result<PsychologicalProfileResponse>> getMyProfile() async {
    try {
      // 1. 유효한 토큰 확인
      final validToken = await _tokenManager.getValidAccessToken();

      if (validToken == null) {
        // 토큰이 없거나 만료되어 갱신 실패 시
        return Result.failure('로그인이 필요한 서비스입니다.', 'AUTHENTICATION_REQUIRED');
      }

      // 2. API 호출 ('Bearer ' 접두어는 DataSource나 여기서 처리, 보통 여기서 붙여주는 것이 명확함)
      // 만약 DataSource의 @Header에 이미 포함된 로직이 없다면 'Bearer $validToken'으로 보냅니다.
      final apiResponse = await _dataSource.getMyPsychologicalProfile('Bearer $validToken');

      // 3. 응답 처리
      if (apiResponse.success && apiResponse.data != null) {
        // 성공 시 DTO 반환
        return Result.success(apiResponse.data!);
      } else {
        // 서버 비즈니스 로직 에러 (예: success=false)
        final errorMessage = apiResponse.message ?? '프로필 정보를 불러오지 못했습니다.';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';

        return Result.failure(errorMessage, errorCode);
      }

    } on DioException catch (e) {
      // 4. Dio 에러 핸들링 (네트워크 및 HTTP 상태 코드 에러)
      return _handleDioException(e);

    } catch (e) {
      // 5. 그 외 예상치 못한 에러
      return Result.failure('알 수 없는 오류가 발생했습니다.', 'UNKNOWN_ERROR');
    }
  }

  /// DioException을 처리하여 Result.failure로 변환하는 내부 로직
  /// (함수 분리가 필요 없다 하셨지만, 가독성을 위해 switch문만 내부에 둡니다.
  /// 원하시면 try-catch 안에 그대로 넣으셔도 됩니다.)
  Result<PsychologicalProfileResponse> _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return Result.failure('서버 연결 시간이 초과되었습니다. 네트워크를 확인해주세요.', 'TIMEOUT');
    }

    if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;

      switch (statusCode) {
        case 401:
          return Result.failure('인증이 만료되었습니다. 다시 로그인해주세요.', 'AUTHENTICATION_EXPIRED');
        case 403:
          return Result.failure('접근 권한이 없습니다.', 'FORBIDDEN');
        case 404:
          return Result.failure('사용자 정보를 찾을 수 없습니다.', 'USER_NOT_FOUND');
        case 500:
          return Result.failure('서버 내부 오류가 발생했습니다. 잠시 후 다시 시도해주세요.', 'SERVER_ERROR');
        default:
          return Result.failure('서버 통신 중 오류가 발생했습니다. ($statusCode)', 'HTTP_ERROR');
      }
    }

    if (e.error.toString().contains('SocketException')) {
      return Result.failure('인터넷 연결을 확인해주세요.', 'NETWORK_DISCONNECTED');
    }

    return Result.failure('네트워크 오류가 발생했습니다.', 'NETWORK_ERROR');
  }
}