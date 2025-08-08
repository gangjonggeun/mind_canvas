// lib/core/auth/services/google_oauth_service.dart (진짜 최종 버전)

import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'google_oauth_result.dart'; // Result/Error 클래스가 있는 파일

/// Google OAuth 서비스 (최신 google_sign_in 버전 완벽 적용)
class GoogleOAuthService {
  // ✅ GoogleSignIn.instance를 사용하여 기본 싱글턴 인스턴스를 가져옵니다.
  //    serverClientId를 설정하지 않으면, google-services.json을 기반으로
  //    Android ID를 aud로 사용하는 토큰을 생성합니다. (우리가 원하는 동작)
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    // ====================================================================
    // 👇👇👇 바로 여기가 우리의 전략을 결정하는 곳입니다! 👇👇👇
    // ====================================================================
    //
    // [전략 A - aud를 Android ID로 통일하기] - 가장 성공 확률이 높은 방법
    // serverClientId를 제공하지 않으면, 라이브러리는 google-services.json의
    // Android 클라이언트 ID를 aud로 사용하는 토큰을 생성합니다.
    await _googleSignIn.initialize();

    // [전략 B - aud를 Web ID로 설정하기] - 이론적으로 더 표준적인 방법
    // 만약 전략 A가 실패하면, 이 코드로 바꿔서 시도해보세요.
    // await _googleSignIn.initialize(
    //   serverClientId: '여기에 .env에서 읽어온 GOOGLE_WEB_CLIENT_ID 값을 넣습니다',
    // );
    //
    // ====================================================================

    _isInitialized = true;
  }

  /// 🚀 Google 대화형 로그인
  /// 🚀 Google 대화형 로그인 (강제 새 토큰 발급)
  /// 🚀 Google 대화형 로그인 (최신 API 버전)
  Future<GoogleOAuthResult> signIn() async {
    print("여기는 구글 oauth서비스! (최신 API)");
    try {
      await _ensureInitialized();

      // ✅ 핵심 수정: 캐시된 토큰을 강제로 제거
      await _googleSignIn.signOut(); // 기존 캐시 제거

      print("🧹 Google 토큰 캐시 제거 완료");

      // ✅ 최신 API: authenticate() 메소드 사용
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      final googleAuth = await googleUser.authentication;

      print('---ID_TOKEN_START---');
      print(googleAuth.idToken!);
      print('---ID_TOKEN_END---');

      if (googleAuth.idToken == null) {
        print("Google 로그인 실패 (idToken is null)");
        return GoogleOAuthResult.failure(OAuthError.tokenError);
      }

      print("Google 로그인 성공! 새로운 ID 토큰 획득.");
      return GoogleOAuthResult.success(googleAuth.idToken!);

    } catch (e, stackTrace) {
      print("Google 로그인 중 예외 발생: $e");
      print(stackTrace);

      // GoogleSignInException 처리
      if (e.toString().contains('canceled') || e.toString().contains('CANCELED')) {
        return GoogleOAuthResult.failure(OAuthError.userCancelled);
      }

      return GoogleOAuthResult.failure(OAuthError.unknown);
    }
  }


  /// 🔄 자동/무음 로그인 (최신 API 버전)
  Future<GoogleOAuthResult> signInSilently() async {
    try {
      await _ensureInitialized();

      // ✅ 최신 API: attemptLightweightAuthentication() 사용
      final GoogleSignInAccount? googleUser = await _googleSignIn.attemptLightweightAuthentication();

      // 이전에 로그인한 기록이 없으면 null이 반환됩니다.
      if (googleUser == null) {
        print("자동 로그인 실패: 이전 로그인 기록 없음");
        return GoogleOAuthResult.failure(OAuthError.notAuthenticated);
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) {
        print("자동 로그인 실패: ID 토큰 없음");
        return GoogleOAuthResult.failure(OAuthError.tokenError);
      }

      // 토큰 만료 체크
      if (_isTokenExpired(googleAuth.idToken!)) {
        print("자동 로그인 실패: 토큰 만료됨");
        return GoogleOAuthResult.failure(OAuthError.tokenExpired);
      }

      print("자동 로그인 성공!");
      return GoogleOAuthResult.success(googleAuth.idToken!);

    } catch (e) {
      print("자동 로그인 중 예외: $e");
      return GoogleOAuthResult.failure(OAuthError.unknown);
    }
  }

  bool _isTokenExpired(String idToken) {
    try {
      final parts = idToken.split('.');
      if (parts.length != 3) return true;

      final payload = parts[1];
      // Base64 패딩 추가
      String normalized = payload;
      while (normalized.length % 4 != 0) {
        normalized += '=';
      }

      final decoded = utf8.decode(base64.decode(normalized));
      final json = jsonDecode(decoded);

      final exp = json['exp'] as int?;
      if (exp == null) return true;

      final expDateTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();

      print("토큰 만료시간: $expDateTime, 현재시간: $now");

      // 5분 여유를 두고 만료 체크
      return now.isAfter(expDateTime.subtract(Duration(minutes: 5)));

    } catch (e) {
      print("토큰 파싱 오류: $e");
      return true; // 파싱 실패시 만료로 간주
    }
  }
  /// 🚪 로그아웃
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      // 로그아웃 실패는 치명적이지 않으므로 무시합니다.
    }
  }
}