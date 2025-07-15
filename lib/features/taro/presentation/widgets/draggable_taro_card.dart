import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/taro_card.dart';

/// 드래그 가능한 타로 카드 위젯
class DraggableTaroCard extends StatelessWidget {
  final TaroCard card;
  final bool isSelected;
  final bool showBack;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const DraggableTaroCard({
    super.key,
    required this.card,
    this.isSelected = false,
    this.showBack = true,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? 60.w;
    final cardHeight = height ?? 100.h;

    return Draggable<TaroCard>(
      data: card,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.1,
          child: _buildCard(cardWidth, cardHeight, isDragging: true),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildCard(cardWidth, cardHeight),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: _buildCard(cardWidth, cardHeight),
      ),
    );
  }

  Widget _buildCard(double cardWidth, double cardHeight, {bool isDragging = false}) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDragging ? 0.3 : 0.2),
            blurRadius: isDragging ? 12 : 6,
            offset: Offset(0, isDragging ? 6 : 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 카드 이미지
            showBack ? _buildCardBack() : _buildCardFront(),
            
            // 선택 표시
            if (isSelected)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.amber.shade300,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            
            // 드래그 힌트 (뒷면일 때만)
            if (showBack && !isDragging)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Icon(
                    Icons.drag_indicator,
                    color: Colors.white,
                    size: 12.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 카드 앞면 (실제 타로 이미지)
  Widget _buildCardFront() {
    return Image.asset(
      card.imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                color: Colors.grey.shade600,
                size: 24.sp,
              ),
              SizedBox(height: 4.h),
              Text(
                card.name,
                style: TextStyle(
                  fontSize: 8.sp,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  /// 카드 뒷면
  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1a1a2e),
            const Color(0xFF16213e),
            const Color(0xFF0f3460),
          ],
        ),
      ),
      child: Stack(
        children: [
          // 패턴 배경
          Positioned.fill(
            child: Image.asset(
              'assets/illustrations/taro/card_back_1.webp',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.amber.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: CustomPaint(
                    painter: _CardBackPatternPainter(),
                  ),
                );
              },
            ),
          ),
          
          // 중앙 아이콘
          Center(
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                color: Colors.amber.shade300,
                size: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 카드 뒷면 패턴 페인터
class _CardBackPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // 동심원
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(
        Offset(centerX, centerY),
        (size.width / 6) * i,
        paint,
      );
    }

    // 십자가 패턴
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 스프레드 위치에 놓인 카드 위젯
class SpreadPositionCard extends StatelessWidget {
  final TaroCard? card;
  final int position;
  final String positionName;
  final VoidCallback? onRemove;
  final double? width;
  final double? height;

  const SpreadPositionCard({
    super.key,
    this.card,
    required this.position,
    required this.positionName,
    this.onRemove,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? 70.w;
    final cardHeight = height ?? 110.h;

    if (card != null) {
      // 카드가 있는 경우
      return Draggable<TaroCard>(
        data: card!,
        feedback: Material(
          color: Colors.transparent,
          child: Transform.scale(
            scale: 1.1,
            child: DraggableTaroCard(
              card: card!,
              showBack: false,
              width: cardWidth,
              height: cardHeight,
            ),
          ),
        ),
        childWhenDragging: _buildEmptySlot(cardWidth, cardHeight, isDragging: true),
        onDragStarted: () {
          // 드래그 시작시 카드 제거
          onRemove?.call();
        },
        child: DraggableTaroCard(
          card: card!,
          showBack: false,
          width: cardWidth,
          height: cardHeight,
        ),
      );
    } else {
      // 빈 슬롯
      return _buildEmptySlot(cardWidth, cardHeight);
    }
  }

  Widget _buildEmptySlot(double cardWidth, double cardHeight, {bool isDragging = false}) {
    return DragTarget<TaroCard>(
      onAccept: (draggedCard) {
        // 카드 배치 로직은 상위에서 처리
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        
        return Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            color: isHovering 
                ? Colors.amber.withOpacity(0.3)
                : Colors.white.withOpacity(isDragging ? 0.1 : 0.2),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isHovering 
                  ? Colors.amber.shade300 
                  : Colors.white.withOpacity(0.5),
              width: isHovering ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isHovering ? Icons.add_circle : Icons.add_circle_outline,
                color: isHovering 
                    ? Colors.amber.shade300 
                    : Colors.white.withOpacity(0.7),
                size: 24.sp,
              ),
              SizedBox(height: 4.h),
              Text(
                positionName,
                style: TextStyle(
                  fontSize: 8.sp,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
