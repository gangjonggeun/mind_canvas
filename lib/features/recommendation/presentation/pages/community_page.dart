import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/dto/embedded_content.dart';
import '../../data/dto/post_response.dart';
import '../provider/channel_notifier.dart';
import '../provider/post_notifier.dart';
import 'create_post_page.dart'; // 날짜 포맷팅용

// Import 경로를 프로젝트에 맞게 수정해주세요


class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({super.key});

  @override
  ConsumerState<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 1. 스크롤 리스너 등록 (무한 스크롤)
    _scrollController.addListener(_onScroll);

    // 2. 초기 데이터 로드 (프레임 렌더링 후 실행)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 채널 목록 로드
      ref.read(channelNotifierProvider.notifier).loadChannels();
      // 게시글 목록 로드 (기본: 전체/최신순)
      ref.read(postNotifierProvider.notifier).fetchPosts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // 바닥에 닿기 200px 전 로드
      ref.read(postNotifierProvider.notifier).loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white, // 인스타 스타일 깔끔한 흰색 배경
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'MindCanvas', // 로고나 앱 이름
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Billabong', // 인스타 느낌 폰트 예시 (없으면 생략)
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // TODO: 검색 화면 이동
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              // TODO: 알림 화면 이동
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // 현재 필터 상태 유지하며 새로고침
          await ref.read(postNotifierProvider.notifier).fetchPosts(
            channel: postState.currentChannel,
            sort: postState.currentSort,
            forceRefresh: true,
          );
        },
        color: Colors.black,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // 1. 상단 채널 바 (Instagram Stories 스타일)
            const SliverToBoxAdapter(
              child: _ChannelBarSection(),
            ),

            // 2. 정렬 및 필터 바
            SliverToBoxAdapter(
              child: _FilterBar(
                currentSort: postState.currentSort,
                onSortChanged: (sort) {
                  ref.read(postNotifierProvider.notifier).fetchPosts(
                    channel: postState.currentChannel,
                    sort: sort,
                    forceRefresh: true, // 정렬 바뀌면 새로고침
                  );
                },
              ),
            ),

            // 3. 게시글 리스트
            if (postState.isLoading && postState.posts.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: Colors.black)),
              )
            else if (postState.errorMessage != null && postState.posts.isEmpty)
              SliverFillRemaining(
                child: Center(child: Text(postState.errorMessage!)),
              )
            else if (postState.posts.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: Text("아직 게시글이 없습니다.\n첫 글을 작성해보세요!", textAlign: TextAlign.center)),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final post = postState.posts[index];
                      return _PostCard(post: post);
                    },
                    childCount: postState.posts.length,
                  ),
                ),

            // 4. 하단 로딩 인디케이터 (무한 스크롤용)
            if (postState.isLoadMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey)),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ✅ [연결] 글쓰기 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostPage()),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// =============================================================================
// 🧱 [Widget] 상단 채널 바 (인스타 스토리 스타일)
// =============================================================================
class _ChannelBarSection extends ConsumerWidget {
  const _ChannelBarSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelState = ref.watch(channelNotifierProvider);
    final currentChannel = ref.watch(postNotifierProvider).currentChannel;

    // ✅ [수정] 내 채널 목록만 가져오기 ('전체'라는 이름의 가짜 버튼 제거)
    // ChannelNotifier에서 이미 'FREE(자유 광장)'을 맨 앞에 넣어뒀으므로 그대로 씁니다.
    final myChannels = channelState.myChannels;

    if (channelState.isLoading && myChannels.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Container(
      height: 120,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        scrollDirection: Axis.horizontal,
        // ✅ 목록 길이 + 1 (더보기 버튼)
        itemCount: myChannels.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          // 1. 마지막 아이템: 더보기 버튼
          if (index == myChannels.length) {
            return _buildAddChannelButton(context, ref);
          }

          // 2. 채널 아이템 (FREE 포함)
          final item = myChannels[index];

          // FREE 채널은 UI 상에서 "ALL" 또는 "자유"로 보여주고 싶다면 여기서 분기
          // 서버에서는 'FREE', UI에서는 'ALL'이라 쓰고 싶다면:
          final displayName = (item.channel == 'FREE') ? "ALL" : item.name;
          final isSelected = currentChannel == item.channel;

          return GestureDetector(
            onTap: () {
              // ✅ 클릭 시 게시글 새로고침 (추천 요청 X)
              ref.read(postNotifierProvider.notifier).fetchPosts(
                channel: item.channel, // 'FREE' or 'INTP'...
                forceRefresh: true,
              );
            },
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.black, width: 2)
                        : Border.all(color: Colors.grey.shade300, width: 1.5),
                    color: isSelected ? Colors.black.withOpacity(0.05) : Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      displayName.length > 2 ? displayName.substring(0, 2) : displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.black : Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddChannelButton(BuildContext context, WidgetRef ref) {
    // ✅ [추가] 시트를 열 때 최신 목록을 서버에서 가져오도록 강제 호출
    ref.read(channelNotifierProvider.notifier).loadChannels();

    return GestureDetector(
      onTap: () {
        _showRecommendationSheet(context, ref);
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              color: Colors.grey.shade50,
            ),
            child: const Icon(Icons.add, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          const Text(
            "더보기",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
  void _showRecommendationSheet(BuildContext context, WidgetRef ref) {
    // ✅ [추가] 시트를 열 때 최신 목록을 서버에서 가져오도록 강제 호출
    ref.read(channelNotifierProvider.notifier).loadChannels();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final channelState = ref.watch(channelNotifierProvider);
            // ✅ 내 채널 + 추천 채널 모두 보여주되, 중복 제거 로직은 서버나 여기서 처리
            // 여기서는 '추천 목록(recommendedChannels)'을 보여줍니다.
            final recommended = channelState.recommendedChannels;

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              maxChildSize: 0.9,
              builder: (_, scrollController) {
                return Column(
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
                    // ✅ [수정] 타이틀 변경
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                          "현재 참여할 수 있는 커뮤니티",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                      ),
                    ),

                    // ✅ [추가] 로딩 중이면 인디케이터 표시
                    if (channelState.isLoading)
                      const Expanded(child: Center(child: CircularProgressIndicator()))
                    else
                      Expanded(
                        child: recommended.isEmpty
                            ? const Center(child: Text("참여 가능한 채널이 없습니다."))
                            : ListView.builder(
                          controller: scrollController,
                          itemCount: recommended.length,
                          itemBuilder: (context, index) {
                            final channel = recommended[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey.shade100,
                                child: Text(channel.name[0], style: const TextStyle(color: Colors.black)),
                              ),
                              title: Text(channel.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(channel.description),
                              trailing: channel.isJoined
                                  ? TextButton(
                                onPressed: null,
                                child: const Text("참여중", style: TextStyle(color: Colors.grey)),
                              )
                                  : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: const StadiumBorder(),
                                  elevation: 0,
                                ),
                                onPressed: () async {
                                  // ✅ 참여 요청
                                  await ref.read(channelNotifierProvider.notifier).joinChannel(channel.channel);
                                },
                                child: const Text("참여"),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  int min(int a, int b) => a < b ? a : b;
}

// =============================================================================
// 🧹 [Widget] 필터 바 (최신순 / 인기순)
// =============================================================================
class _FilterBar extends StatelessWidget {
  final String? currentSort;
  final Function(String) onSortChanged;



  const _FilterBar({required this.currentSort, required this.onSortChanged});

  @override
  Widget build(BuildContext context) {
    // currentSort가 null이면 기본값(최신순)으로 간주
    final isNew = currentSort == null || currentSort == 'createdAt,desc';
    final isHot = currentSort == 'likeCount,desc';
    final isTrending = currentSort == 'TRENDING';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildFilterChip(
            label: '최신',
            isSelected: isNew,
            onTap: () => onSortChanged('createdAt,desc'),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: '인기 🔥', // 전체 기간 인기글
            isSelected: isHot,
            onTap: () => onSortChanged('likeCount,desc'),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: '급상승 🚀', // 최근 7일 인기글
            isSelected: isTrending,
            // ✅ [중요] 트렌딩은 특수 키워드 'TRENDING'을 넘김
            onTap: () => onSortChanged('TRENDING'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 🃏 [Widget] 게시글 카드 (Post Card)
// =============================================================================
class _PostCard extends StatelessWidget {
  final PostResponse post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    // 날짜 포맷 (예: 10분 전, 1시간 전...)
    final timeAgo = _getTimeAgo(post.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 24), // 카드 간 간격
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 헤더 (프로필, 닉네임, 더보기)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.shade200,
                  // TODO: 유저 프로필 이미지 URL 연동
                  child: const Icon(Icons.person, size: 20, color: Colors.grey),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User ${post.userId}', // TODO: 닉네임 연동
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        '${post.channel} • $timeAgo',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {
                    // TODO: 신고/차단/삭제 바텀시트
                  },
                ),
              ],
            ),
          ),

          // 2. 이미지 (있으면 표시)
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            Container(
              width: double.infinity,
              height: 400, // 인스타 비율 (1:1 or 4:5)
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                image: DecorationImage(
                  image: NetworkImage(post.imageUrl!), // CachedNetworkImage 권장
                  fit: BoxFit.cover,
                ),
              ),
            ),

          // 3. 임베디드 콘텐츠 (영화/책 추천 카드)
          if (post.embeddedContent != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: _EmbeddedContentCard(content: post.embeddedContent!),
            ),

          // 4. 액션 버튼 (좋아요, 댓글, 공유)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Row(
              children: [
                _ActionIcon(
                  icon: Icons.favorite_border,
                  label: '${post.likeCount}',
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                _ActionIcon(
                  icon: Icons.chat_bubble_outline,
                  label: '${post.commentCount}',
                  onTap: () {},
                ),
                const SizedBox(width: 16),
                _ActionIcon(
                  icon: Icons.send_outlined,
                  onTap: () {},
                ),
                const Spacer(),
                Icon(Icons.bookmark_border, color: Colors.black87), // 저장 버튼
              ],
            ),
          ),

          // 5. 본문 및 제목
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 좋아요 수 텍스트
                if (post.likeCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '좋아요 ${post.likeCount}개',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),

                // 제목 & 본문
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                        text: post.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: '  '),
                      TextSpan(
                        text: post.contentSummary ?? post.content ?? '',
                      ),
                    ],
                  ),
                ),

                // 댓글 더보기
                if (post.commentCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: GestureDetector(
                      onTap: () {
                        // TODO: 상세 페이지 이동
                      },
                      child: Text(
                        '댓글 ${post.commentCount}개 모두 보기',
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;

  const _ActionIcon({required this.icon, this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 26, color: Colors.black87),
          if (label != null) ...[
            const SizedBox(width: 6),
            Text(label!, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// 🎬 [Widget] 임베디드 콘텐츠 카드 (영화/책 첨부)
// =============================================================================
class _EmbeddedContentCard extends StatelessWidget {
  final EmbeddedContent content;

  const _EmbeddedContentCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: [
          // 썸네일
          if (content.thumbnail != null)
            Image.network(
              content.thumbnail!,
              width: 80,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_,__,___) => Container(
                width: 80, height: 100, color: Colors.grey.shade300,
                child: const Icon(Icons.movie, color: Colors.white),
              ),
            )
          else
            Container(
              width: 80, height: 100, color: Colors.grey.shade300,
              child: const Icon(Icons.book, color: Colors.white),
            ),

          // 정보
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    content.type == "MOVIE" ? "🎬 영화 추천" : "📚 도서 추천",
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (content.subText != null)
                    Text(
                      content.subText!,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          )
        ],
      ),
    );
  }
}