import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/auth/token_manager.dart';
import '../../../../core/auth/token_manager_provider.dart';
import '../../../../core/network/api_response_dto.dart';
import '../../../../core/network/page_response.dart';
import '../../../../core/utils/result.dart';

import '../../domain/repository/community_repository.dart';
import '../data_source/community_data_source.dart';
import '../dto/channel_recommendation_response.dart';
import '../dto/comment_request.dart';
import '../dto/comment_response.dart';
import '../dto/create_post_request.dart';
import '../dto/embedded_content.dart';
import '../dto/post_response.dart';
import '../dto/report_request.dart';

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

  @override
  Future<Result<void>> leaveChannel({required String channel}) async {
    return _safeCall(() async {
      final token = await _getTokenOrThrow();
      return await _dataSource.leaveChannel(token, channel);
    });
  }

  @override
  Future<Result<void>> reportContent({
    required int targetId,
    required String targetType,
    required String reason,
  }) async {
    return _safeCall(() async {
      final token = await _getTokenOrThrow();
      final request = ReportRequest(
        targetId: targetId,
        targetType: targetType,
        reason: reason,
      );
      return await _dataSource.reportContent(token, request);
    });
  }

  @override
  Future<Result<void>> blockUser({required int userId}) async {
    return _safeCall(() async {
      final token = await _getTokenOrThrow();
      return await _dataSource.blockUser(token, userId);
    });
  }

  @override
  Future<Result<PageResponse<CommentResponse>>> getComments({
    required int postId, // 👈 인터페이스와 동일하게 required named parameter로 변경
    required int page,
    required int size,
  }) async {
    return _safeCall(() async {
      // print('💬 [Repo] 댓글 목록 요청: postId=$postId, page=$page');
      final token = await _getTokenOrThrow();

      // DataSource 호출
      return await _dataSource.getComments(
          token,
          postId,
          page: page,
          size: size
      );
    });
  }

  @override
  Future<Result<int>> createComment({
    required int postId,
    required String content
  }) async {
    return _safeCall(() async {
      // print('✍️ [Repo] 댓글 작성: postId=$postId');
      final token = await _getTokenOrThrow();

      // Request DTO가 필요하다면 여기서 변환, 아니면 DataSource가 String을 받도록 설정
      // 여기서는 DataSource가 CommentRequest를 받는다고 가정 (이전 코드 기반)
      final request = CommentRequest(content: content);

      return await _dataSource.createComment(token, postId, request);
    });
  }

  @override
  Future<Result<void>> deleteComment({required int commentId}) async {
    return _safeCall(() async {
      // print('🗑️ [Repo] 댓글 삭제: commentId=$commentId');
      final token = await _getTokenOrThrow();

      // DataSource에 deleteComment 메서드가 있어야 함 (아래 3번 참조)
      return await _dataSource.deleteComment(token, commentId);
    });
  }
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
  Future<Result<void>> deletePost({required int postId}) async {
    return _safeCallEmpty(() async {
      final token = await _getTokenOrThrow();
      return await _dataSource.deletePost(token, postId);
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
  Future<Result<T>> _safeCall<T>(Future<ApiResponse<T>> Function() call) async {
    try {
      final response = await call();

      // 💡 핵심: success가 true면 무조건 성공 처리
      if (response.success) {
        // data가 null이라도 Result.success를 호출하게 함
        return Result.success(response.data as T);
      } else {
        // 서버가 success=false를 보낸 경우
        return Result.failure(response.errorMessage ?? '알 수 없는 오류', response.errorCode);
      }
    } on DioException catch (e) {
      return _handleDioException<T>(e);
    } catch (e) {
      return Result.failure('알 수 없는 오류: $e');
    }
  }
  Future<Result<void>> _safeCallEmpty(Future<ApiResponse<dynamic>> Function() call) async {
    try {
      final response = await call();
      if (response.success) {
        return Result.successEmpty(); // 아까 만든 데이터 없는 성공 메서드
      } else {
        return Result.failure(response.errorMessage ?? '삭제 실패', response.errorCode);
      }
    } catch (e) {
      return Result.failure('오류: $e');
    }
  }

  Result<T> _handleDioException<T>(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return Result.failure('서버 연결 시간이 초과되었습니다. (Server connection timed out)', 'TIMEOUT');
    }

    if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data; // 👈 서버에서 보낸 JSON 바디

      // ✅ 1. 서버 JSON에서 에러 메시지와 코드 추출
      String? serverMessage;
      String? serverCode;

      if (responseData is Map<String, dynamic>) {
        // 서버의 응답 포맷에 맞춰 안전하게 추출 ("errorMessage" 또는 "error.message")
        serverMessage = responseData['errorMessage'] ?? responseData['error']?['message'];
        serverCode = responseData['errorCode'] ?? responseData['error']?['code'];
      }

      // ✅ 2. 다국어 지원을 위한 커스텀 분기 처리 (Hardcoding Message 감지)
      if (serverMessage != null && serverMessage.contains('성격 유형에 맞는')) {
        // 내부용 에러 코드를 'CHANNEL_MISMATCH'로 강제 할당
        // UI 쪽에서 Result.code == 'CHANNEL_MISMATCH' 이면 다국어 번역팩(tr('error.channel_mismatch')) 출력
        return Result.failure('성격 유형에 맞는 채널에만 글을 작성할 수 있습니다. (You can only post in channels that match your personality type)', 'CHANNEL_MISMATCH');
      }

      // ✅ 3. 기본 상태 코드별 분기
      switch (statusCode) {
        case 401:
          return Result.failure(serverMessage ?? '인증이 만료되었습니다. (Authentication expired)', serverCode ?? 'AUTHENTICATION_EXPIRED');
        case 403:
          return Result.failure(serverMessage ?? '접근 권한이 없습니다. (Access denied)', serverCode ?? 'FORBIDDEN');
        case 404:
          return Result.failure(serverMessage ?? '요청한 데이터를 찾을 수 없습니다. (Resource not found)', serverCode ?? 'NOT_FOUND');
        case 500:
        // 💡 500 에러여도 서버가 준 메시지가 있다면 그걸 보여줍니다! (예: "서버 내부 오류...")
          return Result.failure(serverMessage ?? '서버 오류가 발생했습니다. (Internal server error)', serverCode ?? 'SERVER_ERROR');
        default:
          return Result.failure(serverMessage ?? '통신 오류 Communication error: ($statusCode)', serverCode ?? 'HTTP_ERROR');
      }
    }

    if (e.error.toString().contains('SocketException')) {
      return Result.failure('인터넷 연결을 확인해주세요. (Please check your internet connection)', 'NETWORK_DISCONNECTED');
    }

    return Result.failure('네트워크 오류가 발생했습니다. (A network error occurred)', 'NETWORK_ERROR');
  }


}