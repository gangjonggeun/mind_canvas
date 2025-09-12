// =============================================================
// 📁 lib/features/test/data/datasources/test_api_data_source.dart
// =============================================================

import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../../../../core/network/api_response_dto.dart';
import '../response/tests_response.dart';

part 'test_api_data_source.g.dart'; // build_runner가 생성할 파일

/// 🧠 테스트 API 데이터 소스
@RestApi()
abstract class TestApiDataSource {
  factory TestApiDataSource(Dio dio, {String baseUrl}) = _TestApiDataSource;

  /// 📋 최신 테스트 목록 조회 (페이징)
  @GET('/tests/latest')
  Future<ApiResponse<TestsResponse>> getLatestTests(
      @Query('page') int page,
      @Query('size') int size,
      @Header('Authorization') String authorization,
      );
}