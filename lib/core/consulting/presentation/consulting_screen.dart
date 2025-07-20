import 'package:flutter/material.dart';
import 'pages/emotion_diary_page.dart';
import 'pages/ai_chat_page.dart';

/// 🧠 Mind Canvas 상담 메인 화면
/// 
/// AI 감정일기와 AI 상담 채팅 기능을 제공하는 허브 화면
/// - 깔끔한 카드 기반 UI
/// - 메모리 최적화된 네비게이션
/// - 다크모드 지원 준비
class ConsultingScreen extends StatelessWidget {
  const ConsultingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 영역
              _buildHeader(),
              const SizedBox(height: 32),
              
              // 상담 옵션 카드들
              _buildConsultingOptions(context),
              const SizedBox(height: 24),
              
              // 최근 활동 섹션 (추후 확장용)
              _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎨 헤더 섹션
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF6B73FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.psychology,
                color: Color(0xFF6B73FF),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🌱 마음 상담',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'AI와 함께하는 감정 케어',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 📋 상담 옵션 카드들
  Widget _buildConsultingOptions(BuildContext context) {
    return Column(
      children: [
        // AI 감정일기 카드
        _buildConsultingCard(
          context: context,
          icon: Icons.edit_note,
          iconColor: const Color(0xFF4ECDC4),
          title: '💭 AI 감정일기',
          subtitle: '오늘의 감정을 기록하고\nAI와 함께 분석해보세요',
          gradientColors: [
            const Color(0xFF4ECDC4).withOpacity(0.1),
            const Color(0xFF44A08D).withOpacity(0.1),
          ],
          onTap: () => _navigateToEmotionDiary(context),
        ),
        const SizedBox(height: 16),
        
        // AI 상담 채팅 카드
        _buildConsultingCard(
          context: context,
          icon: Icons.chat_bubble_outline,
          iconColor: const Color(0xFF667EEA),
          title: '💬 AI 상담 채팅',
          subtitle: '실시간으로 AI 상담사와\n대화하며 마음을 나눠보세요',
          gradientColors: [
            const Color(0xFF667EEA).withOpacity(0.1),
            const Color(0xFF764BA2).withOpacity(0.1),
          ],
          onTap: () => _navigateToAiChat(context),
        ),
      ],
    );
  }

  /// 🎭 상담 카드 위젯 (재사용 가능)
  Widget _buildConsultingCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // 아이콘 영역
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            
            // 텍스트 영역
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            // 화살표 아이콘
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF94A3B8),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  /// 📊 최근 활동 섹션 (추후 확장)
  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.timeline,
                color: Color(0xFF6B73FF),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                '📈 최근 활동',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 플레이스홀더 (추후 실제 데이터로 교체)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '아직 상담 기록이 없습니다.\n위의 옵션을 선택해 시작해보세요!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      height: 1.4,
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

  /// 🚀 네비게이션 메서드들 (메모리 최적화)
  void _navigateToEmotionDiary(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EmotionDiaryPage(),
        settings: const RouteSettings(name: '/emotion-diary'),
      ),
    );
  }

  void _navigateToAiChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AiChatPage(),
        settings: const RouteSettings(name: '/ai-chat'),
      ),
    );
  }
}
