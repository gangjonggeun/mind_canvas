import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/taro_card.dart';
import 'card_back.dart';
import 'draggable_taro_card.dart';

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

  // 회전 각도 범위를 클래스 멤버 getter로 정의
  double get _maxRotation => _cardAngleSpacing * (widget.availableCards.length / 2.0);
  double get _minRotation => -_maxRotation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      // lowerBound/upperBound는 애니메이션 값 자체의 한계일 뿐,
      // 시뮬레이션이 이 값을 넘어서는 것을 막지는 못합니다. 따라서 무한대로 둡니다.
      lowerBound: -double.infinity,
      upperBound: double.infinity,
    );

    // ★★★★★ 1. 애니메이션 리스너에서 경계 확인 ★★★★★
    _animationController.addListener(() {
      // 현재 애니메이션 값(예상 회전 각도)을 가져옵니다.
      final currentAngle = _animationController.value;

      // 만약 예상 회전 각도가 우리가 정한 범위를 벗어났다면,
      if (currentAngle < _minRotation || currentAngle > _maxRotation) {
        // 애니메이션을 즉시 멈춥니다.
        _animationController.stop();
        // 실제 회전 각도를 경계 값으로 강제 고정합니다.
        _rotationAngle = currentAngle.clamp(_minRotation, _maxRotation);
      } else {
        // 범위 내에 있다면, 회전 각도를 그대로 반영합니다.
        _rotationAngle = currentAngle;
      }
      // UI를 업데이트합니다.
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // 드래그 중 각도를 제한하는 함수
  void _clampRotation() {
    _rotationAngle = _rotationAngle.clamp(_minRotation, _maxRotation);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        // 새로운 드래그가 시작되면 진행 중인 모든 애니메이션을 멈춥니다.
        _animationController.stop();
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          _rotationAngle -= details.delta.dx / 100;
          _clampRotation(); // 드래그 중에도 경계를 넘지 않도록 실시간으로 제한합니다.
        });
      },
      onHorizontalDragEnd: (details) {
        final double velocity = details.velocity.pixelsPerSecond.dx;

        // ★★★★★ 2. 관성을 위한 FrictionSimulation 사용 (원래대로) ★★★★★
        // 마찰 시뮬레이션은 경계를 모르지만, 자유롭게 미끄러지는 물리 효과를 계산합니다.
        final simulation = FrictionSimulation(
          0.35, // 마찰 계수 (조절 가능)
          _rotationAngle, // 현재 위치
          -velocity / 600, // 속도 (값을 나눠서 민감도 조절)
        );

        // 이 시뮬레이션에 따라 애니메이션을 실행합니다.
        // 애니메이션이 실행되는 동안 위에서 정의한 addListener가 계속 호출되면서 경계를 감시합니다.
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

  // 이하 _buildCardWidgets 및 _buildStaticCard는 동일합니다.
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