import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/ai_analysis_helper.dart';
import '../../../../generated/l10n.dart';
import '../../domain/models/taro_spread_type.dart';
import '../providers/taro_analysis_notifier.dart';
import '../providers/taro_consultation_provider.dart';
import '../providers/taro_consultation_state.dart';
import '../widgets/taro_background.dart';
import '../widgets/spread_type_card.dart';
import 'taro_card_selection_page.dart';


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

  /// 🧹 상태 및 입력 초기화 함수 (Clean Slate)
  void _resetState() {
    // 텍스트 필드 비우기
    _themeController.clear();
    // 포커스 해제
    _themeFocusNode.unfocus();
    // 프로바이더 상태 초기화 (reset 메서드가 없다면 invalidate 사용)
    ref.read(taroConsultationNotifierProvider.notifier).reset();
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
              // 1. 상태 및 노티파이어 가져오기
              final state = ref.watch(taroConsultationNotifierProvider);
              final notifier = ref.read(taroConsultationNotifierProvider.notifier);
              final analysisState = ref.watch(taroAnalysisProvider);

              // =============================================================
              // 🎧 리스너 1: 상담 과정 관리 (카드 선택 페이지 이동 등)
              // =============================================================
              ref.listen<TaroConsultationState>(
                taroConsultationNotifierProvider,
                    (previous, next) {
                  // ❌ 에러 처리 (상담 설정 중 에러)
                  if (next.status == TaroStatus.error && next.errorMessage != null) {
                    AiAnalysisHelper.showErrorSnackBar(context, next.errorMessage!);
                  }

                  // 🃏 카드 선택 단계로 이동 (기존 로직 유지)
                  if (previous?.status != next.status &&
                      next.status == TaroStatus.cardSelection) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TaroCardSelectionPage(),
                      ),
                    ).then((_) {
                      // 돌아왔을 때 설정 초기화
                      notifier.reset();
                    });
                  }
                },
              );

              // =============================================================
              // 🎧 리스너 2: AI 분석 상태 관리 (제출 후 결과 대기)
              // =============================================================
              ref.listen<TarotAnalysisState>(
                taroAnalysisProvider,
                    (previous, next) {
                  // ❌ 분석 요청 자체 실패 시
                  if (next.errorMessage != null && !next.isSubmitting) {
                    AiAnalysisHelper.showErrorSnackBar(context, next.errorMessage!);
                    return;
                  }

                  // 🤖 AI 분석 접수 완료 (PENDING)
                  if (next.isCompleted && next.result?.id == "PENDING") {
                    print("🔮 타로 분석 접수 성공 -> 다이얼로그 노출");

                    // 공통 다이얼로그 호출 (확인 누르면 홈으로 이동)
                    AiAnalysisHelper.showPendingDialog(context);

                    // 분석이 성공적으로 접수되었으므로 상태들 리셋
                    ref.read(taroAnalysisProvider.notifier).reset();
                    notifier.reset();
                    return;
                  }
                },
              );

              // =============================================================
              // 🎨 UI 레이아웃
              // =============================================================
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

                          // 스프레드 선택 섹션
                          _buildSpreadSelectionSection(state, notifier),

                          Gap(32.h),

                          // 시작 버튼 (분석 중일 때는 로딩 표시)
                          analysisState.isSubmitting
                              ? const Center(child: CircularProgressIndicator())
                              : _buildStartButton(state, notifier),

                          Gap(40.h),
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
                      S.of(context).taro_title,
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
                      S.of(context).taro_content,
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
                S.of(context).taro_subject_title,
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
              hintText: S.of(context).taro_subject_content,
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
                S.of(context).taro_spread_select_title,
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
            S.of(context).taro_spread_select_content,
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
          // 키보드 내리기
          FocusScope.of(context).unfocus();
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
