import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../generated/l10n.dart';
import '../../data/dto/post_response.dart';
import '../../domain/usecase/community_use_case.dart';
import '../provider/post_notifier.dart';

// 🛑 신고 사유 리스트
Map<String, String> getReportReasons(BuildContext context) {
  return {
    'SPAM': S.of(context).community_help_spam,
    'INAPPROPRIATE_CONTENT': S.of(context).community_help_inap,
    'HATE_SPEECH': S.of(context).community_help_hate,
    'HARASSMENT': S.of(context).community_help_spam_harassment,
    'OTHER': S.of(context).community_help_other,
  };
}
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
                  title: Text(S.of(context).community_help_delete, style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmDialog(context, ref, post.id);
                  },
                ),
              ]else ...[

              ListTile(
                leading: const Icon(Icons.report_problem_outlined, color: Colors.red),
                title:Text(S.of(context).community_help_report, style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  showReportDialog(context, ref, post.id, 'POST');

                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: Colors.black87),
                title:  Text(S.of(context).community_help_ban),
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
        title:  Text(S.of(context).community_help_delete_confirm),
        content: Text(S.of(context).community_help_delete_confirm_content),
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
                   SnackBar(content: Text(S.of(context).community_help_delete_succes)),
                );
                final postState = ref.read(postNotifierProvider);


              }
            },
            child: Text(S.of(context).community_help_delete, style: TextStyle(color: Colors.red)),
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
              title:  Text(S.of(context).community_help_report_category, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: getReportReasons(context).entries.map((entry) {
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
                  child:  Text(S.of(context).community_help_report_cancel, style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  onPressed: () async {
                    Navigator.pop(context); // 다이얼로그 먼저 닫기

                    // ✅ 올바른 방식: Notifier의 report 함수 호출
                    final isSuccess = await ref.read(postNotifierProvider.notifier).report(
                        targetId, targetType, selectedReason
                    );

                    // 화면이 살아있는지 체크 후 스낵바 띄우기 (Flutter 권장 사항)
                    if (!context.mounted) return;

                    if (isSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text(S.of(context).post_report_succes)),
                      );
                    } else {
                      // ⚠️ 기존 코드에는 성공/실패 여부 상관없이 무조건 fail 스낵바를 띄우고 있었습니다. 수정!
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(S.of(context).community_help_report_fail)),
                      );
                    }
                  },
                  child: Text(S.of(context).community_help_report_ok),
                ),
              ],
            );
          },
        );
      },
    );
  }
  static void _showBlockDialog(BuildContext context, WidgetRef ref, int userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title:  Text(S.of(context).post_ban_title, style: TextStyle(fontWeight: FontWeight.bold)),
          content:  Text(
            S.of(context).post_ban_content,
            style: TextStyle(height: 1.5),
          ),
          actions:[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  Text(S.of(context).post_ban_cancel, style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
              onPressed: () async {
                Navigator.pop(context); // 다이얼로그 닫기

                // ✅ 올바른 방식: Notifier의 blockUser 호출 (알아서 로컬 업데이트됨)
                final isSuccess = await ref.read(postNotifierProvider.notifier).blockUser(userId);

                // ❌ fetchPosts(forceRefresh: true) 제거! 낙관적 업데이트를 했으니 서버에서 다시 부를 필요가 없습니다.

                if (!context.mounted) return;

                if (isSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text(S.of(context).post_ban_succes)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text(S.of(context).post_ban_title_fail)),
                  );
                }
              },
              child:  Text(S.of(context).post_ban_ok),
            ),
          ],
        );
      },
    );
  }
}