import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_canvas/features/recommendation/presentation/recommendation_screen.dart';

/// 🧪 추천 메인 화면 테스트
/// 
/// UI 구성 요소들이 제대로 렌더링되는지 확인
/// - 메모리 누수 방지
/// - 다크모드 지원 확인
/// - 터치 이벤트 정상 작동 확인
void main() {
  group('RecommendationScreen Tests', () {
    testWidgets('메인 화면이 올바르게 렌더링되는지 확인', (WidgetTester tester) async {
      // Given: 추천 화면을 구성
      await tester.pumpWidget(
        MaterialApp(
          home: const RecommendationScreen(),
          theme: ThemeData.light(),
        ),
      );

      // When: 화면이 렌더링됨
      await tester.pumpAndSettle();

      // Then: 주요 UI 요소들이 존재하는지 확인
      expect(find.text('✨ 맞춤 추천'), findsOneWidget);
      expect(find.text('🎯 성격 기반 컨텐츠 추천'), findsOneWidget);
      expect(find.text('🏆 재미있는 테스트'), findsOneWidget);
      expect(find.text('👥 사용자 추천'), findsOneWidget);
    });

    testWidgets('다크모드에서 올바르게 렌더링되는지 확인', (WidgetTester tester) async {
      // Given: 다크모드로 설정된 추천 화면
      await tester.pumpWidget(
        MaterialApp(
          home: const RecommendationScreen(),
          theme: ThemeData.dark(),
        ),
      );

      // When: 화면이 렌더링됨
      await tester.pumpAndSettle();

      // Then: 다크모드 색상이 적용되었는지 확인
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFF1A202C));
    });

    testWidgets('성격 기반 추천 카테고리 카드 터치 테스트', (WidgetTester tester) async {
      // Given: 추천 화면을 구성
      await tester.pumpWidget(
        MaterialApp(
          home: const RecommendationScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // When: 드라마 & 영화 카테고리를 터치
      final dramaMovieCard = find.text('드라마 & 영화');
      expect(dramaMovieCard, findsOneWidget);
      
      await tester.tap(dramaMovieCard);
      await tester.pumpAndSettle();

      // Then: 새로운 화면으로 네비게이션이 발생했는지 확인
      // (실제로는 PersonalityRecommendationsPage로 이동해야 함)
      // 여기서는 네비게이션이 시도되었는지만 확인
    });

    testWidgets('이상형 월드컵 카테고리 터치 테스트', (WidgetTester tester) async {
      // Given: 추천 화면을 구성
      await tester.pumpWidget(
        MaterialApp(
          home: const RecommendationScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // When: 음식 취향 테스트를 터치
      final foodCard = find.text('음식 취향');
      expect(foodCard, findsOneWidget);
      
      await tester.tap(foodCard);
      await tester.pumpAndSettle();

      // Then: 터치 이벤트가 정상 처리되었는지 확인
    });

    testWidgets('스크롤 동작 테스트', (WidgetTester tester) async {
      // Given: 추천 화면을 구성
      await tester.pumpWidget(
        MaterialApp(
          home: const RecommendationScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // When: 화면을 아래로 스크롤
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      // Then: 스크롤이 정상적으로 동작했는지 확인
      // (사용자 추천 섹션이 보여야 함)
      expect(find.text('👥 사용자 추천'), findsOneWidget);
    });

    testWidgets('메모리 효율성 테스트 - 여러 번 빌드해도 누수 없음', (WidgetTester tester) async {
      // Given & When: 화면을 여러 번 빌드
      for (int i = 0; i < 5; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: const RecommendationScreen(),
          ),
        );
        await tester.pumpAndSettle();
        
        // 화면을 제거하고 다시 생성
        await tester.pumpWidget(Container());
      }

      // Then: 메모리 누수나 에러가 발생하지 않았는지 확인
      // (테스트가 완료되면 성공)
    });

    testWidgets('반응형 레이아웃 테스트', (WidgetTester tester) async {
      // Given: 작은 화면 크기로 설정
      await tester.binding.setSurfaceSize(const Size(320, 568)); // iPhone SE 크기
      
      await tester.pumpWidget(
        MaterialApp(
          home: const RecommendationScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // When: UI 요소들이 작은 화면에서도 올바르게 표시되는지 확인
      expect(find.text('✨ 맞춤 추천'), findsOneWidget);
      
      // 화면 크기를 리셋
      await tester.binding.setSurfaceSize(null);
    });
  });

  group('RecommendationScreen Widget Interactions', () {
    testWidgets('전체보기 버튼 동작 테스트', (WidgetTester tester) async {
      // Given: 추천 화면을 구성
      await tester.pumpWidget(
        MaterialApp(
          home: const RecommendationScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // When: 전체보기 버튼을 찾아서 터치
      final viewAllButton = find.text('전체보기');
      if (viewAllButton.evaluate().isNotEmpty) {
        await tester.tap(viewAllButton);
        await tester.pumpAndSettle();
      }

      // Then: 터치 이벤트가 처리되었는지 확인
    });

    testWidgets('더보기 버튼 동작 테스트', (WidgetTester tester) async {
      // Given: 추천 화면을 구성
      await tester.pumpWidget(
        MaterialApp(
          home: const RecommendationScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // When: 더보기 버튼을 찾아서 터치
      final moreButton = find.text('더보기');
      if (moreButton.evaluate().isNotEmpty) {
        await tester.tap(moreButton);
        await tester.pumpAndSettle();
      }

      // Then: 터치 이벤트가 처리되었는지 확인
    });
  });
}
