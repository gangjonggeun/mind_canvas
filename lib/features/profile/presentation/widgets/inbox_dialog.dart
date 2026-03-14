import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/inbox_message.dart';
import '../providers/inbox_notifier.dart';

// 💡 2. 우편함 다이얼로그 본체
class InboxDialog extends ConsumerWidget {
  const InboxDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 상태 읽어오기
    final inboxState = ref.watch(inboxNotifierProvider);
    final messages = inboxState.messages;
    final dialogHeight = MediaQuery.of(context).size.height * 0.7;

    return Dialog(
      backgroundColor: const Color(0xFF1E212D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: dialogHeight),
        child: Column(
          children: [
            // 🛑 헤더 영역
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '📬 우편함',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    // ✅ Notifier의 삭제 함수 호출
                    onPressed: () {
                      ref.read(inboxNotifierProvider.notifier).deleteAllRead();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('읽은 우편이 모두 삭제되었습니다.')),
                      );
                    },
                    icon: const Icon(Icons.delete_sweep,
                        color: Colors.grey, size: 20),
                    label: const Text('읽은 우편 삭제',
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            GestureDetector(
              onTap: () async {
                final url = Uri.parse('https://www.notion.so/323b4bde4afa8049b699e9e5767a61f6?source=copy_link');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url,mode: LaunchMode.inAppWebView);
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // ✨ 세로 여백을 8로 확 줄여 얇게 만듦
                color: const Color(0xFF3498DB).withOpacity(0.15), // 은은한 파란색 배경
                child: Row(
                  children:[
                    const Icon(Icons.campaign, color: Colors.lightBlueAccent, size: 18), // ✨ 아이콘 작게
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        '마인드캔버스 최신 업데이트 및 이벤트 안내',
                        style: TextStyle(color: Colors.lightBlueAccent, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.lightBlueAccent, size: 16),
                  ],
                ),
              ),
            ),
            const Divider(color: Colors.white24, height: 1, thickness: 1),
            // 🛑 리스트 영역
            Expanded(
              child: messages.isEmpty
                  ? const Center(
                      child: Text('우편함이 비어있습니다.',
                          style: TextStyle(color: Colors.white54)))
                  : NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        // 💡 리스트 하단에 닿았고, 로딩 중이 아니고, 더 가져올 데이터가 있을 때만
                        if (scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            !inboxState.isLoading &&
                            inboxState.hasMore) {
                          ref
                              .read(inboxNotifierProvider.notifier)
                              .loadNextPage();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount:
                            messages.length + (inboxState.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == messages.length) {
                            // 다음 페이지 로딩 호출
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ref
                                  .read(inboxNotifierProvider.notifier)
                                  .loadNextPage();
                            });
                            return const Center(
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator()));
                          }

                          final msg = messages[index];
                          final isRead = msg.isRead;

                          return InkWell(
                            onTap: () {
                              // ✅ 클릭 시 읽음 처리 및 팝업 띄우기
                              ref
                                  .read(inboxNotifierProvider.notifier)
                                  .markAsRead(msg.id);
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    MailDetailDialog( messageId: msg.id,),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: isRead
                                    ? Colors.transparent
                                    : Colors.white.withOpacity(0.05),
                                border: const Border(
                                    bottom: BorderSide(
                                        color: Colors.white10, width: 1)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, right: 12),
                                    child: Icon(
                                      isRead
                                          ? Icons.drafts
                                          : Icons.mark_email_unread,
                                      color:
                                          isRead ? Colors.grey : Colors.amber,
                                      size: 24,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          msg.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: isRead
                                                ? Colors.white54
                                                : Colors.white,
                                            fontSize: 16,
                                            fontWeight: isRead
                                                ? FontWeight.normal
                                                : FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          msg.content,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: isRead
                                                  ? Colors.white38
                                                  : Colors.white70,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat('MM/dd').format(msg.date),
                                    style: TextStyle(
                                        color: isRead
                                            ? Colors.white38
                                            : Colors.white54,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),

            // 🛑 하단 닫기 버튼
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white12,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('닫기'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MailDetailDialog extends ConsumerStatefulWidget {
  final int messageId;

  const MailDetailDialog({super.key, required this.messageId});

  @override
  ConsumerState<MailDetailDialog> createState() => _MailDetailDialogState();
}

class _MailDetailDialogState extends ConsumerState<MailDetailDialog> {
  bool _showAnimation = false; // 🌟 애니메이션 상태 변수 추가

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inboxNotifierProvider);
    final message = state.messages.firstWhere(
          (m) => m.id == widget.messageId,
      orElse: () => throw Exception('메시지를 찾을 수 없음'),
    );

    final hasUnclaimedReward = message.rewardInk > 0 && !message.isClaimed;

    return Dialog(
      backgroundColor: const Color(0xFF2C3E50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack( // 🌟 1. Stack으로 감싸서 다이얼로그 내용과 애니메이션을 겹침
        children: [
          // 2. 기존 다이얼로그 내용 UI
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('yy-MM-dd HH:mm').format(message.date),
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  message.title,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(color: Colors.white24, height: 24, thickness: 1),
                Container(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                  child: SingleChildScrollView(
                    child: Text(
                      message.content,
                      style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.6),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: hasUnclaimedReward
                      ? ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        // 1. 보상 수령 로직
                        await ref.read(inboxNotifierProvider.notifier)
                            .claimReward(message.id, message.rewardInk);

                        // 2. 🌟 애니메이션 시작
                        setState(() => _showAnimation = true);

                        // 3. 2초 후 다이얼로그 닫기
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) Navigator.pop(context);
                        });

                        // 4. 스낵바 띄우기
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('🎁 ${message.rewardInk} 잉크를 받았습니다!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('보상 수령에 실패했습니다.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: Image.asset('assets/images/icon/coin_palette_128.webp', width: 20, height: 20),
                    label: Text('${message.rewardInk} 잉크 받기', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  )
                      : ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white12, foregroundColor: Colors.white),
                    child: const Text('확인', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),

          // 3. 🌟 애니메이션 레이어 (조건부로 렌더링)
          if (_showAnimation)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Lottie.asset(
                    'assets/lottie/coins.json',
                    repeat: false,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}