import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ✅ 화풀기 Notifier Import
import '../../../../generated/l10n.dart';
import '../providers/anger_vent_notifier.dart';

/// 🔥 AI 화풀기(샌드백) 채팅 페이지
///
/// - 컨셉: 붉은 톤, 반말, 샌드백 역할
/// - Provider: AngerVentNotifier
class AngerVentPage extends ConsumerStatefulWidget {
  const AngerVentPage({super.key});

  @override
  ConsumerState<AngerVentPage> createState() => _AngerVentPageState();
}

class _AngerVentPageState extends ConsumerState<AngerVentPage>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _typingAnimationController;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  void _initAnimations() {
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    // 🔍 Provider 상태 구독 (AngerVentNotifier)
    final ventState = ref.watch(angerVentNotifierProvider);

    // 👂 상태 리스너
    ref.listen(angerVentNotifierProvider, (previous, next) {
      if (next.errorMessage != null && !next.isResponding) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('⚠️ ${next.errorMessage}')));
      }

      // 메시지 개수가 늘어나면 스크롤 이동
      if (next.messages.length > (previous?.messages.length ?? 0)) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      // 🔥 배경색: 아주 연한 붉은색 (화난 느낌의 배경)
      backgroundColor: const Color(0xFFFFF5F5),
      appBar: _buildAppBar(ventState.isResponding),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(ventState)),
          _buildInputArea(ventState.isResponding),
        ],
      ),
    );
  }

  /// 🎯 앱바 구성 (붉은 테마)
  PreferredSizeWidget _buildAppBar(bool isTyping) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.red.withOpacity(0.1),
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3748)),
      ),
      title: Row(
        children: [
          // 🔥 아이콘 변경 (불꽃 or 샌드백)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                // 붉은색 ~ 주황색 그라데이션
                colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                S.of(context).consulting_punchingbag_title, // 이름 변경
                style: TextStyle(
                  color: Color(0xFF2D3748),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                isTyping ? S.of(context).consulting_punchingbag_loading : S.of(context).consulting_punchingbag_online,
                style: TextStyle(
                  color: isTyping
                      ? const Color(0xFFFF5F6D)
                      : const Color(0xFF718096),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _showChatOptions,
          icon: const Icon(Icons.more_vert, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  /// 📜 메시지 리스트
  Widget _buildMessageList(dynamic state) {
    // AngerVentState
    final List<Widget> uiMessages = [
      // 🔥 웰컴 메시지: 반말 컨셉
      _buildMessageBubble(
        isFromAi: true,
        content: S.of(context).consulting_punchingbag_menu_1,
        type: MessageType.text,
      ),
      _buildMessageBubble(
        isFromAi: true,
        content: S.of(context).consulting_punchingbag_menu_2,
        type: MessageType.text,
      ),
      // 🔥 추천 질문: 화풀이용 멘트
      _buildMessageBubble(
        isFromAi: true,
        content: '',
        type: MessageType.suggestions,
        suggestions: [S.of(context).consulting_punchingbag_option_1, S.of(context).consulting_punchingbag_option_2, S.of(context).consulting_punchingbag_option_3],
      ),
    ];

    // 상태의 메시지 목록 매핑
    for (var chat in state.messages) {
      uiMessages.add(
        _buildMessageBubble(
          isFromAi: chat.role == 'AI' || chat.role == 'model', // Gemini Role 처리
          content: chat.content,
          type: MessageType.text,
        ),
      );
    }

    // 로딩 인디케이터
    if (state.isResponding) {
      uiMessages.add(_buildTypingIndicator());
    }

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      children: uiMessages,
    );
  }

  /// 💬 메시지 버블
  Widget _buildMessageBubble({
    required bool isFromAi,
    required String content,
    required MessageType type,
    List<String>? suggestions,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isFromAi
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          if (type == MessageType.text)
            _buildTextMessage(isFromAi, content)
          else if (type == MessageType.suggestions)
            _buildSuggestionsMessage(suggestions ?? []),
        ],
      ),
    );
  }

  /// 📝 텍스트 메시지 (붉은 테마 적용)
  Widget _buildTextMessage(bool isFromAi, String content) {
    return Row(
      mainAxisAlignment: isFromAi
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        if (isFromAi) ...[
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                // AI 아이콘도 붉은 계열
                colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
        ],

        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              // 🔥 사용자의 말풍선: 강렬한 붉은색 그라데이션 대신 가독성을 위해 단색이나 진한 핑크 사용
              // AI 말풍선: 흰색
              color: isFromAi ? Colors.white : const Color(0xFFFF6B6B),
              borderRadius: BorderRadius.circular(20).copyWith(
                bottomLeft: isFromAi
                    ? const Radius.circular(4)
                    : const Radius.circular(20),
                bottomRight: isFromAi
                    ? const Radius.circular(20)
                    : const Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 15,
                color: isFromAi ? const Color(0xFF2D3748) : Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 💡 추천 질문 메시지 (스타일 변경)
  Widget _buildSuggestionsMessage(List<String> suggestions) {
    return Row(
      children: [
        // AI 아이콘
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).consulting_punchingbag_message,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFE53E3E), // 붉은 텍스트
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: suggestions.map((suggestion) {
                  return GestureDetector(
                    onTap: () {
                      _messageController.text = suggestion; // 텍스트 입력
                      _messageController.selection = TextSelection.fromPosition(
                        // 커서 끝으로 이동
                        TextPosition(offset: _messageController.text.length),
                      );
                      setState(() {}); // UI 갱신 (전송 버튼 활성화 등)
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE3E3), // 연한 붉은 배경
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFFF6B6B).withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        suggestion,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFC53030), // 진한 붉은 글씨
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ⌨️ 타이핑 인디케이터 (색상 변경)
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                20,
              ).copyWith(bottomLeft: const Radius.circular(4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _typingAnimationController,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    final delay = index * 0.3;
                    final animationValue =
                        (_typingAnimationController.value - delay).clamp(
                          0.0,
                          1.0,
                        );
                    final opacity = (animationValue < 0.5)
                        ? animationValue * 2
                        : (1 - animationValue) * 2;

                    return Padding(
                      padding: EdgeInsets.only(right: index < 2 ? 4 : 0),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          // 인디케이터 점 색상도 붉은색
                          color: const Color(0xFFFF6B6B).withOpacity(opacity),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ⌨️ 입력 영역 (아이콘/버튼 색상 변경)
  Widget _buildInputArea(bool isTyping) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F5), // 입력창 배경도 연한 붉은색
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFFFD1D1)),
                ),
                child: TextField(
                  controller: _messageController,
                  enabled: !isTyping,
                  decoration:  InputDecoration(
                    hintText: S.of(context).consulting_punchingbag_enter_message,
                    hintStyle: TextStyle(
                      color: Color(0xFFA0AEC0),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF2D3748),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) _sendMessage(text.trim());
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),

            GestureDetector(
              onTap: isTyping
                  ? null
                  : () {
                      final text = _messageController.text.trim();
                      if (text.isNotEmpty) _sendMessage(text);
                    },
              child: Opacity(
                opacity: isTyping ? 0.5 : 1.0,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📨 메시지 전송
  void _sendMessage(String content) {
    if (content.trim().isEmpty) return;

    // ✅ AngerVentNotifier 호출
    ref.read(angerVentNotifierProvider.notifier).sendMessage(content);

    _messageController.clear();
    _scrollToBottom();
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           Text(
              S.of(context).consulting_punchingbag_option,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.refresh, color: Color(0xFFFF6B6B)),
              title:  Text(S.of(context).consulting_punchingbag_reset),
              onTap: () {
                Navigator.pop(context);
                // TODO: Notifier에 clear 메서드 만들어서 호출
                // ref.read(angerVentNotifierProvider.notifier).resetChat();
                Navigator.pop(context); // 페이지 나가기
              },
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

// 이 파일 하단에 MessageType enum은 재사용하셔도 되고,
// 이미 다른 파일에 있다면 지우셔도 됩니다.
enum MessageType { text, suggestions }
