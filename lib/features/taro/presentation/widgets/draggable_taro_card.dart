import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/taro_card.dart'; // 경로는 본인 프로젝트에 맞게 확인해주세요.
import 'card_back.dart';                     // CardBack 위젯을 import 합니다.

/// 드래그 가능한 타로 카드 위젯 (깜빡임 방지 최적화)
class DraggableTaroCard extends StatefulWidget {
  final TaroCard card;
  final bool showBack;

  const DraggableTaroCard({
    super.key,
    required this.card,
    this.showBack = true,
  });

  @override
  State<DraggableTaroCard> createState() => _DraggableTaroCardState();
}

class _DraggableTaroCardState extends State<DraggableTaroCard> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    // FanCardDeck에서 크기를 지정해주므로, 여기서는 고정된 값을 사용해도 무방합니다.
    final cardWidth = 85.w;
    final cardHeight = 130.h;

    // ★★★★★ 깜빡임 방지를 위한 최적화된 Draggable ★★★★★
    return Draggable<TaroCard>(
      // data: 이 카드가 어떤 카드인지 알려주는 정보
      data: widget.card,

      // 드래그 시작/종료 상태 관리
      onDragStarted: () {
        setState(() {
          _isDragging = true;
        });
      },
      onDragEnd: (details) {
        setState(() {
          _isDragging = false;
        });
      },
      onDraggableCanceled: (velocity, offset) {
        setState(() {
          _isDragging = false;
        });
      },

      // feedback: 드래그하는 동안 손가락을 따라다니는 위젯
      feedback: Material(
        color: Colors.transparent,
        elevation: 8, // 그림자 효과 추가
        borderRadius: BorderRadius.circular(12.r),
        child: Transform.scale(
          scale: 1.1, // 살짝 크게 보여줌
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: const CardBack(),
          ),
        ),
      ),

      // childWhenDragging: 원래 카드가 있던 자리에 남는 위젯
      childWhenDragging: Opacity(
        opacity: 0.3, // 더 투명하게 처리
        child: Transform.scale(
          scale: 0.95, // 살짝 작게 처리
          child: const CardBack(),
        ),
      ),

      // child: 드래그하기 전, 평소에 보이는 위젯
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..scale(_isDragging ? 0.95 : 1.0), // 드래그 시 살짝 작아짐
        child: const CardBack(),
      ),
    );
  }
}
