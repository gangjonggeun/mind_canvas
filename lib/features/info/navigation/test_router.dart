// lib/core/navigation/test_router.dart

import 'package:flutter/material.dart';
import '../navigation/psy_router.dart';
import '../factories/test_factory.dart';

/// 테스트 네비게이션 전용 Router
/// 단일 책임: 오직 화면 전환과 라우팅만 담당
class TestRouter {
  /// 테스트 화면으로 네비게이션
  static Future<void> navigateToTest(
    BuildContext context,
    TestType testType, {
    TestConfig? config,
    Map<String, dynamic>? additionalData,
    bool enableCustomTransition = true,
  }) async {
    try {
      // 🏭 Factory에 객체 생성 위임
      final testScreen = TestFactory.createTestScreen(
        testType,
        config: config,
        additionalData: additionalData,
      );
      
      // 🧭 Router는 네비게이션 로직만 담당
      if (enableCustomTransition) {
        await _navigateWithCustomTransition(context, testScreen, testType);
      } else {
        await _navigateWithDefaultTransition(context, testScreen);
      }
      
      // 📊 네비게이션 로그 (Router의 책임)
      _logNavigation(testType);
      
    } catch (e) {
      // 🚨 에러 처리 (Router의 책임)
      _handleNavigationError(context, e);
    }
  }
  
  /// 커스텀 전환 애니메이션과 함께 네비게이션
  static Future<void> _navigateWithCustomTransition(
    BuildContext context,
    Widget screen,
    TestType testType,
  ) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // 🎨 테스트 타입별 다른 애니메이션
          return _getTransitionForTestType(
            testType,
            animation,
            secondaryAnimation,
            child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        settings: RouteSettings(
          name: '/test/${testType.name}',
          arguments: {'testType': testType},
        ),
      ),
    );
  }
  
  /// 기본 전환 애니메이션
  static Future<void> _navigateWithDefaultTransition(
    BuildContext context,
    Widget screen,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
  
  /// 테스트 타입별 전환 애니메이션
  static Widget _getTransitionForTestType(
    TestType testType,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (testType) {
      case TestType.htp:
        // 🎨 HTP는 창작 느낌의 회전 효과
        return RotationTransition(
          turns: Tween<double>(begin: 0.1, end: 0.0).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
        
      case TestType.mbti:
        // 🧠 MBTI는 분석 느낌의 슬라이드 효과
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          )),
          child: child,
        );
        
      default:
        // 기본 페이드 효과
        return FadeTransition(
          opacity: animation,
          child: child,
        );
    }
  }
  
  /// 네비게이션 로그
  static void _logNavigation(TestType testType) {
    // 📊 실제로는 Analytics 서비스에 전송
    debugPrint('🧭 Navigation: ${testType.displayName} 테스트 시작');
  }
  
  /// 네비게이션 에러 처리
  static void _handleNavigationError(BuildContext context, dynamic error) {
    // 🚨 에러 로깅 및 사용자에게 알림
    debugPrint('🚨 Navigation Error: $error');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('테스트를 시작할 수 없습니다: ${error.toString()}'),
        backgroundColor: const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
