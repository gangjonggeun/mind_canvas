import '../../features/auth/data/models/response/auth_response_dto.dart';
import 'auth_storage.dart';

/// 🎯 토큰 관리자 - 토큰 관련 모든 비즈니스 로직 담당
///
/// 메모리 최적화 및 보안 강화:
/// - 액세스/리프레시 토큰 분리 관리
/// - 자동 토큰 갱신
/// - 메모리 누수 방지
class TokenManager {
  AuthResponse? _currentAuth;
  DateTime? _tokenIssuedAt;  // 토큰 발급 시간 기록

  // =============================================================
  // 🏗️ 초기화 및 복원
  // =============================================================

  /// 앱 시작 시 저장된 토큰 복원
  Future<void> initFromStorage() async {
    try {
      final authData = await AuthStorage.loadCompleteAuthData();
      if (authData != null) {
        _currentAuth = authData;
        _tokenIssuedAt = authData.issuedAt ?? DateTime.now();
        print('✅ 저장된 토큰 복원 완료: ${authData.toSafeString}');
      } else {
        print('ℹ️ 저장된 토큰 없음');
      }
    } catch (e) {
      print('❌ 토큰 복원 실패: $e');
      await _handleTokenError();
    }
  }

  /// 새로운 인증 정보 저장
  Future<void> saveAuthResponse(AuthResponse authResponse) async {
    try {
      final now = DateTime.now();

      // 발급 시간을 포함한 AuthResponse 생성
      _currentAuth = authResponse.copyWith(issuedAt: now);
      _tokenIssuedAt = now;

      // AuthStorage에 영구 저장
      await AuthStorage.saveCompleteAuthData(_currentAuth!);
      print('✅ 토큰 저장 완료: ${_currentAuth!.toSafeString}');
    } catch (e) {
      print('❌ 토큰 저장 실패: $e');
      rethrow;
    }
  }

  /// 현재 저장된 인증 정보 반환 (읽기 전용)
  AuthResponse? get currentAuth => _currentAuth;

  // =============================================================
  // ⏰ 액세스 토큰 만료 검사
  // =============================================================

  /// 액세스 토큰 만료 시간 계산
  DateTime? get accessTokenExpiresAt {
    if (_currentAuth == null || _tokenIssuedAt == null) return null;
    return _tokenIssuedAt!.add(Duration(seconds: _currentAuth!.accessExpiresIn));
  }

  /// 리프레시 토큰 만료 시간 계산
  DateTime? get refreshTokenExpiresAt {
    if (_currentAuth == null || _tokenIssuedAt == null) return null;
    return _tokenIssuedAt!.add(Duration(seconds: _currentAuth!.refreshExpiresIn));
  }

  /// 액세스 토큰이 만료되었는지 확인
  bool get isAccessTokenExpired {
    final expiresAt = accessTokenExpiresAt;
    if (expiresAt == null) return true;
    return DateTime.now().isAfter(expiresAt);
  }

  /// 리프레시 토큰이 만료되었는지 확인
  bool get isRefreshTokenExpired {
    final expiresAt = refreshTokenExpiresAt;
    if (expiresAt == null) return true;
    return DateTime.now().isAfter(expiresAt);
  }

  /// 액세스 토큰이 곧 만료되는지 확인 (5분 이내)
  bool get isAccessTokenExpiringSoon {
    final expiresAt = accessTokenExpiresAt;
    if (expiresAt == null) return true;
    return DateTime.now().add(const Duration(minutes: 5)).isAfter(expiresAt);
  }

  /// 액세스 토큰 남은 시간 (초)
  int get accessTokenRemainingSeconds {
    final expiresAt = accessTokenExpiresAt;
    if (expiresAt == null) return 0;
    final remaining = expiresAt.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  /// 리프레시 토큰 남은 시간 (초)
  int get refreshTokenRemainingSeconds {
    final expiresAt = refreshTokenExpiresAt;
    if (expiresAt == null) return 0;
    final remaining = expiresAt.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  // =============================================================
  // 🔧 API 호출용 헬퍼
  // =============================================================

  /// Authorization 헤더 생성 (액세스 토큰용)
  String? get authorizationHeader {
    if (_currentAuth == null) return null;
    return '${_currentAuth!.tokenType} ${_currentAuth!.accessToken}';
  }

  /// Refresh용 Authorization 헤더
  String? get refreshAuthorizationHeader {
    if (_currentAuth == null) return null;
    return '${_currentAuth!.tokenType} ${_currentAuth!.refreshToken}';
  }

  /// 유효한 Access Token 반환 (자동 갱신 포함)
  Future<String?> getValidAccessToken() async {
    // 토큰이 없으면 null
    if (_currentAuth == null) return null;

    // 리프레시 토큰이 만료되었으면 재로그인 필요
    if (isRefreshTokenExpired) {
      print('⚠️ 리프레시 토큰 만료 - 재로그인 필요');
      await clearTokens();
      return null;
    }

    // 액세스 토큰이 만료되었으면 갱신 시도
    if (isAccessTokenExpired) {
      print('🔄 액세스 토큰 만료 - 갱신 시도');
      final refreshed = await _attemptTokenRefresh();
      if (!refreshed) {
        print('❌ 토큰 갱신 실패');
        return null;
      }
    }

    return authorizationHeader;
  }

  // =============================================================
  // 🔄 토큰 갱신 로직
  // =============================================================

  /// 토큰 갱신 시도
  Future<bool> _attemptTokenRefresh() async {
    try {
      if (_currentAuth == null || isRefreshTokenExpired) {
        return false;
      }

      // TODO: AuthRepository에서 실제 갱신 API 호출
      // final refreshRequest = RefreshTokenRequest(
      //   refreshToken: _currentAuth!.refreshToken,
      // );
      //
      // final result = await authRepository.refreshToken(refreshRequest);
      // if (result.isSuccess) {
      //   await saveAuthResponse(result.data!);
      //   print('✅ 토큰 갱신 성공');
      //   return true;
      // }

      print('⚠️ 토큰 갱신 미구현 - AuthRepository 연동 필요');
      return false;  // 임시
    } catch (e) {
      print('❌ 토큰 갱신 중 오류: $e');
      // 갱신 실패 시 토큰 제거
      await _handleTokenError();
      return false;
    }
  }

  /// 토큰 오류 처리
  Future<void> _handleTokenError() async {
    await clearTokens();
    // TODO: 로그인 페이지로 이동 로직 추가
  }

  // =============================================================
  // 🧹 토큰 관리
  // =============================================================

  /// 토큰 제거 (로그아웃)
  Future<void> clearTokens() async {
    try {
      _currentAuth = null;
      _tokenIssuedAt = null;

      // AuthStorage에서도 삭제
      await AuthStorage.clearAll();
      print('✅ 토큰 클리어 완료');
    } catch (e) {
      print('❌ 토큰 클리어 실패: $e');
      rethrow;
    }
  }

  /// 로그인 상태 확인 (종합적 검사)
  bool get isLoggedIn {
    return _currentAuth != null &&
        !isRefreshTokenExpired &&  // 리프레시 토큰이 유효해야 함
        _currentAuth!.isValid;      // 토큰 자체가 유효해야 함
  }

  /// 액세스 토큰 유효성 (API 호출 가능 여부)
  bool get canMakeApiCall {
    return isLoggedIn && !isAccessTokenExpired;
  }

  // =============================================================
  // 📊 디버깅 및 모니터링
  // =============================================================

  /// 토큰 정보 안전 출력 (로깅용)
  String get debugInfo {
    if (_currentAuth == null) return 'TokenManager{no_token}';

    return 'TokenManager{'
        'hasToken: true, '
        'access_expires_in: ${_currentAuth!.accessExpiresIn}s, '
        'refresh_expires_in: ${_currentAuth!.refreshExpiresIn}s, '
        'access_expired: $isAccessTokenExpired, '
        'refresh_expired: $isRefreshTokenExpired, '
        'access_remaining: ${accessTokenRemainingSeconds}s, '
        'refresh_remaining: ${refreshTokenRemainingSeconds}s, '
        'can_make_api_call: $canMakeApiCall'
        '}';
  }

  /// 토큰 상태 요약 (모니터링용)
  Map<String, dynamic> get statusSummary => {
    'has_token': _currentAuth != null,
    'is_logged_in': isLoggedIn,
    'can_make_api_call': canMakeApiCall,
    'access_token_expired': isAccessTokenExpired,
    'refresh_token_expired': isRefreshTokenExpired,
    'access_expiring_soon': isAccessTokenExpiringSoon,
    'access_remaining_seconds': accessTokenRemainingSeconds,
    'refresh_remaining_seconds': refreshTokenRemainingSeconds,
    'issued_at': _tokenIssuedAt?.toIso8601String(),
  };

  /// 메모리 정리 (앱 종료 시)
  void dispose() {
    _currentAuth = null;
    _tokenIssuedAt = null;
    print('🧹 TokenManager 메모리 정리 완료');
  }
}

// =============================================================
// 🏭 TokenManager 싱글톤 제공
// =============================================================

/// 글로벌 토큰 매니저 (Riverpod Provider로 대체 권장)
final tokenManager = TokenManager();

// =============================================================
// 🎯 사용 예시
// =============================================================

/*
// 1. 앱 시작 시 초기화
await tokenManager.initFromStorage();

// 2. 로그인 성공 시
final authResponse = await authApi.loginWithGoogle(request);
if (authResponse.isSuccess) {
  await tokenManager.saveAuthResponse(authResponse.data!);
}

// 3. API 호출 시 (자동 갱신 포함)
final validToken = await tokenManager.getValidAccessToken();
if (validToken != null) {
  final userProfile = await userApi.getProfile(
    headers: {'Authorization': validToken}
  );
} else {
  // 로그인 페이지로 이동
  Navigator.pushReplacementNamed(context, '/login');
}

// 4. 로그인 상태 체크
if (tokenManager.isLoggedIn) {
  // 홈 화면 표시
} else {
  // 로그인 화면 표시
}

// 5. API 호출 가능 여부 체크
if (tokenManager.canMakeApiCall) {
  // 즉시 API 호출 가능
} else {
  // 토큰 갱신 필요 또는 재로그인 필요
}

// 6. 로그아웃
await tokenManager.clearTokens();

// 7. 앱 종료 시
tokenManager.dispose();
*/