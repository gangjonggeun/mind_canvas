import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 타로 상담 배경 위젯
/// card_back_1.webp를 사용한 신비로운 느낌의 배경
class TaroBackground extends StatelessWidget {
  final Widget child;
  final double opacity;

  const TaroBackground({
    super.key,
    required this.child,
    this.opacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // 기본 그라데이션 배경
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1a1a2e),  // 진한 네이비
            const Color(0xFF16213e),  // 미드나이트 블루
            const Color(0xFF0f3460),  // 딥 블루
          ],
        ),
      ),
      child: Stack(
        children: [
          // 타로 카드 백 패턴 배경
          Positioned.fill(
            child: Opacity(
              opacity: opacity,
              child: Image.asset(
                'assets/illustrations/taro/card_back_1.webp',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // 이미지 로드 실패시 기본 패턴
                  return Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.0,
                        colors: [
                          Colors.amber.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: CustomPaint(
                      painter: _MysticPatternPainter(),
                      size: Size.infinite,
                    ),
                  );
                },
              ),
            ),
          ),
          
          // 상단 그라데이션 오버레이
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          
          // 자식 위젯
          child,
        ],
      ),
    );
  }
}

/// 신비로운 패턴을 그리는 CustomPainter
class _MysticPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final maxRadius = size.width * 0.8;

    // 동심원 그리기
    for (int i = 1; i <= 5; i++) {
      final radius = (maxRadius / 5) * i;
      canvas.drawCircle(
        Offset(centerX, centerY),
        radius,
        paint,
      );
    }

    // 별 모양 패턴
    _drawStar(canvas, paint, Offset(centerX, centerY), maxRadius * 0.3);
  }

  void _drawStar(Canvas canvas, Paint paint, Offset center, double radius) {
    const int points = 8;
    final path = Path();
    
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * 3.14159) / points;
      final currentRadius = i.isEven ? radius : radius * 0.5;
      final x = center.dx + currentRadius * math.cos(angle);
      final y = center.dy + currentRadius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
