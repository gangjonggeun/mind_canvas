import 'package:freezed_annotation/freezed_annotation.dart';

part 'insight_response.freezed.dart';
part 'insight_response.g.dart';

@freezed
class InsightResponse with _$InsightResponse {
  const factory InsightResponse({
    required int id,
    required String title,
    required String tag,      // 상세 주제
    required String category, // HEALING, WISDOM 등
    required String content,  // 본문
    required String imageUrl,
  }) = _InsightResponse;

  factory InsightResponse.fromJson(Map<String, dynamic> json) =>
      _$InsightResponseFromJson(json);
}