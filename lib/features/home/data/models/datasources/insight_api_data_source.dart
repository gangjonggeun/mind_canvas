import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/network/api_response_dto.dart';
import '../../../../../core/network/dio_provider.dart';
import '../response/insight_response.dart';

part 'insight_api_data_source.g.dart';

@riverpod
InsightApiDataSource insightApiDataSource(InsightApiDataSourceRef ref) {
  return InsightApiDataSource(ref.watch(dioProvider));
}

@RestApi()
abstract class InsightApiDataSource {
  factory InsightApiDataSource(Dio dio, {String baseUrl}) = _InsightApiDataSource;

  @GET('/insights/random')
  Future<ApiResponse<List<InsightResponse>>> getRandomInsights(
      @Header('Authorization') String token,
      @Query('count') int count,
      );
}