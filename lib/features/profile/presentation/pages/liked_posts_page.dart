import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../recommendation/presentation/widgets/post_card.dart';
import '../providers/liked_posts_notifier.dart';

class LikedPostsPage extends ConsumerWidget {
  const LikedPostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedPostsAsync = ref.watch(likedPostsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('profile.menu.likes'.tr()),
        centerTitle: true,
      ),
      body: likedPostsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return Center(child: Text('좋아요한 게시글이 없습니다.'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(likedPostsNotifierProvider.future),
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                // 무한 스크롤 로직: 마지막 아이템 도달 시 더 불러오기
                if (index == posts.length - 1) {
                  Future.microtask(() =>
                      ref.read(likedPostsNotifierProvider.notifier).loadMore());
                }
                return PostCard(post: posts[index]); // 기존 _PostCard 사용
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('오류가 발생했습니다: $err')),
      ),
    );
  }
}