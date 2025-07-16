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
      body: TaroBackground(
        child: SafeArea(
          // ★★★★★ 1. Column을 Stack으로 변경 ★★★★★
          child: Stack(
            children: [
              // ★★★★★ 2. 카드 덱을 맨 아래에 배치 (더 위로 이동) ★★★★★
              // Positioned를 사용하여 위치를 정밀하게 조정합니다.
              Positioned(
                top: 10.h, // 상단으로부터의 거리 (수치를 줄이면 더 위로 올라갑니다)
                left: 0,
                right: 0,
                child: FanCardDeck(availableCards: displayCards),
              ),

              // ★★★★★ 3. 나머지 UI 요소들을 카드 덱 '위'에 배치 ★★★★★
              // Stack은 나중에 추가된 자식이 더 위에 그려집니다.
              Column(
                children: [
                  // 상단 헤더
                  _buildHeader(context, state),

                  // 안내 문구
                  Padding(
                    padding: EdgeInsets.only(top: 180.h), // 카드 덱과의 간격 조절
                    child: Text(
                      '카드를 드래그하여 배치하세요',
                      style: TextStyle(color: TaroColors.textSecondary, fontSize: 14.sp),
                    ),
                  ),

                  // 스프레드 영역 (남는 공간을 모두 차지)
                  Expanded(
                    // SingleChildScrollView를 추가하여 이 영역만 스크롤 가능하게 만듭니다.
                    child: SingleChildScrollView(
                      // 자식 위젯이 스크롤 영역의 중앙에 오도록 정렬합니다.
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

    final selectedCards = state.selectedCards.map((id) => id != null ? TaroCards.findById(id) : null).toList();

    return SpreadLayout(
      spreadType: spread,
      selectedCards: selectedCards,
      onCardPlaced: (card, position) => notifier.selectCard(card.id, position),
      onCardRemoved: (position) => notifier.removeCard(position),
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

