import 'package:dio/dio.dart'; // DioException을 사용하기 위해 import

import '../../../../core/utils/result.dart'; // Result 타입
import '../../domain/entities/auth_user_entity.dart'; // AuthUser 타입 (getCurrentUser 때문)
import '../../domain/repositories/auth_repository.dart'; // 인터페이스 구현
import '../datasources/auth_api_data_source.dart';     // DataSource
import '../models/response/auth_response_dto.dart';  // DTO 타입

/// 🔑 인증 Repository 구현체
///
/// DataSource를 호출하고, 발생할 수 있는 모든 예외를 처리하여
/// 안전한 Result 타입으로 감싸 UseCase에 전달하는 역할을 합니다.
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDataSource _dataSource;
  // 토큰 저장을 위한 로컬 스토리지 (예: flutter_secure_storage)
  // final SecureStorageService _secureStorage;

  // 생성자를 통해 외부 의존성을 주입받습니다 (DI).
  AuthRepositoryImpl(this._dataSource /*, this._secureStorage */);

  @override
  Future<Result<AuthResponse>> loginWithGoogle() {
    return _safeApiCall(() => _dataSource.loginWithGoogle());
  }

  @override
  Future<Result<AuthResponse>> loginWithApple() {
    return _safeApiCall(() => _dataSource.loginWithApple());
  }

  @override
  Future<Result<AuthResponse>> loginAsGuest() {
    return _safeApiCall(() => _dataSource.loginAsGuest());
  }

  /// ✨ [RepositoryImpl의 핵심] API 호출을 안전하게 감싸는 공통 메서드
  Future<Result<T>> _safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      final result = await apiCall();
      return Results.success(result);
    } on DioException catch (e) {
      // Dio 관련 예외를 상세하게 처리
      // 예를 들어, 서버가 401 Unauthorized 에러를 보내면, "인증 정보가 올바르지 않습니다." 라는 메시지를 보낼 수 있음
      final errorMessage = e.response?.data['error_description'] ?? '네트워크 오류가 발생했습니다.';
      return Results.failure(errorMessage, e.response?.statusCode?.toString());
    } catch (e) {
      // Dio 외의 모든 예외 처리
      return Results.failure('알 수 없는 오류가 발생했습니다: $e');
    }
  }

  // --- 나머지 인터페이스 메서드 구현 ---
  @override
  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    // 실제 로컬 스토리지에 저장하는 로직
    // await _secureStorage.write('ACCESS_TOKEN', accessToken);
    // await _secureStorage.write('REFRESH_TOKEN', refreshToken);
    print('Tokens saved!'); // 임시 로그
  }

  // 이 아래부터는 지금 당장 필요 없지만, 인터페이스에 있으므로 구현해야 합니다.
  // 실제 구현은 나중에 필요할 때 채워넣으면 됩니다.
  @override
  Future<void> clearAuthTokens() async {
    print('Tokens cleared!');
  }

  @override
  Future<Result<AuthUser?>> getCurrentUser() async {
    // 로컬에 저장된 사용자 정보가 있는지 확인하는 로직
    return Results.success(null); // 지금은 우선 null 반환
  }

  @override
  Future<bool> isLoggedIn() async {
    // 저장된 토큰이 있는지 확인하는 로직
    return false; // 지금은 우선 false 반환
  }

  @override
  Future<Result<AuthResponse>> refreshToken(String refreshToken) async {
    // 토큰 갱신 API를 호출하는 로직
    return Results.failure('Not implemented');
  }

  @override
  Future<Result<void>> logout({bool logoutFromAllDevices = false}) async {
    // 로그아웃 API를 호출하는 로직
    return Results.success(null);
  }
}