import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_recommendation_response.freezed.dart';
part 'test_recommendation_response.g.dart';

@freezed
class TestRecommendationResponse with _$TestRecommendationResponse {
  const factory TestRecommendationResponse({
    // ✅ 서버의 testId (Long -> int)
    required int testId,

    // ✅ 제목
    required String title,

    // ✅ 썸네일 URL
    required String thumbnailUrl,

    // ✅ 추천 이유 (서버에서 null로 올 수도 있으니 nullable 처리)
    // 예: "🔥 지금 뜨는 인기 테스트", "MD Pick"
    String? reason,

    // ✅ 카테고리 (서버 Enum.name -> String)
    required String category,

    // ✅ 플레이 횟수 (서버에서 "1.2만명" 등으로 포맷팅해서 줌)
    required String playCount,
  }) = _TestRecommendationResponse;

  factory TestRecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$TestRecommendationResponseFromJson(json);
}