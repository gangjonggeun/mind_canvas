import 'package:flutter/material.dart';
import 'package:mind_canvas/features/recommendation/presentation/pages/community_page.dart';
import 'package:mind_canvas/features/recommendation/presentation/widgets/community_promo_section.dart';

// 실제 프로젝트에서는 아래 import 경로를 활성화하고 사용하세요.
import '../../../core/widgets/common_sliver_app_bar.dart';
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
          const CommonSliverAppBar(
            title: '맞춤 컨텐츠 추천',
            subtitle: '당신의 성격에 딱 맞는 컨텐츠를 찾아보세요',
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

  /// 🎨 1. 헤더 섹션
  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✨ 맞춤 추천',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '당신의 성격에 맞는 특별한 추천',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
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


  /// 👥 4. 서브2: 사용자 컨텐츠 추천 섹션
  Widget _buildUserRecommendationSection(bool isDark) {
    final recommendations = MockContentData.getUserRecommendations();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D3748) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black).withOpacity(0.07),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF9F7AEA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.people, color: Color(0xFF9F7AEA), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '👥 사용자 추천',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      '비슷한 성격의 사용자들이 추천한 컨텐츠',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _navigateToUserRecommendations(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9F7AEA).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '더보기',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9F7AEA),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: recommendations.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final rec = recommendations[index];
                return _buildUserRecommendationCard(rec, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }


  /// 이상형 월드컵 테스트 카테고리 카드 위젯
  Widget _buildTestCategoryCard(bool isDark, String emoji, String title, String category, String subtitle) {
    return GestureDetector(
      onTap: () => _navigateToWorldCup(category),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF4A5568) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748)),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 사용자 추천 카드 위젯
  Widget _buildUserRecommendationCard(Map<String, String> rec, bool isDark) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF4A5568) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rec['title']!,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748)),
              ),
              Text(
                rec['similarity']!,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF9F7AEA)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            rec['content']!,
            style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B), height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }




  /// 🚀 네비게이션 함수들
  void _navigateToPersonalityRecommendations() {
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (_) => const PersonalityRecommendationsPage()),
    // );
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