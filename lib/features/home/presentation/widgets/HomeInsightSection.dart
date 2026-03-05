import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../data/models/response/insight_response.dart';
import '../notifiers/insight_notifier.dart';

class HomeInsightSection extends ConsumerWidget {
  const HomeInsightSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(insightNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ 1. 헤더 영역 (항상 보임 + 새로고침 버튼 추가)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).home_insight_title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            // 🔄 새로고침 버튼
            IconButton(
              onPressed: () {
                // 회전 애니메이션 효과를 주거나 스낵바를 띄울 수도 있음
                ref.read(insightNotifierProvider.notifier).fetchInsights();
              },
              icon: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh, color: AppColors.primaryBlue),
              tooltip: S.of(context).home_insight_see_new,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ✅ 2. 상태별 본문 표시
        if (state.isLoading && state.insights.isEmpty)
          _buildLoadingState(context) // 로딩 중 (데이터 없을 때만)
        else if (state.errorMessage != null)
          _buildErrorState(state.errorMessage!) // 에러 발생
        else if (state.insights.isEmpty)
          _buildEmptyState() // 데이터 없음
        else
          // 데이터 있음 (리스트 렌더링)
          ...state.insights.map(
            (insight) => _buildInsightCard(context, insight),
          ),
      ],
    );
  }

  // 🔄 로딩 UI (스켈레톤 느낌)
  Widget _buildLoadingState(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: Text(S.of(context).home_insight_loading)),
    );
  }

  // ⚠️ 에러 UI
  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 📭 빈 데이터 UI
  Widget _buildEmptyState() {
    return Container(
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text("오늘의 인사이트를 준비 중입니다."),
    );
  }

  // 🃏 카드 UI (기존 디자인 유지)
  Widget _buildInsightCard(BuildContext context, InsightResponse insight) {
    // 카테고리별 그라디언트 (기본값)
    const gradient = LinearGradient(
      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return GestureDetector(
      onTap: () => _showImmersiveInsightDetail(context, insight),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
              // 1. 배경 이미지
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: insight.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    decoration: const BoxDecoration(gradient: gradient),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    decoration: const BoxDecoration(gradient: gradient),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.white24,
                    ),
                  ),
                ),
              ),

              // 2. 그라디언트 오버레이 (가독성 확보)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0], // 기존 느낌 유지
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),

              // 3. 텍스트 내용
              Positioned(
                left: 20,
                right: 20,
                // 오른쪽 화살표 공간 확보
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 태그 (배지)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        insight.tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      insight.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
      ),
    );
  }

  // 2. [신규] 몰입형 다이얼로그 (전체 배경 이미지)
  void _showImmersiveInsightDetail(
    BuildContext context,
    InsightResponse insight,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent, // 다이얼로그 자체 배경 투명
        insetPadding: const EdgeInsets.all(16), // 화면 꽉 차게 말고 약간 여백
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24), // 둥근 모서리
          child: SizedBox(
            height: screenHeight * 0.85, // 다이얼로그 높이 고정 (필요 시 조절 가능)
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 🌌 1. 배경 이미지 (전체 깔기)
                CachedNetworkImage(
                  imageUrl: insight.imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(color: Colors.grey),
                ),

                // 🌑 2. 어두운 오버레이 (투명도 조절)
                // 이미지가 배경이 되므로 글씨가 보이려면 어둡게 눌러줘야 함
                Container(
                  color: Colors.black.withOpacity(0.65), // 0.0 ~ 1.0 사이 조절
                ),

                // 📝 3. 컨텐츠 내용
                Column(
                  children: [
                    // 상단 닫기 버튼 영역
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white),
                            tooltip: S.of(context).home_insight_close,
                          ),
                        ],
                      ),
                    ),

                    // 스크롤 가능한 텍스트 영역
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 태그
                            Text(
                              insight.tag,
                              style: TextStyle(
                                color: AppColors.primaryBlue.withOpacity(
                                  0.9,
                                ), // 밝은 파랑
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // 제목
                            Text(
                              insight.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // 구분선 (선택 사항)
                            Container(
                              width: 40,
                              height: 2,
                              color: Colors.white.withOpacity(0.3),
                            ),

                            const SizedBox(height: 24),

                            // 본문
                            Text(
                              insight.content,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                // 완전 흰색보다 눈 편함
                                fontSize: 16,
                                height: 1.8,
                                // 줄간격 넓게
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 📝 상세 다이얼로그
  void _showInsightDetail(BuildContext context, InsightResponse insight) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: insight.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black38,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insight.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      insight.tag,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: SingleChildScrollView(
                        child: Text(
                          insight.content,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: AppColors.textSecondary,
                          ),
                        ),
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
}
