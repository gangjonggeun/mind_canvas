import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/taro_spread_type.dart';
import '../providers/taro_consultation_provider.dart';
import '../providers/taro_consultation_state.dart';
import '../widgets/taro_background.dart';
import '../widgets/spread_type_card.dart';
import 'taro_card_selection_page.dart';
import 'taro_result_page.dart';
import 'dart:async';

/// 타로 상담 설정 페이지 (테마 입력 + 스프레드 선택)
/// 
/// 특징:
/// - 테마 입력 (최대 200자)
/// - 스프레드 타입 선택 (3, 5, 7, 10장)
/// - 실시간 유효성 검사
/// - TaroColors 시스템 사용
class TaroConsultationSetupPage extends ConsumerStatefulWidget {
  const TaroConsultationSetupPage({super.key});

  @override
  ConsumerState<TaroConsultationSetupPage> createState() => _TaroConsultationSetupPageState();
}

class _TaroConsultationSetupPageState extends ConsumerState<TaroConsultationSetupPage> {
  final _themeController = TextEditingController();
  final _themeFocusNode = FocusNode();


  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _themeController.dispose();
    _themeFocusNode.dispose();
    super.dispose();
  }

  // /// 앱 생명주기 변화 감지
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //
  //   switch (state) {
  //     case AppLifecycleState.paused:
  //     case AppLifecycleState.inactive:
  //       // 백그라운드 진입 시 메모리 정리
  //       _performMemoryCleanup();
  //       break;
  //     case AppLifecycleState.resumed:
  //       // 포그라운드 복귀 시 필요한 작업 (없음)
  //       break;
  //     case AppLifecycleState.detached:
  //       // 앱 종료 시 완전 정리
  //       _performMemoryCleanup();
  //       break;
  //     case AppLifecycleState.hidden:
  //       // TODO: Handle this case.
  //       throw UnimplementedError();
  //   }
  // }

  // /// 메모리 정리 작업
  // void _performMemoryCleanup() {
  //   if (_isDisposed) return;
  //
  //   try {
  //     // 이미지 캐시 정리 (메모리 절약)
  //     imageCache.clear();
  //     imageCache.clearLiveImages();
  //   } catch (e) {
  //     // 정리 중 오류 발생 시 무시
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TaroBackground(
        child: SafeArea(
          child: Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(taroConsultationNotifierProvider);
              final notifier = ref.read(taroConsultationNotifierProvider.notifier);

              // 상태 변화 리스너
              ref.listen<TaroConsultationState>(
                taroConsultationNotifierProvider,
                (previous, next) {
                  // 에러 처리
                  if (next.status == TaroStatus.error && next.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(next.errorMessage!),
                        backgroundColor: TaroColors.statusError,
                      ),
                    );
                  }

                  // 카드 선택 단계로 이동
                  if (next.status == TaroStatus.cardSelection) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TaroCardSelectionPage(),
                      ),
                    );
                  }

                  // 🎯 결과 화면으로 이동
                  if (next.status == TaroStatus.completed) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TaroResultPage(),
                      ),
                    );
                  }
                },
              );

              return Column(
                children: [
                  // 상단 타이틀
                  _buildHeader(),
                  
                  // 나머지 전체를 스크롤 가능한 영역으로
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(24.h),
                          
                          // 테마 입력 섹션
                          _buildThemeSection(state, notifier),
                          
                          Gap(32.h),
                          
                          // 스프레드 선택 섹션 - 고정 높이로 단순하게
                          _buildSpreadSelectionSection(state, notifier),
                          
                          Gap(32.h),
                          
                          // 시작 버튼
                          _buildStartButton(state, notifier),
                          
                          Gap(40.h), // 하단 여유 공간 더 많이
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// 헤더 영역
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            TaroColors.backgroundOverlay,
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          // 뒤로가기 버튼
          IconButton(
            onPressed: () {
              // 현재 내비게이션 스택의 맨 처음(홈)으로 돌아갑니다.
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Icon(Icons.arrow_back_ios, color: TaroColors.textMystic),
          ),
          
          // 타이틀 영역 (우측 정렬)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '타로 심리 상담',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: TaroColors.textMystic,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Gap(8.w),
                    Text(
                      '🔮',
                      style: TextStyle(
                        fontSize: 28.sp,
                      ),
                    ),
                  ],
                ),
                Gap(6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '✨',
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                    Gap(4.w),
                    Text(
                      '자신의 운명을 점쳐보세요',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w300,
                        color: TaroColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Gap(4.w),
                    Text(
                      '✨',
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 테마 입력 섹션
  Widget _buildThemeSection(TaroConsultationState state, TaroConsultationNotifier notifier) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: TaroColors.backgroundMystic,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: TaroColors.cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: TaroColors.accentGold,
                size: 24.sp,
              ),
              Gap(8.w),
              Text(
                '점치고 싶은 주제',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: TaroColors.textMystic,
                ),
              ),
            ],
          ),
          Gap(16.h),
          TextField(
            controller: _themeController,
            focusNode: _themeFocusNode,
            maxLines: 3,
            maxLength: 200,
            style: TextStyle(
              fontSize: 16.sp,
              color: TaroColors.textMystic,
              height: 1.4,
            ),
            decoration: InputDecoration(
              hintText: '예: 새로운 직장에서의 성공 가능성\n연인과의 관계 발전 방향\n중요한 결정에 대한 조언',
              hintStyle: TextStyle(
                color: TaroColors.textMuted,
                fontSize: 14.sp,
                height: 1.4,
              ),
              filled: true,
              fillColor: TaroColors.backgroundCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: TaroColors.accentGold,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.all(16.w),
              counterStyle: TextStyle(
                color: TaroColors.textMuted,
                fontSize: 12.sp,
              ),
            ),
            onChanged: (value) {
              notifier.updateTheme(value);
            },
          ),
        ],
      ),
    );
  }

  /// 스프레드 선택 섹션
  Widget _buildSpreadSelectionSection(TaroConsultationState state, TaroConsultationNotifier notifier) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: TaroColors.backgroundMystic,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: TaroColors.cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.grid_view,
                color: TaroColors.accentGold,
                size: 24.sp,
              ),
              Gap(8.w),
              Text(
                '스프레드 선택',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: TaroColors.textMystic,
                ),
              ),
            ],
          ),
          Gap(16.h),
          Text(
            '원하는 카드 배치 방법을 선택해주세요',
            style: TextStyle(
              fontSize: 14.sp,
              color: TaroColors.textSecondary,
            ),
          ),
          Gap(20.h),
          
          // 스프레드 타입 그리드 - 고정 높이로 단순하게
          SizedBox(
            height: 400.h, // 고정 높이 400.h로 충분히 크게
            child: GridView.count(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 0.7, // 비율 더 줄여서 카드를 더더더 세로로 길게
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              children: TaroSpreadTypes.all.map((spreadType) {
                final isSelected = state.selectedSpreadType?.cardCount == spreadType.cardCount;
                
                return SpreadTypeCard(
                  spreadType: spreadType,
                  isSelected: isSelected,
                  onTap: () {
                    notifier.selectSpreadType(spreadType);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 시작 버튼
  Widget _buildStartButton(TaroConsultationState state, TaroConsultationNotifier notifier) {
    final canProceed = state.canProceedToCardSelection;
    
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: canProceed
            ? () {
                notifier.startConsultation();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canProceed 
              ? TaroColors.accentGold 
              : TaroColors.cardDisabled,
          disabledBackgroundColor: TaroColors.cardDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: canProceed ? 8 : 0,
          shadowColor: TaroColors.withMysticOpacity(TaroColors.accentGold, 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              color: TaroColors.backgroundDark,
              size: 24.sp,
            ),
            Gap(8.w),
            Text(
              '타로 카드 선택하기',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: TaroColors.backgroundDark,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
