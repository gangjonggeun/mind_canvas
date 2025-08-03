import 'package:freezed_annotation/freezed_annotation.dart';

import '../../features/auth/data/models/response/auth_response_dto.dart';

part 'api_response_dto.freezed.dart';
part 'api_response_dto.g.dart';

/// 📊 API 응답 래퍼 DTO (서버 구조에 맞춤)
///
/// 서버의 ApiResponse<T> 구조와 완전히 일치하도록 설계되었습니다.
@Freezed(genericArgumentFactories: true)
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool success,
    T? data,
    String? message,
    ErrorInfo? error,  // ← 서버의 ErrorInfo와 매칭
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) => _$ApiResponseFromJson(json, fromJsonT);
}

/// ❌ 에러 정보 DTO (서버의 ErrorInfo와 매칭)
///
/// 서버의 간단한 ErrorInfo 구조에 맞춰 설계된 에러 정보입니다.
@freezed
class ErrorInfo with _$ErrorInfo {
  const factory ErrorInfo({
    required String code,      // 서버의 "code" 필드
    required String message,   // 서버의 "message" 필드
  }) = _ErrorInfo;

  factory ErrorInfo.fromJson(Map<String, dynamic> json) =>
      _$ErrorInfoFromJson(json);
}

// --- 공용 Extension ---
extension ApiResponseExtension<T> on ApiResponse<T> {
  /// 데이터가 존재하는지 확인
  bool get hasData => success && data != null;

  /// 에러 메시지 추출 (error가 있으면 error.message, 없으면 message)
  String? get errorMessage => error?.message ?? message;

  /// 에러 코드 추출
  String? get errorCode => error?.code;

  /// 성공 여부 확인
  bool get isSuccess => success;

  /// 실패 여부 확인
  bool get isFailure => !success;
}

// --- 편의 팩토리 메서드들 ---
extension ApiResponseFactory on ApiResponse {
  /// 성공 응답 생성
  static ApiResponse<T> success<T>(T data, [String? message]) {
    return ApiResponse(
      success: true,
      data: data,
      message: message ?? '성공적으로 처리되었습니다',
      timestamp: DateTime.now(),
    );
  }

  /// 에러 응답 생성
  static ApiResponse<T> error<T>(String code, String message) {
    return ApiResponse(
      success: false,
      error: ErrorInfo(code: code, message: message),
      timestamp: DateTime.now(),
    );
  }
}

// --- 타입 안전성을 위한 특화된 ApiResponse들 ---

/// 🔐 인증 응답용 ApiResponse
typedef AuthApiResponse = ApiResponse<AuthResponse>;



/// 📝 목록 응답용 ApiResponse
typedef ListApiResponse<T> = ApiResponse<List<T>>;

/// 🔢 ID 응답용 ApiResponse (토큰 검증 등)
typedef IdApiResponse = ApiResponse<int>;