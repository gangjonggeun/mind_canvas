import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/page_response.dart';
import '../../../../core/utils/result.dart';

import '../../data/dto/channel_recommendation_response.dart';
import '../../data/dto/comment_response.dart';
import '../../data/dto/embedded_content.dart';
import '../../data/dto/post_response.dart';
import '../../data/repository/community_repository_impl.dart';
import '../repository/community_repository.dart';

part 'community_use_case.g.dart';

@riverpod
CommunityUseCase communityUseCase(CommunityUseCaseRef ref) {
  return CommunityUseCase(ref.watch(communityRepositoryProvider));
}

class CommunityUseCase {
  final CommunityRepository _repository;

  CommunityUseCase(this._repository);

  // ===========================================================================
  // 📝 게시글 관련
  // ===========================================================================
  Future<Result<void>> reportContent({
    required int targetId,
    required String targetType, // 'POST' 또는 'COMMENT'
    String reason = 'INAPPROPRIATE_CONTENT', // 기본 사유
  }) {
    return _repository.reportContent(
      targetId: targetId,
      targetType: targetType,
      reason: reason,
    );
  }

  /// 🚫 사용자 차단하기
  Future<Result<void>> blockUser(int userId) {
    return _repository.blockUser(userId: userId);
  }

  /// 💬 댓글 목록 조회
  Future<Result<PageResponse<CommentResponse>>> getComments({
    required int postId,
    int page = 0,
    int size = 20,
  }) {
    // Repository에 getComments 메서드가 추가되었다고 가정 (아래 설명 참조)
    return _repository.getComments(postId: postId, page: page, size: size);
  }

  /// ✍️ 댓글 작성
  Future<Result<void>> createComment({
    required int postId,
    required String content,
  }) {
    // Repository 호출 (DTO 변환은 여기서 하거나 Repo에서 하거나 선택)
    // 여기서는 String -> Request DTO 변환 없이 Repo 인터페이스가 String을 받는다고 가정했을 때
    // 만약 Repo가 DTO를 원하면 여기서 변환:
    // return _repository.createComment(postId, CommentRequest(content: content));

    // 기존 CommunityRepositoryImpl 참고하여 String content로 넘김
    return _repository.createComment(postId: postId, content: content);
  }

  /// 🗑️ 댓글 삭제
  Future<Result<void>> deleteComment({
    required int commentId,
  }) {
    return _repository.deleteComment(commentId: commentId);
  }

  /// 게시글 목록 조회 (채널별, 카테고리별, 정렬별)
  Future<Result<PageResponse<PostResponse>>> getPosts({
    String? channel,
    String? category,
    String? sort,
    int page = 0,
    int size = 20,
  }) {
    return _repository.getPosts(
      channel: channel,
      category: category,
      sort: sort,
      page: page,
      size: size,
    );
  }

  /// 트렌딩(실시간 인기글) 조회
  Future<Result<PageResponse<PostResponse>>> getTrendingPosts({
    String? channel, // ✅ 추가
    String? category, // ✅ 추가
    int page = 0,
    int size = 10,
  }) {
    return _repository.getTrendingPosts(
      channel: channel,
      category: category,
      page: page,
      size: size,
    );
  }

  /// 게시글 작성
  Future<Result<int>> createPost({
    String? channel,
    required String category,
    required String title,
    required String content,
    String? imageUrl,
    EmbeddedContent? embeddedContent,
  }) {
    return _repository.createPost(
      channel: channel,
      category: category,
      title: title,
      content: content,
      imageUrl: imageUrl,
      embeddedContent: embeddedContent,
    );
  }
  Future<Result<void>> deletePost(int postId) {
    return _repository.deletePost(postId: postId);
  }

  // ===========================================================================
  // 🏘️ 채널 관련
  // ===========================================================================
  Future<Result<void>> leaveChannel(String channel) {
    return _repository.leaveChannel(channel: channel);
  }
  /// 추천 채널 목록
  Future<Result<List<ChannelRecommendationResponse>>> getRecommendedChannels() {
    return _repository.getRecommendedChannels();
  }

  /// 내 채널 목록
  Future<Result<List<ChannelRecommendationResponse>>> getMyChannels() {
    return _repository.getMyChannels();
  }

  /// 채널 참여
  Future<Result<String>> joinChannel(String channel) {
    return _repository.joinChannel(channel);
  }

  Future<Result<bool>> toggleLike(int postId) {
    return _repository.toggleLike(postId);
  }
}
