import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../info/info_screen.dart'; // 👈 상세 화면 이동을 위해 필요
import '../../../recommendation/presentation/recommendation_screen.dart';
import '../../data/models/response/test_recommendation_response.dart';
import '../notifiers/test_recommendation_notifier.dart'; // 👈 Notifier i

class HomeRecommendationSection extends ConsumerWidget {
  const HomeRecommendationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ 서버 상태 구독
    final state = ref.watch(testRecommendationNotifierProvider);
    // 뷰 카운트가 빠졌으므로 높이를 줄여야 함. (이미지 높이 + 제목 영역 약 60px)
    final double cardImageHeight = AppDimensions.getRankingCardImageHeight(
      context,
    );
    final double compactCardHeight = cardImageHeight + 60; // 텍스트 영역 높이 축소

    // 1. 로딩 중
    if (state.isLoading) {
      return SizedBox(
        height: AppDimensions.getRankingCardTotalHeight(context),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // 2. 에러 발생 시 (재시도 버튼 표시)
    if (state.errorMessage != null) {
      return SizedBox(
        height: 150,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              Text(S.of(context).home_recommend_error({state.errorMessage})), //${state.errorMessage}
              TextButton(
                onPressed: () {
                  // 재시도 요청
                  ref
                      .read(testRecommendationNotifierProvider.notifier)
                      .fetchRecommendations();
                },
                child: Text(S.of(context).home_recommend_retry),
              ),
            ],
          ),
        ),
      );
    }

    // 3. 데이터 없음
    if (state.isEmpty || state.recommendations.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: Text(
          S.of(context).home_recommend_no_data,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // 2. 데이터가 없거나 에러인 경우 (숨김 처리)
    if (state.isEmpty || state.errorMessage != null) {
      return const SizedBox.shrink();
    }

    final recommendations = state.recommendations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ [수정 1] 상단 타이틀 영역 ("전체보기" 버튼 삭제)
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).home_recommend_your_rec,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            // "전체보기" 버튼 삭제됨
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
              // 헤더
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
                          S.of(context).home_recommend_your_test,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          S.of(context).home_recommend_test_content,
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

              // ===== 🎨 추천 검사 카드 리스트 =====
              SizedBox(
                height: compactCardHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendations.length,
                  separatorBuilder: (context, index) => SizedBox(
                    width: AppDimensions.getRankingCardSpacing(context),
                  ),
                  itemBuilder: (context, index) {
                    final item = recommendations[index];
                    return _buildRecommendationCard(context, item);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 🎆 추천 검사 카드 빌더
  Widget _buildRecommendationCard(
    BuildContext context,
    TestRecommendationResponse item,
  ) {
    // 배지 텍스트 및 색상 결정 로직
    String badgeText = S.of(context).home_recommend_rec_badge;
    List<Color> gradientColors = [
      AppColors.primaryBlue,
      AppColors.secondaryTeal,
    ];

    if (item.reason == 'HOT_TREND') {
      badgeText = S.of(context).home_recommend_trend;
      gradientColors = [AppColors.secondaryTeal, AppColors.secondaryPurple];
    } else if (item.reason == 'NEW_ARRIVAL') {
      badgeText = S.of(context).home_recommend_new;
      gradientColors = [AppColors.secondaryPurple, const Color(0xFFFF8A65)];
    }

    return GestureDetector(
      onTap: () {
        // ✅ [수정됨] 상세 화면 이동 로직 (랭킹과 동일하게 testId 전달)
        print('📌 추천 테스트 선택됨: ${item.title} (ID: ${item.testId})');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => InfoScreen(testId: item.testId),
          ),
        );
      },
      child: Container(
        width: AppDimensions.getRankingCardWidth(context),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(
            AppDimensions.rankingCardBorderRadius,
          ),
          border: Border.all(color: gradientColors.first.withOpacity(0.3)),
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
            // 상단 이미지 및 배지
            Stack(
              children: [
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
                        // 네트워크 이미지
                        Image.network(
                          item.thumbnailUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                        // 그라디언트 오버레이
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
                // 배지
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

            // 하단 텍스트 정보
            Padding(
              padding: EdgeInsets.all(
                AppDimensions.getRankingCardPadding(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: gradientColors.first.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
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
}
