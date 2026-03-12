import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mind_canvas/features/recommendation/presentation/pages/expandable_post_text.dart';
import 'package:mind_canvas/features/recommendation/presentation/pages/user_profile_avatar.dart';

import '../../../../app/presentation/notifier/user_notifier.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/dto/embedded_content.dart';
import '../../data/dto/post_response.dart';
import '../pages/community_action_helper.dart';
import '../pages/post_detail_bottom_sheet.dart';
import '../provider/channel_notifier.dart';
import '../provider/post_notifier.dart';
import '../widgets/category_popup_menu.dart';
import '../widgets/like_button.dart';

class PostCard extends ConsumerWidget {
  final PostResponse post;
  final bool isDetailMode;

  const PostCard(
      {required this.post,
      this.isDetailMode = false, // 기본값 false
      super.key});

  String _getChannelDisplayName(String channelCode) {
    if (channelCode == 'FREE') return 'ALL';
    return channelCode; // 나머지는 그대로 (INTP 등)
  }

  Color _getChannelColor(String channelCode) {
    if (channelCode == 'FREE') return Colors.black;
    final hash = channelCode.hashCode;
    final colors = [
      const Color(0xFFE57373),
      const Color(0xFFBA68C8),
      const Color(0xFF64B5F6),
      const Color(0xFF4DB6AC),
      const Color(0xFFFFB74D),
      const Color(0xFFA1887F),
      const Color(0xFF90A4AE)
    ];
    return colors[hash.abs() % colors.length];
  }

  // 📝 카테고리 한글 변환
  String _getCategoryName(String categoryCode) {
    switch (categoryCode) {
      case 'CHAT':
        return '잡담';
      case 'QUESTION':
        return '질문';
      case 'REVIEW':
        return '리뷰';
      default:
        return '기타';
    }
  }

  // 🔹 숫자 포맷팅 헬퍼 (조회수)
  String _formatCount(int count) {
    if (count < 1000) return '$count';
    if (count < 10000) {
      // 1.2천
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    // 3.5만
    return '${(count / 10000).toStringAsFixed(1)}0k';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeAgo = _getTimeAgo(context, post.createdAt);
    final channelName = post.channel == 'FREE' ? 'ALL' : post.channel;
    final channelColor = _getChannelColor(post.channel);
    final categoryName = _getCategoryName(post.category);
    final userState = ref.watch(userNotifierProvider);
    final int myId = userState?.id ?? -1;

    return Container(
      key: ValueKey('post_${post.id}'),

      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      // ✅ 1. 여기서 전체 Column을 GestureDetector로 감쌉니다!
      child: GestureDetector(
        onTap: isDetailMode
            ? null
            : () => PostDetailBottomSheet.show(context, post),
        behavior: HitTestBehavior.opaque, // ⭐️ 빈 공간(여백) 터치도 모두 인식하게 해줌
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 헤더 (프로필, 닉네임, 정보)
            // 💡 안쪽에 있는 IconButton(...)은 자체 클릭 이벤트를 가져가므로 전체 터치가 무시되고 정상 작동합니다.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  UserProfileAvatar(
                      imageUrl: post.authorProfileImage,
                      userId: post.userId,
                      radius: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Text(
                          post.authorNickname ?? S.of(context).post_card_anonymity,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children:[
                            Text(channelName, style: TextStyle(color: channelColor, fontWeight: FontWeight.w700, fontSize: 12)),
                            const SizedBox(width: 6),
                            Text(categoryName, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                            const SizedBox(width: 4),
                            Text('• $timeAgo', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz, color: Colors.grey.shade600),
                    onPressed: () => CommunityActionHelper.showPostOptions(
                        context,
                        ref,
                        post, // PostResponse 객체 전체 넘기기 (id, userId 포함됨)
                        myId  // 내 ID 넘기기
                    ),
                  ),
                ],
              ),
            ),

            // 2. 본문 (제목 + 내용)
            // ❌ 기존에 여기에 있던 GestureDetector는 삭제합니다! (중복 방지)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          height: 1.3)),
                  const SizedBox(height: 8),
                  ExpandablePostText(text: post.content ?? '', maxLines: 5),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 3. 이미지/임베드 (기존 동일)
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  image: DecorationImage(image: NetworkImage(post.imageUrl!), fit: BoxFit.cover),
                ),
              ),
            if (post.embeddedContent != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _EmbeddedContentCard(content: post.embeddedContent!),
              ),


            const SizedBox(height: 8),
            const Divider(height: 1, color: Colors.black12),

            // 4. 하단 액션
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  // 💡 좋아요 버튼도 자체 클릭 이벤트가 있어서 전체 터치보다 우선 작동합니다.
                  LikeButton(
                    isLiked: post.isLiked,
                    likeCount: post.likeCount,
                    onTap: (isLiked) => ref
                        .read(postNotifierProvider.notifier)
                        .toggleLike(post.id),
                  ),
                  const SizedBox(width: 16),

                  // 댓글 버튼 표시 (클릭 이벤트는 이제 전체 카드가 처리하므로 눈에 보여주기만 하면 됨)
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline,
                          size: 22, color: Colors.black87),
                      const SizedBox(width: 4),
                      Text(
                        _formatCount(post.commentCount),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  const Spacer(),
                  // 디테일 모드가 아닐 때만 북마크 표시
                  // if (!isDetailMode)
                  //   const Icon(Icons.bookmark_border, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(BuildContext context, DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return S.of(context).post_card_now;
    if (diff.inMinutes < 60) return S.of(context).post_card_few_m(diff.inMinutes); //${diff.inMinutes}분 전
    if (diff.inHours < 24) return S.of(context).post_card_few_h(diff.inHours);
    return S.of(context).post_card_few_d(diff.inDays);
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
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 100,
                color: Colors.grey.shade300,
                child: const Icon(Icons.movie, color: Colors.white),
              ),
            )
          else
            Container(
              width: 80,
              height: 100,
              color: Colors.grey.shade300,
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
                    content.type == "MOVIE" ? S.of(context).post_card_movie : S.of(context).post_card_book,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blueAccent.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
          ),
        ],
      ),
    );
  }
}
