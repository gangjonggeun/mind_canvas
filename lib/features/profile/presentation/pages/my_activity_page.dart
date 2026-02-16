import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../recommendation/presentation/widgets/post_card.dart';
import '../providers/liked_posts_notifier.dart';
import '../providers/my_posts_notifier.dart';
import '../providers/my_test_results_notifier.dart';
import '../widgets/test_result_item.dart';

class MyActivityPage extends ConsumerWidget {
  const MyActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text('profile.menu.my_records'.tr()),
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: '분석 결과'.tr()),
              Tab(text: '작성한 글'.tr()),
              Tab(text: '좋아요'.tr()),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TestResultsTab(),
            _MyPostsTab(),
            _LikedPostsTab(),
          ],
        ),
      ),
    );
  }
}

// --- 각 탭의 구현 ---

class _TestResultsTab extends ConsumerWidget {
  const _TestResultsTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 여기에 Notifier 연결 (아까 만든 MyTestResultsNotifier)
    final resultsAsync = ref.watch(myTestResultsNotifierProvider);

    return resultsAsync.when(
      data: (results) => results.isEmpty
          ? _buildEmptyState('아직 완료한 테스트가 없습니다.')
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: results.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => TestResultItem(
          result: results[index],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('에러 발생: $e')),
    );
  }
}

class _MyPostsTab extends ConsumerWidget {
  const _MyPostsTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(myPostsNotifierProvider);
    return postsAsync.when(
      data: (posts) => posts.isEmpty
          ? _buildEmptyState('작성한 게시글이 없습니다.')
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) => PostCard(post: posts[index]),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('에러 발생: $e')),
    );
  }
}

class _LikedPostsTab extends ConsumerWidget {
  const _LikedPostsTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedAsync = ref.watch(likedPostsNotifierProvider);
    return likedAsync.when(
      data: (posts) => posts.isEmpty
          ? _buildEmptyState('좋아요한 게시글이 없습니다.')
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) => PostCard(post: posts[index]),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('에러 발생: $e')),
    );
  }
}

// 텅 비어 보임을 방지하는 Empty State 위젯
Widget _buildEmptyState(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox_rounded, size: 64, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text(message, style: TextStyle(color: Colors.grey[400])),
      ],
    ),
  );
}