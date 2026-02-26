import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../../../core/network/api_response_dto.dart';
import '../dto/comprehensive_analysis_response.dart';
import '../dto/psychological_profile_response.dart';

part 'user_analysis_data_source.g.dart';

/// 📊 [UserAnalysisDataSource]
///
/// 서버의 `UserAnalysisController`와 매핑됩니다.
/// 마이페이지, 통계 분석 탭에서 사용자의 누적된 심리 데이터를 조회할 때 사용합니다.
@RestApi()
abstract class UserAnalysisDataSource {
  factory UserAnalysisDataSource(Dio dio, {String baseUrl}) = _UserAnalysisDataSource;


  @GET('/analysis/comprehensive')
  Future<ApiResponse<ComprehensiveAnalysisResponse>> getComprehensiveAnalysis(
      @Header('Authorization') String authorization,
      );

  /// 🎯 내 심리 분석 통계 조회
  ///
  /// - 엔드포인트: GET /api/v1/users/me/profile
  /// - 기능: DB에 저장된 MBTI, Big5, Enneagram 누적 결과를 반환함.
  /// - 인증: 필수 (AccessToken)
  @GET('/analysis/profile')
  Future<ApiResponse<PsychologicalProfileResponse>> getMyPsychologicalProfile(
      @Header('Authorization') String authorization,
      );
}


