import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/taro_card.dart'; // 경로는 본인 프로젝트에 맞게 확인해주세요.
import 'card_back.dart';                     // CardBack 위젯을 import 합니다.

/// 드래그 가능한 타로 카드 위젯 (단순화된 최종 버전)
class DraggableTaroCard extends StatelessWidget {
  final TaroCard card;
  // isSelected, onTap, width, height 등 다른 속성들은
  // 현재 FanCardDeck에서는 사용하지 않으므로, 잠시 남겨두거나 제거해도 됩니다.
  final bool showBack;

  const DraggableTaroCard({
    super.key,
    required this.card,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    // FanCardDeck에서 크기를 지정해주므로, 여기서는 고정된 값을 사용해도 무방합니다.
    final cardWidth = 85.w;
    final cardHeight = 130.h;

    // ★★★★★ 1. Draggable 위젯의 UI를 모두 CardBack으로 통일 ★★★★★
    return Draggable<TaroCard>(
      // data: 이 카드가 어떤 카드인지 알려주는 정보
      data: card,

      // feedback: 드래그하는 동안 손가락을 따라다니는 위젯
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: cardWidth * 1.5, // 살짝 크게 보여줌
          height: cardHeight * 1.5,
          child: const CardBack(), // 안전한 CardBack 위젯 사용
        ),
      ),

      // childWhenDragging: 원래 카드가 있던 자리에 남는 위젯
      childWhenDragging: Opacity(opacity: 0.5, child: const CardBack()),

      // child: 드래그하기 전, 평소에 보이는 위젯
      child: const CardBack(),
    );
  }
}