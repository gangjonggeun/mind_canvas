import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'dart:math' as math;
import '../../domain/models/taro_card.dart';
import '../../domain/models/taro_spread_type.dart';
import '../providers/taro_consultation_provider.dart';
import '../providers/taro_consultation_state.dart';
import '../widgets/taro_background.dart';

/// 타로 결과 화면 (3단계)
///
/// 특징:
/// - 카드 뒤집기 애니메이션
/// - 순차적 카드 공개
/// - AI 해석 결과 표시
/// - 메모리 효율적인 애니메이션
class TaroResultPage extends ConsumerStatefulWidget {
  const TaroResultPage({super.key});

  @override
  ConsumerState<TaroResultPage> createState() => _TaroResultPageState();
}

class _TaroResultPageState extends ConsumerState<TaroResultPage>
    with TickerProviderStateMixin {
  late AnimationController _revealController;
  late AnimationController _fadeController;
  late Animation<double> _revealAnimation;
  late Animation<double> _fadeAnimation;

  final List<bool> _revealedCards = [];
  int _currentRevealIndex = 0;
  bool _allCardsRevealed = false;
  bool _interpretationVisible = false;

  @override
  void initState() {
    super.initState();

    _revealController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _revealAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _revealController,
      curve: Curves.easeInOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeReveal();
    });
  }

  void _initializeReveal() {
    final state = ref.read(taroConsultationNotifierProvider);
    final cardCount = state.selectedCards.where((card) => card != null).length;

    _revealedCards.clear();
    _revealedCards.addAll(List.filled(cardCount, false));

    _showStartDialog();
  }

  void _showStartDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          '타로 결과',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '카드를 하나씩 공개하시겠습니까?\n\n자동으로 순차 공개하거나,\n직접 터치해서 공개할 수 있습니다.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startManualReveal();
            },
            child: Text(
              '직접 공개',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startAutoReveal();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade600,
            ),
            child: Text(
              '자동 공개',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _startAutoReveal() {
    _revealNextCard();
  }

  void _startManualReveal() {
    // 수동 모드에서는 사용자가 터치할 때까지 대기
  }

  void _revealNextCard() {
    if (_currentRevealIndex >= _revealedCards.length) {
      _onAllCardsRevealed();
      return;
    }

    setState(() {
      _revealedCards[_currentRevealIndex] = true;
    });

    _revealController.forward().then((_) {
      _revealController.reset();
      _currentRevealIndex++;

      if (_currentRevealIndex < _revealedCards.length) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) _revealNextCard();
        });
      } else {
        _onAllCardsRevealed();
      }
    });
  }

  void _onAllCardsRevealed() {
    setState(() {
      _allCardsRevealed = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _interpretationVisible = true;
        });
        _fadeController.forward();
      }
    });
  }

  void _onCardTapped(int index) {
    if (_revealedCards[index] || _allCardsRevealed) return;

    setState(() {
      _revealedCards[index] = true;
    });

    _revealController.forward().then((_) {
      _revealController.reset();

      if (_revealedCards.every((revealed) => revealed)) {
        _onAllCardsRevealed();
      }
    });
  }

  @override
  void dispose() {
    _revealController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TaroBackground(
        child: SafeArea(
          child: Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(taroConsultationNotifierProvider);

              if (state.selectedSpreadType == null ||
                  state.selectedCards.isEmpty) {
                return _buildErrorState();
              }

              return Column(
                children: [
                  _buildHeader(state),
                  Expanded(
                    flex: 3,
                    child: _buildCardSpread(state),
                  ),
                  if (_interpretationVisible)
                    Expanded(
                      flex: 2,
                      child: _buildInterpretation(state),
                    ),
                  _buildBottomActions(state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: Colors.red.shade300,
          ),
          Gap(16.h),
          Text(
            '결과를 표시할 수 없습니다',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
            ),
          ),
          Gap(8.h),
          Text(
            '카드가 선택되지 않았습니다',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Gap(24.h),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('돌아가기'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(state) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '타로 결과',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      state.selectedSpreadType!.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.amber.shade300,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _allCardsRevealed ? _shareResult : null,
                icon: Icon(
                  Icons.share,
                  color: _allCardsRevealed ? Colors.white : Colors.grey,
                  size: 24.sp,
                ),
              ),
            ],
          ),

          Gap(16.h),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '주제: ${state.theme}',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCardSpread(TaroConsultationState state) {
    // 1. state.selectedCards(List<String?>)를 List<TaroCard>로 안전하게 변환합니다.
    final List<TaroCard> cards = state.selectedCards
        .where((id) => id != null) // null이 아닌 ID만 필터링
        .map((id) => TaroCards.findById(id!)) // String ID로 TaroCard 객체를 찾음
        .where((card) => card != null) // 혹시 못 찾은 경우(null)를 다시 필터링
        .cast<TaroCard>() // 타입을 TaroCard로 명확히 함
        .toList();

    return Container(
      padding: EdgeInsets.all(12.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 2. 변환된 `cards` 리스트와 다른 정보들을 _buildSpreadLayout으로 전달합니다.
          return _buildSpreadLayout(cards, state.selectedSpreadType!, constraints, state);
        },
      ),
    );
  }

  Widget _buildSpreadLayout(
      List<TaroCard> cards, // ★★★ 타입을 List<TaroCard?>에서 List<TaroCard>로 변경 ★★★
      TaroSpreadType spreadType,
      BoxConstraints constraints,
      TaroConsultationState state,
      ) {
    switch (spreadType.cardCount) {
      case 3:
        return _buildThreeLineLayout(cards, constraints, state);
      case 10:
        return _buildCelticLayout(cards, constraints, state);
      case 7:
        return _buildHorseshoeLayout(cards, constraints, state);
      case 1:
      default:
        return _buildSingleLayout(cards, constraints);
    }
  }

  Widget _buildSingleLayout(List<TaroCard> cards, BoxConstraints constraints) { // ★★★ 타입 변경 ★★★
    if (cards.isEmpty) return Container(); // 비어있는지 체크

    return Center(
      child: GestureDetector(
        onTap: () => _onCardTapped(0),
        child: AnimatedTaroCard(
          card: cards[0], // 이제 null이 아님
          isRevealed: _revealedCards.isNotEmpty ? _revealedCards[0] : false,
          animation: _revealAnimation,
          width: constraints.maxWidth * 0.4,
          height: constraints.maxHeight * 0.7,
        ),
      ),
    );
  }

  Widget _buildThreeLineLayout(List<TaroCard> cards, BoxConstraints constraints, TaroConsultationState state) { // ★★★ 타입 변경 ★★★
    final cardWidth = constraints.maxWidth * 0.25;
    final cardHeight = constraints.maxHeight * 0.8;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 0; i < cards.length; i++) // ★★★ 3. for 루프 조건 단순화 ★★★
          GestureDetector(
            onTap: () => _onCardTapped(i),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedTaroCard(
                  card: cards[i],
                  isRevealed: i < _revealedCards.length ? _revealedCards[i] : false,
                  animation: _revealAnimation,
                  width: cardWidth,
                  height: cardHeight,
                ),
                Gap(8.h),
                Text(
                  _getPositionName(i, state.selectedSpreadType!.cardCount),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCelticLayout(List<TaroCard?> cards, BoxConstraints constraints, TaroConsultationState state) {
    final cardWidth = constraints.maxWidth * 0.18;
    final cardHeight = constraints.maxHeight * 0.3;

    return Stack(
      children: [
        // 중앙 십자가 배치
        Positioned(
          left: constraints.maxWidth * 0.35,
          top: constraints.maxHeight * 0.1,
          child: _buildCelticCard(cards, 0, cardWidth, cardHeight, '현재 상황'),
        ),
        Positioned(
          left: constraints.maxWidth * 0.35,
          top: constraints.maxHeight * 0.45,
          child: _buildCelticCard(cards, 1, cardWidth, cardHeight, '도전'),
        ),
        Positioned(
          left: constraints.maxWidth * 0.15,
          top: constraints.maxHeight * 0.27,
          child: _buildCelticCard(cards, 2, cardWidth, cardHeight, '과거'),
        ),
        Positioned(
          right: constraints.maxWidth * 0.15,
          top: constraints.maxHeight * 0.27,
          child: _buildCelticCard(cards, 3, cardWidth, cardHeight, '미래'),
        ),
        // 오른쪽 세로 배치
        Positioned(
          right: constraints.maxWidth * 0.05,
          top: constraints.maxHeight * 0.05,
          child: _buildCelticCard(cards, 4, cardWidth, cardHeight, '가능성'),
        ),
        Positioned(
          right: constraints.maxWidth * 0.05,
          top: constraints.maxHeight * 0.25,
          child: _buildCelticCard(cards, 5, cardWidth, cardHeight, '환경'),
        ),
        Positioned(
          right: constraints.maxWidth * 0.05,
          top: constraints.maxHeight * 0.45,
          child: _buildCelticCard(cards, 6, cardWidth, cardHeight, '조언'),
        ),
        Positioned(
          right: constraints.maxWidth * 0.05,
          bottom: constraints.maxHeight * 0.05,
          child: _buildCelticCard(cards, 7, cardWidth, cardHeight, '결과'),
        ),
      ],
    );
  }

  Widget _buildCelticCard(
      List<TaroCard?> cards,
      int index,
      double width,
      double height,
      String position,
      ) {
    if (index >= cards.length || cards[index] == null) {
      return Container(width: width, height: height);
    }

    return GestureDetector(
      onTap: () => _onCardTapped(index),
      child: Column(
        children: [
          AnimatedTaroCard(
            card: cards[index]!,
            isRevealed: index < _revealedCards.length ? _revealedCards[index] : false,
            animation: _revealAnimation,
            width: width,
            height: height,
          ),
          Gap(4.h),
          Text(
            position,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHorseshoeLayout(List<TaroCard?> cards, BoxConstraints constraints, TaroConsultationState state) {
    final cardWidth = constraints.maxWidth * 0.2;
    final cardHeight = constraints.maxHeight * 0.6;
    final centerX = constraints.maxWidth / 2;
    final centerY = constraints.maxHeight / 2;
    final radius = constraints.maxWidth * 0.3;

    return Stack(
      children: [
        for (int i = 0; i < math.min(7, cards.length);)
          if (cards[i] != null)
            Positioned(
              left: centerX + radius * math.cos(-math.pi + i * math.pi / 6) - cardWidth / 2,
              top: centerY + radius * math.sin(-math.pi + i * math.pi / 6) - cardHeight / 2,
              child: GestureDetector(
                onTap: () => _onCardTapped(i),
                child: Column(
                  children: [
                    AnimatedTaroCard(
                      card: cards[i]!,
                      isRevealed: i < _revealedCards.length ? _revealedCards[i] : false,
                      animation: _revealAnimation,
                      width: cardWidth,
                      height: cardHeight,
                    ),
                    Gap(4.h),
                    Text(
                      _getPositionName(i, state.selectedSpreadType!.cardCount),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  String _getPositionName(int index, int cardCount) {
    switch (cardCount) {
      case 3: // Three Line
        return ['과거', '현재', '미래'][index];
      case 7: // Horseshoe
        return ['과거', '현재', '숨겨진', '조언', '외부', '내면', '결과'][index];
      case 10: // Celtic Cross
        return ['현재', '도전', '과거', '미래', '가능성', '환경', '조언', '결과'][index];
      default:
        return '카드 ${index + 1}';
    }
  }


  Widget _buildInterpretation(TaroConsultationState state) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: EdgeInsets.all(20.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.amber.shade300.withOpacity(0.3), width: 1),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.amber.shade300, size: 20.sp),
                  Gap(8.w),
                  Text('AI 타로 해석', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              Gap(16.h),
              Text('전체적인 해석', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.amber.shade300)),
              Gap(8.h),
              Text(
                state.interpretation ?? '해석을 생성하고 있습니다...',
                style: TextStyle(fontSize: 13.sp, color: Colors.white.withOpacity(0.9), height: 1.5),
              ),
              Gap(16.h),
              Text('각 카드의 의미', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.amber.shade300)),
              Gap(8.h),
              // ★★★★★ 이 부분의 로직을 String ID에 맞게 수정합니다 ★★★★★
              ...state.selectedCards.asMap().entries.where((entry) => entry.value != null).map((entry) {
                final index = entry.key;
                final cardId = entry.value!; // cardId는 이제 String입니다.
                final card = TaroCards.findById(cardId); // String ID로 카드를 찾습니다.

                // 혹시 모를 에러 방지
                if (card == null) return const SizedBox.shrink();

                final position = _getPositionName(index, state.selectedSpreadType!.cardCount);
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$position: ${card.name}',
                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.amber.shade200),
                      ),
                      Gap(4.h),
                      Text(
                        card.description,
                        style: TextStyle(fontSize: 11.sp, color: Colors.white.withOpacity(0.8), height: 1.4),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(state) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).popUntil(
                      (route) => route.settings.name == '/taro-setup',
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: Text(
                '다시 하기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),

          Gap(16.w),

          Expanded(
            child: ElevatedButton(
              onPressed: _allCardsRevealed ? _saveResult : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _allCardsRevealed
                    ? Colors.amber.shade600
                    : Colors.grey.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: Text(
                '결과 저장',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareResult() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('공유 기능은 추후 구현 예정입니다'),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }

  void _saveResult() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('결과가 저장되었습니다'),
        backgroundColor: Colors.green.shade600,
      ),
    );
  }
}

/// 애니메이션이 적용된 타로 카드 위젯
class AnimatedTaroCard extends StatelessWidget {
  const AnimatedTaroCard({
    super.key,
    required this.card,
    required this.isRevealed,
    required this.animation,
    required this.width,
    required this.height,
  });

  final TaroCard card;
  final bool isRevealed;
  final Animation<double> animation;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final flipValue = isRevealed ? animation.value : 0.0;
        final isShowingFront = flipValue > 0.5;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(flipValue * math.pi),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: isShowingFront
                  ? _buildCardFront()
                  : _buildCardBack(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardFront() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(math.pi),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.indigo.shade800,
              ),
              child: Text(
                card.name,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Expanded(
              child: Container(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isMajorArcana(card)
                          ? _getMajorArcanaNumber(card)
                          : _getMinorArcanaSuit(card),
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade800,
                      ),
                    ),

                    Gap(8.h),

                    Icon(
                      _getCardIcon(card),
                      size: width * 0.3,
                      color: Colors.indigo.shade600,
                    ),

                    Gap(8.h),

                    Text(
                      _getCardKeywords(card),
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo.shade800,
            Colors.purple.shade900,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: CardBackPatternPainter(),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: width * 0.25,
                  color: Colors.amber.shade300.withOpacity(0.8),
                ),
                Gap(8.h),
                Text(
                  'TAROT',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.8),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TaroCard 모델에 맞는 헬퍼 메서드들
  bool _isMajorArcana(TaroCard card) {
    return card.type == TaroCardType.majorArcana;
  }

  String _getMajorArcanaNumber(TaroCard card) {
    // 카드 ID에서 번호 추출 (예: 'major_00' -> '0')
    if (card.id.startsWith('major_')) {
      final numberStr = card.id.substring(6);
      final number = int.tryParse(numberStr) ?? 0;
      return number.toString();
    }
    return '?';
  }

  String _getMinorArcanaSuit(TaroCard card) {
    switch (card.type) {
      case TaroCardType.cups:
        return '♥';
      case TaroCardType.pentacles:
        return '♦';
      case TaroCardType.swords:
        return '♠';
      case TaroCardType.wands:
        return '♣';
      default:
        return '•';
    }
  }

  String _getCardKeywords(TaroCard card) {
    // 카드 타입에 따른 기본 키워드 반환
    switch (card.type) {
      case TaroCardType.majorArcana:
        return '운명 • 변화 • 성장';
      case TaroCardType.cups:
        return '감정 • 사랑 • 관계';
      case TaroCardType.pentacles:
        return '물질 • 돈 • 직업';
      case TaroCardType.swords:
        return '생각 • 갈등 • 결정';
      case TaroCardType.wands:
        return '의지 • 창조 • 열정';
    }
  }

  IconData _getCardIcon(TaroCard card) {
    if (_isMajorArcana(card)) {
      final number = int.tryParse(_getMajorArcanaNumber(card)) ?? 0;
      switch (number) {
        case 0: return Icons.brightness_1; // The Fool
        case 1: return Icons.auto_fix_high; // The Magician
        case 2: return Icons.nightlight; // The High Priestess
        case 3: return Icons.favorite; // The Empress
        case 4: return Icons.account_balance; // The Emperor
        case 5: return Icons.church; // The Hierophant
        case 6: return Icons.favorite_border; // The Lovers
        case 7: return Icons.directions_car; // The Chariot
        case 8: return Icons.pets; // Strength
        case 9: return Icons.lightbulb; // The Hermit
        case 10: return Icons.sync; // Wheel of Fortune
        case 11: return Icons.balance; // Justice
        case 12: return Icons.person_outline; // The Hanged Man
        case 13: return Icons.dangerous; // Death (skull 대신 dangerous 사용)
        case 14: return Icons.local_bar; // Temperance
        case 15: return Icons.warning; // The Devil
        case 16: return Icons.flash_on; // The Tower
        case 17: return Icons.star; // The Star
        case 18: return Icons.brightness_3; // The Moon
        case 19: return Icons.wb_sunny; // The Sun
        case 20: return Icons.music_note; // Judgement
        case 21: return Icons.public; // The World
        default: return Icons.auto_awesome;
      }
    } else {
      // 마이너 아르카나 수트별 아이콘
      switch (card.type) {
        case TaroCardType.cups: return Icons.local_drink;
        case TaroCardType.wands: return Icons.whatshot;
        case TaroCardType.swords: return Icons.flash_on;
        case TaroCardType.pentacles: return Icons.monetization_on;
        default: return Icons.circle;
      }
    }
  }
}

/// 카드 뒷면 패턴을 그리는 CustomPainter
class CardBackPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // 동심원 패턴
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(
        Offset(centerX, centerY),
        (size.width / 2) * (i / 5),
        paint,
      );
    }

    // 십자 패턴
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      paint,
    );

    // 대각선 패턴
    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}