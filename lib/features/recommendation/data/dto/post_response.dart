import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/enums/community_enums.dart';
import 'embedded_content.dart';



part 'post_response.freezed.dart';
part 'post_response.g.dart';

@freezed
class PostResponse with _$PostResponse {
  const factory PostResponse({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    required String channel,
    required String category,
    required String title,

    // 목록 조회시 contentSummary가 내려올 수 있음
    @JsonKey(name: 'content_summary') String? contentSummary,
    @JsonKey(name: 'content') String? content, // 상세 조회시

    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'embedded_content') EmbeddedContent? embeddedContent,

    @JsonKey(name: 'view_count') required int viewCount,
    @JsonKey(name: 'like_count') required int likeCount,
    @JsonKey(name: 'comment_count') required int commentCount,

    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _PostResponse;

  factory PostResponse.fromJson(Map<String, dynamic> json) =>
      _$PostResponseFromJson(json);
}
