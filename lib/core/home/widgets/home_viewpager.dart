import 'dart:async';
import 'package:flutter/material.dart';
import 'viewpager_items.dart';
import 'page_indicator.dart';

/// Mind Canvas 홈 화면 ViewPager 컨테이너
///
/// 책임:
/// - ViewPager 생명주기 관리
/// - 자동 슬라이드 제어
/// - 페이지 변경 이벤트 처리
/// - 사용자 인터랙션 관리
class HomeViewPager extends StatefulWidget {
  const HomeViewPager({super.key});

  @override
  State<HomeViewPager> createState() => _HomeViewPagerState();
}

class _HomeViewPagerState extends State<HomeViewPager> {
  late PageController _pageController;
  Timer? _autoSlideTimer;
  int _currentPageIndex = 0;

  // ===== 🎛️ ViewPager 설정 =====
  static const int _totalPages = 3; // 타로, 페르소나, HTP2 순서로 3개 페이지
  static const Duration _autoSlideDuration = Duration(seconds: 4);
  static const Duration _pageAnimationDuration = Duration(milliseconds: 350);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoSlide();
  }

  @override
  void dispose() {
    _stopAutoSlide();
    _pageController.dispose();
    super.dispose();
  }

  /// 자동 슬라이드 시작
  ///
  /// 메모리 누수 방지:
  /// - mounted 상태 체크
  /// - hasClients 확인
  /// - Timer 중복 생성 방지
  void _startAutoSlide() {
    _stopAutoSlide(); // 기존 타이머 정리
    _autoSlideTimer = Timer.periodic(_autoSlideDuration, (_) {
      if (mounted && _pageController.hasClients) {
        final nextPage = (_currentPageIndex + 1) % _totalPages;
        _pageController.animateToPage(
          nextPage,
          duration: _pageAnimationDuration,
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// 자동 슬라이드 중지
  ///
  /// 메모리 누수 방지:
  /// - Timer cancel 후 null 처리
  void _stopAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer = null;
  }

  /// 페이지 변경 핸들러
  ///
  /// State 업데이트:
  /// - 현재 페이지 인덱스 갱신
  /// - UI 리빌드 트리거
  void _onPageChanged(int index) {
    if (mounted) {
      setState(() {
        _currentPageIndex = index;
      });
    }
  }

  /// 사용자 터치 시 타이머 재시작
  ///
  /// UX 최적화:
  /// - 사용자 조작 후 자동 슬라이드 재개
  /// - 자연스러운 사용자 경험 제공
  void _onUserInteraction() {
    _startAutoSlide();
  }

  /// 페이지 이동 (프로그래매틱)
  ///
  /// 외부에서 특정 페이지로 이동할 때 사용
  void moveToPage(int pageIndex) {
    if (_pageController.hasClients &&
        pageIndex >= 0 &&
        pageIndex < _totalPages) {
      _pageController.animateToPage(
        pageIndex,
        duration: _pageAnimationDuration,
        curve: Curves.easeInOut,
      );
      _onUserInteraction();
    }
  }

  @override
  Widget build(BuildContext context) {
    const taroItem = TaroPageViewItem();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ===== 📱 메인 ViewPager =====
        SizedBox(
          height: 280,
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              // 타로 심리상담
              GestureDetector(
                onTap: () {
                  _onUserInteraction(); // 1. 기존의 자동 슬라이드 재시작
                  taroItem.onTapCallback(context)?.call(); // 2. 타로 아이템의 페이지 이동 콜백 실행
                },
                child: const TaroPageViewItem(),
              ),
              // 페르소나 테스트
              GestureDetector(
                onTap: _onUserInteraction,
                child: const PersonaPageViewItem(),
              ),
              // HTP 심리검사
              GestureDetector(
                onTap: _onUserInteraction,
                child: const HTPPageViewItem(),
              ),
            ],
          ),
        ),

        // ===== 🔘 페이지 인디케이터 =====
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: PageIndicator(
            totalPages: _totalPages,
            currentPage: _currentPageIndex,
            onPageTap: (index) {
              moveToPage(index);
            },
          ),
        ),
      ],
    );
  }
}
