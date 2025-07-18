import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mind_canvas/features/taro/presentation/pages/taro_result_page.dart';
import 'package:mind_canvas/features/taro/presentation/pages/taro_consultation_setup_page.dart';
import '../../../../core/theme/app_colors.dart'; // AppColors 경로
import '../../domain/models/taro_card.dart';
import '../providers/taro_consultation_provider.dart';
import '../providers/taro_consultation_state.dart';
import '../widgets/fan_card_deck.dart';
import '../widgets/spread_layout.dart';
import '../widgets/taro_background.dart';
import 'dart:async';

class TaroCardSelectionPage extends ConsumerStatefulWidget {
  const TaroCardSelectionPage({super.key});

  @override
  ConsumerState<TaroCardSelectionPage> createState() =>
      _TaroCardSelectionPageState();
}
class _TaroCardSelectionPageState extends ConsumerState<TaroCardSelectionPage> {
  // 스크롤 컨트롤러는 UI를 위한 것이므로 유지합니다.
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // 스크롤 컨트롤러만 정리해주면 됩니다.
    _scrollController.dispose();
    super.dispose();
  }

  // 뒤로가기 처리가 훨씬 간단해집니다.
  void _handleBackNavigation() {
    // Provider 상태를 초기화하거나 메모리를 정리할 필요가 없습니다.
    // .autoDispose가 페이지를 벗어날 때 알아서 처리해줍니다.
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const TaroConsultationSetupPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // build 메소드 로직은 이전과 거의 동일합니다.
    // (깜빡임 문제 해결을 위해 displayCards.removeRange는 이미 제거했습니다.)
    final state = ref.watch(taroConsultationNotifierProvider);
    final notifier = ref.read(taroConsultationNotifierProvider.notifier);

    final List<TaroCard> displayCards = List.generate(
      35,
          (i) => TaroCard(
        id: "",
        name: 'dummy',
        imagePath: '',
        type: TaroCardType.majorArcana,
        nameEn: '',
        description: '',
      ),
    );

    // availableCards 로직은 실제 카드 선택에 필요하므로 유지합니다.
    final availableCards = TaroCards.getShuffledDeck()
      ..removeWhere((card) => state.selectedCards.contains(card.id));

    ref.listen<TaroConsultationState>(taroConsultationNotifierProvider, (
        previous,
        next,
        ) {
      if (next.status == TaroStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        notifier.clearError();
      }
      if (next.status == TaroStatus.completed) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const TaroResultPage()));
      }
    });

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          _handleBackNavigation();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: TaroBackground(
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 10.h,
                  left: 0,
                  right: 0,
                  child: FanCardDeck(availableCards: displayCards),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 100.h,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF1a1a2e),
                          const Color(0xFF1a1a2e).withOpacity(0.7),
                          const Color(0xFF16213e).withOpacity(0.5),
                          const Color(0xFF16213e).withOpacity(0.2),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    _buildHeader(context, state),
                    Padding(
                      padding: EdgeInsets.only(top: 140.h),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: _buildSpreadArea(state, notifier),
                        ),
                      ),
                    ),
                    _buildBottomActions(state, notifier, context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // _handleCardPlacement, _buildHeader, _buildSpreadArea, _buildBottomActions 메소드들은
  // 수정할 필요 없이 그대로 두시면 됩니다.
  void _handleCardPlacement(
      TaroCard draggedCard,
      int position,
      TaroConsultationState state,
      TaroConsultationNotifier notifier,
      ) {
    final fullDeck = TaroCards.fullDeck;
    final Set<String?> alreadySelectedIds = state.selectedCards.toSet();
    final List<TaroCard> availableRealCards = fullDeck
        .where((card) => !alreadySelectedIds.contains(card.id))
        .toList();
    availableRealCards.shuffle();
    if (availableRealCards.isNotEmpty) {
      final selectedCard = availableRealCards.first;
      notifier.selectCard(selectedCard.id, position);
    }
  }

  Widget _buildHeader(BuildContext context, TaroConsultationState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _handleBackNavigation,
                icon: Icon(Icons.arrow_back_ios, color: TaroColors.textMystic),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '카드 선택',
                      style: TextStyle(
                        color: TaroColors.textMystic,
                        fontSize: 20.sp,
                      ),
                    ),
                    Text(
                      state.selectedSpreadType?.name ?? '',
                      style: TextStyle(color: TaroColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: TaroColors.backgroundCard.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${state.selectedCards.where((c) => c != null).length}/${state.selectedSpreadType?.cardCount ?? 0}',
                  style: TextStyle(
                    color: TaroColors.textMystic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Gap(12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: TaroColors.backgroundCard.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '주제: ${state.theme}',
              style: TextStyle(color: TaroColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpreadArea(
      TaroConsultationState state,
      TaroConsultationNotifier notifier,
      ) {
    final spread = state.selectedSpreadType;
    if (spread == null) return const SizedBox.shrink();

    final List<TaroCard?> selectedCardObjects = state.selectedCards.map((
        cardId,
        ) {
      return cardId != null ? TaroCards.findById(cardId) : null;
    }).toList();

    return SpreadLayout(
      spreadType: spread,
      selectedCards: selectedCardObjects,
      onCardPlaced: (draggedCard, position) {
        _handleCardPlacement(draggedCard, position, state, notifier);
      },
      onCardRemoved: (position) {
        notifier.removeCard(position);
      },
    );
  }

  Widget _buildBottomActions(
      TaroConsultationState state,
      TaroConsultationNotifier notifier,
      BuildContext context,
      ) {
    final canRequestResult = state.canRequestResult;
    final isLoading = state.status == TaroStatus.loading;

    return Padding(
      padding: EdgeInsets.all(20.w).copyWith(top: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('카드를 다시 섞었습니다.')));
              },
              icon: Icon(Icons.shuffle, color: TaroColors.textMystic),
              label: Text(
                '카드 다시 섞기',
                style: TextStyle(color: TaroColors.textMystic),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: TaroColors.cardBorder),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
          Gap(12.h),
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: canRequestResult && !isLoading
                  ? () => notifier.requestResult()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: TaroColors.accentGold,
                disabledBackgroundColor: TaroColors.cardDisabled,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                canRequestResult ? '타로 결과 보기' : '모든 카드를 선택해주세요',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: TaroColors.backgroundDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}