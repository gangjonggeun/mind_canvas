import 'package:mind_canvas/features/auth/domain/enums/login_type.dart';

import '../../../../core/utils/result.dart';
import '../../data/models/response/auth_response_dto.dart';
import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';
/// 🔑 인증 UseCase (업데이트된 버전)
///
/// Repository와 UI 사이의 비즈니스 로직을 담당합니다.
/// - 새로운 Repository 인터페이스에 맞춤
/// - AuthResponse에서 User 정보 분리 처리
/// - 간소화된 로그인 플로우
class AuthUseCase {
  final AuthRepository _authRepository;

  const AuthUseCase(this._authRepository);

  // =============================================================
  // 🔐 로그인 메서드들
  // =============================================================

  /// 🌐 Google 로그인
  Future<Result<AuthResponse>> loginWithGoogle({
    required String idToken,
    String? deviceId,
    String? fcmToken,
  }) async {
    try {
      _logLoginAttempt(LoginType.google);

      // Repository에서 Google 로그인 처리
      final result = await _authRepository.loginWithGoogle(
        idToken,
        deviceId: deviceId,
        fcmToken: fcmToken,
      );

      return result.fold(
        onSuccess: (authResponse) {
          _logLoginSuccess(LoginType.google, 'unknown'); // 사용자 ID는 별도 API에서
          return Results.success(authResponse);
        },
        onFailure: (message, code) {
          _logLoginFailure(LoginType.google, message, code);
          return Results.failure<AuthResponse>(message, code);
        },
      );
    } catch (e) {
      _logLoginFailure(LoginType.google, e.toString(), 'UNEXPECTED_ERROR');
      return Results.failure('Google 로그인 중 오류가 발생했습니다.');
    }
  }

  /// 🍎 Apple 로그인 (미구현)
  Future<Result<AuthResponse>> loginWithApple() async {
    try {
      _logLoginAttempt(LoginType.apple);

      final result = await _authRepository.loginWithApple();

      return result.fold(
        onSuccess: (authResponse) {
          _logLoginSuccess(LoginType.apple, 'unknown');
          return Results.success(authResponse);
        },
        onFailure: (message, code) {
          _logLoginFailure(LoginType.apple, message, code);
          return Results.failure<AuthResponse>(message, code);
        },
      );
    } catch (e) {
      _logLoginFailure(LoginType.apple, e.toString(), 'UNEXPECTED_ERROR');
      return Results.failure('Apple 로그인 중 오류가 발생했습니다.');
    }
  }

  /// 👥 게스트 로그인 (미구현)
  Future<Result<AuthResponse>> loginAsGuest() async {
    try {
      _logLoginAttempt(LoginType.guest);

      final result = await _authRepository.loginAsGuest();

      return result.fold(
        onSuccess: (authResponse) {
          _logLoginSuccess(LoginType.guest, 'guest');
          return Results.success(authResponse);
        },
        onFailure: (message, code) {
          _logLoginFailure(LoginType.guest, message, code);
          return Results.failure<AuthResponse>(message, code);
        },
      );
    } catch (e) {
      _logLoginFailure(LoginType.guest, e.toString(), 'UNEXPECTED_ERROR');
      return Results.failure('게스트 로그인 중 오류가 발생했습니다.');
    }
  }

  // =============================================================
  // 👤 사용자 정보 관련
  // =============================================================

  /// 👤 현재 사용자 정보 조회 (별도 API)
  Future<Result<AuthUser?>> getCurrentUser() async {
    try {
      final result = await _authRepository.getCurrentUser();

      return result.fold(
        onSuccess: (authUser) => Results.success(authUser),
        onFailure: (message, code) => Results.failure<AuthUser?>(message, code),
      );
    } catch (e) {
      return Results.failure('사용자 정보 조회 중 오류가 발생했습니다.');
    }
  }

  /// 🔍 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    return await _authRepository.isLoggedIn();
  }

  /// ⏰ 토큰 만료 확인
  Future<bool> isTokenExpired() async {
    return await _authRepository.isTokenExpired();
  }

  // =============================================================
  // 🔄 토큰 관리
  // =============================================================

  /// 🔄 토큰 갱신
  Future<Result<AuthResponse>> refreshToken() async {
    try {
      final result = await _authRepository.refreshToken();

      return result.fold(
        onSuccess: (authResponse) {
          print('✅ 토큰 갱신 성공');
          return Results.success(authResponse);
        },
        onFailure: (message, code) {
          print('❌ 토큰 갱신 실패: $message');
          return Results.failure<AuthResponse>(message, code);
        },
      );
    } catch (e) {
      return Results.failure('토큰 갱신 중 오류가 발생했습니다.');
    }
  }

  /// 🔍 토큰 유효성 검증
  Future<Result<int?>> validateToken() async {
    try {
      final result = await _authRepository.validateToken();

      return result.fold(
        onSuccess: (userId) => Results.success(userId),
        onFailure: (message, code) => Results.failure<int?>(message, code),
      );
    } catch (e) {
      return Results.failure('토큰 검증 중 오류가 발생했습니다.');
    }
  }

  // =============================================================
  // 🚪 로그아웃
  // =============================================================

  /// 🚪 로그아웃
  Future<Result<void>> logout({bool logoutFromAllDevices = false}) async {
    try {
      final result = await _authRepository.logout(
        logoutFromAllDevices: logoutFromAllDevices,
      );

      return result.fold(
        onSuccess: (_) {
          print('✅ 로그아웃 완료');
          return Results.success(null);
        },
        onFailure: (message, code) {
          print('❌ 로그아웃 실패: $message');
          return Results.failure<void>(message, code);
        },
      );
    } catch (e) {
      return Results.failure('로그아웃 중 오류가 발생했습니다.');
    }
  }

  // =============================================================
  // 🧪 편의 메서드들
  // =============================================================
  /// 🔐 완전한 로그인 플로우 (로그인 + 사용자 정보 조회)
  Future<Result<AuthUser?>> completeLoginFlow({
    required String idToken,
    String? deviceId,
    String? fcmToken,
  }) async {
    // 1단계: Google 로그인
    final loginResult = await loginWithGoogle(
      idToken: idToken,
      deviceId: deviceId,
      fcmToken: fcmToken,
    );

    // ✅ fold 사용으로 변경
    return loginResult.fold(
      onSuccess: (authResponse) async {
        // 2단계: 사용자 정보 조회 (선택적)
        final userResult = await getCurrentUser();
        return userResult.fold(
          onSuccess: (user) => Results.success(user),
          onFailure: (_, __) => Results.success(null), // 실패해도 로그인은 성공으로 처리
        );
      },
      onFailure: (message, code) {
        return Results.failure<AuthUser?>(message, code);
      },
    );
  }

  /// 🎫 유효한 Access Token 반환
  Future<String?> getValidAccessToken() async {
    return await _authRepository.getAccessToken();
  }

  // =============================================================
  // 📝 로깅 메서드들
  // =============================================================

  void _logLoginAttempt(LoginType provider) {
    print('🔐 ${provider.name} 로그인 시도');
  }

  void _logLoginSuccess(LoginType provider, String userId) {
    print('✅ ${provider.name} 로그인 성공 - 사용자: $userId');
  }

  void _logLoginFailure(LoginType provider, String message, String? code) {
    print('❌ ${provider.name} 로그인 실패 - $message (코드: $code)');
  }
}

// =============================================================
// 📦 AuthProvider Enum (필요시 추가)
// =============================================================
