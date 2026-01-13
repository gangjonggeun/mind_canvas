// lib/features/community/data/dtos/community_dtos.dart

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/enums/community_enums.dart';
import 'embedded_content.dart';


part 'create_post_request.freezed.dart';
part 'create_post_request.g.dart';

// ------------------------------------------------------------------
// 1. 게시글 작성 요청 (Request)
// ------------------------------------------------------------------
@freezed
class CreatePostRequest with _$CreatePostRequest {
  const factory CreatePostRequest({
    // 채널이 null이면 서버가 알아서 자동 배정하므로 nullable
    ChannelType? channel,
    required PostCategory category,
    required String title,
    required String content,

    // 리스트에서 단일 String으로 변경됨
    @JsonKey(name: 'image_url') String? imageUrl,

    @JsonKey(name: 'embedded_content') EmbeddedContent? embeddedContent,
  }) = _CreatePostRequest;

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);
}