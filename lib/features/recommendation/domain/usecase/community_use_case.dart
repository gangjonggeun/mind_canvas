import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/page_response.dart';
import '../../../../core/utils/result.dart';

import '../../data/dto/channel_recommendation_response.dart';
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

  // ===========================================================================
  // 🏘️ 채널 관련
  // ===========================================================================

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
