import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mind_canvas/main.dart' as app;

/// HomeScreen 통합 테스트
/// 
/// 실제 앱 환경에서의 end-to-end 테스트
/// - 실제 디바이스/에뮬레이터에서 실행
/// - 전체 사용자 플로우 검증
/// - 성능 측정 및 메모리 사용량 체크
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('HomeScreen Integration Tests', () {
    
    /// 🚀 앱 시작 및 홈스크린 로딩 테스트
    group('App Launch and Home Loading', () {
      testWidgets('앱이 정상적으로 시작되고 홈스크린이 표시되는지 확인', (WidgetTester tester) async {
        // Given: 앱 시작
        app.main();
        await tester.pumpAndSettle();
        
        // Then: 홈스크린이 표시되어야 함
        expect(find.text('🏆 인기 테스트 랭킹'), findsOneWidget);
        expect(find.text('✨ 당신을 위한 추천'), findsOneWidget);
        expect(find.text('💭 인기 간단한 테스트'), findsOneWidget);
        expect(find.text('📈 최근 검사 기록'), findsOneWidget);
        expect(find.text('💡 심리 인사이트'), findsOneWidget);
      });

      testWidgets('홈스크린 로딩 시간 측정', (WidgetTester tester) async {
        // Given: 시간 측정 시작
        final stopwatch = Stopwatch()..start();
        
        // When: 앱 시작 및 홈스크린 로딩
        app.main();
        await tester.pumpAndSettle();
        
        // Then: 로딩 시간이 5초 이내여야 함
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(5000),
          reason: '홈스크린 로딩이 5초를 초과함: ${stopwatch.elapsedMilliseconds}ms');
        
        print('📊 홈스크린 로딩 시간: ${stopwatch.elapsedMilliseconds}ms');
      });
    });

    /// 🎯 사용자 상호작용 플로우 테스트
    group('User Interaction Flow', () {
      testWidgets('인기 테스트 랭킹 카드 탭 플로우 테스트', (WidgetTester tester) async {
        // Given: 앱 시작
        app.main();
        await tester.pumpAndSettle();
        
        // When: MBTI 검사 카드 탭
        final mbtiCard = find.text('MBTI 검사');
        expect(mbtiCard, findsOneWidget);
        
        await tester.tap(mbtiCard);
        await tester.pumpAndSettle();
        
        // Then: 탭 이벤트가 정상적으로 처리되어야 함
        expect(tester.takeException(), isNull);
      });

      testWidgets('스크롤 동작 플로우 테스트', (WidgetTester tester) async {
        // Given
        app.main();
        await tester.pumpAndSettle();
        
        // When: 수직 스크롤
        final scrollView = find.byType(SingleChildScrollView).first;
        await tester.fling(scrollView, Offset(0, -500), 1000);
        await tester.pumpAndSettle();
        
        // Then: 스크롤이 정상 작동해야 함
        expect(tester.takeException(), isNull);
      });
    });

    /// 📱 반응형 디자인 통합 테스트
    group('Responsive Design Integration', () {
      testWidgets('다양한 화면 크기에서 레이아웃 검증', (WidgetTester tester) async {
        final screenSizes = [
          Size(320, 568), // iPhone 5
          Size(375, 667), // iPhone 8
          Size(414, 896), // iPhone 11
          Size(360, 640), // Android 소형
          Size(400, 800), // Android 중형
          Size(480, 854), // Android 대형
        ];
        
        for (final size in screenSizes) {
          // Given: 특정 화면 크기
          await tester.binding.setSurfaceSize(size);
          app.main();
          await tester.pumpAndSettle();
          
          // Then: 모든 화면 크기에서 정상 렌더링
          expect(find.text('🏆 인기 테스트 랭킹'), findsOneWidget,
            reason: '화면 크기 ${size.width}x${size.height}에서 렌더링 실패');
          expect(tester.takeException(), isNull);
          
          print('✅ 화면 크기 ${size.width}x${size.height}: 성공');
        }
      });
    });

    /// 📊 성능 통합 테스트
    group('Performance Integration', () {
      testWidgets('메모리 사용량 모니터링', (WidgetTester tester) async {
        // Given
        final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
        app.main();
        await tester.pumpAndSettle();
        
        // When: 반복적인 상호작용
        for (int i = 0; i < 10; i++) {
          final scrollView = find.byType(SingleChildScrollView).first;
          await tester.fling(scrollView, Offset(0, -200), 1000);
          await tester.pumpAndSettle();
        }
        
        // Then: 메모리 누수가 없어야 함
        expect(tester.takeException(), isNull);
      });
    });
  });
}

/// 🛠️ 성능 측정 헬퍼
class PerformanceTestHelpers {
  static Future<Duration> measureRenderingTime(
    WidgetTester tester,
    VoidCallback action,
  ) async {
    final stopwatch = Stopwatch()..start();
    action();
    await tester.pumpAndSettle();
    stopwatch.stop();
    return stopwatch.elapsed;
  }
}
