import 'package:flutter/material.dart';
import 'package:mind_canvas/core/theme/app_assets.dart' show AppAssets;
import 'package:mind_canvas/core/theme/app_colors.dart';
import 'package:mind_canvas/features/taro/presentation/pages/taro_consultation_setup_page.dart';

import '../../../../core/animations/htp_background_animation.dart';



/// ViewPager 개별 페이지 아이템들 (통일된 오버플로우 방지 버전)
/// 
/// 책임:
/// - 모든 페이지에 동일한 카드 구조 사용
/// - 오버플로우 방지 레이아웃
/// - 반응형 디자인
/// - 메모리 효율적인 렌더링

/// 통일된 ViewPager 카드 기본 구조
abstract class BaseViewPagerCard extends StatelessWidget {
  const BaseViewPagerCard({super.key});

  // 각 카드마다 구현해야 할 메서드들
  String get title;
  String get subtitle;
  String get emoji;
  String get buttonText;
  List<Color> get gradientColors;
  Widget? get backgroundWidget => null; // HTP만 애니메이션 사용
  String? get backgroundImage => null;  // 일반 이미지
  VoidCallback? onTapCallback(BuildContext context) => null;

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
            // ===== 🌅 배경 영역 =====
            Positioned.fill(
              child: _buildBackground(),
            ),
            
            // ===== 🎨 그라데이션 오버레이 =====
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.0, 0.18, 0.35, 1.0],
                    colors: [
                      gradientColors[0].withOpacity(0.85),
                      gradientColors[1].withOpacity(0.65),
                      gradientColors.length > 2
                          ? gradientColors[2].withOpacity(0.25)
                          : gradientColors[1].withOpacity(0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            
            // ===== 📝 컨텐츠 영역 (오버플로우 방지) =====
            Positioned.fill(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // 화면 크기에 따른 반응형 레이아웃
                      final isSmallScreen = constraints.maxWidth < 300;
                      final contentWidth = isSmallScreen 
                          ? constraints.maxWidth * 0.5 
                          : 140.0;
                      
                      return Row(
                        children: [
                          // 컨텐츠 영역 (고정 크기)
                          SizedBox(
                            width: contentWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 아이콘
                                _buildIcon(),
                                SizedBox(height: isSmallScreen ? 10 : 14),
                                
                                // 메인 타이틀
                                _buildTitle(isSmallScreen),
                                SizedBox(height: isSmallScreen ? 6 : 8),
                                
                                // 서브 타이틀
                                _buildSubtitle(isSmallScreen),
                                SizedBox(height: isSmallScreen ? 12 : 16),
                                
                                // CTA 버튼
                                _buildButton(isSmallScreen, context),
                              ],
                            ),
                          ),
                          // 나머지 공간 (이미지 영역)
                          const Expanded(child: SizedBox()),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 배경 빌더 (이미지 또는 애니메이션)
  Widget _buildBackground() {
    if (backgroundWidget != null) {
      return backgroundWidget!;
    }
    
    if (backgroundImage != null) {
      return Image.asset(
        backgroundImage!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors.take(2).toList(),
              ),
            ),
          );
        },
      );
    }
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors.take(2).toList(),
        ),
      ),
    );
  }

  /// 아이콘 빌더
  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.textWhite.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 28),
      ),
    );
  }

  /// 타이틀 빌더
  Widget _buildTitle(bool isSmallScreen) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textWhite,
        fontSize: isSmallScreen ? 18 : 20,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        height: 1.1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// 서브타이틀 빌더
  Widget _buildSubtitle(bool isSmallScreen) {
    return Text(
      subtitle,
      style: TextStyle(
        color: AppColors.textWhite70,
        fontSize: isSmallScreen ? 11 : 13,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// 버튼 빌더
  Widget _buildButton(bool isSmallScreen, BuildContext context) {
    return GestureDetector(
      onTap: () => onTapCallback(context)?.call(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 10 : 12, 
          vertical: isSmallScreen ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: gradientColors[0].withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              buttonText,
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: isSmallScreen ? 11 : 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: isSmallScreen ? 4 : 6),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.textWhite.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: AppColors.textWhite,
                size: isSmallScreen ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 타로 심리상담 페이지
class TaroPageViewItem extends BaseViewPagerCard {

  const TaroPageViewItem({super.key});

  @override
  String get title => '타로\n심리상담';

  @override
  String get subtitle => '카드를 통한\n내면 탐구';

  @override
  String get emoji => '🔮';

  @override
  String get buttonText => '시작';

  @override
  List<Color> get gradientColors => [
    const Color(0xFF667EEA),
    const Color(0xFF764BA2),
    const Color(0xFF8E8FFF),
  ];

  @override
  String? get backgroundImage => AppAssets.taro2High;

  @override
  VoidCallback? onTapCallback(BuildContext context) => () {
    // 타로 상담 설정 페이지로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TaroConsultationSetupPage(),
      ),
    );
  };
}

/// 페르소나 테스트 페이지
class PersonaPageViewItem extends BaseViewPagerCard {
  const PersonaPageViewItem({super.key});

  @override
  String get title => '페르소나\n테스트';

  @override
  String get subtitle => '내면의 페르소나를\n찾으세요';

  @override
  String get emoji => '🎭';

  @override
  String get buttonText => '시작';

  @override
  List<Color> get gradientColors => [
    const Color(0xFFFF6B6B),
    const Color(0xFFFF8E8E),
    const Color(0xFFFFB3B3),
  ];

  @override
  String? get backgroundImage => AppAssets.personaPageViewHigh;

  @override
  VoidCallback? onTapCallback(BuildContext context) => () {
    print('페르소나 테스트 시작');
  };
}

/// HTP 심리검사 페이지 (애니메이션 유지)
class HTPPageViewItem extends BaseViewPagerCard {
  const HTPPageViewItem({super.key});

  @override
  String get title => 'HTP\n심리검사';

  @override
  String get subtitle => '집-나무-사람\n그림검사';

  @override
  String get emoji => '🏠';

  @override
  String get buttonText => '시작';

  @override
  List<Color> get gradientColors => [
    const Color(0xFF1E3A8A),
    const Color(0xFF3B82F6),
    const Color(0xFF60A5FA),
  ];

  @override
  Widget? get backgroundWidget => HTPBackgroundAnimation(
    imagePath: AppAssets.htpPageViewMid,
    backgroundColor: AppColors.htpBackground,
    duration: const Duration(milliseconds: 1200),
    delay: const Duration(milliseconds: 400),
    slideDistance: 50.0,
    scaleFrom: 0.85,
    scaleTo: 1.05,
    enableOverflow: true,
    child: const SizedBox.expand(),
  );

  @override
  VoidCallback? onTapCallback(BuildContext context) => () {
    print('HTP 심리검사 시작');
  };
}
