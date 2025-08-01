import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart'; // Retrofit import
import '../models/response/auth_response_dto.dart';

part 'auth_api_data_source.g.dart'; // ✨ build_runner가 생성할 파일

// ✨ @RestApi 어노테이션으로 API 명세서를 정의합니다.
@RestApi()
abstract class AuthApiDataSource {
  factory AuthApiDataSource(Dio dio, {String baseUrl}) = _AuthApiDataSource;

  @POST('/auth/google')
  Future<AuthResponse> loginWithGoogle();

  @POST('/auth/apple')
  Future<AuthResponse> loginWithApple();

  @POST('/auth/guest')
  Future<AuthResponse> loginAsGuest();
}