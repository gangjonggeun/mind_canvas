import 'package:flutter/material.dart';
import '../core/analysis/presentation/analysis_screen.dart';
import '../core/home/home_screen.dart';

/// Mind Canvas 메인 화면
/// 
/// 바텀 네비게이션을 담당하며 화면 분기 처리만 수행
/// - 탭 상태 관리
/// - 각 Screen으로 분기 처리
/// - 단순한 라우팅 역할
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  /// 각 탭별 실제 화면 목록
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onGoToAnalysis: goToAnalysis),  // 콜백 전달
      const AnalysisScreen(),  // 트렌디한 분석 화면
      const _HistoryScreen(),
      const _ProfileScreen(),
    ];
  }

  /// 분석 화면으로 이동하는 메서드 (홈 화면에서 호출용)
  void goToAnalysis() {
    setState(() {
      _currentIndex = 1; // 분석 탭 인덱스
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  /// 하단 네비게이션 바 구성
  Widget _buildBottomNavigation() {
    return Container(
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
          _buildNavItem(Icons.history_outlined, '기록', 2),
          _buildNavItem(Icons.person_outline, '프로필', 3),
        ],
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
              color: isActive ? const Color(0xFF6B73FF) : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive ? const Color(0xFF6B73FF) : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 기록 화면 임시 플레이스홀더
class _HistoryScreen extends StatelessWidget {
  const _HistoryScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 64,
                color: Color(0xFF4ECDC4),
              ),
              SizedBox(height: 16),
              Text(
                '📱 기록 화면',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '심리검사 기록을 관리하는 화면입니다',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 프로필 화면 임시 플레이스홀더
class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 64,
                color: Color(0xFF667EEA),
              ),
              SizedBox(height: 16),
              Text(
                '👤 프로필 화면',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '사용자 프로필을 관리하는 화면입니다',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
