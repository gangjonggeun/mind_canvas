import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response_dto.freezed.dart';
part 'auth_response_dto.g.dart';

/// 🔑 인증 응답 DTO (순수 데이터)
/// 서버 응답 구조와 1:1 매칭, 비즈니스 로직 없음
@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'access_expires_in') @Default(3600) int accessExpiresIn,
    @JsonKey(name: 'refresh_expires_in') @Default(1209600) int refreshExpiresIn,
    @JsonKey(name: 'token_type') @Default('Bearer') String tokenType,

    // 클라이언트에서 추가하는 필드들 (서버에서 안옴)
    @JsonKey(includeFromJson: false, includeToJson: false)
    DateTime? issuedAt,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
}

// =============================================================
// 🔧 AuthResponse 확장 메서드들 (보안 + 성능 최적화)
// =============================================================

/// 🔐 AuthResponse 보안 확장 메서드
extension AuthResponseExtension on AuthResponse {
  /// 🔐 안전한 토큰 로깅용 문자열 (보안)
  ///
  /// 실제 토큰값을 숨기고 마스킹된 정보만 표시
  /// - 메모리 누수 방지
  /// - 로그 보안 강화
  String get toSafeString {
    final maskedAccessToken = _maskToken(accessToken);
    final maskedRefreshToken = _maskToken(refreshToken);

    return 'AuthResponse('
        'type: $tokenType, '
        'access: $maskedAccessToken, '
        'refresh: $maskedRefreshToken, '
        'access_expires_in: ${accessExpiresIn}s, '
        'refresh_expires_in: ${refreshExpiresIn}s)';
  }

  /// 🎭 토큰 마스킹 (처음 6자 + ... + 마지막 4자)
  /// 메모리 효율적인 문자열 조작
  String _maskToken(String token) {
    if (token.isEmpty) return 'empty';
    if (token.length <= 10) return '***masked***';

    final start = token.substring(0, 6);
    final end = token.substring(token.length - 4);
    return '$start...${token.length - 10}chars...$end';
  }

  /// ⏰ 액세스 토큰 만료 시간 계산 (수정됨)
  DateTime get accessExpiryTime {
    final issued = issuedAt ?? DateTime.now();
    return issued.add(Duration(seconds: accessExpiresIn));
  }

  /// ⏰ 리프레시 토큰 만료 시간 계산
  DateTime get refreshExpiryTime {
    final issued = issuedAt ?? DateTime.now();
    return issued.add(Duration(seconds: refreshExpiresIn));
  }

  /// ⚠️ 액세스 토큰 곧 만료 여부 (30분 이내)
  bool get isAccessExpiringSoon {
    return accessExpiresIn <= 1800; // 30분
  }

  /// ⚠️ 리프레시 토큰 곧 만료 여부 (1일 이내)
  bool get isRefreshExpiringSoon {
    return refreshExpiresIn <= 86400; // 1일
  }

  /// ✅ 토큰 유효성 빠른 체크 (수정됨)
  bool get isValid {
    return accessToken.isNotEmpty &&
        refreshToken.isNotEmpty &&
        accessExpiresIn > 0 &&
        refreshExpiresIn > 0;
  }

  /// 액세스 토큰 만료 시간 (nullable)
  DateTime? get accessExpiresAt => issuedAt?.add(Duration(seconds: accessExpiresIn));

  /// 리프레시 토큰 만료 시간 (nullable)
  DateTime? get refreshExpiresAt => issuedAt?.add(Duration(seconds: refreshExpiresIn));

  /// 액세스 토큰 만료 여부
  bool get isAccessExpired => accessExpiresAt?.isBefore(DateTime.now()) ?? true;

  /// 리프레시 토큰 만료 여부
  bool get isRefreshExpired => refreshExpiresAt?.isBefore(DateTime.now()) ?? true;

  /// 🛡️ 토큰 보안 검증 (추가)
  bool get hasSecureLength {
    return accessToken.length >= 20 && refreshToken.length >= 20;
  }

  /// 📊 토큰 상태 요약 (디버깅용)
  Map<String, dynamic> get statusSummary => {
    'valid': isValid,
    'access_expired': isAccessExpired,
    'refresh_expired': isRefreshExpired,
    'access_expiring_soon': isAccessExpiringSoon,
    'refresh_expiring_soon': isRefreshExpiringSoon,
    'secure_length': hasSecureLength,
  };
}