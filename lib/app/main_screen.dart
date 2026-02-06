import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_canvas/app/widgets/coin_badge.dart';
import 'package:mind_canvas/features/consulting/presentation/consulting_screen.dart';

import '../core/services/notification_service.dart';
import '../features/analysis/presentation/analysis_screen.dart';
import '../features/home/home_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/recommendation/presentation/recommendation_screen.dart';
import '../app/presentation/notifier/user_notifier.dart';

/// Mind Canvas 메인 화면
///
/// 바텀 네비게이션을 담당하며 화면 분기 처리만 수행
/// - 탭 상태 관리
/// - 각 Screen으로 분기 처리
/// - 단순한 라우팅 역할
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

// 2️⃣ ConsumerState로 변경
class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  /// 각 탭별 실제 화면 목록
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onGoToAnalysis: goToAnalysis), // 콜백 전달
      const AnalysisScreen(), // 트렌디한 분석 화면
      const RecommendationScreen(),
      const ConsultingScreen(), // 🔄 기록 → 상담으로 변경
      const ProfileScreen(),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationHandler.initialize(context, ref);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 1. 인기 테스트 로드 (기존)
      // ref.read(testListNotifierProvider.notifier).loadPopularTests(); // HomeScreen에서 하고 있다면 제거 가능

      // 2. 💰 내 정보(코인) 최신화 (이게 없어서 0이었음!)
      ref.read(userNotifierProvider.notifier).refreshProfile();
    });
  }

  /// 분석 화면으로 이동하는 메서드 (홈 화면에서 호출용)
  void goToAnalysis() {
    setState(() {
      _currentIndex = 1; // 분석 탭 인덱스
    });
  }

  @override
  Widget build(BuildContext context) {
    // 💰 UserNotifier 구독 (코인 잔액 실시간 감지)
    // final userState = ref.watch(userNotifierProvider);
    // final int coins = userState?.coins ?? 0;

    return Scaffold(
      // 🔥 Stack으로 감싸서 코인 배지를 최상단에 띄움
      body: Stack(
        children: [
          // 1. 실제 화면들
          IndexedStack(index: _currentIndex, children: _screens),

          // 2. 코인 배지 (우측 상단 고정)
          // 프로필 화면(index 4)에서는 중복될 수 있으니 숨길 수도 있음 (선택사항)
          if (_currentIndex != 4)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10, // 상태바 아래 여백
              right: 16,
              child: CoinBadge(
                onTap: () {
                  // 클릭 시 프로필 탭으로 이동하거나 충전 페이지로 이동
                  setState(() => _currentIndex = 4);
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  /// 하단 네비게이션 바 구성
  Widget _buildBottomNavigation() {
    return SafeArea(
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home_outlined, '홈', 0),
            _buildNavItem(Icons.bar_chart_outlined, '분석', 1),
            _buildNavItem(Icons.star_border, '추천', 2),
            _buildNavItem(Icons.psychology_outlined, '상담', 3),
            _buildNavItem(Icons.person_outline, '프로필', 4),
          ],
        ),
      ),
    );
  }

  /// 네비게이션 아이템 위젯
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive
                  ? const Color(0xFF6B73FF)
                  : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? const Color(0xFF6B73FF)
                    : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
