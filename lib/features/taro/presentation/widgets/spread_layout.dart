import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../domain/models/taro_card.dart';
import '../../domain/models/taro_spread_type.dart';
// DraggableTaroCard 위젯이 있는 파일을 import 해야 할 수 있습니다.
// import 'widgets/taro_card_widgets.dart';

/// 타로 스프레드 레이아웃 위젯
/// 다양한 스프레드 타입에 따라 카드들을 배치하고, 드래그 앤 드롭을 처리합니다.
class SpreadLayout extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // SpreadLayout의 크기가 내용에 맞게 조절되도록 합니다.
    return _buildSpreadLayout();
  }

  Widget _buildSpreadLayout() {
    switch (spreadType.cardCount) {
      case 1:
        return _buildSingleCard();
      case 3:
        return _buildThreeCards();
      case 5:
        return _buildCrossSpread();
      case 7:
        return _buildHorseshoeSpread();
      case 10:
        return _buildCelticCross();
      default:
        return _buildGridLayout();
    }
  }

  /// 단일 카드 레이아웃
  Widget _buildSingleCard() {
    return Center(
      child: _buildCardSlot(0, '현재 상황'),
    );
  }

  /// 3카드 레이아웃 (과거-현재-미래)
  Widget _buildThreeCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCardSlot(0, '과거'),
        _buildCardSlot(1, '현재'),
        _buildCardSlot(2, '미래'),
      ],
    );
  }

  /// 십자가 스프레드 (5카드)
  Widget _buildCrossSpread() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 중앙
        _buildCardSlot(0, '현재'),
        // 위
        Positioned(
          top: 0,
          child: _buildCardSlot(1, '도전'),
        ),
        // 왼쪽
        Positioned(
          left: 0,
          child: _buildCardSlot(2, '과거'),
        ),
        // 오른쪽
        Positioned(
          right: 0,
          child: _buildCardSlot(3, '미래'),
        ),
        // 아래
        Positioned(
          bottom: 0,
          child: _buildCardSlot(4, '기반'),
        ),
      ],
    );
  }

  /// 호스슈 스프레드 (7카드)
  Widget _buildHorseshoeSpread() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        for (int i = 0; i < 7; i++)
          _buildCardSlot(i, _getHorseshoePositionName(i)),
      ],
    );
  }

  /// 켈틱 크로스 (10카드)
  Widget _buildCelticCross() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildCardSlot(index, _getCelticPositionName(index));
      },
    );
  }

  /// 기본 그리드 레이아웃
  Widget _buildGridLayout() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
      itemCount: spreadType.cardCount,
      itemBuilder: (context, index) {
        return _buildCardSlot(index, '카드 ${index + 1}');
      },
    );
  }


  /// ★★★★★ 수정된 카드 슬롯 빌더 ★★★★★
  Widget _buildCardSlot(int position, String positionName) {
    final card = (position < selectedCards.length)
        ? selectedCards[position]
        : null;

    // DragTarget으로 전체 슬롯을 감싸 카드를 받을 수 있게 합니다.
    return DragTarget<TaroCard>(
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        // 기존의 카드 표시 로직을 재사용합니다.
        return Container(
          width: 80.w,
          height: 120.h,
          decoration: BoxDecoration(
            color: card != null
                ? Colors.indigo.shade800 // 카드가 있을 때
                : (isHovering ? Colors.amber.withOpacity(0.2) : Colors.grey
                .shade800.withOpacity(0.5)), // 비어있을 때 (호버링 효과)
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isHovering || card != null
                  ? Colors.amber.shade300
                  : Colors.white.withOpacity(0.3),
              width: isHovering || card != null ? 2 : 1.5,
            ),
          ),
          // 카드가 있으면 선택된 카드 위젯, 없으면 빈 슬롯 위젯 표시
          child: card != null
              ? _buildSelectedCard(card, position) // 제거를 위해 position 전달
              : _buildEmptySlot(positionName, isHovering), // 호버링 상태 전달
        );
      },
      // 슬롯이 비어있을 때만 카드를 받도록 합니다.
      onWillAccept: (draggedCard) => card == null,
      // 카드가 성공적으로 드롭되면 콜백 함수를 호출합니다.
      onAccept: (draggedCard) {
        onCardPlaced?.call(draggedCard, position);
      },
    );
  }

  /// 선택된 카드 표시 위젯 (수정: onTap 추가)
  Widget _buildSelectedCard(TaroCard card, int position) {
    return GestureDetector(
      onTap: () => onCardRemoved?.call(position),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome, color: Colors.amber.shade300, size: 24.sp),
          Gap(8.h),
          Text(
            card.name,
            style: TextStyle(fontSize: 10.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// 빈 슬롯 표시 위젯 (수정: isHovering 파라미터 추가)
  Widget _buildEmptySlot(String positionName, bool isHovering) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isHovering ? Icons.add_circle : Icons.add_circle_outline,
          // 호버링 시 아이콘 변경
          color: isHovering ? Colors.amber.shade300 : Colors.white.withOpacity(
              0.5),
          size: 32.sp,
        ),
        Gap(8.h),
        Text(
          positionName,
          style: TextStyle(
              fontSize: 9.sp, color: Colors.white.withOpacity(0.7)),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }


  /// 호스슈 스프레드 위치 이름
  String _getHorseshoePositionName(int index) {
    const names = [
      '과거',
      '현재 상황',
      '숨겨진 영향',
      '조언',
      '외부 영향',
      '내면의 감정',
      '최종 결과'
    ];
    return index < names.length ? names[index] : '카드 ${index + 1}';
  }

  /// 켈틱 크로스 위치 이름
  String _getCelticPositionName(int index) {
    const names = [
      '현재 상황',
      '도전과 갈등',
      '과거의 영향',
      '가능한 미래',
      '의식적 목표',
      '무의식적 영향',
      '당신의 접근법',
      '외부 영향',
      '희망과 두려움',
      '최종 결과'
    ];
    return index < names.length ? names[index] : '카드 ${index + 1}';
  }
}