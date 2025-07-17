import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mind_canvas/features/taro/presentation/pages/taro_result_page.dart';
import '../../../../core/theme/app_colors.dart'; // AppColors 경로
import '../../domain/models/taro_card.dart';
import '../providers/taro_consultation_provider.dart';
import '../providers/taro_consultation_state.dart';
import '../widgets/fan_card_deck.dart';
import '../widgets/spread_layout.dart';
import '../widgets/taro_background.dart';

class TaroCardSelectionPage extends ConsumerWidget {
  const TaroCardSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taroConsultationNotifierProvider);
    final notifier = ref.read(taroConsultationNotifierProvider.notifier);

    // 예를 들어 30개의 카드를 보여주고 싶다면:
    final List<TaroCard> displayCards = List.generate(
        35,
            (i) => TaroCard(id: "", name: 'dummy', imagePath: '', type: TaroCardType.majorArcana, nameEn: '', description: '')
    );

    // 선택된 카드 개수만큼 UI용 덱에서도 카드를 제거하여 시각적으로 동기화
    final int selectedCount = state.selectedCards.where((c) => c != null).length;
    if (displayCards.length > selectedCount) {
      displayCards.removeRange(0, selectedCount);
    }


    final availableCards = TaroCards.getShuffledDeck()
      ..removeWhere((card) => state.selectedCards.contains(card.id));

    ref.listen<TaroConsultationState>(
      taroConsultationNotifierProvider,
          (previous, next) {
        if (next.status == TaroStatus.error && next.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
          notifier.clearError();
        }
        if (next.status == TaroStatus.completed) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TaroResultPage()));
        }
      },
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: TaroBackground(
        child: SafeArea(
          child: Stack(
            children: [
              // ★★★★★ 1. 카드 덱을 맨 아래에 배치 ★★★★★
              Positioned(
                top: 10.h,
                left: 0,
                right: 0,
                child: FanCardDeck(availableCards: displayCards),
              ),

              // ★★★★★ 2. 제목 부근 그라데이션 오버레이 ★★★★★
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 100.h, // 그라데이션이 적용될 높이 (필요에 따라 조정)
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors:  [
                        const Color(0xFF1a1a2e),
                        const Color(0xFF1a1a2e).withOpacity(0.7),  // 진한 네이비
                        const Color(0xFF16213e).withOpacity(0.5),  // 미드나이트 블루
                        const Color(0xFF16213e).withOpacity(0.2),  // 딥 블루
                        Colors.transparent,
                    ],
                      stops: const [0.0, 0.3, 0.5, 0.7, 1.0], // 그라데이션 비율 조정
                    ),
                  ),
                ),
              ),

              // ★★★★★ 3. UI 요소들을 그라데이션 '위'에 배치 ★★★★★
              Column(
                children: [
                  // 상단 헤더
                  _buildHeader(context, state),

                  // 안내 문구
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: Text(
                      '카드를 드래그하여 배치하세요',
                      style: TextStyle(color: TaroColors.textSecondary, fontSize: 14.sp),
                    ),
                  ),

                  // 스프레드 영역
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: _buildSpreadArea(state, notifier),
                      ),
                    ),
                  ),

                  // 하단 버튼
                  _buildBottomActions(state, notifier, context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ★★★★★ Sliver가 아닌 일반 위젯을 반환하는 헤더 ★★★★★
  Widget _buildHeader(BuildContext context, TaroConsultationState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back_ios, color: TaroColors.textMystic),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('카드 선택', style: TextStyle(color: TaroColors.textMystic, fontSize: 20.sp)),
                    Text(state.selectedSpreadType?.name ?? '', style: TextStyle(color: TaroColors.textSecondary)),
                  ],
                ),
              ),
              // 진행률 표시 위젯 (필요시 _buildProgressIndicator 추가)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: TaroColors.backgroundCard.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${state.selectedCards.where((c) => c != null).length}/${state.selectedSpreadType?.cardCount ?? 0}',
                  style: TextStyle(color: TaroColors.textMystic, fontWeight: FontWeight.bold),
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
            child: Text('주제: ${state.theme}', style: TextStyle(color: TaroColors.textSecondary)),
          ),
        ],
      ),
    );
  }


  Widget _buildSpreadArea(TaroConsultationState state, TaroConsultationNotifier notifier) {
    final spread = state.selectedSpreadType;
    if (spread == null) return const SizedBox.shrink();

    // 이 부분은 state.selectedCards (int? 리스트)를
    // TaroCard? 객체 리스트로 변환하는 역할을 합니다.
    final List<TaroCard?> selectedCardObjects = state.selectedCards.map((cardId) {
      return cardId != null ? TaroCards.findById(cardId) : null;
    }).toList();

    return SpreadLayout(
      spreadType: spread,
      selectedCards: selectedCardObjects,

      // ★★★★★ 바로 이 부분을 수정합니다! ★★★★★
      onCardPlaced: (draggedCard, position) {
        // draggedCard는 UI용 '더미' 카드이므로 사용하지 않습니다.

        // 1. 실제 전체 덱(78장)을 가져옵니다.
        final fullDeck = TaroCards.fullDeck;

        // 2. 이미 선택된 카드들의 ID 목록을 가져옵니다.
        final Set<String?> alreadySelectedIds = state.selectedCards.toSet();

        // 3. 아직 선택되지 않은 카드들만 필터링합니다.
        final List<TaroCard> availableRealCards = fullDeck
            .where((card) => !alreadySelectedIds.contains(card.id))
            .toList();

        // 4. 선택 가능한 실제 카드들을 다시 섞어서 랜덤성을 부여합니다.
        availableRealCards.shuffle();

        // 5. 만약 선택할 수 있는 실제 카드가 남아있다면,
        if (availableRealCards.isNotEmpty) {
          // 6. 그중 첫 번째 카드를 '이번에 선택된 진짜 카드'로 결정합니다.
          final selectedCard = availableRealCards.first;

          // 7. 이 '진짜' 카드의 ID를 Notifier에게 전달합니다.
          notifier.selectCard(selectedCard.id, position);
        }
      },
      onCardRemoved: (position) {
        notifier.removeCard(position);
      },
    );
  }

  /// ★★★★★ Sliver가 아닌 일반 위젯을 반환하는 하단 버튼 ★★★★★
  Widget _buildBottomActions(TaroConsultationState state, TaroConsultationNotifier notifier, BuildContext context) {
    final canRequestResult = state.canRequestResult;
    final isLoading = state.status == TaroStatus.loading;

    return Padding(
      padding: EdgeInsets.all(20.w).copyWith(top: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 필요한 만큼만 공간 차지
        children: [
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: OutlinedButton.icon(
              onPressed: () {
                // notifier에 shuffleDeck() 같은 메서드를 만들어 호출하는 것을 권장합니다.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('카드를 다시 섞었습니다.')),
                );
              },
              icon: Icon(Icons.shuffle, color: TaroColors.textMystic),
              label: Text('카드 다시 섞기', style: TextStyle(color: TaroColors.textMystic)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: TaroColors.cardBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ),
          Gap(12.h),
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: canRequestResult && !isLoading ? () => notifier.requestResult() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: TaroColors.accentGold,
                disabledBackgroundColor: TaroColors.cardDisabled,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                canRequestResult ? '타로 결과 보기' : '모든 카드를 선택해주세요',
                style: TextStyle(fontSize: 18.sp, color: TaroColors.backgroundDark, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

