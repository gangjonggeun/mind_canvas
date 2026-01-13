import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 공통 API Response DTO 경로 (프로젝트에 맞게 수정)
import '../../../../../core/network/api_response_dto.dart';
import '../../../../core/network/dio_provider.dart';

import '../dto/content_rec_request.dart';
import '../dto/content_rec_response.dart';

part 'recommendation_data_source.g.dart';

@riverpod
RecommendationDataSource recommendationDataSource(RecommendationDataSourceRef ref) {
  final dio = ref.watch(dioProvider);
  return RecommendationDataSource(dio);
}

/// 🎬 [RecommendationDataSource]
///
/// AI 기반 맞춤 콘텐츠 추천 관련 API
/// Server Controller: RecommendationController
@RestApi()
abstract class RecommendationDataSource {
  factory RecommendationDataSource(Dio dio, {String baseUrl}) = _RecommendationDataSource;

  /// 🎬 콘텐츠 추천 요청
  ///
  /// - Endpoint: POST /api/v1/recommendation/content
  /// - Cost: 15 Coin (Server-side handled)
  @POST('/recommendation/content')
  Future<ApiResponse<ContentRecResponse>> recommendContent(
      @Header('Authorization') String authorization,
      @Body() ContentRecRequest request,
      );
}