// =============================================================
// 📁 features/taro/data/datasources/remote/taro_api_data_source.dart
// =============================================================

import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/network/api_response_dto.dart';
import '../../../../../core/network/dio_provider.dart';
import '../dto/request/submit_taro_request.dart';
import '../dto/response/taro_result_response.dart';


part 'taro_api_data_source.g.dart';

@riverpod
TaroApiDataSource taroApiDataSource(TaroApiDataSourceRef ref) {
  final dio = ref.watch(dioProvider);
  return TaroApiDataSource(dio);
}

/// 🔮 타로 API 데이터 소스 (Retrofit 기반)
///
/// <p><strong>핵심 기능:</strong></p>
/// - 🃏 타로 카드 상담 요청 (AI 분석)
/// - 🔒 인증 필수 (Bearer 토큰)
///
/// <p><strong>참고:</strong></p>
/// - 서버 엔드포인트: /api/v1/taro
@RestApi()
abstract class TaroApiDataSource {
  factory TaroApiDataSource(Dio dio, {String baseUrl}) = _TaroApiDataSource;

  @GET('/taro/results/{resultId}')
  Future<ApiResponse<TaroResultResponse>> getTarotResult(
      @Path('resultId') int resultId,
      @Header('Authorization') String token,
      );
  /// 🔮 타로 상담 요청 (AI 분석)
  ///
  /// <p><strong>요청 예시:</strong></p>
  /// ```dart
  /// final request = SubmitTaroRequest(
  ///   theme: "연애운",
  ///   spreadType: "THREE_CARD",
  ///   cards: [...]
  /// );
  /// ```
  ///
  /// 서버 엔드포인트: POST /api/v1/taro/reading
  ///
  /// @param request 타로 상담 요청 (주제 + 스프레드 + 카드정보)
  /// @param authorization JWT 토큰 (Bearer {token})
  /// @return AI 타로 해석 결과 (종합 해석 + 카드별 해석)
  @POST('/taro/reading')
  Future<ApiResponse<TaroResultResponse>> analyzeTaro(
      @Body() SubmitTaroRequest request,
      @Header('Authorization') String authorization,
      );
}