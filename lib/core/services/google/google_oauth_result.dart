// lib/core/auth/google_oauth_result.dart (기존 파일을 이 내용으로 교체)



// --- 아래의 결과/에러 클래스는 별도의 파일(google_oauth_result.dart)로 분리하거나 여기에 둬도 됩니다. ---

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
  tokenExpired,
  unknown,
}

extension OAuthErrorExtension on OAuthError {
  String get message {
    switch (this) {
      case OAuthError.userCancelled:
        return '로그인이 취소되었습니다.';
      case OAuthError.tokenError:
        return '인증 토큰을 가져오는 데 실패했습니다. 다시 시도해주세요.';
      case OAuthError.networkError:
        return '네트워크 연결을 확인해주세요.';
      case OAuthError.notAuthenticated:
        return '로그인이 필요합니다.';
      case OAuthError.tokenExpired:
        return '토큰 시간이 만료되었습니다. 다시 시도해주세요.';
      case OAuthError.unknown:
      default: // 혹시 모를 다른 에러 타입을 대비
        return '알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
    }
  }
}