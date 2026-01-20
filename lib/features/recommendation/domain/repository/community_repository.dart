import '../../../../core/network/page_response.dart';
import '../../../../core/utils/result.dart';
import '../../data/dto/channel_recommendation_response.dart';
import '../../data/dto/embedded_content.dart';
import '../../data/dto/post_response.dart';


abstract class CommunityRepository {
  /// 📝 게시글 목록 조회 (일반 + 정렬)
  Future<Result<PageResponse<PostResponse>>> getPosts({
    String? channel,
    String? category,
    String? sort, // "createdAt,desc" or "likeCount,desc"
    int page = 0,
    int size = 20,
  });
  Future<Result<bool>> toggleLike(int postId);
  /// 🔥 트렌딩(실시간 인기글) 조회
  Future<Result<PageResponse<PostResponse>>> getTrendingPosts({
    String? channel,
    String? category,
    int page = 0,
    int size = 10,
  });

  /// 📄 게시글 상세 조회
  Future<Result<PostResponse>> getPostDetail(int id);

  /// ✍️ 게시글 작성
  Future<Result<int>> createPost({
    String? channel,
    required String category,
    required String title,
    required String content,
    String? imageUrl,
    EmbeddedContent? embeddedContent,
  });

  /// 🏘️ 추천 채널 목록 조회
  Future<Result<List<ChannelRecommendationResponse>>> getRecommendedChannels();

  /// 📂 내 채널 목록 조회
  Future<Result<List<ChannelRecommendationResponse>>> getMyChannels();

  /// ➕ 채널 참여하기
  Future<Result<String>> joinChannel(String channel);
}