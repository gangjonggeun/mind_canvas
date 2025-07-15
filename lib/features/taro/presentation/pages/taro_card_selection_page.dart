import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart'; // AppColors 경로에 맞게 수정해주세요.
import '../../domain/models/taro_card.dart';
import '../providers/taro_consultation_provider.dart';
import '../providers/taro_consultation_state.dart';
// DraggableTaroCard, SpreadPositionCard 위젯이 있는 파일을 import 해주세요.
import '../widgets/draggable_taro_card.dart';
import '../widgets/fan_card_deck.dart';
import '../widgets/spread_layout.dart';
import '../widgets/spread_type_card.dart';
import 'taro_result_page.dart';

class TaroCardSelectionPage extends ConsumerWidget {
  const TaroCardSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taroConsultationNotifierProvider);
    final notifier = ref.read(taroConsultationNotifierProvider.notifier);

    // 카드 뒷면 이미지 경로
    const cardBackAsset = 'assets/illustrations/taro/card_back_1_high.webp';

    // 사용 가능한 카드 목록 (선택되지 않은 카드)
    final availableCards = TaroCards.getShuffledDeck(majorArcanaOnly: true)
      ..removeWhere((card) => state.selectedCards.contains(card.id));

    // 에러 및 완료 상태 리스너
    ref.listen<TaroConsultationState>(
      taroConsultationNotifierProvider,
          (previous, next) {
        if (next.status == TaroStatus.error && next.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.errorMessage!)),
          );
          notifier.clearError();
        }
        if (next.status == TaroStatus.completed) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const TaroResultPage()),
          );
        }
      },
    );

    return Scaffold(
      // 배경 이미지 또는 색상
      backgroundColor: const Color(0xFF0F0F2E),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. 상단 고정 헤더
            _buildHeaderSliver(context, state),

            // 2. 상단 안내 텍스트
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Text(
                  '좌우로 드래그하여 카드를 선택하세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TaroColors.textSecondary,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),

            // 3. 드래그 가능한 수평 카드 덱
            _buildCardDeckSliver(availableCards),

            // 4. 드롭 가능한 스프레드 영역
            _buildSpreadAreaSliver(state, notifier),

            // 5. 하단 액션 버튼
            _buildBottomActionSliver(state, notifier),
          ],
        ),
      ),
    );
  }

  /// 1. 상단 헤더 Sliver
  SliverAppBar _buildHeaderSliver(BuildContext context, TaroConsultationState state) {
    return SliverAppBar(
      backgroundColor: const Color(0xFF0F0F2E).withOpacity(0.8),
      pinned: true,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios, color: TaroColors.textMystic),
          ),
          Expanded(
            child: Column(
              children: [
                Text('카드 선택', style: TextStyle(color: TaroColors.textMystic, fontSize: 20.sp)),
                Text(
                  state.selectedSpreadType?.name ?? '스프레드',
                  style: TextStyle(color: TaroColors.textSecondary, fontSize: 14.sp),
                ),
              ],
            ),
          ),
          _buildProgressIndicator(state),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40.h),
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: TaroColors.backgroundCard,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            '주제: ${state.theme}',
            style: TextStyle(color: TaroColors.textSecondary, fontSize: 12.sp),
          ),
        ),
      ),
    );
  }

  /// 3. 수평 스크롤 카드 덱 Sliver
  /// 3. 부채꼴 모양의 인터랙티브 카드 덱 Sliver
  SliverToBoxAdapter _buildCardDeckSliver(List<TaroCard> availableCards) {
    return SliverToBoxAdapter(
      child: FanCardDeck(
        availableCards: availableCards,
      ),
    );
  }

  /// 4. 카드 스프레드 영역 Sliver
  Widget _buildSpreadAreaSliver(TaroConsultationState state, TaroConsultationNotifier notifier) {
    final spread = state.selectedSpreadType;
    if (spread == null) return const SliverToBoxAdapter(child: SizedBox.shrink());

    // 상태에 있는 cardId 목록을 TaroCard 객체 목록으로 변환합니다.
    final selectedCards = state.selectedCards
        .map((id) => id != null ? TaroCards.findById(id) : null)
        .toList();

    // SliverToBoxAdapter를 사용해 직접 만드신 SpreadLayout 위젯을 배치합니다.
    return SliverToBoxAdapter(
      child: Padding(
        // 레이아웃 주변에 적절한 여백을 줍니다.
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: SpreadLayout(
          spreadType: spread,
          selectedCards: selectedCards,
          // 카드가 슬롯에 놓이면 notifier의 selectCard 함수를 호출합니다.
          onCardPlaced: (card, position) {
            notifier.selectCard(card.id, position);
          },
          // 카드가 제거되면 notifier의 removeCard 함수를 호출합니다.
          onCardRemoved: (position) {
            notifier.removeCard(position);
          },
        ),
      ),
    );
  }

  /// 5. 하단 액션 버튼 Sliver
  SliverToBoxAdapter _buildBottomActionSliver(TaroConsultationState state, TaroConsultationNotifier notifier) {
    final canRequestResult = state.canRequestResult;
    final isLoading = state.status == TaroStatus.loading;

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(20.w).copyWith(top: 30.h),
        child: Column(
          children: [
            // 카드 다시 섞기 버튼
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: OutlinedButton.icon(
                onPressed: () {
                  //TODO: 카드 섞기 로직 (notifier에 구현하는 것을 권장)
                  // notifier.shuffleDeck();
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('카드를 다시 섞었습니다.')),
                  // );
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
            // 결과 보기 버튼
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  canRequestResult ? '타로 결과 보기' : '모든 카드를 선택해주세요',
                  style: TextStyle(fontSize: 18.sp, color: TaroColors.backgroundDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 기존 코드에 있던 진행률 표시 위젯 (재사용)
  Widget _buildProgressIndicator(TaroConsultationState state) {
    final totalCards = state.selectedSpreadType?.cardCount ?? 0;
    final selectedCount = state.selectedCards.where((c) => c != null).length;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: TaroColors.backgroundCard,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        '$selectedCount/$totalCards',
        style: TextStyle(
          color: TaroColors.textMystic,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}