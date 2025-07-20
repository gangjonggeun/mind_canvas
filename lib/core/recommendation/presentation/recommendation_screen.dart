import 'package:flutter/material.dart';
import 'pages/ideal_type_worldcup_page.dart';
import 'pages/personality_recommendations_page.dart';
import 'pages/user_recommendation_page.dart';

/// 🌟 Mind Canvas 추천 메인 화면
/// 
/// 성격 기반 컨텐츠 추천을 메인으로, 데이터 수집 및 상호 추천을 서브로 구성
/// - 🎯 성격 기반 컨텐츠 추천 (메인): 드라마/영화/게임/소설/음악 추천
/// - 🏆 이상형 월드컵 (서브): 재미있는 테스트로 성격 데이터 수집  
/// - 👥 사용자 컨텐츠 추천 (서브): 비슷한 성격 사용자간 상호 추천
class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A202C) : const Color(0xFFF7F9FC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 영역
              _buildHeader(isDark),
              const SizedBox(height: 32),
              
              // 🎯 메인: 성격 기반 컨텐츠 추천 (50%)
              _buildPersonalizedContentSection(context, isDark),
              const SizedBox(height: 32),
              
              // 🏆 서브1: 이상형 월드컵 (30%) 
              _buildWorldCupSection(context, isDark),
              const SizedBox(height: 24),
              
              // 👥 서브2: 사용자 컨텐츠 추천 (20%)
              _buildUserRecommendationSection(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎨 헤더 섹션
  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B73FF), Color(0xFF9F7AEA)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
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

  /// 🎯 메인: 성격 기반 컨텐츠 추천 섹션 (50%)
  Widget _buildPersonalizedContentSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4ECDC4),
            Color(0xFF44A08D),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4ECDC4).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎯 성격 기반 컨텐츠 추천',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '당신의 성격에 딱 맞는 드라마, 영화, 게임을 만나보세요',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _navigateToPersonalityRecommendations(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '전체보기',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // 컨텐츠 카테고리 그리드
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.4,
            children: [
              _buildContentCategoryCard(
                context,
                '🎬', '드라마 & 영화', 'drama_movie',
                '당신의 취향에 맞는\n작품 추천',
                Colors.red,
              ),
              _buildContentCategoryCard(
                context,
                '🎮', '게임', 'game',
                '성격에 맞는\n게임 장르 추천',
                Colors.blue,
              ),
              _buildContentCategoryCard(
                context,
                '📚', '소설 & 웹툰', 'book_webtoon',
                '몰입할 수 있는\n스토리 추천',
                Colors.orange,
              ),
              _buildContentCategoryCard(
                context,
                '🎵', '음악 & 플레이리스트', 'music_playlist',
                '감성에 어울리는\n음악 추천',
                Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // 오늘의 추천 미리보기
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '✨ 오늘의 추천',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final recommendations = [
                        {'title': '사랑의 불시착', 'type': '로맨스 드라마', 'match': '94%'},
                        {'title': '젤다의 전설', 'type': '어드벤처 게임', 'match': '89%'},
                        {'title': 'Lo-fi 플레이리스트', 'type': '집중 음악', 'match': '92%'},
                        {'title': '달러구트 꿈 백화점', 'type': '판타지 소설', 'match': '87%'},
                      ];
                      
                      final rec = recommendations[index];
                      return Container(
                        width: 140,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rec['title']!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rec['type']!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '일치도',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  rec['match']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🎭 컨텐츠 카테고리 카드
  Widget _buildContentCategoryCard(
    BuildContext context,
    String emoji,
    String title,
    String category,
    String subtitle,
    Color accentColor,
  ) {
    return GestureDetector(
      onTap: () => _navigateToContentCategory(context, category),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const Spacer(),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🏆 서브1: 이상형 월드컵 섹션 (30%)
  Widget _buildWorldCupSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D3748) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B73FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Color(0xFF6B73FF),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '🏆 재미있는 테스트',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '이상형 월드컵을 통해 취향을 발견하고 데이터를 수집해요',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),
          
          // 테스트 카테고리 목록
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.8,
            children: [
              _buildTestCategoryCard(
                context, isDark,
                '🍽️', '음식 취향', 'food',
                '당신의 음식 취향을 알아보세요',
              ),
              _buildTestCategoryCard(
                context, isDark,
                '🎬', '영화 장르', 'movie',
                '선호하는 영화 장르 발견',
              ),
              _buildTestCategoryCard(
                context, isDark,
                '✈️', '여행 스타일', 'travel',
                '이상적인 여행 스타일 찾기',
              ),
              _buildTestCategoryCard(
                context, isDark,
                '🎵', '음악 취향', 'music',
                '좋아하는 음악 스타일 분석',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🎭 테스트 카테고리 카드
  Widget _buildTestCategoryCard(
    BuildContext context,
    bool isDark,
    String emoji,
    String title,
    String category,
    String subtitle,
  ) {
    return GestureDetector(
      onTap: () => _navigateToWorldCup(context, category),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF4A5568) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                      height: 1.2,
                    ),
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

  /// 👥 서브2: 사용자 컨텐츠 추천 섹션 (20%)
  Widget _buildUserRecommendationSection(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D3748) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black).withOpacity(0.05),
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
                child: const Icon(
                  Icons.people,
                  color: Color(0xFF9F7AEA),
                  size: 24,
                ),
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
                onTap: () => _navigateToUserRecommendations(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          
          // 사용자 추천 미리보기
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final userRecs = [
                  {'title': '사용자 @김민수', 'content': '"스트레인저 씽즈" 강추!', 'similarity': '91%'},
                  {'title': '사용자 @박지은', 'content': '카페 브런치 플레이리스트', 'similarity': '89%'},
                  {'title': '사용자 @이준호', 'content': '힐링 게임 "스타듀밸리"', 'similarity': '87%'},
                ];
                
                final rec = userRecs[index];
                return Container(
                  width: 180,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF4A5568) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              rec['title']!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF2D3748),
                              ),
                            ),
                          ),
                          Text(
                            rec['similarity']!,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9F7AEA),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        rec['content']!,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 🚀 네비게이션 메서드들 (메모리 최적화를 위해 lazy loading)
  void _navigateToPersonalityRecommendations(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PersonalityRecommendationsPage(),
        settings: const RouteSettings(name: '/personality-recommendations'),
      ),
    );
  }

  void _navigateToContentCategory(BuildContext context, String category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PersonalityRecommendationsPage(initialCategory: category),
        settings: RouteSettings(name: '/content-category/$category'),
      ),
    );
  }

  void _navigateToWorldCup(BuildContext context, String category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => IdealTypeWorldCupPage(category: category),
        settings: RouteSettings(name: '/worldcup/$category'),
      ),
    );
  }

  void _navigateToUserRecommendations(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const UserRecommendationPage(),
        settings: const RouteSettings(name: '/user-recommendations'),
      ),
    );
  }
}
