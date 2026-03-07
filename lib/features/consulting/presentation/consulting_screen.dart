import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:mind_canvas/features/consulting/presentation/pages/anger_vent_page.dart';
import '../../../core/widgets/common_sliver_app_bar.dart';
import '../../../generated/l10n.dart';
import 'pages/emotion_diary_page.dart';
import 'pages/ai_chat_page.dart';
// import 'pages/mindfulness_sound_page.dart'; // TODO: 구현 필요
// import 'pages/heart_mailbox_page.dart'; // TODO: 구현 필요

/// 🧠 Mind Canvas 상담 메인 화면
///
/// 확장된 상담 기능들을 제공하는 허브 화면:
/// - AI 감정일기 & AI 상담 채팅 (기존)
/// - 마음챙김 사운드 & 마음 우체통 (신규)
/// - 가로 긴 카드 형태의 세로 배치 UI
/// - 메모리 최적화된 네비게이션
/// - 다크모드 지원
class ConsultingScreen extends StatelessWidget {
  static final _logger = Logger('ConsultingScreen');

  const ConsultingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F9FC),
      // ✅ [수정] SingleChildScrollView -> CustomScrollView로 변경해야 SliverAppBar 사용 가능
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. 헤더 (SliverAppBar)
          CommonSliverAppBar(
            title: S.of(context).consulting_header,
            subtitle: S.of(context).consulting_subtitle,
            // 🌱 새싹 모양 아이콘 적용 (아래 설명 참고)
            icon: Icons.eco_rounded,
            iconColor: Color(0xFF69F0AE),
          ),

          // 2. 나머지 컨텐츠 (SliverList로 감싸기)
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 32),

              // 패딩을 여기서 줍니다.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // 상담 옵션 카드들
                    _buildConsultingOptions(context, isDark),
                    const SizedBox(height: 24),

                    // 최근 활동 섹션
                    // _buildRecentActivity(isDark),
                    const SizedBox(height: 40), // 하단 여백
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  /// 🎨 헤더 섹션 - 다크모드 지원
  Widget _buildHeader(bool isDark) {
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748);
    final subTextColor = isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF6B73FF).withOpacity(isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.psychology,
                color: Color(0xFF6B73FF),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🌱 마음 상담',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'AI와 함께하는 종합 감정 케어',
                    style: TextStyle(
                      fontSize: 16,
                      color: subTextColor,
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

  Widget _buildConsultingOptions(BuildContext context, bool isDark) {
    return Column(
      children: [
        // AI 감정일기 카드
        _buildConsultingCard(
          context: context,
          isDark: isDark,
          icon: Icons.edit_note,
          iconColor: const Color(0xFF4ECDC4),
          title: S.of(context).consulting_journal,
          subtitle: S.of(context).consulting_journal_subtitle,
          gradientColors: [
            const Color(0xFF4ECDC4).withOpacity(isDark ? 0.2 : 0.1),
            const Color(0xFF44A08D).withOpacity(isDark ? 0.2 : 0.1),
          ],
          onTap: () => _navigateToEmotionDiary(context),
        ),
        const SizedBox(height: 16),

        // AI 상담 채팅 카드
        _buildConsultingCard(
          context: context,
          isDark: isDark,
          icon: Icons.chat_bubble_outline,
          iconColor: const Color(0xFF667EEA),
          title: S.of(context).consulting_chat,
          subtitle: S.of(context).consulting_chat_subtitle,
          gradientColors: [
            const Color(0xFF667EEA).withOpacity(isDark ? 0.2 : 0.1),
            const Color(0xFF764BA2).withOpacity(isDark ? 0.2 : 0.1),
          ],
          onTap: () => _navigateToAiChat(context),
        ),
        const SizedBox(height: 16),

        // 🔥 AI 화풀기 채팅 카드 (NEW!)
        _buildConsultingCard(
          context: context,
          isDark: isDark,
          icon: Icons.local_fire_department, // 화풀이 아이콘
          iconColor: const Color(0xFFFF5F6D), // 붉은색 계열
          title: S.of(context).consulting_punchingbag,
          subtitle: S.of(context).consulting_punchingbag_subtitle,
          gradientColors: [
            // 붉은색 계열 그라데이션
            const Color(0xFFFF5F6D).withOpacity(isDark ? 0.2 : 0.1),
            const Color(0xFFFFC371).withOpacity(isDark ? 0.2 : 0.1),
          ],
          onTap: () => _navigateToAngerVent(context), // 새로운 네비게이션 함수
          badge: S.of(context).consulting_new,
          badgeColor: const Color(0xFFFF5F6D),
        ),
        const SizedBox(height: 16),
        //
        // // 마음챙김 사운드 카드
        // _buildConsultingCard(
        //   context: context,
        //   isDark: isDark,
        //   icon: Icons.spa_outlined,
        //   iconColor: const Color(0xFF38A169),
        //   title: '🧘 마음챙김 사운드',
        //   subtitle: '명상과 힐링 사운드로\n마음의 평온을 찾아보세요',
        //   gradientColors: [
        //     const Color(0xFF38A169).withOpacity(isDark ? 0.2 : 0.1),
        //     const Color(0xFF2F855A).withOpacity(isDark ? 0.2 : 0.1),
        //   ],
        //   onTap: () => _navigateToMindfulnessSound(context),
        //   badge: '신규',
        //   badgeColor: const Color(0xFF38A169),
        // ),
        // const SizedBox(height: 16),
        //
        // // 마음 우체통 카드
        // _buildConsultingCard(
        //   context: context,
        //   isDark: isDark,
        //   icon: Icons.mail_outline,
        //   iconColor: const Color(0xFFD69E2E),
        //   title: '💌 마음 우체통',
        //   subtitle: '소중한 사람에게 마음을 담은\n편지를 보내보세요',
        //   gradientColors: [
        //     const Color(0xFFD69E2E).withOpacity(isDark ? 0.2 : 0.1),
        //     const Color(0xFFB7791F).withOpacity(isDark ? 0.2 : 0.1),
        //   ],
        //   onTap: () => _navigateToHeartMailbox(context),
        //   badge: '신규',
        //   badgeColor: const Color(0xFFD69E2E),
        // ),
      ],
    );
  }

  void _navigateToAngerVent(BuildContext context) {
    _logger.info('Navigate to Anger Vent');
    context.pushNamed('anger_vent');
  }

  /// 🎭 상담 카드 위젯 (재사용 가능) - 가로 긴 형태
  Widget _buildConsultingCard({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required VoidCallback onTap,
    String? badge,
    Color? badgeColor,
  }) {
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748);
    final subTextColor = isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B);

    return GestureDetector(
      onTap: () {
        _logger.info('Consulting card tapped: $title');
        onTap();
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardColor,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
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
                    color: isDark ? Colors.white.withOpacity(0.9) : Colors.white,
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: subTextColor,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // 화살표 아이콘
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                  size: 18,
                ),
              ],
            ),
          ),

          // 신규 배지 (선택사항)
          if (badge != null && badgeColor != null)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 📊 최근 활동 섹션 - 다크모드 지원
  Widget _buildRecentActivity(bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748);
    final subTextColor = isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B);
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F9FC);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
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
              Text(
                '📈 최근 활동',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 활동 내역 리스트 (예시 데이터)
          _buildActivityCard(
            isDark: isDark,
            icon: Icons.edit_note,
            iconColor: const Color(0xFF4ECDC4),
            title: '감정일기 작성',
            subtitle: '오늘 기분을 기록했어요',
            time: '2시간 전',
            bgColor: bgColor,
            textColor: textColor,
            subTextColor: subTextColor,
          ),
          const SizedBox(height: 12),

          _buildActivityCard(
            isDark: isDark,
            icon: Icons.spa_outlined,
            iconColor: const Color(0xFF38A169),
            title: '명상 사운드 감상',
            subtitle: '15분간 힐링 음악을 들었어요',
            time: '어제',
            bgColor: bgColor,
            textColor: textColor,
            subTextColor: subTextColor,
          ),
          const SizedBox(height: 12),

          _buildActivityCard(
            isDark: isDark,
            icon: Icons.mail_outline,
            iconColor: const Color(0xFFD69E2E),
            title: '마음 편지 발송',
            subtitle: '소중한 사람에게 편지를 보냈어요',
            time: '3일 전',
            bgColor: bgColor,
            textColor: textColor,
            subTextColor: subTextColor,
          ),
        ],
      ),
    );
  }

  /// 📝 활동 카드 위젯
  Widget _buildActivityCard({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required Color bgColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: subTextColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: subTextColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// 🚀 네비게이션 메서드들 (메모리 최적화)
  void _navigateToEmotionDiary(BuildContext context) {
    context.pushNamed('emotion_diary');
  }

  void _navigateToAiChat(BuildContext context) {
    context.pushNamed('ai_chat');
  }

  void _navigateToMindfulnessSound(BuildContext context) {
    _logger.info('Navigate to Mindfulness Sound');
    // TODO: MindfulnessSoundPage 구현 후 주석 해제
    /*
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MindfulnessSoundPage(),
        settings: const RouteSettings(name: '/mindfulness-sound'),
      ),
    );
    */

    // 임시 스낵바 (구현 전까지)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.spa, color: Colors.white),
            SizedBox(width: 8),
            Text('🧘 마음챙김 사운드 페이지 준비 중입니다'),
          ],
        ),
        backgroundColor: const Color(0xFF38A169),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _navigateToHeartMailbox(BuildContext context) {
    _logger.info('Navigate to Heart Mailbox');
    // TODO: HeartMailboxPage 구현 후 주석 해제
    /*
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HeartMailboxPage(),
        settings: const RouteSettings(name: '/heart-mailbox'),
      ),
    );
    */

    // 임시 스낵바 (구현 전까지)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.mail, color: Colors.white),
            SizedBox(width: 8),
            Text('💌 마음 우체통 페이지 준비 중입니다'),
          ],
        ),
        backgroundColor: const Color(0xFFD69E2E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}