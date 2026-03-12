import 'package:flutter/material.dart';
import 'package:mind_canvas/features/recommendation/presentation/pages/community_page.dart';
import 'package:mind_canvas/features/recommendation/presentation/widgets/community_promo_section.dart';

// 실제 프로젝트에서는 아래 import 경로를 활성화하고 사용하세요.
import '../../../core/widgets/common_sliver_app_bar.dart';
import '../../../generated/l10n.dart';
import 'pages/ideal_type_worldcup_page.dart';
import 'pages/personality_recommendations_page.dart';
import 'pages/user_recommendation_page.dart';
import '../data/mock_content_data.dart'; // 제공해주신 Mock 데이터 파일
import '../domain/enums/rec_category.dart';
import 'widgets/personalized_content_section.dart'; // 위젯 import


/// 🌟 Mind Canvas 추천 메인 화면
///
/// 성격 기반 컨텐츠 추천을 메인으로, 데이터 수집 및 상호 추천을 서브로 구성
/// - 🎯 성격 기반 컨텐츠 추천 (메인): '나'를 위한 추천과 '함께' 즐길 컨텐츠 추천 기능 포함
/// - 🏆 이상형 월드컵 (서브): 재미있는 테스트로 성격 데이터 수집
/// - 👥 사용자 컨텐츠 추천 (서브): 비슷한 성격 사용자간 상호 추천
class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  // final String _userMbti = 'INFP';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 배경색 정의
    final bgColorStart = isDark ? const Color(0xFF2D3748) : const Color(0xFFF8FAFC);
    final bgColorEnd = isDark ? const Color(0xFF1A202C) : const Color(0xFFF1F5F9);
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
    final subTextColor = isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColorStart, // 스크롤 시 빈 공간 색상
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ✅ 1. 트렌디한 앱바 (아이콘 없이 텍스트만)
           CommonSliverAppBar(
            title: S.of(context).recommendation_title,
            subtitle: S.of(context).recommendation_subtitle,
            icon: Icons.auto_awesome_rounded,
            iconColor: Color(0xFFFFB74D), // 포인트 컬러 변경
          ),

          // ✅ 2. 바디 컨텐츠 (SliverList로 감싸기)
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),

              // 메인: 성격 기반 컨텐츠 추천
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: PersonalizedContentSection(),
              ),

              const SizedBox(height: 40),

              // 서브: 커뮤니티 프로모션 (배너)
              // (Padding을 위젯 내부에서 주거나 여기서 감싸주세요)
              const CommunityPromoSection(),

              const SizedBox(height: 40), // 하단 여백
            ]),
          ),
        ],
      ),
    );
  }




  void _navigateToWorldCup(String category) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => IdealTypeWorldCupPage(category: category)),
    );
  }

  void _navigateToUserRecommendations() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CommunityPage()),
    );
  }
}