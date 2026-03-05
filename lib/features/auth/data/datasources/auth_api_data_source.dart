import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_response_dto.dart';
import '../models/request/auth_request_dto.dart';
import '../models/response/auth_response_dto.dart';

part 'auth_api_data_source.g.dart'; // build_runner가 생성할 파일

/// 🔐 인증 API 데이터 소스 (수정된 버전)
@RestApi()
abstract class AuthApiDataSource {
  factory AuthApiDataSource(Dio dio, {String baseUrl}) = _AuthApiDataSource;
  @DELETE('/users/account')
  Future<ApiResponse<dynamic>> deleteAccount(
      @Header('Authorization') String authorization,
      );

  @PATCH('/users/fcm-token')
  // 🚨 수정 전: Future<ApiResponse<void>> updateFcmToken(...)
  // ✅ 수정 후: dynamic으로 변경
  Future<ApiResponse<dynamic>> updateFcmToken(
      @Header('Authorization') String authorization,
      @Body() Map<String, String> body,
      );

  // ... 기존 로그인 관련 코드들 ...
  @POST('/auth/google')
  Future<ApiResponse<AuthResponse>> loginWithGoogle(
      @Body() GoogleLoginRequest request,
      );


  // /// Google 로그인 ✅
  // @POST('/auth/google')
  // // @Headers(<String, dynamic>{ // ✅ 헤더 추가
  // //   'Content-Type': 'application/json',
  // // })
  // Future<ApiResponse<AuthResponse>> loginWithGoogle(
  //     @Body() GoogleLoginRequest request,
  //     );

  /// 토큰 갱신 ✅ 및 자동로그인에서 사용
  @POST('/auth/refresh')

  Future<ApiResponse<AuthResponse>> refreshTokens(
      @Body() RefreshTokenRequest request,  // 🔄 Header에서 Body로 변경!
      );

  /// 로그아웃 ✅
  @POST('/auth/logout')
  Future<ApiResponse<String>> logout(
      @Header('Authorization') String authorization,
      );



  /// Access Token 검증 ✅
  @GET('/auth/validate')
  Future<ApiResponse<bool>> validateToken(
      @Header('Authorization') String authorization,
      );

  /// 내 정보 조회 ✅
  @GET('/auth/me')
  Future<ApiResponse<dynamic>> getCurrentUser(
      @Header('Authorization') String authorization,
      );



  @POST('/api/v1/auth/guest')
  Future<ApiResponse<AuthResponse>> loginAsGuest(
      @Body() GuestLoginRequest request,
      );

  @POST('/api/v1/auth/apple')
  Future<ApiResponse<AuthResponse>> loginWithApple(
      @Body() AppleLoginRequest request,
      );
}