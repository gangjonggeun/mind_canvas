// lib/features/community/data/data_sources/community_data_source.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_response_dto.dart'; // 프로젝트 공통 ApiResponse
import '../../../../core/network/dio_provider.dart';
import '../../../../core/network/page_response.dart';
import '../dto/channel_recommendation_response.dart';
import '../dto/create_post_request.dart';
import '../dto/post_response.dart';


part 'community_data_source.g.dart';

@riverpod
CommunityDataSource communityDataSource(CommunityDataSourceRef ref) {
  final dio = ref.watch(dioProvider);
  // baseUrl은 Dio 설정 혹은 여기에서 지정
  return CommunityDataSource(dio);
}

@RestApi()
abstract class CommunityDataSource {
  factory CommunityDataSource(Dio dio, {String baseUrl}) = _CommunityDataSource;

  // ===========================================================================
  // 📝 게시글 관련 (CommunityController)
  // ===========================================================================

  /// 1. 게시글 목록 조회
  /// - [channel]: 특정 채널 (없으면 서버가 자동 배정)
  /// - [category]: 카테고리 필터
  /// - [page], [size], [sort]: 페이징 (예: sort=createdAt,desc)
  @GET('/community/posts')
  Future<ApiResponse<PageResponse<PostResponse>>> getPosts(
      @Header('Authorization') String token, {
        @Query('channel') String? channel,
        @Query('category') String? category,
        @Query('page') int page = 0,
        @Query('size') int size = 20,
        @Query('sort') String? sort, // 예: "createdAt,desc" or "likeCount,desc"
      });

  /// 2. 트렌딩(인기글) 조회
  @GET('/community/trending')
  Future<ApiResponse<PageResponse<PostResponse>>> getTrendingPosts(
      @Header('Authorization') String token, {
        @Query('page') int page = 0,
        @Query('size') int size = 10,
      });

  /// 3. 게시글 상세 조회
  @GET('/community/posts/{id}')
  Future<ApiResponse<PostResponse>> getPostDetail(
      @Header('Authorization') String token,
      @Path('id') int id,
      );

  /// 4. 게시글 작성
  @POST('/community/posts')
  Future<ApiResponse<int>> createPost(
      @Header('Authorization') String token,
      @Body() CreatePostRequest request,
      );

  // ===========================================================================
  // 🏘️ 채널 관련 (ChannelController)
  // ===========================================================================

  /// 5. 추천 채널 목록 ("당신을 위한 커뮤니티")
  @GET('/community/channels/recommendations')
  Future<ApiResponse<List<ChannelRecommendationResponse>>> getRecommendedChannels(
      @Header('Authorization') String token,
      );

  /// 6. 내가 참여중인 채널 목록 ("내 채널")
  @GET('/community/channels/my')
  Future<ApiResponse<List<ChannelRecommendationResponse>>> getMyChannels(
      @Header('Authorization') String token,
      );

  /// 7. 채널 참여하기
  @POST('/community/channels/{channel}/join')
  Future<ApiResponse<String>> joinChannel(
      @Header('Authorization') String token,
      @Path('channel') String channel, // 여기도 String
      );

  @POST('/community/posts/{id}/like')
  Future<ApiResponse<bool>> toggleLike(
      @Header('Authorization') String token,
      @Path('id') int id,
      );
}