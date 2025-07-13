import 'package:flutter/material.dart';
import '../../animations/htp_background_animation.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_assets.dart';
import '../../theme/app_theme.dart';

/// ViewPager 개별 페이지 아이템들 (성능 최적화)
/// 
/// 책임:
/// - 각 테스트별 UI 구현
/// - HTP만 애니메이션 적용 (나머지는 정적 이미지)
/// - 반응형 레이아웃 제공
/// - 메모리 효율적인 렌더링

/// 타로 심리상담 페이지 (애니메이션 제거)
class TaroPageViewItem extends StatelessWidget {
  const TaroPageViewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // ===== 🖼️ 정적 배경 이미지 =====
            Positioned.fill(
              child: Image.asset(
                AppAssets.taro2High,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('🖼️ [TaroPageViewItem] 이미지 로딩 실패: ${AppAssets.taro2High}');
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF667EEA),
                          Color(0xFF764BA2),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // ===== 🎨 좌역 그라데이션 오버레이 (신비로운 보라/남색 그라데이션) =====
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.0, 0.18, 0.35, 1.0],
                    colors: [
                      const Color(0xFF667EEA).withOpacity(0.85),  // 짙은 보라색
                      const Color(0xFF764BA2).withOpacity(0.65),  // 중간 빈보라색
                      const Color(0xFF8E8FFF).withOpacity(0.25),  // 연한 보라색
                      Colors.transparent,                         // 완전 투명
                    ],
                  ),
                ),
              ),
            ),
            
            // ===== 📝 좌측 타로 텍스트 컨텐츠 =====
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // 유연한 컨텐츠 영역
                    Flexible(
                      flex: 1,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                          maxWidth: 140,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 🔮 타로 아이콘
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.textWhite.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '🔮', // 타로 관련 이모지 아이콘
                                style: TextStyle(fontSize: 28),
                              ),
                            ),
                            const SizedBox(height: 14),
                            
                            // 📖 메인 타이틀
                            const Text(
                              '타로\n심리상담',
                              style: TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // 📄 서브 타이틀
                            const Text(
                              '카드를 통한\n내면 탐구',
                              style: TextStyle(
                                color: AppColors.textWhite70,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // 🚀 CTA 버튼
                            IntrinsicWidth(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF667EEA).withOpacity(0.9), // 보라색 버튼
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF667EEA).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      '시작',
                                      style: TextStyle(
                                        color: AppColors.textWhite,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: AppColors.textWhite.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.textWhite,
                                        size: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 나머지 공간 (이미지 영역)
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 페르소나 테스트 페이지 (애니메이션 제거)
class PersonaPageViewItem extends StatelessWidget {
  const PersonaPageViewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // ===== 🖼️ 정적 배경 이미지 (디버깅) =====
            Positioned.fill(
              child: Image.asset(
                'assets/images/persona_pageview/persona_pageview_high.png', // 하드코딩으로 테스트
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('🚫 [PersonaPageViewItem] 이미지 로딩 실패: $error');
                  print('📁 [PersonaPageViewItem] 스택트레이스: $stackTrace');
                  print('🔍 [PersonaPageViewItem] 시도한 경로: assets/images/persona_pageview/persona_pageview_high.png');
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFF6B6B),
                          Color(0xFFFF8E8E),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '이미지 로딩 실패\n펙다 최신 버전 추천',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // ===== 🎨 좌역 그라데이션 오버레이 (따뜻한 주황/분홍 그라데이션) =====
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.0, 0.18, 0.35, 1.0],
                    colors: [
                      const Color(0xFFFF6B6B).withOpacity(0.85),  // 진한 분홍색
                      const Color(0xFFFF8E8E).withOpacity(0.65),  // 중간 분홍색
                      const Color(0xFFFFB3B3).withOpacity(0.25),  // 연한 분홍색
                      Colors.transparent,                         // 완전 투명
                    ],
                  ),
                ),
              ),
            ),
            
            // ===== 📝 좌측 페르소나 텍스트 컨텐츠 =====
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // 유연한 컨텐츠 영역
                    Flexible(
                      flex: 1,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                          maxWidth: 140,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 🎦 페르소나 아이콘
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.textWhite.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '🎦', // 페르소나/역할 관련 이모지 아이콘
                                style: TextStyle(fontSize: 28),
                              ),
                            ),
                            const SizedBox(height: 14),
                            
                            // 📖 메인 타이틀
                            const Text(
                              '페르소나\n테스트',
                              style: TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // 📄 서브 타이틀
                            const Text(
                              '내면의 페르소나를\n찾으세요',
                              style: TextStyle(
                                color: AppColors.textWhite70,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // 🚀 CTA 버튼
                            IntrinsicWidth(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B6B).withOpacity(0.9), // 분홍색 버튼
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF6B6B).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      '시작',
                                      style: TextStyle(
                                        color: AppColors.textWhite,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: AppColors.textWhite.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.textWhite,
                                        size: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 나머지 공간 (이미지 영역)
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// HTP 심리검사 페이지
class HTPPageViewItem extends StatelessWidget {
  const HTPPageViewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.withOpacity10(AppColors.textPrimary),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // ===== 🖼️ 배경 이미지 (HTP 애니메이션) =====
            Positioned.fill(
              child: HTPBackgroundAnimation(
                imagePath: AppAssets.htpPageViewMid,
                backgroundColor: AppColors.htpBackground,
                duration: const Duration(milliseconds: 1200),
                delay: const Duration(milliseconds: 400),
                slideDistance: 50.0,
                scaleFrom: 0.85,
                scaleTo: 1.05,
                enableOverflow: true,
                child: const SizedBox.expand(), // 전체 영역 차지
              ),
            ),
            
            // ===== 🎨 좌역 그라데이션 오버레이 (하늘색과 어울리는 따뜻한 블루 톤) =====
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.0, 0.18, 0.35, 1.0],
                    colors: [
                      const Color(0xFF1E3A8A).withOpacity(0.85),  // 딥 블루
                      const Color(0xFF3B82F6).withOpacity(0.65),  // 브라이트 블루
                      const Color(0xFF60A5FA).withOpacity(0.25),  // 라이트 블루
                      Colors.transparent,                         // 완전 투명
                    ],
                  ),
                ),
              ),
            ),
            
            // ===== 📝 좌측 텍스트 컨텐츠 (유연한 레이아웃으로 개선) =====
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // 유연한 컨텐츠 영역 (화면 크기에 따라 자동 조정)
                    Flexible(
                      flex: 1,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                          maxWidth: 140, // 최대 폭 제한으로 반응형 대응
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 🏠 아이콘 (더 크게)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.textWhite.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                'assets/icons/htp_tree_128_icon.png',
                                width: 28,
                                height: 28,
                                color: AppColors.textWhite,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.home_outlined,
                                    color: AppColors.textWhite,
                                    size: 28,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 14),
                            
                            // 📖 메인 타이틀
                            const Text(
                              'HTP\n심리검사',
                              style: TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            // 📄 서브 타이틀
                            const Text(
                              '집-나무-사람\n그림검사',
                              style: TextStyle(
                                color: AppColors.textWhite70,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // 🚀 CTA 버튼 (오버플로우 방지)
                            IntrinsicWidth(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryBlue.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      '시작',
                                      style: TextStyle(
                                        color: AppColors.textWhite,
                                        fontSize: 12, // 공간 효율성을 위해 약간 축소
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: AppColors.textWhite.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.textWhite,
                                        size: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 나머지 공간 (이미지 영역)
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
