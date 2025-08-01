import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response_dto.freezed.dart';
part 'api_response_dto.g.dart';

/// 📊 API 응답 래퍼 DTO (공용)
///
/// 어떤 종류의 데이터(T)든 감쌀 수 있는 범용 응답 래퍼입니다.
@Freezed(genericArgumentFactories: true) // 제네릭 타입을 위한 설정
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool success,
    T? data,
    String? message,
    ErrorResponse? error,
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) => _$ApiResponseFromJson(json, fromJsonT);
}

/// ❌ 에러 응답 DTO (공용)
///
/// API 호출 실패 시 공통적으로 사용될 에러 정보입니다.
@freezed
class ErrorResponse with _$ErrorResponse {
  const factory ErrorResponse({
    required String error,
    required String errorDescription,
    String? errorCode,
    String? errorUri,
    Map<String, dynamic>? details,
    DateTime? timestamp,
  }) = _ErrorResponse;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
}

// --- 공용 Extension ---
extension ApiResponseExtension<T> on ApiResponse<T> {
  bool get hasData => success && data != null;
  String? get errorMessage => error?.errorDescription ?? message;
  String? get errorCode => error?.errorCode;
}