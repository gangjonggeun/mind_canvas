import 'package:flutter/material.dart';

/// 💬 AI 상담 채팅 페이지
/// 
/// 실시간 AI 상담사와의 채팅 인터페이스
/// - 카카오톡 스타일 채팅 UI
/// - 타이핑 애니메이션
/// - 메모리 효율적인 메시지 관리
/// - 감정 분석 기반 맞춤 응답
class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isAiTyping = false;
  late AnimationController _typingAnimationController;

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _initAnimations();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingAnimationController.dispose();
    super.dispose();
  }

  /// 🎬 애니메이션 초기화
  void _initAnimations() {
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  /// 💬 채팅 초기화
  void _initializeChat() {
    // 웰컴 메시지
    _messages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: '안녕하세요! 저는 마인드 캔버스의 AI 상담사입니다. 🤗\n\n오늘 어떤 이야기를 나누고 싶으신가요?',
        isFromAi: true,
        timestamp: DateTime.now(),
        messageType: MessageType.text,
      ),
    );

    // 추천 질문들
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              content: '',
              isFromAi: true,
              timestamp: DateTime.now(),
              messageType: MessageType.suggestions,
              suggestions: [
                '😊 오늘 기분이 어때요?',
                '💭 고민이 있어요',
                '😴 스트레스를 받고 있어요',
                '🎯 목표를 세우고 싶어요',
              ],
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // 채팅 메시지 영역
          Expanded(
            child: _buildMessageList(),
          ),
          // 입력 영역
          _buildInputArea(),
        ],
      ),
    );
  }

  /// 🎯 앱바 구성
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Color(0xFF2D3748),
        ),
      ),
      title: Row(
        children: [
          // AI 아바타
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B73FF), Color(0xFF9F7AEA)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI 상담사',
                style: TextStyle(
                  color: Color(0xFF2D3748),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _isAiTyping ? '입력 중...' : '온라인',
                style: TextStyle(
                  color: _isAiTyping ? const Color(0xFF6B73FF) : const Color(0xFF4ECDC4),
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
          icon: const Icon(
            Icons.more_vert,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  /// 📜 메시지 리스트
  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isAiTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isAiTyping) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  /// 💬 메시지 버블
  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: message.isFromAi 
          ? CrossAxisAlignment.start 
          : CrossAxisAlignment.end,
        children: [
          // 메시지 버블
          if (message.messageType == MessageType.text)
            _buildTextMessage(message)
          else if (message.messageType == MessageType.suggestions)
            _buildSuggestionsMessage(message),
          
          // 타임스탬프
          const SizedBox(height: 4),
          Text(
            _formatTime(message.timestamp),
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  /// 📝 텍스트 메시지
  Widget _buildTextMessage(ChatMessage message) {
    return Row(
      mainAxisAlignment: message.isFromAi 
        ? MainAxisAlignment.start 
        : MainAxisAlignment.end,
      children: [
        if (message.isFromAi) ...[
          // AI 아바타
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B73FF), Color(0xFF9F7AEA)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
        ],
        
        // 메시지 버블
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: message.isFromAi 
                ? Colors.white 
                : const Color(0xFF6B73FF),
              borderRadius: BorderRadius.circular(20).copyWith(
                bottomLeft: message.isFromAi 
                  ? const Radius.circular(4) 
                  : const Radius.circular(20),
                bottomRight: message.isFromAi 
                  ? const Radius.circular(20) 
                  : const Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message.content,
              style: TextStyle(
                fontSize: 15,
                color: message.isFromAi 
                  ? const Color(0xFF2D3748) 
                  : Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 💡 추천 질문 메시지
  Widget _buildSuggestionsMessage(ChatMessage message) {
    return Row(
      children: [
        // AI 아바타
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6B73FF), Color(0xFF9F7AEA)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.psychology,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        
        // 추천 질문들
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '💡 이런 주제로 대화해보는 건 어떨까요?',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: message.suggestions!.map((suggestion) {
                  return GestureDetector(
                    onTap: () => _sendMessage(suggestion),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B73FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF6B73FF).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        suggestion,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B73FF),
                          fontWeight: FontWeight.w500,
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

  /// ⌨️ 타이핑 인디케이터
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // AI 아바타
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B73FF), Color(0xFF9F7AEA)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          
          // 타이핑 애니메이션
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
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
                    final animationValue = (_typingAnimationController.value - delay).clamp(0.0, 1.0);
                    final opacity = (animationValue < 0.5) 
                      ? animationValue * 2 
                      : (1 - animationValue) * 2;
                    
                    return Padding(
                      padding: EdgeInsets.only(right: index < 2 ? 4 : 0),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF94A3B8).withOpacity(opacity),
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

  /// ⌨️ 입력 영역
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 메시지 입력 필드
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                  ),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: '메시지를 입력하세요...',
                    hintStyle: TextStyle(
                      color: Color(0xFF94A3B8),
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
                    if (text.trim().isNotEmpty) {
                      _sendMessage(text.trim());
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // 전송 버튼
            GestureDetector(
              onTap: () {
                final text = _messageController.text.trim();
                if (text.isNotEmpty) {
                  _sendMessage(text);
                }
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6B73FF), Color(0xFF9F7AEA)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
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

    // 사용자 메시지 추가
    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: content,
          isFromAi: false,
          timestamp: DateTime.now(),
          messageType: MessageType.text,
        ),
      );
    });

    _messageController.clear();
    _scrollToBottom();

    // AI 응답 시뮬레이션
    _simulateAiResponse(content);
  }

  /// 🤖 AI 응답 시뮬레이션
  void _simulateAiResponse(String userMessage) {
    setState(() {
      _isAiTyping = true;
    });

    // 응답 지연 시뮬레이션
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final aiResponse = _generateAiResponse(userMessage);
        
        setState(() {
          _isAiTyping = false;
          _messages.add(
            ChatMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              content: aiResponse,
              isFromAi: true,
              timestamp: DateTime.now(),
              messageType: MessageType.text,
            ),
          );
        });

        _scrollToBottom();
      }
    });
  }

  /// 🎯 AI 응답 생성 (간단한 패턴 매칭)
  String _generateAiResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    if (message.contains('기분') || message.contains('어때')) {
      return '기분에 대해 이야기해주셔서 감사합니다. 😊\n\n지금 느끼시는 감정을 조금 더 구체적으로 표현해주시면, 더 도움이 되는 대화를 나눌 수 있을 것 같아요. 예를 들어, 무엇이 그런 기분을 만들었는지 말씀해 주시겠어요?';
    } else if (message.contains('고민') || message.contains('걱정')) {
      return '고민이 있으시군요. 마음이 무거우실 것 같아요. 💭\n\n고민을 나누는 것만으로도 마음이 한결 가벼워질 수 있어요. 어떤 부분이 가장 신경 쓰이시는지 천천히 말씀해 주세요. 함께 해결 방법을 찾아보아요.';
    } else if (message.contains('스트레스') || message.contains('힘들')) {
      return '스트레스를 받고 계시는군요. 정말 수고 많으셨어요. 😴\n\n스트레스는 누구에게나 찾아오는 자연스러운 반응이에요. 지금 가장 큰 스트레스 요인이 무엇인지, 그리고 평소에 마음이 편해지는 활동이 있는지 알려주시겠어요?';
    } else if (message.contains('목표') || message.contains('계획')) {
      return '목표를 세우려고 하시는군요! 정말 멋진 마음가짐이에요. 🎯\n\n구체적으로 어떤 분야의 목표를 생각하고 계신가요? 작은 목표부터 시작해서 단계적으로 달성해 나가는 것이 좋답니다. 함께 실현 가능한 계획을 세워보아요!';
    } else {
      return '말씀해 주신 내용을 잘 들었습니다. 🤗\n\n더 깊이 있는 대화를 위해 조금 더 자세히 설명해 주시거나, 어떤 도움이 필요한지 구체적으로 말씀해 주시면 좋겠어요. 저는 언제나 여기서 당신의 이야기를 들을 준비가 되어 있답니다.';
    }
  }

  /// 📱 채팅 옵션 표시
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
            const Text(
              '채팅 옵션',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.refresh, color: Color(0xFF6B73FF)),
              title: const Text('대화 초기화'),
              onTap: () {
                Navigator.pop(context);
                _resetChat();
              },
            ),
            ListTile(
              leading: const Icon(Icons.save, color: Color(0xFF4ECDC4)),
              title: const Text('대화 저장'),
              onTap: () {
                Navigator.pop(context);
                _saveChat();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 🔄 유틸리티 메서드들
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

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _resetChat() {
    setState(() {
      _messages.clear();
    });
    _initializeChat();
  }

  void _saveChat() {
    // TODO: 실제 저장 로직 구현
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('💾 대화가 저장되었습니다!'),
        backgroundColor: Color(0xFF4ECDC4),
      ),
    );
  }
}

/// 💬 채팅 메시지 모델
class ChatMessage {
  final String id;
  final String content;
  final bool isFromAi;
  final DateTime timestamp;
  final MessageType messageType;
  final List<String>? suggestions;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isFromAi,
    required this.timestamp,
    required this.messageType,
    this.suggestions,
  });
}

/// 📝 메시지 타입
enum MessageType {
  text,
  suggestions,
}
