import 'package:dio/dio.dart';
import 'package:mind_canvas/core/network/dio_provider.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/network/api_response_dto.dart';
import '../../../../psy_result/data/model/response/test_result_response.dart';
import '../response/test_recommendation_response.dart';


part 'test_recommendation_api_data_source.g.dart';

@riverpod
TestRecommendationApiDataSource testRecommendationApiDataSource(TestRecommendationApiDataSourceRef ref) {
  final dio = ref.watch(dioProvider);
  return TestRecommendationApiDataSource(dio);
}

@RestApi()
abstract class TestRecommendationApiDataSource {
  factory TestRecommendationApiDataSource(Dio dio, {String baseUrl}) = _TestRecommendationApiDataSource;



  // ===========================================================================
  // 🎁 [신규] 홈 화면 맞춤 추천 목록 조회
  // ===========================================================================
  // 서버 Controller: @GetMapping("/api/v1/tests/recommendations")
  @GET('/tests/recommendations')
  Future<ApiResponse<List<TestRecommendationResponse>>> getRecommendations(
      @Header('Authorization') String? authorization, // 비로그인도 가능하면 ? 붙임
      );
}