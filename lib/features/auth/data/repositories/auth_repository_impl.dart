import 'package:dio/dio.dart';
import '../../../../core/auth/token_manager.dart';
import '../../../../core/utils/result.dart';

import '../../../../core/network/api_response_dto.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_data_source.dart';
import '../models/request/auth_request_dto.dart';
import '../models/response/auth_response_dto.dart';

/// 🔑 인증 Repository 구현체 (업데이트)
///
/// 새로운 구조에 맞춰 수정:
/// - ApiResponse<T> 래핑 처리
/// - TokenManager 연동
/// - AuthStorage 연동
/// - 서버 API 구조와 매칭
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDataSource _dataSource;
  final TokenManager _tokenManager;

  AuthRepositoryImpl(this._dataSource, this._tokenManager);

  // =============================================================
  // 🔐 로그인 메서드들
  // =============================================================

  @override
  Future<Result<AuthResponse>> loginWithGoogle(String idToken, {
    String? deviceId,
    String? fcmToken,
  }) async {
    return _safeApiCall(() async {
      final request = GoogleLoginRequest(
        idToken: idToken,
        deviceId: deviceId,
        fcmToken: fcmToken,
      );

      // API 호출 - ApiResponse<AuthResponse> 반환
      final apiResponse = await _dataSource.loginWithGoogle(request);

      // ApiResponse 성공 체크
      if (apiResponse.isSuccess && apiResponse.hasData) {
        final authResponse = apiResponse.data!;

        // TokenManager에 저장
        await _tokenManager.saveAuthResponse(authResponse);

        return authResponse;
      } else {
        // 서버에서 실패 응답
        final errorMessage = apiResponse.errorMessage ?? 'Google 로그인에 실패했습니다';
        throw DioException(
          requestOptions: RequestOptions(path: '/auth/google'),
          response: Response(
            requestOptions: RequestOptions(path: '/auth/google'),
            statusCode: 400,
            data: {'error_description': errorMessage},
          ),
        );
      }
    });
  }

  @override
  Future<Result<AuthResponse>> refreshToken() async {
    return _safeApiCall(() async {
      // 현재 저장된 refresh token 가져오기
      final refreshAuthHeader = _tokenManager.refreshAuthorizationHeader;
      if (refreshAuthHeader == null) {
        throw Exception('Refresh Token이 없습니다');
      }

      // API 호출
      final apiResponse = await _dataSource.refreshToken(refreshAuthHeader);

      if (apiResponse.isSuccess && apiResponse.hasData) {
        final authResponse = apiResponse.data!;

        // 새로운 토큰으로 업데이트
        await _tokenManager.saveAuthResponse(authResponse);

        return authResponse;
      } else {
        final errorMessage = apiResponse.errorMessage ?? '토큰 갱신에 실패했습니다';
        throw Exception(errorMessage);
      }
    });
  }

  @override
  Future<Result<void>> logout({bool logoutFromAllDevices = false}) async {
    return _safeApiCall(() async {
      try {
        // 서버에 로그아웃 요청
        final authHeader = _tokenManager.authorizationHeader;
        if (authHeader != null) {
          final apiResponse = await _dataSource.logout(authHeader);

          if (!apiResponse.isSuccess) {
            print('⚠️ 서버 로그아웃 실패: ${apiResponse.errorMessage}');
            // 서버 로그아웃 실패해도 로컬 토큰은 삭제
          }
        }
      } catch (e) {
        print('⚠️ 서버 로그아웃 요청 실패: $e');
        // 네트워크 오류 등으로 실패해도 로컬 토큰은 삭제
      }

      // 로컬 토큰 삭제 (항상 실행)
      await _tokenManager.clearTokens();
    });
  }

  // =============================================================
  // 🔍 상태 확인 메서드들
  // =============================================================

  @override
  Future<bool> isLoggedIn() async {
    return _tokenManager.isLoggedIn;
  }

  @override
  Future<Result<AuthUser?>> getCurrentUser() async {
    return _safeApiCall(() async {
      // 로그인 상태 확인
      if (!_tokenManager.isLoggedIn) {
        return null;
      }

      // 서버에서 사용자 정보 조회
      final authHeader = await _tokenManager.getValidAccessToken();
      if (authHeader == null) {
        return null;
      }

      final apiResponse = await _dataSource.getCurrentUser(authHeader);

      if (apiResponse.isSuccess && apiResponse.hasData) {
        // TODO: Object를 AuthUser로 변환하는 로직 필요
        final userData = apiResponse.data;

        // 임시로 null 반환
        return null;
      } else {
        return null;
      }
    });
  }

  @override
  Future<Result<int?>> validateToken() async {
    return _safeApiCall(() async {
      final authHeader = _tokenManager.authorizationHeader;
      if (authHeader == null) {
        return null;
      }

      final apiResponse = await _dataSource.validateToken(authHeader);

      if (apiResponse.isSuccess && apiResponse.hasData) {
        return apiResponse.data!;  // 사용자 ID
      } else {
        return null;
      }
    });
  }

  // =============================================================
  // 🔧 토큰 관리 메서드들
  // =============================================================

  @override
  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    // TokenManager를 통해 저장
    final authResponse = AuthResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    await _tokenManager.saveAuthResponse(authResponse);
  }

  @override
  Future<void> clearAuthTokens() async {
    await _tokenManager.clearTokens();
  }

  @override
  Future<String?> getAccessToken() async {
    return await _tokenManager.getValidAccessToken();
  }

  @override
  Future<bool> isTokenExpired() async {
    return _tokenManager.isTokenExpired;
  }

  // =============================================================
  // 🚨 미구현 메서드들 (TODO)
  // =============================================================

  // Repository에서 미구현 API 처리
  @override
  Future<Result<AuthResponse>> loginWithApple() async {
    return Results.failure('Apple 로그인은 아직 구현되지 않았습니다', 'NOT_IMPLEMENTED');
  }

  @override
  Future<Result<AuthResponse>> loginAsGuest() async {
    return Results.failure('게스트 로그인은 아직 구현되지 않았습니다', 'NOT_IMPLEMENTED');
  }

  // =============================================================
  // 🛡️ 안전한 API 호출 래퍼
  // =============================================================

  /// API 호출을 안전하게 감싸는 공통 메서드 (업데이트)
  Future<Result<T>> _safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      final result = await apiCall();
      return Results.success(result);
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return Results.failure('알 수 없는 오류가 발생했습니다: $e');
    }
  }

  /// DioException 상세 처리
  Result<T> _handleDioException<T>(DioException e) {
    // 서버에서 ApiResponse 형태로 에러를 보낸 경우
    if (e.response?.data is Map<String, dynamic>) {
      final responseData = e.response!.data as Map<String, dynamic>;

      // ApiResponse 형태의 에러
      if (responseData.containsKey('error')) {
        final error = responseData['error'] as Map<String, dynamic>?;
        final errorMessage = error?['message'] ?? responseData['message'] ?? '서버 오류가 발생했습니다';
        final errorCode = error?['code'] ?? e.response?.statusCode?.toString();

        return Results.failure(errorMessage, errorCode);
      }
    }

    // 기본 HTTP 상태 코드별 처리
    switch (e.response?.statusCode) {
      case 401:
        return Results.failure('인증이 필요합니다', '401');
      case 403:
        return Results.failure('접근 권한이 없습니다', '403');
      case 404:
        return Results.failure('요청한 리소스를 찾을 수 없습니다', '404');
      case 500:
        return Results.failure('서버 내부 오류가 발생했습니다', '500');
      default:
        final errorMessage = e.message ?? '네트워크 오류가 발생했습니다';
        return Results.failure(errorMessage, e.response?.statusCode?.toString());
    }
  }
}