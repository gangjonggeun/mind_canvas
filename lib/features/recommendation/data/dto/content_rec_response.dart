import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/enums/rec_category.dart';

part 'content_rec_response.freezed.dart';
part 'content_rec_response.g.dart';

/// 1. 전체 응답 래퍼
@freezed
class ContentRecResponse with _$ContentRecResponse {
  const factory ContentRecResponse({
    /// 카테고리별 추천 결과 리스트
    required List<CategoryResult> results,
  }) = _ContentRecResponse;

  factory ContentRecResponse.fromJson(Map<String, dynamic> json) =>
      _$ContentRecResponseFromJson(json);
}

/// 2. 카테고리별 결과 그룹
@freezed
class CategoryResult with _$CategoryResult {
  const factory CategoryResult({
    required RecCategory category, // MOVIE, GAME 등
    required List<RecItem> items,  // 추천작 4개 리스트
  }) = _CategoryResult;

  factory CategoryResult.fromJson(Map<String, dynamic> json) =>
      _$CategoryResultFromJson(json);
}

/// 3. 개별 추천 아이템
@freezed
class RecItem with _$RecItem {
  const factory RecItem({
    required String title,       // 제목
    @JsonKey(name: 'description') required String description,
    required String reason,      // 추천 이유
    required int matchPercent,   // 매칭 확률 (0~100)
  }) = _RecItem;

  factory RecItem.fromJson(Map<String, dynamic> json) =>
      _$RecItemFromJson(json);
}