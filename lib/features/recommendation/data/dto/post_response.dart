import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/enums/community_enums.dart';
import 'embedded_content.dart';



part 'post_response.freezed.dart';
part 'post_response.g.dart';

@freezed
class PostResponse with _$PostResponse {
  const factory PostResponse({
    required int id,

    // ✅ [수정] user_id -> userId (서버가 보내는 키값 확인 필요)
    // 만약 서버가 snake_case 설정을 안 했다면 기본값은 userId입니다.
    @JsonKey(name: 'userId') required int userId,

    required String channel,
    required String category,
    required String title,
    // ✅ [추가] 작성자 정보 받기 (서버 필드명과 일치해야 함 authorNickname)
    @JsonKey(name: 'authorNickname') String? authorNickname,
    @JsonKey(name: 'authorProfileImage') String? authorProfileImage,

    // // ✅ [수정] content_summary -> contentSummary
    // @JsonKey(name: 'contentSummary') String? contentSummary,
    @JsonKey(name: 'content') String? content,

    // ✅ [수정] image_url -> imageUrl
    @JsonKey(name: 'imageUrl') String? imageUrl,

    // ✅ [수정] embedded_content -> embeddedContent
    @JsonKey(name: 'embeddedContent') EmbeddedContent? embeddedContent,

    // ✅ [수정] view_count -> viewCount 등
    @JsonKey(name: 'viewCount') required int viewCount,
    @JsonKey(name: 'likeCount') required int likeCount,
    @JsonKey(name: 'commentCount') required int commentCount,

    // ✅ [수정] created_at -> createdAt
    @JsonKey(name: 'createdAt') required DateTime createdAt,
  }) = _PostResponse;

  factory PostResponse.fromJson(Map<String, dynamic> json) =>
      _$PostResponseFromJson(json);
}
