import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../domain/models/taro_card.dart';
import '../../domain/models/taro_spread_type.dart';
import 'card_back.dart';
import 'dart:math' as math;

class SpreadLayout extends StatefulWidget {
  const SpreadLayout({
    super.key,
    required this.spreadType,
    required this.selectedCards,
    this.onCardPlaced,
    this.onCardRemoved,
  });

  final TaroSpreadType spreadType;
  final List<TaroCard?> selectedCards;
  final Function(TaroCard card, int position)? onCardPlaced;
  final Function(int position)? onCardRemoved;

  @override
  State<SpreadLayout> createState() => _SpreadLayoutState();
}

class _SpreadLayoutState extends State<SpreadLayout> {
  // 드래그 상태 관리 (깜빡임 방지)
  int? _hoveredSlot;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _buildSpreadLayout(constraints);
      },
    );
  }

  /// 카드 개수에 따라 적절한 레이아웃을 반환합니다.
  Widget _buildSpreadLayout(BoxConstraints constraints) {
    switch (widget.spreadType.cardCount) {
      case 3:
        return _buildThreeCardVerticalLayout(constraints);
      case 5:
        return _buildFiveCardCrossLayout(constraints);
      case 7:
        return _buildMagicSevenLayout(constraints);
      case 10:
        return _buildTenCardCelticCrossLayout(constraints);
      default:
        // 기본값은 그리드 레이아웃
        return _buildGridLayout(constraints);
    }
  }

  // --- 각 스프레드에 맞는 커스텀 레이아웃 빌더 ---
  final double cardWidth = 75;
  final double cardHeight = 120;
  final double gap = 8;
  /// 3카드: 세로 배치
  Widget _buildThreeCardVerticalLayout(BoxConstraints constraints) {
    final cardWidth = constraints.maxWidth * 0.28; // 크기 약간 줄임
    final cardHeight = cardWidth * 1.6;
    final gap = 16.h; // 간격 늘림

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCardSlot(0, '과거', width: cardWidth, height: cardHeight),
        SizedBox(height: gap),
        _buildCardSlot(1, '현재', width: cardWidth, height: cardHeight),
        SizedBox(height: gap),
        _buildCardSlot(2, '미래', width: cardWidth, height: cardHeight),
      ],
    );
  }

  /// 5카드: 십자가 모양 배치
  Widget _buildFiveCardCrossLayout(BoxConstraints constraints) {
    final cardWidth = constraints.maxWidth / 5; // 크기 약간 줄임
    final cardHeight = cardWidth * 1.6;
    final gap = 12.w; // 간격 늘림

    return Center(
      child: SizedBox(
        width: cardWidth * 3 + gap * 2,
        height: cardHeight * 3 + gap * 2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(child: _buildCardSlot(0, '현재', width: cardWidth, height: cardHeight)),
            Positioned(top: 0, child: _buildCardSlot(1, '목표', width: cardWidth, height: cardHeight)),
            Positioned(left: 0, child: _buildCardSlot(2, '과거', width: cardWidth, height: cardHeight)),
            Positioned(right: 0, child: _buildCardSlot(3, '미래', width: cardWidth, height: cardHeight)),
            Positioned(bottom: 0, child: _buildCardSlot(4, '결과', width: cardWidth, height: cardHeight)),
          ],
        ),
      ),
    );
  }

  /// 7카드: 매직세븐  배치
  Widget _buildMagicSevenLayout(BoxConstraints constraints) {
    // 카드 크기와 간격을 일관되게 정의합니다.
    final cardWidth = 80.w;
    final cardHeight = 128.h;
    final gap = 12.w;

    // 각 자리의 의미를 이미지에 맞게 정확히 정의합니다.
    const List<String> positionNames = [
      '과거의 사건', // 1
      '현재 상태',    // 2
      '가까운 미래',  // 3
      '문제해결 방법', // 4
      '주변환경',     // 5
      '장애물',       // 6
      '결과'        // 7
    ];

    // 전체 레이아웃을 큰 Row로 감싸서 좌, 중, 우 3개의 열로 나눕니다.
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- 1. 왼쪽 열 (2장) ---
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 5번 카드
              _buildCardSlot(4, positionNames[4], width: cardWidth, height: cardHeight),
              SizedBox(height: gap),
              // 3번 카드
              _buildCardSlot(2, positionNames[2], width: cardWidth, height: cardHeight),
            ],
          ),
          SizedBox(width: gap),

          // --- 2. 중앙 열 (3장) ---
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1번 카드
              _buildCardSlot(0, positionNames[0], width: cardWidth, height: cardHeight),
              SizedBox(height: gap),
              // 7번 카드
              _buildCardSlot(6, positionNames[6], width: cardWidth, height: cardHeight),
              SizedBox(height: gap),
              // 4번 카드
              _buildCardSlot(3, positionNames[3], width: cardWidth, height: cardHeight),
            ],
          ),
          SizedBox(width: gap),

          // --- 3. 오른쪽 열 (2장) ---
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 6번 카드
              _buildCardSlot(5, positionNames[5], width: cardWidth, height: cardHeight),
              SizedBox(height: gap),
              // 2번 카드
              _buildCardSlot(1, positionNames[1], width: cardWidth, height: cardHeight),
            ],
          ),
        ],
      ),
    );
  }

  //10장 캘틱크로스
  Widget _buildTenCardCelticCrossLayout(BoxConstraints constraints) {
    // 화면 크기에 따라 카드 크기와 간격을 유연하게 계산합니다.
    final cardWidth = constraints.maxWidth / 5; // 카드 너비를 약간 줄여 간격 확보
    final cardHeight = cardWidth * 1.6;
    final gap = 10.w;

    return Center(
      child: SizedBox(
        // 간격이 넓어졌으므로 전체 너비를 조금 더 넉넉하게 잡습니다.
        width: cardWidth * 3 + gap * 4,
        height: cardHeight * 5 + gap * 4,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // --- 중앙 십자가 (이미지 기준) ---
            // 1. 세로 카드 (중앙)
            Positioned(
              top: cardHeight + gap,
              child: _buildCardSlot(0, '현재', width: cardWidth, height: cardHeight),
            ),
            // 2. 가로 카드 (중앙)
            Positioned(
              top: cardHeight + gap + (cardHeight / 4),
              child: Transform.rotate(
                angle: math.pi / 2,
                child: _buildCardSlot(1, '장애물', width: cardWidth, height: cardHeight),
              ),
            ),

            // --- 주변 카드들 (이미지 기준) ---
            // 3. 맨 위 카드
            Positioned(
              top: 0,
              child: _buildCardSlot(2, '문제의 이유', width: cardWidth, height: cardHeight),
            ),
            // 4. 맨 아래 카드
            Positioned(
              top: cardHeight * 2 + gap * 2,
              child: _buildCardSlot(3, '과거의 사건', width: cardWidth, height: cardHeight),
            ),
            // ★★★★★ 5. 왼쪽 카드 ('과거') - 간격 조정 ★★★★★
            Positioned(
              top: cardHeight + gap,
              left: 0, // 왼쪽 끝에 배치
              child: _buildCardSlot(4, '목표', width: cardWidth, height: cardHeight),
            ),
            // ★★★★★ 6. 오른쪽 카드 ('미래') - 간격 조정 ★★★★★
            Positioned(
              top: cardHeight + gap,
              right: 0, // 오른쪽 끝에 배치
              child: _buildCardSlot(5, '가까운미래', width: cardWidth, height: cardHeight),
            ),

            // --- 하단 2x2 카드 (이미지 기준) ---
            // ... (하단 4개 카드 배치는 이전과 동일) ...
            Positioned(
              bottom: cardHeight + gap,
              left: (cardWidth / 2) + (gap / 2),
              child: _buildCardSlot(6, '나의 모습', width: cardWidth, height: cardHeight),
            ),
            Positioned(
              bottom: cardHeight + gap,
              right: (cardWidth / 2) + (gap / 2),
              child: _buildCardSlot(7, '남이 보는\n나의 모습', width: cardWidth, height: cardHeight),
            ),
            Positioned(
              bottom: 0,
              left: (cardWidth / 2) + (gap / 2),
              child: _buildCardSlot(8, '희망/두려움', width: cardWidth, height: cardHeight),
            ),
            Positioned(
              bottom: 0,
              right: (cardWidth / 2) + (gap / 2),
              child: _buildCardSlot(9, '최종 결과', width: cardWidth, height: cardHeight),
            ),
          ],
        ),
      ),
    );
  }

  /// 기본 그리드 레이아웃 (Fallback)
  Widget _buildGridLayout(BoxConstraints constraints) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
      itemCount: widget.spreadType.cardCount,
      itemBuilder: (context, index) {
        return _buildCardSlot(index, '카드 ${index + 1}');
      },
    );
  }

  /// 카드 슬롯 빌더 (깜빡임 방지 최적화)
  Widget _buildCardSlot(
    int position,
    String positionName, {
    double? width,
    double? height,
  }) {
    final card = (position < widget.selectedCards.length)
        ? widget.selectedCards[position]
        : null;

    return DragTarget<TaroCard>(
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        final isHighlighted = card != null || isHovering;
        
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isHighlighted
                  ? Colors.amber.shade400
                  : Colors.blueGrey.shade600,
              width: isHighlighted ? 2 : 1,
            ),
          ),
          child: card != null
              ? GestureDetector(
                  onTap: () => widget.onCardRemoved?.call(position),
                  child: const CardBack(),
                )
              : _buildEmptySlot(positionName),
        );
      },
      onWillAcceptWithDetails: (details) {
        // 드래그 상태 관리
        if (_hoveredSlot != position) {
          setState(() {
            _hoveredSlot = position;
          });
        }
        return card == null;
      },
      onLeave: (data) {
        // 드래그가 슬롯을 벗어났을 때
        if (_hoveredSlot == position) {
          setState(() {
            _hoveredSlot = null;
          });
        }
      },
      onAcceptWithDetails: (details) async {
        // 드래그 상태 초기화
        setState(() {
          _hoveredSlot = null;
          _isDragging = false;
        });

        // 카드 놓는 사운드 재생 (비동기로 처리하여 UI 블로킹 방지)
        _playCardPlaceSound();
        
        // 카드 배치 처리
        widget.onCardPlaced?.call(details.data, position);
      },
    );
  }

  /// 카드 놓는 사운드 재생 (비동기 처리)
  void _playCardPlaceSound() async {
    try {
      final player = AudioPlayer();
      // TODO: assets/sounds/card_place.mp3 파일을 추가하세요
      await player.play(AssetSource('sounds/card_place.mp3'));
    } catch (e) {
      // 사운드 파일이 없을 경우 에러 무시
      debugPrint('사운드 재생 실패: $e');
    }
  }

  /// 빈 슬롯 UI
  Widget _buildEmptySlot(String positionName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add, color: Colors.blueGrey.shade400, size: 32.sp),
        SizedBox(height: 8.h),
        Text(
          positionName,
          style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 10.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
