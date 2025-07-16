import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/taro_card.dart'; // 경로는 본인 프로젝트에 맞게 확인해주세요.
import 'card_back.dart';
import 'draggable_taro_card.dart';        // 경로는 본인 프로젝트에 맞게 확인해주세요.


class FanCardDeck extends StatefulWidget {
  final List<TaroCard> availableCards;
  const FanCardDeck({super.key, required this.availableCards});

  @override
  State<FanCardDeck> createState() => _FanCardDeckState();
}

class _FanCardDeckState extends State<FanCardDeck> {
  double _rotationAngle = 0.0;
  static const double _cardAngleSpacing = math.pi / 22;
  static const int _card_width = 105;
  static const int _card_height = 155;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _rotationAngle -= details.delta.dx / 100;
          final maxRotation = _cardAngleSpacing * (widget.availableCards.length / 2.5);
          _rotationAngle = _rotationAngle.clamp(-maxRotation, maxRotation);
        });
      },
      child: Container(
        height: 250.h,
        width: double.infinity,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: _buildCardWidgets(),
        ),
      ),
    );
  }

  List<Widget> _buildCardWidgets() {
    if (widget.availableCards.isEmpty) return [];

    int centerCardIndex = 0;
    double minAngle = double.infinity;

    for (int i = 0; i < widget.availableCards.length; i++) {
      final angleFromCenter = (i - widget.availableCards.length / 2) * _cardAngleSpacing;
      final totalAngle = angleFromCenter + _rotationAngle;

      if (totalAngle.abs() < minAngle) {
        minAngle = totalAngle.abs();
        centerCardIndex = i;
      }
    }

    return List.generate(widget.availableCards.length, (index) {
      final card = widget.availableCards[index];
      // ★★★★★ 여기! 'i'를 'index'로 수정했습니다 ★★★★★
      final angleFromCenter = (index - widget.availableCards.length / 2) * _cardAngleSpacing;
      final totalAngle = angleFromCenter + _rotationAngle;

      final bool isCenter = index == centerCardIndex;
      final scale = isCenter ? 1.1 : 1.0;

      return Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateZ(totalAngle)
          ..translate(0.0, 40.h, 0.0),
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: _card_width.w * scale,
          height: _card_height.h * scale,
          child: isCenter
              ? DraggableTaroCard(card: card, showBack: true)
              : _buildStaticCard(),
        ),
      );
    });
  }

  Widget _buildStaticCard() {
    return const CardBack();
  }
}