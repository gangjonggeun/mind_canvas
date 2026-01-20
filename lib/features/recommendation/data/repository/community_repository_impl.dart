import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/auth/token_manager.dart';
import '../../../../core/auth/token_manager_provider.dart';
import '../../../../core/network/page_response.dart';
import '../../../../core/utils/result.dart';

import '../../domain/repository/community_repository.dart';
import '../data_source/community_data_source.dart';
import '../dto/channel_recommendation_response.dart';
import '../dto/create_post_request.dart';
import '../dto/embedded_content.dart';
import '../dto/post_response.dart';

part 'community_repository_impl.g.dart';

// ==========================================================
// ⚡ Riverpod Provider
// ==========================================================
@riverpod
CommunityRepository communityRepository(CommunityRepositoryRef ref) {
  final dataSource = ref.watch(communityDataSourceProvider);
  final tokenManager = ref.watch(tokenManagerProvider);

  return CommunityRepositoryImpl(dataSource, tokenManager);
}

// ==========================================================
// 🛠️ Repository Implementation
// ==========================================================
class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityDataSource _dataSource;
  final TokenManager _tokenManager;

  CommunityRepositoryImpl(this._dataSource, this._tokenManager);

  // ------------------------------------------------------------------------
  // 📝 게시글 관련
  // ------------------------------------------------------------------------
  @override
  Future<Result<bool>> toggleLike(int postId) async {
    return _safeCall(() async {
      // print('❤️ [Repo] 좋아요 토글 요청: id=$postId');
      final token = await _getTokenOrThrow();
      return await _dataSource.toggleLike(token, postId);
    });
  }
  @override
  Future<Result<PageResponse<PostResponse>>> getPosts({
    String? channel,
    String? category,
    String? sort,
    int page = 0,
    int size = 20,
  }) async {
    return _safeCall(() async {
      print('🚀 [Repo] 게시글 목록 요청: channel=$channel, sort=$sort, page=$page');

      final token = await _getTokenOrThrow();
      final response = await _dataSource.getPosts(
        token,
        channel: channel,
        category: category,
        sort: sort,
        page: page,
        size: size,
      );

      return response;
    });
  }

  @override
  Future<Result<PageResponse<PostResponse>>> getTrendingPosts({
    String? channel,
    String? category,
    int page = 0,
    int size = 10,
  }) async {
    return _safeCall(() async {
      print('🔥 [Repo] 트렌딩 요청: page=$page');

      final token = await _getTokenOrThrow();
      final response = await _dataSource.getTrendingPosts(
        channel,
        category,
        token,
        page: page,
        size: size,
      );

      return response;
    });
  }

  @override
  Future<Result<PostResponse>> getPostDetail(int id) async {
    return _safeCall(() async {
      print('📄 [Repo] 게시글 상세 요청: id=$id');

      final token = await _getTokenOrThrow();
      final response = await _dataSource.getPostDetail(token, id);

      return response;
    });
  }

  @override
  Future<Result<int>> createPost({
    String? channel,
    required String category,
    required String title,
    required String content,
    String? imageUrl,
    EmbeddedContent? embeddedContent,
  }) async {
    return _safeCall(() async {
      print('✍️ [Repo] 게시글 작성 시도: title=$title');

      final token = await _getTokenOrThrow();

      // Request DTO 생성
      final request = CreatePostRequest(
        channel: channel,
        category: category,
        title: title,
        content: content,
        imageUrl: imageUrl,
        embeddedContent: embeddedContent,
      );

      final response = await _dataSource.createPost(token, request);

      return response;
    });
  }

  // ------------------------------------------------------------------------
  // 🏘️ 채널 관련
  // ------------------------------------------------------------------------

  @override
  Future<Result<List<ChannelRecommendationResponse>>> getRecommendedChannels() async {
    return _safeCall(() async {
      print('🏘️ [Repo] 추천 채널 목록 요청');
      final token = await _getTokenOrThrow();
      return await _dataSource.getRecommendedChannels(token);
    });
  }

  @override
  Future<Result<List<ChannelRecommendationResponse>>> getMyChannels() async {
    return _safeCall(() async {
      print('📂 [Repo] 내 채널 목록 요청');
      final token = await _getTokenOrThrow();
      return await _dataSource.getMyChannels(token);
    });
  }

  @override
  Future<Result<String>> joinChannel(String channel) async {
    return _safeCall(() async {
      print('➕ [Repo] 채널 참여 요청: $channel');
      final token = await _getTokenOrThrow();
      return await _dataSource.joinChannel(token, channel);
    });
  }

  // ==========================================================
  // 🔒 Internal Helper Methods
  // ==========================================================

  /// 토큰 획득 실패 시 Exception을 던져서 _safeCall의 catch에서 잡도록 함
  Future<String> _getTokenOrThrow() async {
    final validToken = await _tokenManager.getValidAccessToken();
    if (validToken == null) {
      throw Exception('AUTHENTICATION_REQUIRED');
    }
    return validToken;
  }

  /// 공통 try-catch 래퍼 (코드 중복 방지)
  Future<Result<T>> _safeCall<T>(Future<dynamic> Function() apiCall) async {
    try {
      final response = await apiCall();

      // ✅ [수정] data가 없더라도 success가 true면 성공으로 처리
      // (특히 joinChannel 처럼 응답 데이터 없이 메시지만 오는 경우 대응)
      if (response.success) {

        // 데이터가 있으면 반환
        if (response.data != null) {
          return Result.success(response.data as T);
        }

        // 데이터가 없는데 T가 String이면 message라도 반환 (joinChannel 대응)
        if (T == String) {
          return Result.success(response.message as T);
        }

        // 데이터가 꼭 필요한데 없으면 에러 (Post 목록 등)
        // 하지만 void나 bool, String 응답인 경우는 위에서 처리됨
        return Result.failure('데이터가 없습니다.', 'NO_DATA');
      } else {
        // 실패 처리
        print('❌ [Repo] API 실패 응답: ${response.message}');
        return Result.failure(response.message ?? '요청 실패', response.error?.code);
      }

    } on Exception catch (e) {
      // 'AUTHENTICATION_REQUIRED' 예외 처리
      if (e.toString().contains('AUTHENTICATION_REQUIRED')) {
        return Result.failure('로그인이 필요한 서비스입니다.', 'AUTHENTICATION_REQUIRED');
      }

      if (e is DioException) {
        print('🔥 [Repo] Dio 에러: ${e.message}');
        return _handleDioException(e);
      }

      print('💀 [Repo] 알 수 없는 에러: $e');
      return Result.failure('알 수 없는 오류가 발생했습니다.', 'UNKNOWN_ERROR');
    }
  }

  /// 🛠️ 공통 DioException 핸들러
  Result<T> _handleDioException<T>(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return Result.failure('서버 연결 시간이 초과되었습니다.', 'TIMEOUT');
    }

    if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      switch (statusCode) {
        case 401:
          return Result.failure('인증이 만료되었습니다.', 'AUTHENTICATION_EXPIRED');
        case 403:
          return Result.failure('접근 권한이 없습니다.', 'FORBIDDEN');
        case 404:
          return Result.failure('요청한 데이터를 찾을 수 없습니다.', 'NOT_FOUND');
        case 500:
          return Result.failure('서버 오류가 발생했습니다.', 'SERVER_ERROR');
        default:
          return Result.failure('통신 오류 ($statusCode)', 'HTTP_ERROR');
      }
    }

    if (e.error.toString().contains('SocketException')) {
      return Result.failure('인터넷 연결을 확인해주세요.', 'NETWORK_DISCONNECTED');
    }

    return Result.failure('네트워크 오류가 발생했습니다.', 'NETWORK_ERROR');
  }
}