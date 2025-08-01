import '../../../../core/utils/result.dart';
import '../../data/models/response/auth_response_dto.dart'; // DTO 사용
import '../entities/auth_user_entity.dart'; // Entity 사용
import '../repositories/auth_repository.dart';



class AuthUseCase {
  final AuthRepository _authRepository;

  const AuthUseCase(this._authRepository);

  Future<Result<AuthUser>> loginWithGoogle() {
    return _executeLogin(
      provider: AuthProvider.google,
      loginFuture: _authRepository.loginWithGoogle(),
    );
  }

  Future<Result<AuthUser>> loginWithApple() {
    return _executeLogin(
      provider: AuthProvider.apple,
      loginFuture: _authRepository.loginWithApple(),
    );
  }

  Future<Result<AuthUser>> loginAsGuest() {
    return _executeLogin(
      provider: AuthProvider.anonymous,
      loginFuture: _authRepository.loginAsGuest(),
    );
  }

  Future<Result<AuthUser>> _executeLogin({
    required AuthProvider provider,
    required Future<Result<AuthResponse>> loginFuture,
  }) async {
    try {
      _logLoginAttempt(provider);

      final result = await loginFuture;

      return await result.when(
        success: (authResponse) async {
          // 1. 토큰 저장
          await _authRepository.saveAuthTokens(
            accessToken: authResponse.accessToken,
            refreshToken: authResponse.refreshToken,
          );

          // 2. DTO -> Entity 변환 (사장님 코드로 작업된 부분)
          final userEntity = _convertDtoToAuthUser(authResponse.user);

          _logLoginSuccess(provider, userEntity.id);
          return Results.success(userEntity);
        },
        failure: (message, code) {
          _logLoginFailure(provider, message, code);
          return Results.failure<AuthUser>(message, code);
        },
        loading: () => Results.loading<AuthUser>(),
      );
    } catch (e) {
      _logLoginFailure(provider, e.toString(), 'UNEXPECTED_ERROR');
      return Results.failure('${provider.name} 로그인 중 오류가 발생했습니다.');
    }
  }

  /// ✨ [핵심] DTO를 사장님의 AuthUser 엔티티로 변환하는 메서드
  AuthUser _convertDtoToAuthUser(UserResponse userDto) {
    return AuthUser(
      id: userDto.id,
      email: userDto.email,
      nickname: userDto.displayName, // DTO의 displayName을 Entity의 nickname으로 매핑
      profileImageUrl: userDto.profileImageUrl,
      authProvider: _parseAuthProvider(userDto.authProvider), // 문자열을 Enum으로 변환
      isEmailVerified: userDto.isEmailVerified,
      isProfileComplete: userDto.isProfileComplete,
    );
  }

  /// 헬퍼: 서버에서 받은 문자열을 AuthProvider Enum으로 변환
  AuthProvider _parseAuthProvider(String providerString) {
    switch (providerString.toLowerCase()) {
      case 'google':
        return AuthProvider.google;
      case 'apple':
        return AuthProvider.apple;
      case 'email':
        return AuthProvider.email;
      case 'anonymous':
      default:
        return AuthProvider.anonymous;
    }
  }

  // 로깅 메서드 ...
  void _logLoginAttempt(AuthProvider provider) {/* ... */}
  void _logLoginSuccess(AuthProvider provider, String userId) {/* ... */}
  void _logLoginFailure(AuthProvider provider, String message, String? code) {/* ... */}
}