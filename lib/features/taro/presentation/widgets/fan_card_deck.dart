import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/taro_card.dart';
// DraggableTaroCard 위젯이 있는 파일을 import 해주세요.
import 'draggable_taro_card.dart';

/// 정렬 로직을 위한 임시 데이터 클래스
class _CardData {
  final TaroCard card;
  final double angle;

  _CardData({required this.card, required this.angle});
}

class FanCardDeck extends StatefulWidget {
  final List<TaroCard> availableCards;

  const FanCardDeck({
    super.key,
    required this.availableCards,
  });

  @override
  State<FanCardDeck> createState() => _FanCardDeckState();
}

class _FanCardDeckState extends State<FanCardDeck> {
  double _rotationAngle = 0.0;
  static const double _cardAngleSpacing = math.pi / 20; // 약 9도

  @override
  Widget build(BuildContext context) {
    // --- 1. 카드와 각도 정보를 묶은 데이터 리스트 생성 ---
    final List<_CardData> cardDataList = [];
    for (int i = 0; i < widget.availableCards.length; i++) {
      final angleFromCenter = (i - widget.availableCards.length / 2) * _cardAngleSpacing;
      final totalAngle = angleFromCenter + _rotationAngle;
      cardDataList.add(_CardData(card: widget.availableCards[i], angle: totalAngle));
    }

    // --- 2. 각도의 절대값을 기준으로 정렬 ---
    // Stack은 리스트의 앞 순서부터 그리므로, 각도가 큰(바깥쪽) 카드가 먼저 그려져야(뒤에 깔려야) 함.
    // 따라서 각도의 절대값을 기준으로 '내림차순' 정렬.
    cardDataList.sort((a, b) => b.angle.abs().compareTo(a.angle.abs()));

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _rotationAngle += details.delta.dx / 100;
          final maxRotation = _cardAngleSpacing * (widget.availableCards.length / 2);
          _rotationAngle = _rotationAngle.clamp(-maxRotation, maxRotation);
        });
      },
      child: Container(
        height: 250.h,
        width: double.infinity,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 150.h,
              child: Stack(
                alignment: Alignment.center,
                // --- 3. 정렬된 리스트를 기반으로 위젯 생성 ---
                children: cardDataList.map((cardData) {
                  final card = cardData.card;
                  final totalAngle = cardData.angle;
                  final scale = 1.0 - (totalAngle).abs() * 0.1;

                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateZ(totalAngle)
                      ..translate(0.0, -100.h, 0.0)
                      ..scale(scale.clamp(0.8, 1.0)),
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 75.w,
                      height: 115.h,
                      child: DraggableTaroCard(
                        card: card,
                        showBack: true,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}