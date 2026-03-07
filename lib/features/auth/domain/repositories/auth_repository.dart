import '../../../../core/utils/result.dart';
import '../../data/models/response/auth_response_dto.dart';
import '../entities/auth_user_entity.dart';

/// 🔑 인증 Repository 인터페이스 (업데이트)
///
/// Repository Layer의 역할:
/// - DataSource에서 받은 데이터를 도메인으로 변환
/// - 모든 예외를 Result 패턴으로 안전하게 래핑
/// - 비즈니스 로직과 데이터 소스 분리
/// - 테스트 가능한 추상화 제공
abstract class AuthRepository {
  Future<Result<AuthResponse>> loginAsGuest(
      String languageCode, {
        String? deviceId, // ✨ 추가
        String? fcmToken,
      });
  Future<Result<void>> deleteAccount();
  Future<Result<AuthResponse>> loginWithApple(
      String identityToken, {
        String? deviceId, // ✨ 추가
        String? fcmToken,
      });

  Future<void> syncFcmToken();

  // =============================================================
  // 🔐 로그인 메서드들
  // =============================================================

  /// 🌐 Google 로그인
  ///
  /// @param idToken Google OAuth2 ID Token
  /// @param deviceId 기기 식별자 (선택사항)
  /// @param fcmToken FCM 푸시 토큰 (선택사항)
  /// @return Result<AuthResponse> 인증 정보 또는 에러
  Future<Result<AuthResponse>> loginWithGoogle(
    String idToken, {
    String? deviceId,
    String? fcmToken,
  });

  // =============================================================
  // 🔄 토큰 관리
  // =============================================================

  /// 🔄 토큰 갱신
  ///
  /// Repository에서 저장된 refresh token을 자동으로 사용
  /// @return Result<AuthResponse> 새로운 토큰 정보 또는 에러
  Future<Result<AuthResponse>> refreshTokens();

  /// 🔍 토큰 유효성 검증
  ///
  /// @return Result<int?> 유효한 경우 사용자 ID, 무효한 경우 null
  /// 자동로그인에서 사용
  Future<Result<void>> validateToken();

  /// ⏰ 토큰 만료 여부 확인
  ///
  /// @return bool 만료되었으면 true (Result 불필요 - 로컬 체크)
  Future<bool> isTokenExpired();

  /// 🎫 유효한 Access Token 반환
  ///
  /// 만료된 경우 자동으로 갱신 시도
  /// @return String? Authorization 헤더용 토큰 ("Bearer xxx")
  Future<String?> getAccessToken();

  // =============================================================
  // 🚪 로그아웃 및 상태 관리
  // =============================================================

  /// 🚪 로그아웃
  ///
  /// @param logoutFromAllDevices 모든 기기에서 로그아웃 여부
  /// @return Result<void> 성공/실패 여부
  Future<Result<void>> logout({bool logoutFromAllDevices = false});

  /// 💾 로그인 상태 확인
  ///
  /// @return bool 로그인 상태 (Result 불필요 - 로컬 체크)
  Future<bool> isLoggedIn();

  // =============================================================
  // 👤 사용자 정보
  // =============================================================

  /// 👤 현재 사용자 정보 조회
  ///
  /// @return Result<AuthUser?> 사용자 정보 또는 null
  Future<Result<AuthUser?>> getCurrentUser();

  // =============================================================
  // 🔧 토큰 저장/삭제 (내부 사용)
  // =============================================================

  /// 🔐 토큰 저장
  ///
  /// 일반적으로 로그인 성공 시 자동 호출됨
  /// @param accessToken JWT Access Token
  /// @param refreshToken JWT Refresh Token
  Future<void> saveAuthTokens(
      {required String accessToken,
      required String refreshToken,
      required int userId});

  /// 🗑️ 토큰 삭제
  ///
  /// 로그아웃 시 자동 호출됨
  Future<void> clearAuthTokens();
}
