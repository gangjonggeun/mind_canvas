import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_response_dto.dart';
import '../models/request/setup_profile_request.dart';
import '../models/response/setup_profile_response.dart';

part 'profile_api_data_source.g.dart';

/// 🌐 프로필 API 데이터 소스 (RESTful)
@RestApi()
abstract class ProfileApiDataSource {
  factory ProfileApiDataSource(Dio dio, {String baseUrl}) = _ProfileApiDataSource;

  /// 🔄 프로필 업데이트 (닉네임 등)
  @PATCH('/profile')
  @Headers(<String, dynamic>{
    'Content-Type': 'application/json',
  })
  Future<ApiResponse<SetupProfileResponse>> setupProfile(
      @Header('Authorization') String authorization,
      @Body() SetupProfileRequest request,
      );
}