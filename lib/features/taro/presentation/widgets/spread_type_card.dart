import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/taro_spread_type.dart';

/// 스프레드 타입 선택 카드 위젯
class SpreadTypeCard extends StatelessWidget {
  final TaroSpreadType spreadType;
  final bool isSelected;
  final VoidCallback onTap;

  const SpreadTypeCard({
    super.key,
    required this.spreadType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: TaroColors.gradientGolden,
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    TaroColors.withMysticOpacity(TaroColors.textMystic, 0.1),
                    TaroColors.withMysticOpacity(TaroColors.textMystic, 0.05),
                  ],
                ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected 
                ? TaroColors.accentGold 
                : TaroColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: TaroColors.withMysticOpacity(TaroColors.accentGold, 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 카드 수 표시
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: isSelected 
                      ? TaroColors.textMystic 
                      : TaroColors.accentGold,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: TaroColors.cardShadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${spreadType.cardCount}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected 
                          ? TaroColors.accentGold 
                          : TaroColors.textMystic,
                    ),
                  ),
                ),
              ),
              
              Gap(12.h),
              
              // 스프레드 이름
              Text(
                spreadType.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? TaroColors.textMystic : TaroColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              Gap(4.h),
              
              // 스프레드 설명
              Text(
                spreadType.description,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isSelected 
                      ? TaroColors.textSecondary 
                      : TaroColors.textMuted,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              Gap(8.h),
              
              // 선택 인디케이터
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: TaroColors.textMystic,
                  size: 16.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 스프레드 패턴 미리보기 위젯
class SpreadPreviewWidget extends StatelessWidget {
  final TaroSpreadType spreadType;
  final double size;

  const SpreadPreviewWidget({
    super.key,
    required this.spreadType,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SpreadPatternPainter(
          cardCount: spreadType.cardCount,
          color: TaroColors.textSecondary,
        ),
      ),
    );
  }
}

/// 스프레드 패턴을 그리는 CustomPainter
class _SpreadPatternPainter extends CustomPainter {
  final int cardCount;
  final Color color;

  const _SpreadPatternPainter({
    required this.cardCount,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cardWidth = size.width * 0.15;
    final cardHeight = size.height * 0.25;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    switch (cardCount) {
      case 3:
        _draw3CardSpread(canvas, paint, centerX, centerY, cardWidth, cardHeight);
        break;
      case 5:
        _draw5CardSpread(canvas, paint, centerX, centerY, cardWidth, cardHeight);
        break;
      case 7:
        _draw7CardSpread(canvas, paint, centerX, centerY, cardWidth, cardHeight);
        break;
      case 10:
        _draw10CardSpread(canvas, paint, centerX, centerY, cardWidth, cardHeight);
        break;
    }
  }

  void _draw3CardSpread(Canvas canvas, Paint paint, double centerX, double centerY, double cardWidth, double cardHeight) {
    // 세로 일렬
    for (int i = 0; i < 3; i++) {
      final x = centerX - cardWidth / 2;
      final y = centerY - cardHeight * 1.2 + (i * cardHeight * 0.8);
      _drawCard(canvas, paint, x, y, cardWidth, cardHeight);
    }
  }

  void _draw5CardSpread(Canvas canvas, Paint paint, double centerX, double centerY, double cardWidth, double cardHeight) {
    // 십자가 형태
    final positions = [
      Offset(centerX - cardWidth / 2, centerY - cardHeight * 0.6), // 상
      Offset(centerX - cardWidth * 1.2, centerY - cardHeight / 2), // 좌
      Offset(centerX - cardWidth / 2, centerY - cardHeight / 2), // 중앙
      Offset(centerX + cardWidth * 0.2, centerY - cardHeight / 2), // 우
      Offset(centerX - cardWidth / 2, centerY + cardHeight * 0.1), // 하
    ];

    for (final pos in positions) {
      _drawCard(canvas, paint, pos.dx, pos.dy, cardWidth, cardHeight);
    }
  }

  void _draw7CardSpread(Canvas canvas, Paint paint, double centerX, double centerY, double cardWidth, double cardHeight) {
    // 호스슈 형태 (U자)
    final positions = [
      Offset(centerX - cardWidth * 1.5, centerY - cardHeight * 0.5), // 좌상
      Offset(centerX - cardWidth * 0.5, centerY - cardHeight * 0.8), // 중상
      Offset(centerX + cardWidth * 0.5, centerY - cardHeight * 0.5), // 우상
      Offset(centerX - cardWidth * 1.2, centerY + cardHeight * 0.1), // 좌중
      Offset(centerX - cardWidth / 2, centerY + cardHeight * 0.2), // 중앙
      Offset(centerX + cardWidth * 0.2, centerY + cardHeight * 0.1), // 우중
      Offset(centerX - cardWidth / 2, centerY + cardHeight * 0.8), // 하단
    ];

    for (final pos in positions) {
      _drawCard(canvas, paint, pos.dx, pos.dy, cardWidth, cardHeight);
    }
  }

  void _draw10CardSpread(Canvas canvas, Paint paint, double centerX, double centerY, double cardWidth, double cardHeight) {
    // 켈틱 크로스
    final positions = [
      // 중앙 십자가
      Offset(centerX - cardWidth / 2, centerY - cardHeight * 0.4), // 1
      Offset(centerX - cardWidth / 2, centerY - cardHeight / 2), // 2
      Offset(centerX - cardWidth / 2, centerY + cardHeight * 0.1), // 3
      Offset(centerX - cardWidth / 2, centerY - cardHeight * 1.0), // 4
      Offset(centerX - cardWidth * 1.2, centerY - cardHeight / 2), // 5
      Offset(centerX + cardWidth * 0.2, centerY - cardHeight / 2), // 6
      
      // 우측 세로
      Offset(centerX + cardWidth * 1.0, centerY + cardHeight * 0.8), // 7
      Offset(centerX + cardWidth * 1.0, centerY + cardHeight * 0.3), // 8
      Offset(centerX + cardWidth * 1.0, centerY - cardHeight * 0.2), // 9
      Offset(centerX + cardWidth * 1.0, centerY - cardHeight * 0.7), // 10
    ];

    for (final pos in positions) {
      _drawCard(canvas, paint, pos.dx, pos.dy, cardWidth, cardHeight);
    }
  }

  void _drawCard(Canvas canvas, Paint paint, double x, double y, double width, double height) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, y, width, height),
      const Radius.circular(2),
    );
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
