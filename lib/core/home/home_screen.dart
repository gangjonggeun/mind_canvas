import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../features/info/info_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_assets.dart';
import '../theme/app_theme.dart';
import 'widgets/home_viewpager.dart';


/// 컨텐츠 타입 열거형
enum ContentType { movie, drama, music }

/// 컨텐츠 모드 열거형 (개인 추천 vs 함께 보기)
enum ContentMode { personal, together }
/// Mind Canvas 심리테스트 홈 화면
/// 
/// 심리테스트 메인 대시보드
/// - ViewPager (타로, 페르소나, HTP)
/// - 테스트 랭킹 및 추천
/// - 카테고리별 테스트 목록
/// - 최근 검사 기록
/// - 프로모션 배너
class HomeScreen extends StatefulWidget {
  final VoidCallback? onGoToAnalysis; // 분석 화면으로 이동 콜백

  const HomeScreen({
    super.key,
    this.onGoToAnalysis,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ===== 📱 컨텐츠 추천 상태 관리 =====
  ContentType _selectedContentType = ContentType.movie;
  ContentMode _selectedContentMode = ContentMode.personal;
  String _userMbti = 'ENFP'; // 예시 데이터
  String _partnerMbti = 'ISFJ'; // 예시 데이터

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // ===== 📱 상단 ViewPager =====
            const HomeViewPager(),

            // ===== 📋 메인 컨텐츠 영역 (반응형 패딩) =====
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.getMainPadding(context)),  // 반응형 패딩
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildTestRanking(),
                    const SizedBox(height: 32),
                    _buildUserRecommendations(),
                    const SizedBox(height: 32),
                    _buildTestCategories(),
                    const SizedBox(height: 32),
                    _buildRecentTests(),
                    const SizedBox(height: 32),
                    _buildPsychologyInsights(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🧠 심리 팁 인사이트 섹션
  Widget _buildPsychologyInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('💡 심리 인사이트', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            TextButton(onPressed: () {}, child: const Text('더보기', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w500))),
          ],
        ),
        const SizedBox(height: 16),

        // ===== 🧠 첫 번째 인사이트: 심리 학자의 조언 =====
        _buildPsychologyInsightCard(
          title: '대인 관계 회복',
          subtitle: '전문가의 심리학 지식으로\n더 깊이 있는 자아 이해를 도와드려요',
          imageUrl: 'https://images.unsplash.com/photo-1544027993-37dbfe43562a?w=600&h=150&fit=crop&auto=format',
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
          badgeText: '전문가',
        ),

        const SizedBox(height: 12),

        // ===== 🌌 두 번째 인사이트: 일상 심리학 =====
        _buildPsychologyInsightCard(
          title: '일상 심리학',
          subtitle: '매일 만나는 상황에서\n심리학적 원리를 찾아보세요',
          imageUrl: 'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=600&h=150&fit=crop&auto=format',
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF26C6DA), Color(0xFF00BCD4)],
          ),
          badgeText: '일상',
        ),

        const SizedBox(height: 12),

        // ===== 💭 세 번째 인사이트: 마음 챙기기 =====
        _buildPsychologyInsightCard(
          title: '마음 챙기기',
          subtitle: '스트레스와 불안에서 벗어나\n평온한 마음을 찾아보세요',
          imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&h=150&fit=crop&auto=format',
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFFF8A65), Color(0xFFFFB74D)],
          ),
          badgeText: '힐링',
        ),
      ],
    );
  }

  /// 심리 인사이트 카드 빌더
  Widget _buildPsychologyInsightCard({
    required String title,
    required String subtitle,
    required String imageUrl,
    required Gradient gradient,
    required String badgeText,
  }) {
    return GestureDetector(
      onTap: () {
        print('심리 인사이트 클릭: $title');
      },
      child: Container(
        width: double.infinity,
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // ===== 🖼️ 배경 이미지 (고선명도 최적화) =====
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  placeholder: (context, url) => Container(
                    decoration: BoxDecoration(gradient: gradient),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(gradient: gradient),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          color: Colors.white.withOpacity(0.7),
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '이미지 로딩 실패',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ===== 🎨 그라데이션 오버레이 (더 부드럽게) =====
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.5, 1.0],
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ===== 📝 주요 컨텐츠 영역 =====
              Positioned(
                left: 20,
                right: 70,
                top: 0,
                bottom: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🏷️ 배지
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        badgeText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 📝 메인 타이틀
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // 📄 서브 타이틀
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // ===== 🔜 오른쪽 아이콘 영역 =====
              Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🏆 인기 테스트 랭킹 섹션 (반응형)
  Widget _buildTestRanking() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('🏆 인기 테스트 랭킹', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            TextButton(onPressed: () {}, child: const Text('더보기', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w500))),
          ],
        ),
        const SizedBox(height: 16),
        // 가로 스크롤 카드 형태 (반응형 높이)
        SizedBox(
          height: AppDimensions.getRankingCardTotalHeight(context),  // 반응형 높이
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4),
            children: [
              // 1위: MBTI 검사
              _buildRankingCard(
                rank: 1,
                title: 'MBTI 검사',
                subtitle: '성격 유형 분석',
                imagePath: AppAssets.mbtiItemHigh,
                participantCount: 12345,
                onTap: () {
                  print('MBTI 검사 선택됨');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => InfoScreen(
                        testId: 'mbti', // 또는 'mbti', 'persona'
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: AppDimensions.getRankingCardSpacing(context)),  // 반응형 간격

              // 2위: 페르소나 테스트
              _buildRankingCard(
                rank: 2,
                title: '페르소나 테스트',
                subtitle: '내면의 페르소나',
                imagePath: AppAssets.personaItemHigh,
                participantCount: 9876,
                onTap: () {
                  print('페르소나 선택됨');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => InfoScreen(
                        testId: 'persona', // 또는 'mbti', 'persona'
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: AppDimensions.getRankingCardSpacing(context)),  // 반응형 간격

              // 3위: HTP 심리검사
              _buildRankingCard(
                rank: 3,
                title: 'HTP 심리검사',
                subtitle: '집나무사람 그림검사',
                imagePath: AppAssets.headspaceItemHigh,
                participantCount: 7654,
                onTap: () {
                  print('HTP 심리검사  선택됨');
                  // TODO: HTP 검사 화면으로 이동
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => InfoScreen(
                        testId: 'htp', // 또는 'mbti', 'persona'
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('✨ 당신을 위한 추천', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 16),
        
        // ===== 🎯 추천 테스트 섹션 =====
        Container(
          padding: EdgeInsets.all(AppDimensions.getMainPadding(context)),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.backgroundSecondary, AppColors.backgroundTertiary]
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.withOpacity20(AppColors.primaryBlue)),
          ),
          child: Column(
            children: [
              // ===== 🎯 추천 테스트 헤더 =====
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: AppColors.withOpacity10(AppColors.primaryBlue),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: const Text('🎯', style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('당신을 위한 테스트', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        const Text('당신의 성향에 맞는 심리검사를 추천해드려요', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ===== 🎨 추천 검사 카드들 (랭킹 카드 재사용) =====
              SizedBox(
                height: AppDimensions.getRankingCardTotalHeight(context),  // 랭킹 카드와 동일한 높이
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // 첫 번째 추천: 꿈 분석 검사
                    _buildRecommendationCard(
                      title: '꿈 분석 검사',
                      subtitle: '무의식 탐구',
                      imagePath: AppAssets.personaItemHigh, // 기존 에셋 재사용
                      accuracy: '95%',
                      badgeText: '추천',
                      gradientColors: [AppColors.primaryBlue, AppColors.secondaryTeal],
                      onTap: () {
                        print('꿈 분석 검사 선택됨');
                      },
                    ),
                    SizedBox(width: AppDimensions.getRankingCardSpacing(context)),

                    // 두 번째 추천: 색채 심리 검사
                    _buildRecommendationCard(
                      title: '색채 심리 검사',
                      subtitle: '감정 상태 분석',
                      imagePath: AppAssets.mbtiItemHigh, // 기존 에셋 재사용
                      accuracy: '92%',
                      badgeText: '인기',
                      gradientColors: [AppColors.secondaryTeal, AppColors.secondaryPurple],
                      onTap: () {
                        print('색채 심리 검사 선택됨');
                      },
                    ),
                    SizedBox(width: AppDimensions.getRankingCardSpacing(context)),

                    // 세 번째 추천: 성격 분석 검사
                    _buildRecommendationCard(
                      title: '성격 분석 검사',
                      subtitle: '심층 성격 탐구',
                      imagePath: AppAssets.headspaceItemHigh, // 기존 에셋 재사용
                      accuracy: '89%',
                      badgeText: '신규',
                      gradientColors: [AppColors.secondaryPurple, Color(0xFFFF8A65)],
                      onTap: () {
                        print('성격 분석 검사 선택됨');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // ===== 🎬 추천 컨텐츠 섹션 =====
        _buildRecommendedContent(),
      ],
    );
  }

  Widget _buildTestCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('💭 인기 간단한 테스트', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            TextButton(onPressed: () {}, child: const Text('더보기', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w500))),
          ],
        ),
        const SizedBox(height: 16),

        // ===== 🌅 첫 번째 카드: 상상해보는 내 심리테스트 =====
        _buildImageContentCard(
          title: '상상해보는 내 심리테스트',
          imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&h=200&fit=crop&auto=format',
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFFF8A65), Color(0xFFFFAB40)],
          ),
        ),

        const SizedBox(height: 12),

        // ===== 🤝 두 번째 카드: 육감불만 테스트 =====
        _buildImageContentCard(
          title: '육감불만 테스트',
          imageUrl: 'https://images.unsplash.com/photo-1559181567-c3190ca9959b?w=600&h=200&fit=crop&auto=format',
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF42A5F5), Color(0xFF26C6DA)],
          ),
        ),

        const SizedBox(height: 12),

        // ===== 🌌 세 번째 카드: 남성적 VS 여성적 테스트 =====
        _buildImageContentCard(
          title: '당신은 남성적? 여성적? 남성성 여성성 테스트',
          imageUrl: 'https://images.unsplash.com/photo-1519578443396-9048f6db0b2f?w=600&h=200&fit=crop&auto=format',
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF7B1FA2), Color(0xFFAB47BC)],
          ),
        ),
      ],
    );
  }

  /// 이미지 기반 컨텐츠 카드 빌더
  Widget _buildImageContentCard({
    required String title,
    required String imageUrl,
    required Gradient gradient,
  }) {
    return GestureDetector(
      onTap: () {
        print('컨텐츠 카드 클릭: $title');
      },
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // ===== 🖼️ 배경 이미지 (고선명도 최적화) =====
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  placeholder: (context, url) => Container(
                    decoration: BoxDecoration(gradient: gradient),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(gradient: gradient),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          color: Colors.white.withOpacity(0.7),
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '이미지 로딩 실패',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ===== 🎨 그라데이션 오버레이 =====
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.4, 1.0],
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ===== 📝 텍스트 컨텐츠 =====
              Positioned(
                left: 20,
                right: 60,
                top: 0,
                bottom: 0,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              '심리테스트',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ===== 🔜 오른쪽 화살표 =====
              const Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('📈 최근 검사 기록', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      // 분석 화면으로 이동
                      widget.onGoToAnalysis?.call();
                    },
                    child: const Text('내 분석', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600))
                ),
                TextButton(
                    onPressed: () {},
                    child: const Text('전체보기', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w500))
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildRecentTestItem('🏠 HTP 심리검사', '2024.07.03', '분석 완료', AppColors.primaryBlue),
        const SizedBox(height: 12),
        _buildRecentTestItem('🎨 자유화 검사', '2024.07.01', '분석 중', AppColors.secondaryTeal),
        const SizedBox(height: 12),
        _buildRecentTestItem('👥 성격 유형 검사', '2024.06.28', '분석 완료', AppColors.secondaryPurple),
      ],
    );
  }

  /// 화면 크기에 따른 반응형 랭킹 카드
  Widget _buildRankingCard({
    required int rank,
    required String title,
    required String subtitle,
    required String imagePath,
    required int participantCount,
    required VoidCallback onTap,
  }) {
    // 랭킹별 색상 설정
    Color rankColor = _getRankColor(rank);

    print('🖼️ Loading responsive image: $imagePath');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.getRankingCardWidth(context),  // 반응형 너비
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(AppDimensions.rankingCardBorderRadius),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 이미지 및 랭킹 영역 (메인 이미지)
            Stack(
              children: [
                // 메인 이미지 - 반응형 크기로 관리
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.rankingCardBorderRadius)
                  ),
                  child: Container(
                    width: double.infinity,
                    height: AppDimensions.getRankingCardImageHeight(context),  // 반응형 높이
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary.withOpacity(0.1),
                    ),
                    child: _buildImageWithFallback(
                        imagePath,
                        AppDimensions.getRankingCardImageHeight(context)  // 반응형 높이 전달
                    ),
                  ),
                ),

                // 랭킹 배지
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: rankColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '$rank위',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppDimensions.getRankingCardRankBadgeFontSize(context),  // 반응형 폰트
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 하단 텍스트 정보 - 반응형 크기로 관리
            Padding(
              padding: EdgeInsets.all(AppDimensions.getRankingCardPadding(context)),  // 반응형 패딩
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목만 표시
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppDimensions.getRankingCardTitleFontSize(context),  // 반응형 폰트
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // 참여자 수만 표시
                  Text(
                    '${_formatParticipantCount(participantCount)}명 참여',
                    style: TextStyle(
                      fontSize: AppDimensions.getRankingCardParticipantFontSize(context),  // 반응형 폰트
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 랭킹별 색상 반환
  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // 금색
      case 2:
        return const Color(0xFFC0C0C0); // 은색
      case 3:
        return const Color(0xFFCD7F32); // 동색
      default:
        return AppColors.textTertiary;
    }
  }

  /// 참여자 수 포맷팅
  String _formatParticipantCount(int count) {
    if (count >= 10000) {
      return '${(count / 10000).toStringAsFixed(1)}만';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}천';
    } else {
      return count.toString();
    }
  }

  /// 이미지 로딩 및 fallback 처리 (단순 버전 - 디버깅용)
  Widget _buildImageWithFallback(String imagePath, double height) {
    print('🖼️ Loading simple image: $imagePath');

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.rankingCardBorderRadius)
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.rankingCardBorderRadius)
        ),
        child: Image.asset(
          imagePath,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
          // 간단한 설정만 사용
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) {
            print('❌ Image load failed: $imagePath - $error');
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.image_not_supported, size: 40),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 이미지 로딩 플레이스홀더
  Widget _buildImageLoadingPlaceholder(double height) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.backgroundSecondary.withOpacity(0.3),
            AppColors.primaryBlue.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryBlue.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '이미지 로딩 중...',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 이미지 에러 폴백
  Widget _buildImageErrorFallback(double height) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.withOpacity(0.1),
            Colors.orange.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            color: AppColors.textTertiary,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            '이미지 로딩 실패',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 테스트 타입별 아이콘
  IconData _getTestIcon(String imagePath) {
    if (imagePath.contains('mbti')) {
      return Icons.psychology;
    } else if (imagePath.contains('persona')) {
      return Icons.home;
    } else if (imagePath.contains('headspace')) {
      return Icons.self_improvement;
    } else {
      return Icons.quiz;
    }
  }

  /// 🎆 추천 검사를 위한 랭킹 카드 기반 위젯
  Widget _buildRecommendationCard({
    required String title,
    required String subtitle,
    required String imagePath,
    required String accuracy,
    required String badgeText,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.getRankingCardWidth(context),  // 랭킹 카드와 동일한 너비
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(AppDimensions.rankingCardBorderRadius),
          border: Border.all(color: gradientColors.first.withOpacity(0.3)), // 그라디언트 색상 사용
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 이미지 및 배지 영역
            Stack(
              children: [
                // 메인 이미지 - 랭킹 카드와 동일한 구조
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.rankingCardBorderRadius)
                  ),
                  child: Container(
                    width: double.infinity,
                    height: AppDimensions.getRankingCardImageHeight(context),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary.withOpacity(0.1),
                    ),
                    child: Stack(
                      children: [
                        // 배경 이미지
                        _buildImageWithFallback(
                          imagePath,
                          AppDimensions.getRankingCardImageHeight(context),
                        ),

                        // 그라디언트 오버레이 (추천 전용 스타일)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  gradientColors.first.withOpacity(0.3),
                                  gradientColors.last.withOpacity(0.1),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 추천 배지 (랭킹 배지 대신)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: gradientColors.first.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppDimensions.getRankingCardRankBadgeFontSize(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 하단 텍스트 정보 - 랭킹 카드와 동일한 구조
            Padding(
              padding: EdgeInsets.all(AppDimensions.getRankingCardPadding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppDimensions.getRankingCardTitleFontSize(context),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // 정확도 표시 (참여자 수 대신)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: gradientColors.first.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '정확도 $accuracy',
                          style: TextStyle(
                            fontSize: AppDimensions.getRankingCardParticipantFontSize(context),
                            fontWeight: FontWeight.w600,
                            color: gradientColors.first,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTestItem(String title, String date, String status, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.withOpacity10(color), borderRadius: BorderRadius.circular(6)),
            child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
          ),
        ],
      ),
    );
  }

  /// 🎬 추천 컨텐츠 섹션 (영화, 드라마, 노래 등)
  Widget _buildRecommendedContent() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.getMainPadding(context)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.withOpacity20(AppColors.secondaryTeal)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== 🎬 컨텐츠 추천 헤더 =====
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.withOpacity10(AppColors.secondaryTeal),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _selectedContentMode == ContentMode.personal ? '🎬' : '👥',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedContentMode == ContentMode.personal
                          ? '당신을 위한 컨텐츠'
                          : '함께 보기 추천',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedContentMode == ContentMode.personal
                          ? '성격에 맞는 영화, 드라마, 노래를 추천해드려요'
                          : '두 사람이 함께 즐길 수 있는 컨텐츠를 추천해드려요',
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              // 모드 전환 버튼
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedContentMode = _selectedContentMode == ContentMode.personal
                        ? ContentMode.together
                        : ContentMode.personal;
                  });
                },
                icon: Icon(
                  _selectedContentMode == ContentMode.personal
                      ? Icons.group_add_outlined
                      : Icons.person_outline,
                  color: AppColors.secondaryTeal,
                ),
                tooltip: _selectedContentMode == ContentMode.personal ? '함께 보기' : '개인 추천',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ===== 👥 함께 보기 모드일 때 MBTI 입력 영역 =====
          if (_selectedContentMode == ContentMode.together)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.withOpacity10(AppColors.primaryBlue),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.withOpacity20(AppColors.primaryBlue)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 5, // 비율 조정: 나의 MBTI 영역
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('나의 MBTI', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity, // 전체 너비 사용
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // 패딩 증가
                              decoration: BoxDecoration(
                                color: AppColors.backgroundCard,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.borderLight),
                              ),
                              child: Text(
                                _userMbti,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                textAlign: TextAlign.center, // 가운데 정렬
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12), // 간격 종소
                      const Icon(Icons.favorite, color: AppColors.primaryBlue, size: 20),
                      const SizedBox(width: 12), // 간격 종소
                      Expanded(
                        flex: 5, // 비율 조정: 상대방 MBTI 영역
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('상대방 MBTI', style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _showMbtiSelector(),
                              child: Container(
                                width: double.infinity, // 전체 너비 사용
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // 패딩 증가
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundCard,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.borderLight),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded( // 텍스트 오버플로우 방지
                                      child: Text(
                                        _partnerMbti,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                        textAlign: TextAlign.center, // 가운데 정렬
                                      ),
                                    ),
                                    const Icon(Icons.edit, size: 16, color: AppColors.textTertiary),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          if (_selectedContentMode == ContentMode.together)
            const SizedBox(height: 16),

          // ===== 📱 컨텐츠 카테고리 탭 =====
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildContentTab('🎬 영화', ContentType.movie),
                const SizedBox(width: 12),
                _buildContentTab('📺 드라마', ContentType.drama),
                const SizedBox(width: 12),
                _buildContentTab('🎵 음악', ContentType.music),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ===== 🎯 추천 컨텐츠 리스트 =====
          SizedBox(
            height: 180, // 높이 증가 (카드 높이에 맞춤)
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: _getContentList().length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final content = _getContentList()[index];
                return _buildContentCard(
                  title: content['title']!,
                  subtitle: content['subtitle']!,
                  imageUrl: content['imageUrl']!,
                  category: content['category']!,
                  rating: content['rating']!,
                  gradientColors: content['gradientColors']! as List<Color>,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 컨텐츠 카테고리 탭 빌더
  Widget _buildContentTab(String title, ContentType type) {
    final bool isSelected = _selectedContentType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedContentType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryTeal : AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.secondaryTeal : AppColors.borderLight,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// 추천 컨텐츠 카드 빌더 (오버플로우 방지 버전)
  Widget _buildContentCard({
    required String title,
    required String subtitle,
    required String imageUrl,
    required String category,
    required String rating,
    required List<Color> gradientColors,
  }) {
    return GestureDetector(
      onTap: () {
        print('컨텐츠 카드 클릭: $title');
      },
      child: Container(
        width: 180, // 너비 제한
        constraints: const BoxConstraints(
          maxHeight: 180, // 최대 높이 증가 (텍스트 공간 확보)
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // 최소 크기
          children: [
            // 상단 이미지 영역
            Expanded(
              flex: 3, // 비율 조정: 이미지 영역
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.movie_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 평점 배지
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 10,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            rating,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 하단 텍스트 정보
            Container(
              height: 70, // 고정 높이로 텍스트 공간 보장
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start, // 상단 정렬로 변경
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4), // 간격 축소
                  Expanded( // 남은 공간을 모두 사용
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.2, // 줄 간격 축소로 공간 효율성 향상
                      ),
                      maxLines: 2, // 최대 2줄로 제한
                      overflow: TextOverflow.ellipsis, // 2줄 넘으면 ... 표시
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📊 컨텐츠 데이터 가져오기 (카테고리별 + 모드별)
  List<Map<String, dynamic>> _getContentList() {
    // 개인 추천 vs 함께 보기에 따른 데이터 변경
    if (_selectedContentMode == ContentMode.together) {
      return _getTogetherContentList();
    }
    
    switch (_selectedContentType) {
      case ContentType.movie:
        return _getMovieList();
      case ContentType.drama:
        return _getDramaList();
      case ContentType.music:
        return _getMusicList();
    }
  }

  /// 🎬 영화 데이터 리스트
  List<Map<String, dynamic>> _getMovieList() {
    return [
      {
        'title': '인터스텔라',
        'subtitle': '깊이 있는 사고를 좋아하는 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=300&h=200&fit=crop&auto=format',
        'category': '영화',
        'rating': '9.2',
        'gradientColors': [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      },
      {
        'title': '라라랜드',
        'subtitle': '감성적인 당신의 마음을 울릴',
        'imageUrl': 'https://images.unsplash.com/photo-1489599833288-b62ca85c4383?w=300&h=200&fit=crop&auto=format',
        'category': '영화',
        'rating': '8.8',
        'gradientColors': [const Color(0xFFFF8A65), const Color(0xFFFFB74D)],
      },
      {
        'title': '기생충',
        'subtitle': '사회적 통찰력이 있는 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=300&h=200&fit=crop&auto=format',
        'category': '영화',
        'rating': '9.5',
        'gradientColors': [const Color(0xFF26C6DA), const Color(0xFF00BCD4)],
      },
      {
        'title': '어벤져스',
        'subtitle': '모험을 즐기는 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1635805737707-575885ab0820?w=300&h=200&fit=crop&auto=format',
        'category': '영화',
        'rating': '8.4',
        'gradientColors': [const Color(0xFFE53E3E), const Color(0xFFDD6B20)],
      },
    ];
  }

  /// 📺 드라마 데이터 리스트
  List<Map<String, dynamic>> _getDramaList() {
    return [
      {
        'title': '오징어 게임',
        'subtitle': '스릴을 즐기는 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=200&fit=crop&auto=format',
        'category': '드라마',
        'rating': '8.7',
        'gradientColors': [const Color(0xFFE53E3E), const Color(0xFFC53030)],
      },
      {
        'title': '사랑의 불시착',
        'subtitle': '로맨틱한 감성의 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=300&h=200&fit=crop&auto=format',
        'category': '드라마',
        'rating': '9.0',
        'gradientColors': [const Color(0xFFD53F8C), const Color(0xFFB83280)],
      },
      {
        'title': '킹덤',
        'subtitle': '역사와 스릴러를 좋아하는 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=200&fit=crop&auto=format',
        'category': '드라마',
        'rating': '8.3',
        'gradientColors': [const Color(0xFF553C9A), const Color(0xFF44337A)],
      },
    ];
  }

  /// 🎵 음악 데이터 리스트
  List<Map<String, dynamic>> _getMusicList() {
    return [
      {
        'title': 'Dynamite - BTS',
        'subtitle': '에너지 넘치는 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=200&fit=crop&auto=format',
        'category': '음악',
        'rating': '9.1',
        'gradientColors': [const Color(0xFFED8936), const Color(0xFFDD6B20)],
      },
      {
        'title': 'Through the Night - IU',
        'subtitle': '잔잔한 감성의 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1471478331149-c72f17e33c73?w=300&h=200&fit=crop&auto=format',
        'category': '음악',
        'rating': '8.9',
        'gradientColors': [const Color(0xFF38B2AC), const Color(0xFF319795)],
      },
      {
        'title': 'Bohemian Rhapsody - Queen',
        'subtitle': '클래식한 감성의 당신에게',
        'imageUrl': 'https://images.unsplash.com/photo-1524368535928-5b5e00ddc76b?w=300&h=200&fit=crop&auto=format',
        'category': '음악',
        'rating': '9.7',
        'gradientColors': [const Color(0xFF9F7AEA), const Color(0xFF805AD5)],
      },
    ];
  }

  /// 👥 함께 보기 컨텐츠 데이터 (MBTI 조합 기반)
  List<Map<String, dynamic>> _getTogetherContentList() {
    // 실제로는 _userMbti + _partnerMbti 조합을 분석해서 추천
    // 현재는 예시 데이터
    switch (_selectedContentType) {
      case ContentType.movie:
        return [
          {
            'title': '어바웃 타임',
            'subtitle': '$_userMbti와 $_partnerMbti가 함께 즐길',
            'imageUrl': 'https://images.unsplash.com/photo-1489599833288-b62ca85c4383?w=300&h=200&fit=crop&auto=format',
            'category': '영화',
            'rating': '8.9',
            'gradientColors': [const Color(0xFFFF8A65), const Color(0xFFFFB74D)],
          },
          {
            'title': '인사이드 아웃',
            'subtitle': '두 사람 모두 공감할 수 있는',
            'imageUrl': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300&h=200&fit=crop&auto=format',
            'category': '영화',
            'rating': '8.6',
            'gradientColors': [const Color(0xFF667EEA), const Color(0xFF764BA2)],
          },
        ];
      case ContentType.drama:
        return [
          {
            'title': '스타트업',
            'subtitle': '$_userMbti와 $_partnerMbti의 조합에 맞는',
            'imageUrl': 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300&h=200&fit=crop&auto=format',
            'category': '드라마',
            'rating': '8.2',
            'gradientColors': [const Color(0xFF26C6DA), const Color(0xFF00BCD4)],
          },
        ];
      case ContentType.music:
        return [
          {
            'title': 'Perfect - Ed Sheeran',
            'subtitle': '커플이 함께 들으면 좋은',
            'imageUrl': 'https://images.unsplash.com/photo-1471478331149-c72f17e33c73?w=300&h=200&fit=crop&auto=format',
            'category': '음악',
            'rating': '9.3',
            'gradientColors': [const Color(0xFFD53F8C), const Color(0xFFB83280)],
          },
        ];
    }
  }

  /// 📱 MBTI 선택 모달
  void _showMbtiSelector() {
    final List<String> mbtiTypes = [
      'ENFP', 'ENFJ', 'ENTP', 'ENTJ',
      'ESFP', 'ESFJ', 'ESTP', 'ESTJ',
      'INFP', 'INFJ', 'INTP', 'INTJ',
      'ISFP', 'ISFJ', 'ISTP', 'ISTJ',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '상대방 MBTI 선택',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2,
                ),
                itemCount: mbtiTypes.length,
                itemBuilder: (context, index) {
                  final mbti = mbtiTypes[index];
                  final isSelected = mbti == _partnerMbti;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _partnerMbti = mbti;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryBlue : AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryBlue : AppColors.borderLight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          mbti,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}