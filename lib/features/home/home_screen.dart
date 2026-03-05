import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mind_canvas/features/home/presentation/screen/popular_test_ranking_screen.dart';
import 'package:mind_canvas/features/home/presentation/widgets/HomeInsightSection.dart';
import 'package:mind_canvas/features/home/presentation/widgets/home_recommendation_section.dart';
import 'package:mind_canvas/features/home/presentation/widgets/home_viewpager.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../features/info/info_screen.dart';
import '../../generated/l10n.dart';
import '../profile/presentation/pages/my_activity_page.dart';
import '../profile/presentation/providers/recent_test_results_provider.dart';
import '../profile/presentation/widgets/test_result_item.dart';
import '../recommendation/presentation/recommendation_screen.dart';

import '../recommendation/presentation/widgets/personalized_content_section.dart'
    as recommendation;

// import 'widgets/home_viewpager.dart';
import 'dart:math' as math;
import '../home/presentation/notifiers/test_list_notifier.dart';

import 'domain/models/test_ranking_item.dart';

/// Mind Canvas 심리테스트 홈 화면
///
/// 심리테스트 메인 대시보드
/// - ViewPager (타로, 페르소나, HTP)
/// - 테스트 랭킹 및 추천
/// - 카테고리별 테스트 목록
/// - 최근 검사 기록
/// - 프로모션 배너
class HomeScreen extends ConsumerStatefulWidget {
  final VoidCallback? onGoToAnalysis; // 분석 화면으로 이동 콜백

  const HomeScreen({super.key, this.onGoToAnalysis});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final String _userMbti = 'INFP'; // 사용자 MBTI (실제로는 UserProvider에서 가져와야 함)

  @override
  void initState() {
    super.initState();
    // 위젯 마운트 후 인기 테스트 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(testListNotifierProvider.notifier).loadPopularTests();
    });


    // 🔔 앱이 켜져 있을 때 알림 수신 안내 메세지
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 포그라운드 알림 도착: ${message.notification?.title}');

      if (message.notification != null) {
        // 간단하게 스낵바로 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${message.notification!.title}\n${message.notification!.body}'),
            backgroundColor: Colors.blueAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

  }

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
                padding: EdgeInsets.all(AppDimensions.getMainPadding(context)),
                // 반응형 패딩
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildTestRanking(),
                    const SizedBox(height: 32),
                    const HomeRecommendationSection(),
                    const SizedBox(height: 32),
                    // _buildTestCategories(),
                    // const SizedBox(height: 32),
                    _buildRecentTests(),
                    const SizedBox(height: 32),
                    const HomeInsightSection(),
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

  /// 네비게이션: 성격 기반 추천 화면으로 이동
  void _navigateToPersonalityRecommendations() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RecommendationScreen()),
    );
  }


  /// 🏆 인기 테스트 랭킹 섹션 (반응형) - Consumer 버전
  Widget _buildTestRanking() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).home_popular,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PopularTestRankingScreen(),
                  ),
                );
              },
              child: Text(
                S.of(context).home_more,
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Consumer로 안전한 상태 관리
        Consumer(
          builder: (context, ref, child) {
            final testListState = ref.watch(testListNotifierProvider);

            return testListState.when(
              initial: () {
                // 초기 상태에서 자동 로드
                Future.microtask(() {
                  if (context.mounted) {
                    print(
                      '🔄 HomeScreen: Loading popular tests from initial state',
                    );
                    // ref.read(testListNotifierProvider.notifier).loadPopularTests();
                  }
                });
                return _buildRankingLoading();
              },

              loading: () {
                print('⏳ HomeScreen: Loading popular tests...');
                return _buildRankingLoading();
              },

              loaded: (items, hasMore, currentPage, isLoadingMore, loadType) {
                print(
                  '✅ HomeScreen: Loaded ${items.length} items, loadType: $loadType',
                );

                // 데이터가 있으면 표시
                if (items.isNotEmpty) {
                  return _buildRankingList(items);
                } else {
                  // 빈 데이터면 다시 로드 시도
                  print('⚠️ HomeScreen: Empty data, retrying...');

                  return SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        S.of(context).home_noTest,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
              },

              error: (message) {
                print('❌ HomeScreen: Error loading popular tests: $message');
                return _buildRankingError(message);
              },
            );
          },
        ),
      ],
    );
  }

  // 에러 상태 UI (재시도 버튼 포함)
  Widget _buildRankingError(String message) {
    return Container(
      height: AppDimensions.getRankingCardTotalHeight(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 32, color: Colors.red[400]),
            const SizedBox(height: 8),
            Text(
              S.of(context).home_data_fail,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                print('🔄 HomeScreen: Manual retry requested');
                ref.read(testListNotifierProvider.notifier).loadPopularTests();
              },
              icon: Icon(Icons.refresh, size: 16),
              label: Text(S.of(context).home_retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // 실제 랭킹 리스트 UI
  Widget _buildRankingList(List<TestRankingItem> items) {
    return SizedBox(
      height: AppDimensions.getRankingCardTotalHeight(context),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: math.min(items.length, 5),
        separatorBuilder: (context, index) =>
            SizedBox(width: AppDimensions.getRankingCardSpacing(context)),
        itemBuilder: (context, index) {
          final test = items[index];
          return _buildRankingCard(
            rank: index + 1,
            title: test.title,
            subtitle: test.subtitle,
            imagePath: test.imagePath ?? AppAssets.mbtiItemHigh,
            participantCount: test.viewCount ?? 0,
            onTap: () {
              print("info Screen으로 이동 예정");
              // 단순히 testId만 전달하여 InfoScreen으로 이동
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => InfoScreen(
                    testId: test.id, // testId만 전달
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  //
  // Future<void> _handleTestCardTap(int testId) async {
  //   // 상세 정보 로드 시작
  //   ref.read(testDetailNotifierProvider.notifier).loadTestDetail(testId);
  //
  //   // 상태 변화를 감시하는 다이얼로그 표시
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => Consumer(
  //       builder: (context, ref, child) {
  //         final state = ref.watch(testDetailNotifierProvider);
  //
  //         if (state.isLoading) {
  //           return const Center(child: CircularProgressIndicator());
  //         }
  //
  //         // 로딩 완료 시 자동으로 다이얼로그 닫고 화면 이동
  //         WidgetsBinding.instance.addPostFrameCallback((_) {
  //           Navigator.of(context).pop(); // 다이얼로그 닫기
  //
  //           if (state.testDetail != null) {
  //             Navigator.of(context).push(
  //               MaterialPageRoute(
  //                 builder: (context) => InfoScreen(
  //                   testId: testId.toString(),
  //                   testDetail: state.testDetail,
  //                 ),
  //               ),
  //             );
  //           } else if (state.errorMessage != null) {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(content: Text(state.errorMessage!)),
  //             );
  //           }
  //         });
  //
  //         return const SizedBox.shrink();
  //       },
  //     ),
  //   );
  // }

  // 로딩 상태 UI (개선)
  Widget _buildRankingLoading() {
    return Container(
      height: AppDimensions.getRankingCardTotalHeight(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              S.of(context).home_load_test,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).home_recomend,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RecommendationScreen(),
                  ),
                );
              },
              child: Text(
                S.of(context).home_all,
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ===== 🎯 추천 테스트 섹션 =====
        Container(
          padding: EdgeInsets.all(AppDimensions.getMainPadding(context)),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.backgroundSecondary,
                AppColors.backgroundTertiary,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.withOpacity20(AppColors.primaryBlue),
            ),
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('🎯', style: TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).home_foryour,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          S.of(context).home_foryour_content,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ===== 🎨 추천 검사 카드들 (랭킹 카드 재사용) =====
              SizedBox(
                height: AppDimensions.getRankingCardTotalHeight(context),
                // 랭킹 카드와 동일한 높이
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // 첫 번째 추천: 꿈 분석 검사
                    _buildRecommendationCard(
                      title: '꿈 분석 검사',
                      subtitle: '무의식 탐구',
                      imagePath: AppAssets.personaItemHigh,
                      // 기존 에셋 재사용
                      accuracy: '95%',
                      badgeText: '추천',
                      gradientColors: [
                        AppColors.primaryBlue,
                        AppColors.secondaryTeal,
                      ],
                      onTap: () {
                        print('꿈 분석 검사 선택됨');
                      },
                    ),
                    SizedBox(
                      width: AppDimensions.getRankingCardSpacing(context),
                    ),

                    // 두 번째 추천: 색채 심리 검사
                    _buildRecommendationCard(
                      title: '색채 심리 검사',
                      subtitle: '감정 상태 분석',
                      imagePath: AppAssets.mbtiItemHigh,
                      // 기존 에셋 재사용
                      accuracy: '92%',
                      badgeText: '인기',
                      gradientColors: [
                        AppColors.secondaryTeal,
                        AppColors.secondaryPurple,
                      ],
                      onTap: () {
                        print('색채 심리 검사 선택됨');
                      },
                    ),
                    SizedBox(
                      width: AppDimensions.getRankingCardSpacing(context),
                    ),

                    // 세 번째 추천: 성격 분석 검사
                    _buildRecommendationCard(
                      title: '성격 분석 검사',
                      subtitle: '심층 성격 탐구',
                      imagePath: AppAssets.headspaceItemHigh,
                      // 기존 에셋 재사용
                      accuracy: '89%',
                      badgeText: '신규',
                      gradientColors: [
                        AppColors.secondaryPurple,
                        Color(0xFFFF8A65),
                      ],
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

        // ===== 🎬 새로운 추천 컨텐츠 섹션 사용 =====
        recommendation.PersonalizedContentSection(),
        const SizedBox(height: 32),
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
            const Text(
              '💭 인기 간단한 테스트',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                '더보기',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ===== 🌅 첫 번째 카드: 상상해보는 내 심리테스트 =====
        _buildImageContentCard(
          title: '상상해보는 내 심리테스트',
          imageUrl:
              'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&h=200&fit=crop&auto=format',
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
          imageUrl:
              'https://images.unsplash.com/photo-1559181567-c3190ca9959b?w=600&h=200&fit=crop&auto=format',
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
          imageUrl:
              'https://images.unsplash.com/photo-1519578443396-9048f6db0b2f?w=600&h=200&fit=crop&auto=format',
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
                          S.of(context).home_image_load_fail,
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child:  Text(
                              S.of(context).home_test,
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
      children:[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text(
              S.of(context).home_recent_insp,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Row(
              children:[
                // 🔄 [추가] 새로고침 아이콘 버튼
                IconButton(
                  onPressed: () {
                    // Riverpod Provider의 상태를 무효화하여 API를 다시 호출하도록 만듭니다.
                    ref.invalidate(recentTestResultsProvider);

                    // // (선택사항) 새로고침 피드백
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //     content: Text('최근 검사 기록을 업데이트했습니다.'),
                    //     duration: Duration(seconds: 1),
                    //   ),
                    // );
                  },
                  icon: const Icon(Icons.refresh, color: AppColors.primaryBlue),
                  tooltip: S.of(context).home_refresh,
                  padding: EdgeInsets.zero, // 버튼 주변 기본 여백 제거
                  constraints: const BoxConstraints(), // 버튼 크기를 아이콘에 딱 맞춤
                ),
                const SizedBox(width: 4), // 아이콘과 버튼 사이 간격

                // TextButton(
                //   onPressed: () {
                //     // 분석 화면으로 이동
                //     widget.onGoToAnalysis?.call();
                //   },
                //   child: const Text(
                //     '내 분석',
                //     style: TextStyle(
                //       color: AppColors.primaryBlue,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
                TextButton(
                  onPressed: () {
                    // 🎯 내 모든 기록을 볼 수 있는 통합 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyActivityPage()),
                    );
                  },
                  child: Text(
                    S.of(context).home_all_see,
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildRecentTestsSection(ref)
      ],
    );
  }

  Widget _buildRecentTestsSection(WidgetRef ref) {
    final recentAsync = ref.watch(recentTestResultsProvider);

    return recentAsync.when(
      data: (results) {
        // 1. 데이터가 아예 없는 경우: 섹션 자체를 숨기거나 "첫 테스트 시작하기" 안내
        if (results.isEmpty) {
          return _buildEmptyTestCard();
        }

        // 2. 데이터가 있는 경우: 리스트 렌더링
        return Column(
          children: [
            const SizedBox(height: 16),
            ...results.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TestResultItem(result: item), // 👈 아까 만든 공용 위젯 재사용!
            )).toList(),
          ],
        );
      },
      // 로딩 중 (스켈레톤 UI 등을 넣으면 좋음)
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      ),
      // 에러 발생 시
      error: (err, stack) => const SizedBox.shrink(), // 홈에서는 에러 시 섹션을 숨기는 게 깔끔함
    );
  }

  // 데이터가 없을 때 보여줄 예쁜 안내 카드 (선택사항)
  Widget _buildEmptyTestCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Icon(Icons.psychology_outlined, size: 40, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(S.of(context).home_no_analy, style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => {/* 테스트 탭으로 이동 */},
            child: Text(S.of(context).home_start_test),
          ),
        ],
      ),
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
        width: AppDimensions.getRankingCardWidth(context), // 반응형 너비
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(
            AppDimensions.rankingCardBorderRadius,
          ),
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
                    top: Radius.circular(AppDimensions.rankingCardBorderRadius),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: AppDimensions.getRankingCardImageHeight(context),
                    // 반응형 높이
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary.withOpacity(0.1),
                    ),
                    child: _buildImageWithFallback(
                      imagePath,
                      AppDimensions.getRankingCardImageHeight(
                        context,
                      ), // 반응형 높이 전달
                    ),
                  ),
                ),

                // 랭킹 배지
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
                      S.of(context).home_rank(rank),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppDimensions.getRankingCardRankBadgeFontSize(
                          context,
                        ), // 반응형 폰트
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 하단 텍스트 정보 - 반응형 크기로 관리
            Padding(
              padding: EdgeInsets.all(
                AppDimensions.getRankingCardPadding(context),
              ), // 반응형 패딩
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목만 표시
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppDimensions.getRankingCardTitleFontSize(
                        context,
                      ), // 반응형 폰트
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // 참여자 수만 표시
                  Text(//'${_formatParticipantCount(participantCount)}명 참여'
                    S.of(context).home_count(_formatParticipantCount(participantCount)),
                    style: TextStyle(
                      fontSize: AppDimensions.getRankingCardParticipantFontSize(
                        context,
                      ), // 반응형 폰트
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
      return S.of(context).home_count_people_tenthousand((count / 10000).toStringAsFixed(1)); //'${(count / 10000).toStringAsFixed(1)}만'
    } else if (count >= 1000) {
      return S.of(context).home_count_people_thousand((count / 1000).toStringAsFixed(1)); //'${(count / 1000).toStringAsFixed(1)}천'
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
          top: Radius.circular(AppDimensions.rankingCardBorderRadius),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.rankingCardBorderRadius),
        ),
        child: Image.network(
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
        width: AppDimensions.getRankingCardWidth(context), // 랭킹 카드와 동일한 너비
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(
            AppDimensions.rankingCardBorderRadius,
          ),
          border: Border.all(color: gradientColors.first.withOpacity(0.3)),
          // 그라디언트 색상 사용
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
                    top: Radius.circular(AppDimensions.rankingCardBorderRadius),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
                        fontSize: AppDimensions.getRankingCardRankBadgeFontSize(
                          context,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 하단 텍스트 정보 - 랭킹 카드와 동일한 구조
            Padding(
              padding: EdgeInsets.all(
                AppDimensions.getRankingCardPadding(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppDimensions.getRankingCardTitleFontSize(
                        context,
                      ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: gradientColors.first.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          S.of(context).home_accuracy(accuracy),
                          style: TextStyle(
                            fontSize:
                                AppDimensions.getRankingCardParticipantFontSize(
                                  context,
                                ),
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

  Widget _buildRecentTestItem(
    String title,
    String date,
    String status,
    Color color,
  ) {
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
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.withOpacity10(color),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
