import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/presentation/notifier/user_notifier.dart';
import '../../data/dto/comment_response.dart';
import '../../data/dto/post_response.dart';
import '../../domain/usecase/community_use_case.dart';
import '../provider/comment_notifier.dart';
import '../widgets/post_card.dart';
import 'community_action_helper.dart';

class PostDetailBottomSheet extends ConsumerStatefulWidget {
  final PostResponse post;

  const PostDetailBottomSheet({super.key, required this.post});

  /// 외부에서 호출하기 쉬운 static 메서드
  static void show(BuildContext context, PostResponse post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => PostDetailBottomSheet(post: post),
    );
  }

  @override
  ConsumerState<PostDetailBottomSheet> createState() =>
      _PostDetailBottomSheetState();
}

class _PostDetailBottomSheetState extends ConsumerState<PostDetailBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSubmitting = false;

  late int _localViewCount;

  @override
  void initState() {
    super.initState();
    _localViewCount = widget.post.viewCount; // 초기값

    // 1. 해당 게시글의 댓글 데이터 페칭 (provider 필요)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(commentNotifierProvider(widget.post.id).notifier)
          .fetchComments();
    });

    // 2. 무한 스크롤 리스너
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        ref.read(commentNotifierProvider(widget.post.id).notifier).loadMore();
      }
    });
    // _increaseViewCount();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSubmitting = true); // 시큐어 코딩: 중복 전송 방지

    final result = await ref.read(communityUseCaseProvider).createComment(
          postId: widget.post.id,
          content: text,
        );

    // 댓글 생성 성공 시 리스트 갱신 및 입력창 초기화
    if (result.isSuccess) {
      _commentController.clear();
      ref
          .read(commentNotifierProvider(widget.post.id).notifier)
          .fetchComments();
      FocusScope.of(context).unfocus(); // 키보드 내리기
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('댓글 작성 실패')));
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    // 댓글 상태 구독
    final commentState = ref.watch(commentNotifierProvider(widget.post.id));
    final bottomInset = MediaQuery.of(context).viewInsets.bottom; // 키보드 높이

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (_, __) {
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset), // 키보드 올라올 때 대응
          child: Column(
            children: [
              // 핸들바
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // 앱바 영역
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ✅ [수정] 조회수와 댓글 수를 묶어서 왼쪽에 배치
                    Row(
                      children: [
                        // 1. 조회수 (아이콘 + 숫자)
                        Text(
                          '조회수 ${_formatCount(widget.post.viewCount)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        // 2. 구분선 (조그만 점이나 세로선)
                        const SizedBox(width: 10),
                        Container(
                          width: 1,
                          height: 12,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(width: 10),

                        // 3. 댓글 수
                        Text(
                          '댓글 ${widget.post.commentCount}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    // 닫기 버튼 (오른쪽 고정)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
              const Divider(height: 1),

              // 스크롤 영역 (게시글 본문 + 댓글 목록)
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // 게시글 원본 (옵션: 댓글 창에서 게시글 본문도 보여줄 경우)
                    // SliverToBoxAdapter(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(16.0),
                    //     child: Text(widget.post.content ?? '', style: const TextStyle(fontSize: 15)),
                    //   ),
                    // ),
                    // const SliverToBoxAdapter(child: Divider(thickness: 8, color: Color(0xFFF5F5F5))),
                    SliverToBoxAdapter(
                      child: PostCard(
                        post: widget.post,
                        isDetailMode: true,
                      ),
                    ),

                    //구분선
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5), // 상하 5dp 패딩
                        child: Divider(thickness: 8, color: Color(0xFFF5F5F5)),
                      ),
                    ),

                    // 댓글 목록
                    if (commentState.isLoading && commentState.comments.isEmpty)
                      const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()))
                    else if (commentState.comments.isEmpty)
                      const SliverFillRemaining(
                          child: Center(child: Text("첫 댓글을 남겨보세요!")))
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final comment = commentState.comments[index];
                            return _buildCommentTile(comment);
                          },
                          childCount: commentState.comments.length,
                        ),
                      ),

                    // 무한스크롤 로딩 인디케이터
                    if (commentState.isLoadMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                  ],
                ),
              ),

              // 댓글 입력 필드 (SafeArea로 하단 노치 대응)
              SafeArea(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border(top: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          maxLength: 300, // 시큐어 코딩: 길이 제한
                          decoration: InputDecoration(
                            hintText: '댓글을 입력하세요...',
                            counterText: '',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _isSubmitting
                          ? const CircularProgressIndicator()
                          : IconButton(
                              icon: const Icon(Icons.send,
                                  color: Colors.blueAccent),
                              onPressed: _submitComment,
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatCount(int count) {
    if (count < 1000) return '$count';
    if (count < 10000) return '${(count / 1000).toStringAsFixed(1)}k'; // 1.2k
    return '${(count / 10000).toStringAsFixed(1)}만'; // 1.5만
  }

  // 개별 댓글 위젯
  Widget _buildCommentTile(CommentResponse comment) {
    // final myId = ref.watch(userNotifierProvider)?.id ?? -1;
    // final bool isMine = (comment.userId == myId) || comment.isMyComment;

    final timeAgo = _getTimeAgo(comment.createdAt);

    print(comment.isMyComment);

    return ListTile(
      key: ValueKey('comment_${comment.id}'),
      leading: CircleAvatar(
        backgroundImage: comment.authorProfileImage != null
            ? NetworkImage(comment.authorProfileImage!)
            : null,
        child: comment.authorProfileImage == null
            ? const Icon(Icons.person)
            : null,
      ),
      title: Row(
        children: [
          Text(comment.authorNickname,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(width: 8),
          Text(timeAgo,
              style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(comment.content,
            style: const TextStyle(color: Colors.black87)),
      ),

      // ✅ [수정] 내 댓글이면 삭제, 남의 댓글이면 신고 표시
      trailing: IconButton(
        icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
        onPressed: () {
          // 💡 context를 다이얼로그 안으로 안전하게 전달
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (comment.isMyComment)
                    ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: const Text('삭제하기', style: TextStyle(color: Colors.red)),
                      onTap: () async {
                        Navigator.pop(ctx); // 다이얼로그 먼저 닫기 (이러면 컨텍스트 꼬일 일 없음)

                        // 로직 실행
                        final messenger = ScaffoldMessenger.of(context);
                        final success = await ref
                            .read(commentNotifierProvider(widget.post.id).notifier)
                            .deleteComment(comment.id);

                        if (!context.mounted) return;

                        if (success) {
                          messenger.showSnackBar(const SnackBar(content: Text('댓글이 삭제되었습니다.')));
                        }
                      },
                    )
                  else
                    ListTile(
                      leading: const Icon(Icons.report),
                      title: const Text('신고하기'),
                      onTap: () {
                        Navigator.pop(ctx);
                        // 신고 로직 호출
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getTimeAgo(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final diff = DateTime.now().difference(dateTime);
      if (diff.inMinutes < 1) return '방금 전';
      if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
      if (diff.inHours < 24) return '${diff.inHours}시간 전';
      return '${diff.inDays}일 전';
    } catch (e) {
      return '방금 전'; // 파싱 실패 시 기본값
    }
  }
}
