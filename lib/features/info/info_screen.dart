import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_canvas/core/theme/app_colors.dart';
import 'package:mind_canvas/features/htp/htp_dashboard_premium_screen.dart';
import 'package:mind_canvas/features/htp/single_test_dashboard_screen.dart';
import 'package:mind_canvas/features/info/presentation/notifiers/test_detail_notifier.dart';

import '../htp/htp_dashboard_screen.dart';
import '../htp/presentation/enum/single_test_type.dart';
import '../psytest/psy_test_screen.dart';
import '../taro/presentation/pages/taro_consultation_setup_page.dart';
import 'data/models/response/test_detail_response.dart';

/// 🔍 테스트 정보 화면
///
/// 테스트 시작 전 사용자에게 제공되는 정보:
/// - 테스트 제목 및 부제목
/// - 테스트 진행 방법 안내
/// - 시작하기 버튼
///
/// 메모리 최적화:
/// - const 생성자 사용
/// - 위젯 재사용 최대화
/// - 이미지 로딩 최적화
class InfoScreen extends ConsumerStatefulWidget {
  final int testId;
  final TestDetailResponse? testDetail;

  const InfoScreen({
    Key? key,
    required this.testId,
    this.testDetail
  }) : super(key: key);

  @override
  ConsumerState<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends ConsumerState<InfoScreen> {
  // 화면 패딩 상수
  static const double screenPadding = 20.0;

  @override
  void initState() {
    super.initState();
    print('🚀 InfoScreen initState - testId: ${widget.testId}, hasTestDetail: ${widget.testDetail != null}');

    // 다음 프레임에서 실행 (위젯 트리 완성 후)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTestInfo();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadTestInfo() async {

    print('📱 InfoScreen _loadTestInfo 시작: ${widget.testId}');

    // 이미 testDetail이 있으면 로딩하지 않음
    if (widget.testDetail != null) {
      return;
    }

    // ✅ 최신 방식: .notifier 사용
    await ref.read(testDetailNotifierProvider.notifier).loadTestDetail(widget.testId);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Consumer(
        builder: (context, ref, child) {
          // ✅ TestListNotifier와 동일한 방식
          final testDetailState = ref.watch(testDetailNotifierProvider);

          final testDetail = widget.testDetail ?? testDetailState.testDetail;
          final isLoading = testDetailState.isLoading && testDetail == null;

          print('🖼️ UI 빌드: isLoading=$isLoading, testDetail=${testDetail?.title}');
          print('🔍 상태 디버그: isLoading=${testDetailState.isLoading}, hasTestDetail=${testDetailState.testDetail != null}');

          if (isLoading) {
            return _buildLoadingState();
          }

          if (testDetail != null) {
            return _buildContent(context, testDetail);
          }

          return _buildErrorState(testDetailState.errorMessage ?? '테스트 정보를 불러올 수 없습니다');
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
          ),
          SizedBox(height: 16),
          Text(
            '테스트 정보를 불러오는 중...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String? errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.statusError,
            ),
            const SizedBox(height: 16),
            Text(
              '테스트 정보를 불러올 수 없습니다',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? '알 수 없는 오류가 발생했습니다',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _loadTestInfo(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('다시 시도'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('돌아가기'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TestDetailResponse testDetail) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(testDetail),
          _buildBody(context, testDetail),
        ],
      ),
    );
  }

  Widget _buildHeader(TestDetailResponse testDetail) {
    return Stack(
      children: [
        // 메인 이미지
        Container(
          height: 300,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: testDetail.imagePath ?? '',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 300,
              color: AppColors.backgroundCard,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) {
              return Container(
                height: 300,
                color: AppColors.primaryBlue.withOpacity(0.1),
                child: const Icon(
                  Icons.psychology,
                  size: 80,
                  color: AppColors.primaryBlue,
                ),
              );
            },
          ),
        ),

        // 뒤로가기 버튼
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // 하단 정보 오버레이
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(screenPadding),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 카테고리 배지
                if (testDetail.psychologyTag != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      testDetail.psychologyTag!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                // 제목
                Text(
                  testDetail.title ?? '제목 없음',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                // 부제목
                if (testDetail.subtitle != null)
                  Text(
                    testDetail.subtitle!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, TestDetailResponse testDetail) {
    return Padding(
      padding: const EdgeInsets.all(screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickInfo(testDetail),

          const SizedBox(height: 32),

          _buildDescription(testDetail),

          const SizedBox(height: 32),

          _buildInstructions(testDetail),

          const SizedBox(height: 40),

          _buildStartButton(context, testDetail),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQuickInfo(TestDetailResponse testDetail) {
    return Card(
      color: AppColors.backgroundCard,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                icon: Icons.access_time,
                label: '소요 시간',
                value: testDetail.estimatedTime != null
                    ? '${testDetail.estimatedTime}분'
                    : '미정',
                color: AppColors.primaryBlue,
              ),
            ),

            Container(
              width: 1,
              height: 40,
              color: AppColors.borderLight,
            ),

            Expanded(
              child: _buildInfoItem(
                icon: Icons.trending_up,
                label: '난이도',
                value: testDetail.difficulty ?? '보통',
                color: _getDifficultyColor(testDetail.difficulty ?? '보통'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case '쉬움':
        return AppColors.statusSuccess;
      case '보통':
        return AppColors.statusWarning;
      case '어려움':
        return AppColors.statusError;
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildDescription(TestDetailResponse testDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.primaryBlue,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              '테스트 소개',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryBlue.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Text(
            testDetail.introduction ?? '테스트 소개 정보가 없습니다.',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions(TestDetailResponse testDetail) {
    final instructions = testDetail.instructions ?? [];

    if (instructions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.list_alt,
              color: AppColors.primaryBlue,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              '진행 방법',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 구분선
        Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBlue.withOpacity(0.6),
                AppColors.primaryBlue.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(1),
          ),
        ),

        const SizedBox(height: 20),

        ...List.generate(instructions.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildInstructionItem(
              step: index + 1,
              instruction: instructions[index],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInstructionItem({
    required int step,
    required String instruction,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 스텝 번호
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // 설명 텍스트
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.borderLight,
                width: 1,
              ),
            ),
            child: Text(
              instruction,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context, TestDetailResponse testDetail) {
    // 💰 가격에 따른 텍스트 및 아이콘 설정
    final isFree = testDetail.cost == 0;
    final buttonText = isFree ? '무료로 시작하기' : '${testDetail.cost}코인으로 시작하기';

    // 돈이 부족하면 버튼 색상을 회색이나 붉은색 계열로 바꿀 수도 있음 (선택사항)
    // 여기서는 기본 스타일 유지하되 텍스트만 변경

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        // 👇 클릭 시직접 검사 로직 호출
        onPressed: () => _startTest(context, testDetail),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          // ... 기존 스타일 유지
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 💰 유료면 코인 아이콘, 무료면 플레이 아이콘
            Icon(
              isFree ? Icons.play_arrow : Icons.monetization_on,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              buttonText, // ✅ 동적 텍스트 적용
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


// ✅ 1. 타로 테스트 여부 확인 함수 추가
  bool _isTaroTest(TestDetailResponse testDetail) {
    final tag = testDetail.psychologyTag?.toUpperCase().trim();
    // JSON 데이터의 psychologyTag: "TAROT" 과 일치하는지 확인
    return tag == 'TAROT' || tag == 'TARO';
  }

  bool _isHtpTest(TestDetailResponse testDetail) {
    final tag = testDetail.psychologyTag?.toUpperCase().trim();
    return tag == 'HTP' || tag == 'htp';
  }

  bool _isPremumHtpTest(TestDetailResponse testDetail) {
    final tag = testDetail.psychologyTag?.toUpperCase().trim();
    return tag == "HTP_PREMIUM";
  }
  bool _isFbtTest(TestDetailResponse testDetail) {
    final tag = testDetail.psychologyTag?.toUpperCase().trim();
    return tag == 'FBT' || tag == 'FISHBOWL';
  }
  bool _isStarryTest(TestDetailResponse testDetail) {
    final tag = testDetail.psychologyTag?.toUpperCase().trim();
    return tag == 'STARRY_SEA' || tag == 'STARRY';
  }
  bool _isPitrTest(TestDetailResponse testDetail) {
    final tag = testDetail.psychologyTag?.toUpperCase().trim();
    return tag == 'PITR' || tag == 'pitr';
  }

  // ✅ 2. _startTest 함수 수정
  void _startTest(BuildContext context, TestDetailResponse testDetail) {

    // 🛑 [신규 추가] 1. 입구 컷: 구매 가능 여부 확인
    // 서버가 내려준 isAffordable이 false면 팝업 띄우고 중단
    if (!testDetail.isAffordable) {
      _showChargeDialog(context, testDetail.cost);
      return; // ⛔ 여기서 함수 종료 (페이지 이동 안 함)
    }

    // --- 👇 여기서부터는 기존 로직 그대로 유지 👇 ---

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${testDetail.title} 시작!'), // null check는 DTO에서 required 처리했으므로 제거 가능하지만 안전하게 유지
        backgroundColor: AppColors.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
    // 1️⃣ HTP 테스트인 경우
    if (_isHtpTest(testDetail)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HtpDashboardScreen(),
        ),
      );
      return;
    }

    if (
    _isPremumHtpTest(testDetail)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HtpDashboardPremiumScreen(),
        ),
      );
      return;
    }

    if (_isFbtTest(testDetail)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleTestDashboardScreen(testType: SingleTestType.fishbowl),
        ),
      );
      return;
    }

    if (_isPitrTest(testDetail)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleTestDashboardScreen(testType: SingleTestType.pitr),
        ),
      );
      return;
    }

    if (_isStarryTest(testDetail)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleTestDashboardScreen(testType: SingleTestType.starrySea),
        ),
      );
      return;
    }


    // 2️⃣ 타로 테스트인 경우
    if (_isTaroTest(testDetail)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TaroConsultationSetupPage(),
        ),
      );
      return;
    }

    // 3️⃣ 그 외 일반 객관식 심리 테스트
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PsyTestScreen(
          testId: testDetail.testId,
          testName: testDetail.title,
          testTag: testDetail.psychologyTag,
        ),
      ),
    );
  }

  // 💰 [신규 추가] 충전 유도 다이얼로그
  void _showChargeDialog(BuildContext context, int cost) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('코인이 부족해요', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          '이 테스트를 진행하려면 $cost코인이 필요합니다.\n보유 코인이 부족합니다.',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // 팝업 닫기
              // TODO: 충전 페이지나 광고 보기 페이지로 이동 구현
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('충전 페이지 준비 중입니다!')),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('충전하러 가기'),
          ),
        ],
      ),
    );
  }
}