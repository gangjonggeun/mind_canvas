import 'google_oauth_result.dart';




/// Google OAuth 서비스의 공통 기능 명세 (Interface)
abstract class BaseGoogleOAuthService {
  /// 구글 계정으로 로그인 (팝업 표시)
  Future<GoogleOAuthResult> signIn();

  /// 자동 로그인 (무음 로그인)
  Future<GoogleOAuthResult> signInSilently();

  /// 로그아웃
  Future<void> signOut();
}