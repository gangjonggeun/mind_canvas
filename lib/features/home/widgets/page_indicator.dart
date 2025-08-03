import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// ViewPager 페이지 인디케이터
/// 
/// 책임:
/// - 현재 페이지 표시
/// - 페이지 네비게이션 제공
/// - 시각적 피드백 애니메이션
/// - 터치 인터랙션 처리
class PageIndicator extends StatelessWidget {
  /// 전체 페이지 수
  final int totalPages;
  
  /// 현재 활성 페이지 인덱스
  final int currentPage;
  
  /// 페이지 탭 콜백
  final Function(int) onPageTap;
  
  /// 애니메이션 지속시간
  final Duration animationDuration;
  
  /// 활성 인디케이터 크기
  final double activeWidth;
  final double activeHeight;
  
  /// 비활성 인디케이터 크기
  final double inactiveWidth;
  final double inactiveHeight;
  
  /// 인디케이터 간격
  final double spacing;

  const PageIndicator({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.onPageTap,
    this.animationDuration = const Duration(milliseconds: 300),
    this.activeWidth = 24,
    this.activeHeight = 8,
    this.inactiveWidth = 8,
    this.inactiveHeight = 8,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => _buildIndicatorDot(index),
      ),
    );
  }

  /// 개별 인디케이터 점 생성
  /// 
  /// 기능:
  /// - 활성/비활성 상태별 크기 변경
  /// - 부드러운 애니메이션 적용
  /// - 터치 인터랙션 지원
  /// - 그림자 효과 (활성 상태)
  Widget _buildIndicatorDot(int index) {
    final isActive = currentPage == index;
    
    return GestureDetector(
      onTap: () => onPageTap(index),
      child: AnimatedContainer(
        duration: animationDuration,
        margin: EdgeInsets.symmetric(horizontal: spacing),
        width: isActive ? activeWidth : inactiveWidth,
        height: isActive ? activeHeight : inactiveHeight,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryBlue
              : AppColors.withOpacity30(AppColors.textWhite),
          borderRadius: BorderRadius.circular(4),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.withOpacity30(AppColors.primaryBlue),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}

/// 확장 가능한 커스텀 페이지 인디케이터
/// 
/// 추가 기능:
/// - 커스텀 색상 지원
/// - 다양한 모양 (원형, 사각형, 커스텀)
/// - 진행률 표시 기능
class CustomPageIndicator extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final Function(int) onPageTap;
  final Color activeColor;
  final Color inactiveColor;
  final PageIndicatorShape shape;
  final double size;
  final bool showProgress;

  const CustomPageIndicator({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.onPageTap,
    this.activeColor = AppColors.primaryBlue,
    this.inactiveColor = AppColors.borderLight,
    this.shape = PageIndicatorShape.rounded,
    this.size = 8.0,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showProgress) {
      return _buildProgressIndicator();
    }
    
    return _buildDotIndicator();
  }

  /// 점 형태 인디케이터
  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = currentPage == index;
        return GestureDetector(
          onTap: () => onPageTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: size,
            height: size,
            decoration: _getShapeDecoration(isActive),
          ),
        );
      }),
    );
  }

  /// 진행률 바 형태 인디케이터
  Widget _buildProgressIndicator() {
    final progress = totalPages > 0 ? (currentPage + 1) / totalPages : 0.0;
    
    return Column(
      children: [
        // 진행률 바
        Container(
          width: 120,
          height: 4,
          decoration: BoxDecoration(
            color: inactiveColor,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 120 * progress,
              height: 4,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // 페이지 번호
        Text(
          '${currentPage + 1} / $totalPages',
          style: TextStyle(
            color: activeColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 모양별 데코레이션 반환
  BoxDecoration _getShapeDecoration(bool isActive) {
    switch (shape) {
      case PageIndicatorShape.circle:
        return BoxDecoration(
          color: isActive ? activeColor : inactiveColor,
          shape: BoxShape.circle,
        );
      case PageIndicatorShape.square:
        return BoxDecoration(
          color: isActive ? activeColor : inactiveColor,
        );
      case PageIndicatorShape.rounded:
      default:
        return BoxDecoration(
          color: isActive ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(4),
        );
    }
  }
}

/// 페이지 인디케이터 모양 옵션
enum PageIndicatorShape {
  circle,    // 원형
  square,    // 사각형
  rounded,   // 둥근 사각형
}
