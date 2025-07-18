import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/taro_card.dart';
import 'card_back.dart';
import 'draggable_taro_card.dart';
import 'dart:async';

class FanCardDeck extends StatefulWidget {
  final List<TaroCard> availableCards;
  const FanCardDeck({super.key, required this.availableCards});

  @override
  State<FanCardDeck> createState() => _FanCardDeckState();
}

class _FanCardDeckState extends State<FanCardDeck> with TickerProviderStateMixin {
  double _rotationAngle = 0.0;
  static const double _cardAngleSpacing = math.pi / 22;
  static const int _card_width = 105;
  static const int _card_height = 155;

  late AnimationController _animationController;

  double get _maxRotation => _cardAngleSpacing * (widget.availableCards.length / 2.0);
  double get _minRotation => -_maxRotation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: -double.infinity,
      upperBound: double.infinity,
    );

    _animationController.addListener(() {
      final currentAngle = _animationController.value;

      if (currentAngle < _minRotation || currentAngle > _maxRotation) {
        _animationController.stop();
        _rotationAngle = currentAngle.clamp(_minRotation, _maxRotation);
      } else {
        _rotationAngle = currentAngle;
      }

      // mounted 체크는 안전을 위해 남겨두는 것이 좋습니다.
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // 애니메이션 컨트롤러만 정리하면 됩니다.
    _animationController.dispose();
    super.dispose();
  }

  void _clampRotation() {
    _rotationAngle = _rotationAngle.clamp(_minRotation, _maxRotation);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        _animationController.stop();
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          _rotationAngle -= details.delta.dx / 100;
          _clampRotation();
        });
      },
      onHorizontalDragEnd: (details) {
        final double velocity = details.velocity.pixelsPerSecond.dx;

        final simulation = FrictionSimulation(
          0.35,
          _rotationAngle,
          -velocity / 600,
        );

        _animationController.animateWith(simulation);
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
      final angleFromCenter = (index - widget.availableCards.length / 2) * _cardAngleSpacing;
      final totalAngle = angleFromCenter + _rotationAngle;

      final bool isCenter = index == centerCardIndex;
      final scale = isCenter ? 1.2 : 1.0;

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