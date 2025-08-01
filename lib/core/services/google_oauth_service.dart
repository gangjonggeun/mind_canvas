import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

///
/// **OAuth2 플로우:**
/// 1. Google OAuth 서버로 인증 요청
/// 2. Authorization Code 받기
/// 3. Access Token & ID Token 교환
/// 4. ID Token을 Spring 백엔드로 전송하여 검증
///
/// **메모리 최적화:** Result 패턴으로 Exception 대신 가벼운 에러 처리
class GoogleOAuthService {
  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  // 싱글톤 패턴
  static GoogleOAuthService? _instance;
  static GoogleOAuthService get instance {
    _instance ??= GoogleOAuthService._internal();
    return _instance!;
  }
  GoogleOAuthService._internal();

  /// Google Sign-In 인스턴스
  GoogleSignIn? _googleSignIn;

  GoogleSignIn get _google {
    _googleSignIn ??= GoogleSignIn(
      serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID']!,
      scopes: [
        'email',
        'profile',
        'openid', // ID Token을 위해 필요
      ],
    );
    return _googleSignIn!;
  }

  /// 🚀 Google OAuth2 로그인 - idToken만 반환
  ///
  /// **반환값:** GoogleOAuthResult - idToken만 포함
  Future<GoogleOAuthResult> signIn() async {
    try {
      _logger.i('🚀 Google OAuth2 로그인 시작...');

      // 1단계: Google 계정 선택
      final GoogleSignInAccount? googleUser = await _google.signIn();
      if (googleUser == null) {
        _logger.w('⚠️ 사용자가 로그인을 취소했습니다.');
        return GoogleOAuthResult.failure(OAuthError.userCancelled);
      }

      _logger.i('👤 Google 계정: ${googleUser.email}');

      // 2단계: 인증 토큰 획득
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        _logger.e('❌ ID Token을 가져올 수 없습니다.');
        return GoogleOAuthResult.failure(OAuthError.tokenError);
      }

      _logger.i('✅ Google OAuth2 로그인 성공: ${googleUser.email}');
      return GoogleOAuthResult.success(googleAuth.idToken!);

    } catch (e, stackTrace) {
      _logger.e('❌ Google OAuth2 로그인 실패', error: e, stackTrace: stackTrace);
      return GoogleOAuthResult.failure(OAuthError.unknown);
    }
  }

  /// 🔄 무음 로그인 (자동 로그인)
  Future<GoogleOAuthResult> signInSilently() async {
    try {
      _logger.i('🔄 Google 무음 로그인 시도...');

      final GoogleSignInAccount? googleUser = await _google.signInSilently();
      if (googleUser == null) {
        _logger.i('ℹ️ 기존 로그인 정보 없음');
        return GoogleOAuthResult.failure(OAuthError.notAuthenticated);
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        _logger.e('❌ 캐시된 ID Token이 유효하지 않습니다.');
        return GoogleOAuthResult.failure(OAuthError.tokenError);
      }

      _logger.i('✅ Google 무음 로그인 성공: ${googleUser.email}');
      return GoogleOAuthResult.success(googleAuth.idToken!);

    } catch (e, stackTrace) {
      _logger.w('⚠️ 무음 로그인 실패', error: e, stackTrace: stackTrace);
      return GoogleOAuthResult.failure(OAuthError.unknown);
    }
  }

  /// 🚪 로그아웃
  Future<bool> signOut() async {
    try {
      _logger.i('🚪 Google 로그아웃 시작...');
      await _google.signOut();
      _logger.i('✅ Google 로그아웃 완료');
      return true;
    } catch (e, stackTrace) {
      _logger.e('❌ Google 로그아웃 실패', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// 🧹 메모리 정리
  void dispose() {
    _logger.i('🧹 Google OAuth 서비스 정리 중...');
    _googleSignIn = null;
  }
}

/// 🎯 Google OAuth2 결과 - idToken만 포함
class GoogleOAuthResult {
  final String? idToken;
  final OAuthError? error;
  final bool isSuccess;

  const GoogleOAuthResult._({
    this.idToken,
    this.error,
    required this.isSuccess,
  });

  factory GoogleOAuthResult.success(String idToken) => GoogleOAuthResult._(
    idToken: idToken,
    isSuccess: true,
  );

  factory GoogleOAuthResult.failure(OAuthError error) => GoogleOAuthResult._(
    error: error,
    isSuccess: false,
  );

  T when<T>({
    required T Function(String idToken) success,
    required T Function(OAuthError error) failure,
  }) {
    if (isSuccess) {
      return success(idToken!);
    } else {
      return failure(error!);
    }
  }
}

/// 🚨 OAuth 에러 타입
enum OAuthError {
  userCancelled,
  tokenError,
  networkError,
  notAuthenticated,
  unknown,
}

extension OAuthErrorExt on OAuthError {
  String get message {
    switch (this) {
      case OAuthError.userCancelled:
        return '로그인이 취소되었습니다.';
      case OAuthError.tokenError:
        return '인증 토큰을 가져올 수 없습니다.';
      case OAuthError.networkError:
        return '네트워크 연결을 확인해주세요.';
      case OAuthError.notAuthenticated:
        return '로그인이 필요합니다.';
      case OAuthError.unknown:
        return '알 수 없는 오류가 발생했습니다.';
    }
  }
}