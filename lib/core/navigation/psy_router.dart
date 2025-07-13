// lib/core/navigation/psy_router.dart

import 'package:flutter/material.dart';
import '../models/psy_types.dart';
import '../factories/psy_factory.dart';

/// 심리검사 네비게이션 전용 Router
/// 단일 책임: 오직 심리검사 화면 전환과 라우팅만 담당
class PsyRouter {
  /// 심리검사 화면으로 네비게이션
  static Future<void> navigateToTest(
    BuildContext context,
    PsyTestType testType, {
    PsyTestConfig? config,
    PsyTestInfo? testInfo,
    Map<String, dynamic>? additionalData,
    bool enableCustomTransition = true,
    bool logNavigation = true,
  }) async {
    try {
      // 🔍 테스트 가능 여부 확인
      if (!PsyFactory.isTestAvailable(testType)) {
        _showUnavailableMessage(context, testType);
        return;
      }
      
      // 🏭 Factory에 화면 생성 위임
      final testScreen = PsyFactory.createTestScreen(
        testType,
        config: config,
        testInfo: testInfo,
        additionalData: additionalData,
      );
      
      // 🧭 Router는 네비게이션 로직만 담당
      if (enableCustomTransition) {
        await _navigateWithCustomTransition(context, testScreen, testType);
      } else {
        await _navigateWithDefaultTransition(context, testScreen);
      }
      
      // 📊 네비게이션 로그 (선택적)
      if (logNavigation) {
        _logNavigation(testType, testInfo);
      }
      
    } catch (e, stackTrace) {
      // 🚨 에러 처리 (Router의 책임)
      _handleNavigationError(context, testType, e, stackTrace);
    }
  }
  
  /// 커스텀 전환 애니메이션과 함께 네비게이션
  static Future<void> _navigateWithCustomTransition(
    BuildContext context,
    Widget screen,
    PsyTestType testType,
  ) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return _getTransitionForTestType(
            testType,
            animation,
            secondaryAnimation,
            child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        settings: RouteSettings(
          name: '/psy_test/${testType.name}',
          arguments: {
            'testType': testType,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          },
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
  
  /// 심리검사 타입별 맞춤 전환 애니메이션
  static Widget _getTransitionForTestType(
    PsyTestType testType,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (testType) {
      case PsyTestType.htp:
        // 🎨 HTP는 창작적 느낌의 회전 + 슬라이드 효과
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          )),
          child: RotationTransition(
            turns: Tween<double>(
              begin: 0.05,
              end: 0.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            )),
            child: child,
          ),
        );
        
      case PsyTestType.mbti:
        // 🧠 MBTI는 분석적 느낌의 슬라이드 효과
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
        
      case PsyTestType.persona:
        // 🎭 페르소나는 신비로운 느낌의 페이드 + 스케일
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuart,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
        
      case PsyTestType.cognitive:
        // 💡 인지스타일은 논리적 느낌의 좌우 슬라이드
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
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
  
  /// 사용 불가능한 테스트 메시지 표시
  static void _showUnavailableMessage(BuildContext context, PsyTestType testType) {
    final testInfo = PsyTestInfo.findByType(testType);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: Color(testInfo?.primaryColor ?? 0xFF718096),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(testInfo?.title ?? '알림'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${testInfo?.title ?? testType.displayName}은 현재 준비중입니다.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (testInfo?.description != null)
              Text(
                testInfo!.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
              ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 16,
                    color: Color(0xFF718096),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '곧 만나볼 수 있도록 열심히 준비중이에요!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
  
  /// 네비게이션 로그 (분석/디버깅용)
  static void _logNavigation(PsyTestType testType, PsyTestInfo? testInfo) {
    // 📊 실제로는 Firebase Analytics, Crashlytics 등에 전송
    debugPrint('🧭 [PsyRouter] ${testType.displayName} 검사 시작');
    debugPrint('   📋 테스트 ID: ${testInfo?.id ?? 'unknown'}');
    debugPrint('   ⏱️ 예상 소요시간: ${testInfo?.estimatedMinutes ?? 0}분');
    debugPrint('   📅 시작 시간: ${DateTime.now()}');
  }
  
  /// 네비게이션 에러 처리
  static void _handleNavigationError(
    BuildContext context,
    PsyTestType testType,
    dynamic error,
    StackTrace stackTrace,
  ) {
    // 🚨 에러 로깅 (실제로는 Crashlytics 등에 전송)
    debugPrint('🚨 [PsyRouter] Navigation Error:');
    debugPrint('   🎯 테스트 타입: ${testType.displayName}');
    debugPrint('   ❌ 에러: $error');
    debugPrint('   📍 스택 트레이스: $stackTrace');
    
    // 사용자에게 친화적인 에러 메시지 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '검사를 시작할 수 없습니다',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '잠시 후 다시 시도해 주세요',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: '재시도',
          textColor: Colors.white,
          onPressed: () {
            // 재시도 로직
            navigateToTest(context, testType);
          },
        ),
      ),
    );
  }
  
  /// 사용 가능한 심리검사 목록 반환
  static List<PsyTestType> getAvailableTests() {
    return PsyFactory.availableTests;
  }
  
  /// 특정 타입의 테스트 정보 반환
  static PsyTestInfo? getTestInfo(PsyTestType type) {
    return PsyTestInfo.findByType(type);
  }
}
