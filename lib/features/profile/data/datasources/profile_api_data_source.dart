import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_response_dto.dart';
import '../../../../core/network/page_response.dart';
import '../../../recommendation/data/dto/post_response.dart';
import '../models/request/inquiry_request.dart';
import '../models/request/setup_profile_request.dart';
import '../models/response/profile_dto.dart';
import '../models/response/setup_profile_response.dart';

part 'profile_api_data_source.g.dart';

/// 🌐 프로필 API 데이터 소스 (RESTful)
@RestApi()
abstract class ProfileApiDataSource {
  factory ProfileApiDataSource(Dio dio, {String baseUrl}) =
      _ProfileApiDataSource;

  @POST('/attendance/claim')
  Future<ApiResponse<int>> claimAttendance(
      @Header('Authorization') String token,
      @Query('seconds') double seconds, // 💡 쿼리 파라미터 추가
      );

  @POST('/payments/sync') // 서버의 결제 동기화 엔드포인트와 맞추세요
  Future<ApiResponse<dynamic>> syncRevenueCat(
      @Header('Authorization') String token,
      );

  @POST('/support/inquiry')
  Future<ApiResponse<dynamic>> submitInquiry(
      @Header('Authorization') String token,
      @Body() InquiryRequest request,
      );

  /// 🔄 프로필 업데이트 (닉네임 등)
  @PATCH('/profile')
  // @MultiPart() // FormData를 쓰면 @MultiPart 생략 가능 (Dio가 알아서 처리)
  Future<ApiResponse<SetupProfileResponse>> setupProfile(
      @Header('Authorization') String authorization,
      @Body() FormData body, // 👈 여기가 핵심 변경점
      );

  @POST('/payments/ad-reward')
  Future<ApiResponse<dynamic>> claimAdReward(
      @Header('Authorization') String token,
      );


  @POST('/payments/verify')
  Future<ApiResponse<dynamic>> verifyPayment(
      @Header('Authorization') String token,
      @Body() Map<String, dynamic> body,
      );

  @GET('/profile/summary')
  Future<ApiResponse<ProfileSummaryResponse>> getProfileSummary(
    @Header('Authorization') String authorization,
  );

  @PATCH('/profile/language')
  Future<ApiResponse<dynamic>> updateLanguage(
    @Header('Authorization') String authorization,
    @Body() Map<String, String> body,
  );

  @GET('/profile/coin/history')
  Future<ApiResponse<PageResponse<InkHistoryResponse>>> getInkHistory(
    @Header('Authorization') String authorization,
    @Queries() Map<String, dynamic> queries,
  );

  // 내 게시글 (Community 관련이지만 Profile 기획상 여기에 포함)
  @GET('/community/me')
  Future<ApiResponse<PageResponse<PostResponse>>> getMyPosts(
    @Header('Authorization') String authorization,
    @Queries() Map<String, dynamic> queries,
  );

  // 좋아요한 게시글
  @GET('/community/liked')
  Future<ApiResponse<PageResponse<PostResponse>>> getLikedPosts(
    @Header('Authorization') String authorization,
    @Queries() Map<String, dynamic> queries,
  );

  @GET('/profile/test-results')
  Future<ApiResponse<PageResponse<MyTestResultSummaryResponse>>>
      getMyTestResults(
    @Header('Authorization') String authorization,
    @Queries() Map<String, dynamic> queries,
  );
}
