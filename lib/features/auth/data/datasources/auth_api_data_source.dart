import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_response_dto.dart';
import '../models/request/auth_request_dto.dart';
import '../models/response/auth_response_dto.dart';

part 'auth_api_data_source.g.dart'; // build_runner가 생성할 파일

/// 🔐 인증 API 데이터 소스 (수정된 버전)
@RestApi()
abstract class AuthApiDataSource {
  factory AuthApiDataSource(Dio dio, {String baseUrl}) = _AuthApiDataSource;

  /// Google 로그인 ✅
  @POST('/api/v1/auth/google')
  Future<ApiResponse<AuthResponse>> loginWithGoogle(
      @Body() GoogleLoginRequest request,
      );

  /// 토큰 갱신 ✅
  @POST('/api/v1/auth/refresh')
  Future<ApiResponse<AuthResponse>> refreshToken(
      @Header('Authorization') String authorization,
      );

  /// 로그아웃 ✅
  @POST('/api/v1/auth/logout')
  Future<ApiResponse<String>> logout(
      @Header('Authorization') String authorization,
      );

  /// Access Token 검증 ✅
  @GET('/api/v1/auth/validate')
  Future<ApiResponse<int>> validateToken(
      @Header('Authorization') String authorization,
      );

  /// 내 정보 조회 ✅
  @GET('/api/v1/auth/me')
  Future<ApiResponse<Object>> getCurrentUser(
      @Header('Authorization') String authorization,
      );

  // =============================================================
  // 🚧 미구현 API들 - 서버 구현 후 반환 타입 변경 예정
  // =============================================================

  /// Apple 로그인 (TODO - 서버 미구현)
  ///
  /// 🔄 현재: ApiResponse<String> (에러 메시지)
  /// 🎯 목표: ApiResponse<AuthResponse> (서버 구현 후)
  @POST('/api/v1/auth/apple')
  Future<ApiResponse<String>> loginWithApple();

  /// 게스트 로그인 (TODO - 서버 미구현)
  ///
  /// 🔄 현재: ApiResponse<String> (에러 메시지)
  /// 🎯 목표: ApiResponse<AuthResponse> (서버 구현 후)
  @POST('/api/v1/auth/guest')
  Future<ApiResponse<String>> loginAsGuest();
}