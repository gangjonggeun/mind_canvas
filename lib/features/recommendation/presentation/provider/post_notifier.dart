import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';

import '../../data/dto/embedded_content.dart';
import '../../data/dto/post_response.dart';
import '../../domain/usecase/community_use_case.dart';

part 'post_notifier.freezed.dart';

part 'post_notifier.g.dart';

// -----------------------------------------------------------------------------
// 📋 State Definition
// -----------------------------------------------------------------------------
@freezed
class PostState with _$PostState {
  const factory PostState({
    @Default(false) bool isLoading, // 로딩 중
    @Default(false) bool isLoadMore, // 추가 로딩 중 (하단 스피너용)
    @Default([]) List<PostResponse> posts, // 게시글 리스트
    String? errorMessage, // 에러 메시지
    // 페이징 관련 상태
    @Default(0) int currentPage,
    @Default(true) bool hasMore, // 다음 페이지가 있는지
    @Default(20) int size, // 페이지 사이즈
    // 현재 필터 상태 (새로고침 시 사용)
    String? currentChannel,
    String? currentCategory,
    String? currentSort,
  }) = _PostState;

  factory PostState.initial() => const PostState();
}

// -----------------------------------------------------------------------------
// 📢 Notifier Implementation
// -----------------------------------------------------------------------------
@Riverpod(keepAlive: true) // 탭 이동해도 스크롤/데이터 유지
class PostNotifier extends _$PostNotifier {
  late final CommunityUseCase _useCase;




  @override
  PostState build() {
    _useCase = ref.watch(communityUseCaseProvider);
    return PostState.initial();
  }


  Future<bool> report(int id, String type) async {
    final useCase = ref.read(communityUseCaseProvider); // 또는 reportUseCaseProvider
    final result = await useCase.reportContent(targetId: id, targetType: type);

    return result.isSuccess; // UI에서 "신고되었습니다" 토스트 띄우기용
  }

  // 사용자 차단
  Future<bool> blockUser(int targetUserId) async {
    // 1. ⚡ [낙관적 업데이트] 해당 유저가 작성한 모든 글을 즉시 UI에서 숨김
    final oldPosts = state.posts;
    final newPosts = oldPosts.where((post) => post.userId != targetUserId).toList();

    state = state.copyWith(posts: newPosts);

    // 2. 서버 요청
    final useCase = ref.read(communityUseCaseProvider);
    final result = await useCase.blockUser(targetUserId);

    // 3. 결과 처리
    if (result.isSuccess) {
      return true; // UI는 이미 반영됨
    } else {
      // 4. 🚨 실패 시 롤백 (차단 실패했으므로 다시 보이게 함)
      // Todo: 여기서 "차단에 실패했습니다" 라는 SnackBar를 띄우도록 UI 쪽에 false 반환
      state = state.copyWith(posts: oldPosts);
      return false;
    }
  }
  Future<bool> deletePost(int postId) async {
    final useCase = ref.read(communityUseCaseProvider);
    final result = await useCase.deletePost(postId);

    // 💡 수정: result.isSuccess가 false여도,
    // 만약 서버의 message가 "삭제되었습니다"라면 성공으로 간주하도록 로직을 넓히세요.
    if (result.isSuccess) {
      print("✅ 서버 삭제 성공 간주 (로컬 리스트 갱신)");

      // 로컬 업데이트 수행
      final currentState = state; // (AsyncNotifier가 아니라 일반 Notifier니까 그냥 state)
      final newPosts = currentState.posts.where((p) => p.id != postId).toList();
      state = currentState.copyWith(posts: newPosts);
      return true;
    }

    print("❌ 서버 삭제 최종 실패: ${result.message}");
    return false;
  }


  /// 🔄 게시글 목록 새로고침 (첫 로드)
  /// - [channel]: 특정 채널 (없으면 전체/자동)
  /// - [sort]: 정렬 (최신순, 인기순 등)
  Future<void> fetchPosts({
    String? channel,
    String? category,
    String? sort,
    bool forceRefresh = false,
  }) async {
    // 이미 데이터가 있고 강제 새로고침이 아니면 패스 (채널이 바뀌었으면 무조건 실행)
    if (state.posts.isNotEmpty &&
        !forceRefresh &&
        state.currentChannel == channel &&
        state.currentSort == sort) {
      return;
    }

    state = state.copyWith(
      isLoading: true,
      posts: forceRefresh ? [] : state.posts,
      currentPage: 0,
      hasMore: true,
      currentChannel: channel,
      currentCategory: category,
      currentSort: sort,
      errorMessage: null,
    );

    // ✅ [핵심 변경] sort가 'TRENDING'이면 트렌딩 API 호출, 아니면 일반 API 호출
    final result = (sort == 'TRENDING')
        ? await _useCase.getTrendingPosts(
            channel: channel, // 👈 추가
            category: category,
            page: 0,
            size: state.size,
          )
        : await _useCase.getPosts(
            channel: channel,
            category: category,
            sort: sort,
            // 'createdAt,desc' or 'likeCount,desc'
            page: 0,
            size: state.size,
          );

    result.fold(
      onSuccess: (pageData) {
        state = state.copyWith(
          isLoading: false,
          posts: pageData.content,
          hasMore: !pageData.last,
          currentPage: pageData.number,
        );
      },
      onFailure: (message, code) {
        state = state.copyWith(isLoading: false, errorMessage: message);
      },
    );
  }

  /// ⬇️ 무한 스크롤: 다음 페이지 불러오기
  Future<void> loadMorePosts() async {
    if (state.isLoading || state.isLoadMore || !state.hasMore) return;

    state = state.copyWith(isLoadMore: true);
    final nextPage = state.currentPage + 1;

    // ✅ [핵심 변경] 무한 스크롤 때도 분기 처리 필요
    final result = (state.currentSort == 'TRENDING')
        ? await _useCase.getTrendingPosts(page: nextPage, size: state.size)
        : await _useCase.getPosts(
            channel: state.currentChannel,
            category: state.currentCategory,
            sort: state.currentSort,
            page: nextPage,
            size: state.size,
          );

    result.fold(
      onSuccess: (pageData) {
        state = state.copyWith(
          isLoadMore: false,
          posts: [...state.posts, ...pageData.content],
          hasMore: !pageData.last,
          currentPage: pageData.number,
        );
      },
      onFailure: (message, code) {
        state = state.copyWith(isLoadMore: false);
      },
    );
  }

  /// ✍️ 게시글 작성
  /// - 성공 시 목록을 새로고침하여 내가 쓴 글이 보이게 함
  Future<bool> createPost({
    required String channel,
    required String title,
    required String content,
    required String category, // "CHAT", "REVIEW" ...
    String? imageUrl,
    EmbeddedContent? embeddedContent,
  }) async {
    state = state.copyWith(isLoading: true);

    final result = await _useCase.createPost(
      channel: channel,
      category: category,
      title: title,
      content: content,
      imageUrl: imageUrl,
      embeddedContent: embeddedContent,
    );

    bool isSuccess = false;

    await result.fold(
      onSuccess: (newPostId) async {
        isSuccess = true;
        // 작성 성공 시 목록 새로고침 (최신순일 경우)
        await fetchPosts(
          channel: state.currentChannel,
          sort: 'createdAt,desc',
          forceRefresh: true,
        );
      },
      onFailure: (message, code) {
        state = state.copyWith(isLoading: false, errorMessage: message);
      },
    );

    return isSuccess;
  }

  Future<void> toggleLike(int postId) async {
    // 1. 현재 리스트에서 해당 포스트 찾기
    final currentPosts = [...state.posts];
    final index = currentPosts.indexWhere((p) => p.id == postId);

    if (index == -1) return; // 없으면 리턴

    final post = currentPosts[index];

    // ⚠️ 주의: 서버 DTO에 'isLiked' 필드가 있어야 완벽함.
    // 현재는 로컬에서만 상태를 뒤집습니다. (기본값 false라고 가정 시)
    // 만약 PostResponse에 isLiked 필드가 없다면, UI에서는 토글될 때마다 상태를 반전시킵니다.
    // 여기서는 로컬 UI만 갱신하기 위해 임시 변수를 씁니다.

    // 2. API 호출
    final result = await _useCase.toggleLike(postId);

    result.fold(
      onSuccess: (isLikedNow) {
        // 3. 성공 시: 서버가 준 최신 상태(isLikedNow)에 맞춰 카운트 업데이트
        // (만약 서버가 bool을 안 준다면 로컬에서 계산)

        final newLikeCount = isLikedNow
            ? post.likeCount + 1
            : (post.likeCount > 0 ? post.likeCount - 1 : 0);

        final updatedPost = post.copyWith(
          isLiked: isLikedNow, // DTO에 필드 추가 권장
          likeCount: newLikeCount,
        );

        currentPosts[index] = updatedPost;

        // 상태 업데이트 (화면 갱신)
        state = state.copyWith(posts: currentPosts);
      },
      onFailure: (msg, code) {
        // 실패 시 에러 메시지 (원상복구 로직은 생략함)
        print("좋아요 실패: $msg");
      },
    );
  }
}
