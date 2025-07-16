import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/taro_card.dart';
import 'card_back.dart';

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
    final cardWidth = width ?? 85.w;
    final cardHeight = height ?? 130.h;

    return Draggable<TaroCard>(
      data: card,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox( // ★★★ 2. 드래그 피드백 위젯의 크기를 명확히 지정합니다.
          width: cardWidth * 1.1,
          height: cardHeight * 1.1,
          child: const CardBack(), // ★★★ 3. 안전한 CardBack 위젯 사용
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.5, child: const CardBack()),
      child: const CardBack(),
    );
  }

  // ★★★★★ 오버플로우 해결을 위해 _buildCard 구조 변경 ★★★★★
  Widget _buildCard({bool isDragging = false}) {
    return Container(
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
      // ClipRRect로 먼저 테두리를 둥글게 자릅니다.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        // ★★★★★ FittedBox로 이미지 크기를 강제로 맞춥니다 ★★★★★
        child: FittedBox(
          fit: BoxFit.cover, // 공간을 꽉 채우도록 설정 (비율 유지, 잘릴 수 있음)
          child: showBack ? _buildCardBack() : _buildCardFront(),
        ),
      ),
    );
  }

  Widget _buildCardFront() {
    // 앞면 이미지
    return SizedBox(
      // 이미지의 원래 비율을 알려주면 더 안정적입니다. (선택사항)
      // width: 400,
      // height: 680,
      child: Image.asset(card.imagePath),
    );
  }

  Widget _buildCardBack() {
    // 뒷면 이미지
    return SizedBox(
      // 이미지의 원래 비율을 알려주면 더 안정적입니다. (선택사항)
      // width: 400,
      // height: 680,
      child: Image.asset('assets/illustrations/taro/taro_back_1_high.webp'),
    );
  }
}