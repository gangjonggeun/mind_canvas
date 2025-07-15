import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/taro_card.dart';
import '../providers/taro_consultation_provider.dart';

/// 사진과 같이 호(arc) 형태로 배치된 타로 카드 더미
class ArcCardDeck extends ConsumerStatefulWidget {
  const ArcCardDeck({
    super.key,
    required this.availableCards,
    required this.onCardSelected,
  });

  final List<TaroCard> availableCards;
  final ValueChanged<TaroCard> onCardSelected;

  @override
  ConsumerState<ArcCardDeck> createState() => _ArcCardDeckState();
}

class _ArcCardDeckState extends ConsumerState<ArcCardDeck> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _scrollController.jumpTo((_scrollController.offset - details.delta.dx)
            .clamp(0.0, _scrollController.position.maxScrollExtent));
      },
      child: CustomScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 280.h,
              child: Stack(
                alignment: Alignment.topCenter,
                children: widget.availableCards.asMap().entries.map((entry) {
                  final index = entry.key;
                  final card = entry.value;
                  return _buildCard(card, index);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(TaroCard card, int index) {
    const cardWidth = 80.0;
    const totalSpacing = 20.0; // 카드 간 간격
    final totalWidth = widget.availableCards.length * (cardWidth + totalSpacing);
    final position = index * (cardWidth + totalSpacing);
    final dx = position - _scrollOffset;

    // 화면 중앙을 기준으로 카드 위치 계산
    final screenCenter = MediaQuery.of(context).size.width / 2;
    final distanceFromCenter = (dx - screenCenter + cardWidth / 2).abs();
    final rotation = (dx - screenCenter + cardWidth / 2) / screenCenter * 0.5;
    final scale = (1 - (distanceFromCenter / screenCenter).clamp(0, 0.5) * 0.2);

    return Positioned(
      top: 50.h + (distanceFromCenter / 5),
      left: dx,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateZ(rotation)
          ..scale(scale),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () => widget.onCardSelected(card),
          child: Container(
            width: cardWidth,
            height: 120.h,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/illustrations/taro/card_back_1_high.webp'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: TaroColors.cardBorder, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: TaroColors.cardShadow,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}