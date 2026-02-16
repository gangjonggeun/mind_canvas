import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mind_canvas/features/recommendation/presentation/pages/expandable_post_text.dart';
import 'package:mind_canvas/features/recommendation/presentation/pages/user_profile_avatar.dart';

import '../../data/dto/embedded_content.dart';
import '../../data/dto/post_response.dart';
import '../provider/channel_notifier.dart';
import '../provider/post_notifier.dart';
import '../widgets/category_popup_menu.dart';
import '../widgets/like_button.dart';
import '../widgets/post_card.dart';
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
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
          await ref
              .read(postNotifierProvider.notifier)
              .fetchPosts(
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
            const SliverToBoxAdapter(child: _ChannelBarSection()),

            // 2. 정렬 및 필터 바
            SliverToBoxAdapter(
              child: _FilterBar(
                currentSort: postState.currentSort,
                onSortChanged: (sort) {
                  ref
                      .read(postNotifierProvider.notifier)
                      .fetchPosts(
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
                child: Center(
                  child: CircularProgressIndicator(color: Colors.black),
                ),
              )
            else if (postState.errorMessage != null && postState.posts.isEmpty)
              SliverFillRemaining(
                child: Center(child: Text(postState.errorMessage!)),
              )
            else if (postState.posts.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    "아직 게시글이 없습니다.\n첫 글을 작성해보세요!",
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final post = postState.posts[index];
                  return PostCard(post: post);
                }, childCount: postState.posts.length),
              ),

            // 4. 하단 로딩 인디케이터 (무한 스크롤용)
            if (postState.isLoadMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey,
                    ),
                  ),
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

  Color _getChannelColor(String channelCode) {
    if (channelCode == 'FREE') return Colors.black; // 자유 광장은 검정

    // 문자열의 hashCode를 이용해 랜덤하지만 고정된 색상 선택
    final hash = channelCode.hashCode;
    final colors = [
      const Color(0xFFE57373), // Red
      const Color(0xFFBA68C8), // Purple
      const Color(0xFF64B5F6), // Blue
      const Color(0xFF4DB6AC), // Teal
      const Color(0xFFFFB74D), // Orange
      const Color(0xFFA1887F), // Brown
      const Color(0xFF90A4AE), // Blue Grey
    ];
    return colors[hash.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelState = ref.watch(channelNotifierProvider);
    final currentChannel = ref.watch(postNotifierProvider).currentChannel;
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

          final displayName = (item.channel == 'FREE') ? "자유 광장" : item.name;
          final isSelected = currentChannel == item.channel;
          final color = _getChannelColor(item.channel);

          return GestureDetector(
            onTap: () {
              // ✅ 클릭 시 게시글 새로고침 (추천 요청 X)
              ref
                  .read(postNotifierProvider.notifier)
                  .fetchPosts(
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
                        ? Border.all(color: color, width: 4) // 선택 시 해당 색상 테두리
                        : Border.all(color: Colors.grey.shade300, width: 1.5),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: item.channel == 'FREE'
                        ? const Icon(
                            Icons.public,
                            color: Colors.black,
                          ) // 자유 광장은 아이콘
                        : Text(
                            item.channel.substring(
                              0,
                              min(item.channel.length, 4),
                            ),
                            // MBTI 코드 표시
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: color, // 글자색을 채널 고유색으로
                              fontSize: 13,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? color : Colors.grey,
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
          const Text("더보기", style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    // ✅ [추가] 로딩 중이면 인디케이터 표시
                    if (channelState.isLoading)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
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
                                      child: Text(
                                        channel.name[0],
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      channel.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(channel.description),
                                    trailing: channel.isJoined
                                        ? TextButton(
                                            onPressed: null,
                                            child: const Text(
                                              "참여중",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
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
                                              await ref
                                                  .read(
                                                    channelNotifierProvider
                                                        .notifier,
                                                  )
                                                  .joinChannel(channel.channel);
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
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final currentCategory = ref.watch(postNotifierProvider).currentCategory;

        void changeCategory(String? category) {
          final postState = ref.read(postNotifierProvider);
          ref.read(postNotifierProvider.notifier).fetchPosts(
            channel: postState.currentChannel,
            sort: postState.currentSort,
            category: category,
            forceRefresh: true,
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ 좌우 끝으로 정렬
            children: [
              // 1. [좌측] 정렬 칩 (최신 / 인기 / 급상승)
              Row(
                children: [
                  _buildSortChip(
                    label: '최신 ✨', // ✅ 이모티콘 추가
                    isSelected: currentSort == null || currentSort == 'createdAt,desc',
                    onTap: () => onSortChanged('createdAt,desc'),
                  ),
                  const SizedBox(width: 8),
                  _buildSortChip(
                    label: '인기 🔥',
                    isSelected: currentSort == 'likeCount,desc',
                    onTap: () => onSortChanged('likeCount,desc'),
                  ),
                  const SizedBox(width: 8),
                  _buildSortChip(
                    label: '급상승 🚀',
                    isSelected: currentSort == 'TRENDING',
                    onTap: () => onSortChanged('TRENDING'),
                  ),
                ],
              ),

              // 2. [우측] 카테고리 선택 (드롭다운 메뉴)
              CategoryPopupMenu(
                currentCategory: currentCategory,
                onCategoryChanged: changeCategory,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String label,
    String? categoryValue,
  ) {
    // 현재 선택된 카테고리인지 확인 (Provider 구독 필요)
    // 여기선 편의상 ConsumerWidget으로 바꾸거나, 상위에서 상태를 받아와야 함.
    final currentCategory = ProviderScope.containerOf(
      context,
    ).read(postNotifierProvider).currentCategory;
    final isSelected = currentCategory == categoryValue;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          // 카테고리 변경 요청
          // ref.read가 안되면 콜백으로 위임하거나 ConsumerWidget 사용
          // onCategoryChanged(categoryValue);
        }
      },
      // ... 스타일링 (파스텔톤 등)
    );
  }

  // 정렬 칩 (기존 디자인)
  Widget _buildSortChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
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

  // ✅ [신규] 카테고리 옵션 박스 디자인
  Widget _buildCategoryOption(
      String label,
      String? value,
      String? currentValue,
      Function(String?) onSelect
      ) {
    final isSelected = currentValue == value;
    return GestureDetector(
      onTap: () => onSelect(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6B73FF).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8), // 네모난 박스 느낌
          border: Border.all(
            color: isSelected ? const Color(0xFF6B73FF) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF6B73FF) : Colors.grey.shade600,
          ),
        ),
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

