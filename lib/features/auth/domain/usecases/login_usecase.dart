
import '../../../../core/utils/result.dart';
import '../entities/auth_user_entity.dart';

/// 🔑 로그인 Use Case
/// 
/// 비즈니스 로직을 캡슐화한 로그인 처리 클래스
/// - Single Responsibility: 로그인만 담당
/// - Result 패턴으로 안전한 에러 처리
/// - 로깅 및 분석 이벤트 추가
class LoginUseCase {
  static const String _logTag = 'LoginUseCase';
  
  final AuthRepository _authRepository;
  
  const LoginUseCase(this._authRepository);

  /// 📧 이메일로 로그인
  /// 
  /// [email] 사용자 이메일
  /// [password] 사용자 비밀번호
  /// [rememberMe] 로그인 상태 유지 여부
  /// 
  /// Returns: [Result<UserEntity>] 로그인 결과
  Future<Result<AuthUser>> loginWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      // 🔍 입력값 검증
      final validationResult = _validateEmailInput(email, password);
      if (validationResult != null) {
        return validationResult;
      }

      // 📊 로그인 시도 로깅
      _logLoginAttempt('email', email);

      // 🌐 API 호출
      final authResult = await _authRepository.loginWithEmail(
        email: email.trim().toLowerCase(),
        password: password,
        rememberMe: rememberMe,
      );

      return await authResult.when(
        success: (authResponse) async {
          // 💾 토큰 저장
          await _authRepository.saveAuthTokens(
            accessToken: authResponse.accessToken,
            refreshToken: authResponse.refreshToken,
          );

          // 👤 사용자 엔티티 변환
          final user = _convertDtoToAuthUser(authResponse.user);
          
          _logLoginSuccess('email', user.id);
          return Results.success(user);
        },
        failure: (message, code) {
          _logLoginFailure('email', message, code);
          return Results.failure<AuthUser>(message, code);
        },
        loading: () => Results.loading<AuthUser>(),
      );

    } catch (e) {
      _logLoginFailure('email', e.toString(), 'UNEXPECTED_ERROR');
      return Results.failure('로그인 중 예상치 못한 오류가 발생했습니다: ${e.toString()}');
    }
  }

  /// 🌐 Google로 로그인
  Future<Result<AuthUser>> loginWithGoogle() async {
    try {
      _logLoginAttempt('google', null);

      final authResult = await _authRepository.loginWithGoogle();

      return await authResult.when(
        success: (authResponse) async {
          await _authRepository.saveAuthTokens(
            accessToken: authResponse.accessToken,
            refreshToken: authResponse.refreshToken,
          );

          final user = _convertDtoToAuthUser(authResponse.user);
          _logLoginSuccess('google', user.id);
          return Results.success(user);
        },
        failure: (message, code) {
          _logLoginFailure('google', message, code);
          return Results.failure<AuthUser>(message, code);
        },
        loading: () => Results.loading<AuthUser>(),
      );

    } catch (e) {
      _logLoginFailure('google', e.toString(), 'UNEXPECTED_ERROR');
      return Results.failure('Google 로그인 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  /// 🍎 Apple로 로그인
  Future<Result<AuthUser>> loginWithApple() async {
    try {
      _logLoginAttempt('apple', null);

      final authResult = await _authRepository.loginWithApple();

      return await authResult.when(
        success: (authResponse) async {
          await _authRepository.saveAuthTokens(
            accessToken: authResponse.accessToken,
            refreshToken: authResponse.refreshToken,
          );

          final user = _convertDtoToAuthUser(authResponse.user);
          _logLoginSuccess('apple', user.id);
          return Results.success(user);
        },
        failure: (message, code) {
          _logLoginFailure('apple', message, code);
          return Results.failure<AuthUser>(message, code);
        },
        loading: () => Results.loading<AuthUser>(),
      );

    } catch (e) {
      _logLoginFailure('apple', e.toString(), 'UNEXPECTED_ERROR');
      return Results.failure('Apple 로그인 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  /// 👥 게스트로 로그인
  Future<Result<AuthUser>> loginAsGuest() async {
    try {
      _logLoginAttempt('guest', null);

      final authResult = await _authRepository.loginAsGuest();

      return await authResult.when(
        success: (authResponse) async {
          await _authRepository.saveAuthTokens(
            accessToken: authResponse.accessToken,
            refreshToken: authResponse.refreshToken,
          );

          final user = _convertDtoToAuthUser(authResponse.user);
          _logLoginSuccess('guest', user.id);
          return Results.success(user);
        },
        failure: (message, code) {
          _logLoginFailure('guest', message, code);
          return Results.failure<AuthUser>(message, code);
        },
        loading: () => Results.loading<AuthUser>(),
      );

    } catch (e) {
      _logLoginFailure('guest', e.toString(), 'UNEXPECTED_ERROR');
      return Results.failure('게스트 로그인 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  /// 🔍 이메일 입력값 검증
  Result<AuthUser>? _validateEmailInput(String email, String password) {
    if (email.trim().isEmpty) {
      return Results.failure('이메일을 입력해주세요', 'VALIDATION_EMAIL_EMPTY');
    }

    if (!_isValidEmail(email.trim())) {
      return Results.failure('올바른 이메일 형식이 아닙니다', 'VALIDATION_EMAIL_INVALID');
    }

    if (password.isEmpty) {
      return Results.failure('비밀번호를 입력해주세요', 'VALIDATION_PASSWORD_EMPTY');
    }

    if (password.length < 6) {
      return Results.failure('비밀번호는 6자 이상이어야 합니다', 'VALIDATION_PASSWORD_TOO_SHORT');
    }

    return null; // 검증 통과
  }

  /// 📧 이메일 형식 검증
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// 🔄 DTO를 Entity로 변환
  /// 🔄 DTO를 AuthUser로 변환
  AuthUser _convertDtoToAuthUser(UserResponse dto) {
    return AuthUser(
      id: dto.id,
      email: dto.email,
      nickname: dto.displayName,              // displayName → nickname
      profileImageUrl: dto.profileImageUrl,
      authProvider: _parseAuthProvider(dto.authProvider),
      isEmailVerified: dto.isEmailVerified,
      isProfileComplete: dto.isProfileComplete,
      // lastLoginAt, createdAt 제거 (AuthUser에 없음)
    );
  }

  /// 🔗 AuthProvider 파싱
  AuthProvider _parseAuthProvider(String provider) {
    switch (provider.toLowerCase()) {
      case 'email':
        return AuthProvider.email;
      case 'google':
        return AuthProvider.google;
      case 'apple':
        return AuthProvider.apple;
      case 'anonymous':
        return AuthProvider.anonymous;
      default:
        return AuthProvider.email;
    }
  }

  /// 📊 로그인 시도 로깅
  void _logLoginAttempt(String provider, String? email) {
    // TODO: Logger 구현 후 활성화
    // Logger.i(_logTag, 'Login attempt with $provider${email != null ? ' for $email' : ''}');
    
    // TODO: Analytics 이벤트 전송
    // Analytics.track('login_attempt', {
    //   'provider': provider,
    //   'timestamp': DateTime.now().toIso8601String(),
    // });
  }

  /// ✅ 로그인 성공 로깅
  void _logLoginSuccess(String provider, String userId) {
    // TODO: Logger 구현 후 활성화
    // Logger.i(_logTag, 'Login successful with $provider for user $userId');
    
    // TODO: Analytics 이벤트 전송
    // Analytics.track('login_success', {
    //   'provider': provider,
    //   'user_id': userId,
    //   'timestamp': DateTime.now().toIso8601String(),
    // });
  }

  /// ❌ 로그인 실패 로깅
  void _logLoginFailure(String provider, String message, String? code) {
    // TODO: Logger 구현 후 활성화
    // Logger.e(_logTag, 'Login failed with $provider: $message (code: $code)');
    
    // TODO: Analytics 이벤트 전송
    // Analytics.track('login_failure', {
    //   'provider': provider,
    //   'error_message': message,
    //   'error_code': code,
    //   'timestamp': DateTime.now().toIso8601String(),
    // });
  }
}
