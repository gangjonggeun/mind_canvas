import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/rec_category.dart';

part 'recommendation_result.freezed.dart';

/// 🎬 [RecommendationResult]
///
/// 서버에서 받은 추천 결과를 클라이언트에서 관리하기 위한 엔티티입니다.
/// UI에 표시할 때 최적화된 구조를 가집니다.
@freezed
class RecommendationResult with _$RecommendationResult {
  const factory RecommendationResult({
    /// 추천 생성 일시 (데이터가 언제 만들어졌는지 표시용)
    required DateTime createdAt,

    /// 카테고리별 추천 목록
    required List<RecommendationCategoryGroup> groups,
  }) = _RecommendationResult;
}

@freezed
class RecommendationCategoryGroup with _$RecommendationCategoryGroup {
  const factory RecommendationCategoryGroup({
    required RecCategory category,
    required List<RecommendationContent> items,
  }) = _RecommendationCategoryGroup;
}

@freezed
class RecommendationContent with _$RecommendationContent {
  const factory RecommendationContent({
    required String title,
    required String description,
    required String reason,
    required int matchPercent,
  }) = _RecommendationContent;
}