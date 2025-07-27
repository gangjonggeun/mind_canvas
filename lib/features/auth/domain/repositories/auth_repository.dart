
import '../../../../core/utils/result.dart';
import '../../data/models/response/auth_response_dto.dart';
import '../entities/auth_user_entity.dart';


/// 🔑 인증 Repository 인터페이스
/// 
/// 다양한 로그인 방식을 지원하는 추상 인터페이스
/// - Result 패턴으로 안전한 에러 처리
/// - 메모리 효율적인 비동기 처리
/// - 테스트 가능한 설계
abstract class AuthRepository {
  
  /// 📧 이메일 로그인
  Future<Result<AuthResponse>> loginWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  });

  /// 🌐 Google 로그인
  Future<Result<AuthResponse>> loginWithGoogle();

  /// 🍎 Apple 로그인
  Future<Result<AuthResponse>> loginWithApple();

  /// 👥 게스트 로그인 (익명)
  Future<Result<AuthResponse>> loginAsGuest();

  /// 🔄 토큰 갱신
  Future<Result<AuthResponse>> refreshToken(String refreshToken);

  /// 🚪 로그아웃
  Future<Result<void>> logout({bool logoutFromAllDevices = false});

  /// 👤 현재 사용자 정보 조회
  Future<Result<AuthUser?>> getCurrentUser();

  /// 💾 로그인 상태 확인
  Future<bool> isLoggedIn();

  /// 🔐 토큰 저장
  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  });

  /// 🗑️ 토큰 삭제
  Future<void> clearAuthTokens();
}
