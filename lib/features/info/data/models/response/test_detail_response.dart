import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_detail_response.freezed.dart';
part 'test_detail_response.g.dart';

@freezed
class TestDetailResponse with _$TestDetailResponse {
  const factory TestDetailResponse({
    required int testId,
    String? imagePath,
    String? psychologyTag,
    required String title,
    String? subtitle,
    required int estimatedTime,
    required String difficulty,
    String? introduction,
    List<String>? instructions,
    String? backgroundGradient,
    String? darkModeGradient,

    // 💰 [신규 추가] 서버 DTO와 매핑되는 코인 관련 필드
    // @Default를 사용하면 서버에서 해당 필드가 null이거나 안 넘어올 경우(구버전 API 등) 안전하게 기본값을 사용합니다.
    @Default(0) int cost,
    @Default(false) bool isAffordable,

  }) = _TestDetailResponse;

  factory TestDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$TestDetailResponseFromJson(json);
}

// 💡 (선택 사항) 편의를 위한 Extension 추가
// UI에서 test.isFree 로 쉽게 확인 가능
extension TestDetailExtension on TestDetailResponse {
  bool get isFree => cost == 0;
}