import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/page_response.dart';
import '../../data/dto/comment_response.dart';
import '../../domain/usecase/community_use_case.dart';

part 'comment_notifier.g.dart';

// ✅ 1. 무한 스크롤 상태를 관리할 State 클래스
class CommentState {
  final List<CommentResponse> comments;
  final bool isLoading;
  final bool isLoadMore;
  final int page;
  final bool hasMore;

  CommentState({
    this.comments = const [],
    this.isLoading = true,
    this.isLoadMore = false,
    this.page = 0,
    this.hasMore = true,
  });

  CommentState copyWith({
    List<CommentResponse>? comments,
    bool? isLoading,
    bool? isLoadMore,
    int? page,
    bool? hasMore,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

// 🔥 postId를 파라미터로 받는 Family Provider
@riverpod
class CommentNotifier extends _$CommentNotifier {
  @override
  CommentState build(int postId) {
    // 초기 상태 반환 후 데이터 비동기 로드
    Future.microtask(() => fetchComments());
    return CommentState();
  }

  /// 🔄 초기 데이터 및 새로고침
  Future<void> fetchComments() async {
    state = state.copyWith(isLoading: true, page: 0, hasMore: true);

    final useCase = ref.read(communityUseCaseProvider);
    final result = await useCase.getComments(postId: postId, page: 0);

    result.fold(
      onSuccess: (pageResponse) {
        state = state.copyWith(
          comments: pageResponse.content,
          isLoading: false,
          hasMore: !pageResponse.last, // 서버에서 last 여부 혹은 totalPages를 준다고 가정
        );
      },
      onFailure: (msg, code) {
        state = state.copyWith(isLoading: false);
        // 에러 처리 로직
      },
    );
  }

  /// ⬇️ 다음 페이지 로드 (무한 스크롤)
  Future<void> loadMore() async {
    // 로딩중이거나 더 가져올 데이터가 없으면 중단
    if (state.isLoading || state.isLoadMore || !state.hasMore) return;

    state = state.copyWith(isLoadMore: true);
    final nextPage = state.page + 1;

    final useCase = ref.read(communityUseCaseProvider);
    final result = await useCase.getComments(postId: postId, page: nextPage);

    result.fold(
      onSuccess: (pageResponse) {
        state = state.copyWith(
          comments: [...state.comments, ...pageResponse.content], // 기존 댓글에 추가
          isLoadMore: false,
          page: nextPage,
          hasMore: !pageResponse.last,
        );
      },
      onFailure: (msg, code) {
        state = state.copyWith(isLoadMore: false);
      },
    );
  }

  /// ✍️ 댓글 작성
  Future<bool> createComment(String content) async {
    if (content.trim().isEmpty) return false;

    final useCase = ref.read(communityUseCaseProvider);
    final result =
        await useCase.createComment(postId: postId, content: content);

    return result.fold(
      onSuccess: (_) {
        // 작성 성공 시 최신 목록을 보기 위해 0페이지부터 다시 불러옴
        fetchComments();
        return true;
      },
      onFailure: (msg, code) {
        print("댓글 작성 실패: $msg");
        return false;
      },
    );
  }
  Future<bool> deleteComment(int commentId) async {
    final oldComments = state.comments;

    // 1. 낙관적 업데이트
    final newComments = oldComments.where((c) => c.id != commentId).toList();

    print("📝 [낙관적 업데이트] 댓글 삭제 시도 ID: $commentId");
    state = state.copyWith(comments: newComments);

    // 2. 서버 요청
    final useCase = ref.read(communityUseCaseProvider);
    final result = await useCase.deleteComment(commentId: commentId);

    if (result.isSuccess)  {
      print("✅ [서버 댓글 삭제 성공] ID: $commentId");
      return true;
    } else {
      print("❌ [서버 댓글 삭제 실패] ID: $commentId");
      state = state.copyWith(comments: oldComments);
      return false;
    }
  }
}
