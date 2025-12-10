import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mind_canvas/features/taro/presentation/pages/taro_result_page.dart';
import 'package:mind_canvas/features/taro/presentation/pages/taro_consultation_setup_page.dart';
import '../../../../core/theme/app_colors.dart'; // AppColors 경로
import '../../data/dto/request/submit_taro_request.dart';
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
  final Random _random = Random();

  @override
  void dispose() {
    // 스크롤 컨트롤러만 정리해주면 됩니다.
    _scrollController.dispose();
    super.dispose();
  }

  // 뒤로가기 처리가 훨씬 간단해집니다.
  void _handleBackNavigation() {
    if (mounted) {
      // 🚀 핵심: 뒤로 갈 때 상태를 싹 비웁니다.
      // 이러면 다시 Setup 페이지로 갔을 때 입력창이 깨끗해집니다.
      ref.read(taroConsultationNotifierProvider.notifier).reset();

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

    // ✅ 더미 카드 (드래그용)
    final List<TaroCard> displayCards = List.generate(
      35,
      (i) => TaroCard(
        id: "dummy_$i",
        // ID 고유하게
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
      }

      // 결과 완료 시 이동
      if (next.status == TaroStatus.completed) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const TaroResultPage()));
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        // API 변경 대응
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
                    Padding(padding: EdgeInsets.only(top: 140.h)),
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
    // 1. 이미 선택된 카드 ID들 추출
    final selectedIds = state.selectedCards.map((e) => e.cardId).toSet();

    // 2. 전체 덱에서 선택되지 않은 카드들만 추림
    final fullDeck = TaroCards.fullDeck;
    final availableRealCards = fullDeck
        .where((card) => !selectedIds.contains(card.id))
        .toList();

    // 3. 랜덤으로 하나 뽑아서 해당 위치에 배치
    if (availableRealCards.isNotEmpty) {
      availableRealCards.shuffle(_random); // 셔플할 때도 넣으면 더 좋음
      final selectedCard = availableRealCards.first;

      // 2️⃣ 아까 만든 객체 재사용 -> 이러면 아주 빠르게 실행돼도 완벽한 랜덤 보장
      final bool isRandomReversed = _random.nextBool();

      // ✅ Notifier 호출 (객체 생성해서 전달)
      notifier.toggleCardSelection(
        TaroCardInput(
          cardId: selectedCard.id,
          positionIndex: position,
          isReversed: isRandomReversed, // 일단 정방향 (추후 랜덤 or 사용자 선택)
        ),
      );
    }
  }

  Widget _buildHeader(BuildContext context, TaroConsultationState state) {
    final totalCount = state.selectedSpreadType?.cardCount ?? 0;
    final currentCount = state.selectedCards.length; // ✅ length 바로 사용 가능

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
                  '$currentCount/$totalCount', // ✅ 수정됨
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

    // ✅ SpreadLayout은 List<TaroCard?> (고정 길이, 빈 곳은 null)을 원함
    // 하지만 state.selectedCards는 List<TaroCardInput> (선택된 것만 있음)
    // 따라서 변환 작업이 필요함

    final List<TaroCard?> displayList = List.filled(spread.cardCount, null);

    for (var input in state.selectedCards) {
      if (input.positionIndex < spread.cardCount) {
        displayList[input.positionIndex] = TaroCards.findById(input.cardId);
      }
    }

    return SpreadLayout(
      spreadType: spread,
      selectedCards: displayList, // ✅ 변환된 리스트 전달
      onCardPlaced: (draggedCard, position) {
        _handleCardPlacement(draggedCard, position, state, notifier);
      },
      onCardRemoved: (position) {
        // ✅ 카드 제거 로직 (toggleCardSelection 활용 또는 별도 메서드)
        // 여기서는 toggleCardSelection이 '교체/추가' 로직만 있다면 삭제용 메서드가 필요할 수 있음
        // 만약 Notifier에 removeCard가 없다면 toggleCardSelection 로직을 수정하거나
        // removeCard를 Notifier에 추가해야 함.
        // -> 아까 Notifier 코드에 removeCard가 없었으므로 추가 권장
        notifier.removeCard(position);
      },
    );
  }

  Widget _buildBottomActions(
    TaroConsultationState state,
    TaroConsultationNotifier notifier,
    BuildContext context,
  ) {
    // ✅ canRequestResult -> canAnalyze로 변경 (Notifier getter 이름 확인)
    final canRequestResult = state.canAnalyze;
    final isLoading = state.status == TaroStatus.analyzing; // ✅ analyzing 확인

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
                // TODO: 셔플 로직 구현 (Notifier에 clearCards 같은거 만들어서 호출)
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
              // ✅ submitAnalysis 호출
              onPressed: canRequestResult && !isLoading
                  ? () => notifier.submitAnalysis()
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

//
// Widget _buildBottomActions(TaroConsultationState state,
//     TaroConsultationNotifier notifier,
//     BuildContext context,) {
//   final canRequestResult = state.canRequestResult;
//   final isLoading = state.status == TaroStatus.loading;
//
//   return Padding(
//     padding: EdgeInsets.all(20.w).copyWith(top: 10.h),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         SizedBox(
//           width: double.infinity,
//           height: 48.h,
//           child: OutlinedButton.icon(
//             onPressed: () {
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(const SnackBar(content: Text('카드를 다시 섞었습니다.')));
//             },
//             icon: Icon(Icons.shuffle, color: TaroColors.textMystic),
//             label: Text(
//               '카드 다시 섞기',
//               style: TextStyle(color: TaroColors.textMystic),
//             ),
//             style: OutlinedButton.styleFrom(
//               side: BorderSide(color: TaroColors.cardBorder),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//             ),
//           ),
//         ),
//         Gap(12.h),
//         SizedBox(
//           width: double.infinity,
//           height: 56.h,
//           child: ElevatedButton(
//             onPressed: canRequestResult && !isLoading
//                 ? () => notifier.requestResult()
//                 : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: TaroColors.accentGold,
//               disabledBackgroundColor: TaroColors.cardDisabled,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16.r),
//               ),
//             ),
//             child: isLoading
//                 ? const CircularProgressIndicator(color: Colors.white)
//                 : Text(
//               canRequestResult ? '타로 결과 보기' : '모든 카드를 선택해주세요',
//               style: TextStyle(
//                 fontSize: 18.sp,
//                 color: TaroColors.backgroundDark,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
