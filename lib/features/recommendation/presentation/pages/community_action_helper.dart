import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/dto/post_response.dart';
import '../../domain/usecase/community_use_case.dart';
import '../provider/post_notifier.dart';

// 🛑 신고 사유 리스트
const Map<String, String> reportReasons = {
  'SPAM': '스팸 및 도배',
  'INAPPROPRIATE_CONTENT': '음란물 또는 부적절한 콘텐츠',
  'HATE_SPEECH': '혐오 발언 및 모욕',
  'HARASSMENT': '괴롭힘 및 폭력성',
  'OTHER': '기타 사유',
};

class CommunityActionHelper {
  /// 📌 1. 우측 상단 `...` 클릭 시 열리는 BottomSheet
  static void showPostOptions(
      BuildContext context,
      WidgetRef ref,
      PostResponse post, // 게시글 정보
      int myId           // 내 ID (UserNotifier에서 가져온 값)
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final isMyPost = (myId != -1) && (post.userId == myId);

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              if (isMyPost) ...[
                // 내 글일 때 -> 삭제하기
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('이 게시글 삭제하기', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmDialog(context, ref, post.id);
                  },
                ),
              ]else ...[

              ListTile(
                leading: const Icon(Icons.report_problem_outlined, color: Colors.red),
                title: const Text('이 게시글 신고하기', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  showReportDialog(context, ref, post.id, 'POST');

                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.black87),
                title: const Text('이 사용자 차단하기'),
                onTap: () {
                  Navigator.pop(context);
                  _showBlockDialog(context, ref, post.userId);
                },
              ),
              ]
            ],
          ),
        );
      },
    );
  }

  static void _showDeleteConfirmDialog(BuildContext context, WidgetRef ref, int postId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("게시글 삭제"),
        content: const Text("정말로 이 게시글을 삭제하시겠습니까?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("취소")),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);

              // 삭제 로직 호출
              final success =await ref.read(postNotifierProvider.notifier).deletePost(postId);

              if (success) {
                // 성공 토스트
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("게시글이 삭제되었습니다.")),
                );
                final postState = ref.read(postNotifierProvider);


              }
            },
            child: const Text("삭제", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  /// 📌 2. 신고하기 다이얼로그
  static void showReportDialog(BuildContext context, WidgetRef ref, int targetId, String targetType) {
    String selectedReason = 'SPAM'; // 기본값

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('신고 사유 선택', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: reportReasons.entries.map((entry) {
                  return RadioListTile<String>(
                    title: Text(entry.value, style: const TextStyle(fontSize: 14)),
                    value: entry.key,
                    groupValue: selectedReason,
                    activeColor: Colors.black,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setState(() => selectedReason = value!);
                    },
                  );
                }).toList(),
              ),
              actions:[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  onPressed: () async {
                    // TODO: 로딩 표시기 추가 (Double Submit 방지)
                    Navigator.pop(context);
                    await ref.read(communityUseCaseProvider).reportContent(
                      targetId: targetId, targetType: targetType, reason: selectedReason,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('신고가 접수되었습니다. 관리자 검토 후 조치됩니다.')),
                    );
                  },
                  child: const Text('신고하기'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// 📌 3. 차단하기 다이얼로그
  static void _showBlockDialog(BuildContext context, WidgetRef ref, int userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('사용자 차단', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
            '차단하시겠습니까?\n차단된 사용자의 게시글과 댓글은 더 이상 보이지 않으며, 차단 해제는 설정에서 가능합니다.',
            style: TextStyle(height: 1.5),
          ),
          actions:[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
              onPressed: () async {
                Navigator.pop(context);
                await ref.read(communityUseCaseProvider).blockUser(userId);
                // TODO: 게시글 목록 새로고침 호출 (차단한 유저 글 숨기기)
                ref.read(postNotifierProvider.notifier).fetchPosts(forceRefresh: true);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('해당 사용자가 차단되었습니다.')),
                );
              },
              child: const Text('차단하기'),
            ),
          ],
        );
      },
    );
  }
}