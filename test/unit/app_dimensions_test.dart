import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_canvas/core/theme/app_assets.dart';

/// AppDimensions 반응형 디자인 시스템 단위 테스트
/// 
/// 테스트 커버리지:
/// - 화면 크기별 반응형 값 검증
/// - 임계값 경계 조건 테스트
/// - 메서드 일관성 검증
void main() {
  group('AppDimensions Unit Tests', () {
    
    late Widget testWidget;
    late BuildContext testContext;
    
    setUp(() {
      // 테스트용 위젯과 컨텍스트 설정
      testWidget = MaterialApp(
        home: Builder(
          builder: (context) {
            testContext = context;
            return Container();
          },
        ),
      );
    });

    /// 📱 화면 크기별 랭킹 카드 너비 테스트
    group('Ranking Card Width Tests', () {
      testWidgets('작은 화면(≤360px)에서 올바른 카드 너비 반환', (WidgetTester tester) async {
        // Given: 작은 화면 (360px)
        await tester.binding.setSurfaceSize(Size(360, 640));
        await tester.pumpWidget(testWidget);
        
        // When: 카드 너비 계산
        final width = AppDimensions.getRankingCardWidth(testContext);
        
        // Then: 작은 화면 크기 반환
        expect(width, equals(150.0));
      });

      testWidgets('중간 화면(≤400px)에서 올바른 카드 너비 반환', (WidgetTester tester) async {
        // Given: 중간 화면 (400px)
        await tester.binding.setSurfaceSize(Size(400, 640));
        await tester.pumpWidget(testWidget);
        
        // When
        final width = AppDimensions.getRankingCardWidth(testContext);
        
        // Then
        expect(width, equals(165.0));
      });

      testWidgets('큰 화면(>400px)에서 올바른 카드 너비 반환', (WidgetTester tester) async {
        // Given: 큰 화면 (450px)
        await tester.binding.setSurfaceSize(Size(450, 800));
        await tester.pumpWidget(testWidget);
        
        // When
        final width = AppDimensions.getRankingCardWidth(testContext);
        
        // Then
        expect(width, equals(180.0));
      });

      testWidgets('경계값 테스트 - 정확히 360px일 때', (WidgetTester tester) async {
        // Given: 정확히 임계값 (360px)
        await tester.binding.setSurfaceSize(Size(360, 640));
        await tester.pumpWidget(testWidget);
        
        // When
        final width = AppDimensions.getRankingCardWidth(testContext);
        
        // Then: 작은 화면 기준 적용
        expect(width, equals(150.0));
      });

      testWidgets('경계값 테스트 - 정확히 400px일 때', (WidgetTester tester) async {
        // Given: 정확히 임계값 (400px)
        await tester.binding.setSurfaceSize(Size(400, 640));
        await tester.pumpWidget(testWidget);
        
        // When
        final width = AppDimensions.getRankingCardWidth(testContext);
        
        // Then: 중간 화면 기준 적용
        expect(width, equals(165.0));
      });
    });

    /// 📏 이미지 높이 반응형 테스트
    group('Image Height Tests', () {
      testWidgets('화면 크기별 이미지 높이가 올바르게 계산되는지 확인', (WidgetTester tester) async {
        final testCases = [
          {'width': 320.0, 'expectedHeight': 130.0}, // 작은 화면
          {'width': 380.0, 'expectedHeight': 145.0}, // 중간 화면  
          {'width': 450.0, 'expectedHeight': 160.0}, // 큰 화면
        ];
        
        for (final testCase in testCases) {
          // Given
          await tester.binding.setSurfaceSize(Size(testCase['width']!, 640));
          await tester.pumpWidget(testWidget);
          
          // When
          final height = AppDimensions.getRankingCardImageHeight(testContext);
          
          // Then
          expect(height, equals(testCase['expectedHeight']),
            reason: '화면 너비 ${testCase['width']}에서 이미지 높이가 ${testCase['expectedHeight']}이어야 함');
        }
      });
    });

    /// 🔤 폰트 크기 반응형 테스트
    group('Font Size Tests', () {
      testWidgets('제목 폰트 크기가 화면에 따라 올바르게 조정되는지 확인', (WidgetTester tester) async {
        final screenSizes = [
          {'width': 320.0, 'expectedTitleSize': 12.0},
          {'width': 380.0, 'expectedTitleSize': 12.5},
          {'width': 450.0, 'expectedTitleSize': 13.0},
        ];
        
        for (final size in screenSizes) {
          await tester.binding.setSurfaceSize(Size(size['width']!, 640));
          await tester.pumpWidget(testWidget);
          
          final titleSize = AppDimensions.getRankingCardTitleFontSize(testContext);
          
          expect(titleSize, equals(size['expectedTitleSize']!));
        }
      });

      testWidgets('참여자 수 폰트 크기가 화면에 따라 올바르게 조정되는지 확인', (WidgetTester tester) async {
        final screenSizes = [
          {'width': 320.0, 'expectedSize': 10.0},
          {'width': 380.0, 'expectedSize': 10.5},
          {'width': 450.0, 'expectedSize': 11.0},
        ];
        
        for (final size in screenSizes) {
          await tester.binding.setSurfaceSize(Size(size['width']!, 640));
          await tester.pumpWidget(testWidget);
          
          final fontSize = AppDimensions.getRankingCardParticipantFontSize(testContext);
          
          expect(fontSize, equals(size['expectedSize']!));
        }
      });
    });

    /// 📏 패딩 및 간격 테스트
    group('Padding and Spacing Tests', () {
      testWidgets('메인 패딩이 화면 크기에 따라 올바르게 조정되는지 확인', (WidgetTester tester) async {
        final testData = [
          {'screenWidth': 320.0, 'expectedPadding': 16.0},
          {'screenWidth': 380.0, 'expectedPadding': 18.0},
          {'screenWidth': 450.0, 'expectedPadding': 20.0},
        ];
        
        for (final data in testData) {
          await tester.binding.setSurfaceSize(Size(data['screenWidth']!, 640));
          await tester.pumpWidget(testWidget);
          
          final padding = AppDimensions.getMainPadding(testContext);
          
          expect(padding, equals(data['expectedPadding']!));
        }
      });

      testWidgets('카드 간격이 화면 크기에 따라 올바르게 조정되는지 확인', (WidgetTester tester) async {
        final testData = [
          {'screenWidth': 320.0, 'expectedSpacing': 8.0},
          {'screenWidth': 380.0, 'expectedSpacing': 10.0},
          {'screenWidth': 450.0, 'expectedSpacing': 12.0},
        ];
        
        for (final data in testData) {
          await tester.binding.setSurfaceSize(Size(data['screenWidth']!, 640));
          await tester.pumpWidget(testWidget);
          
          final spacing = AppDimensions.getRankingCardSpacing(testContext);
          
          expect(spacing, equals(data['expectedSpacing']!));
        }
      });
    });

    /// 🔄 일관성 검증 테스트
    group('Consistency Tests', () {
      testWidgets('모든 반응형 값들이 논리적으로 일관된지 확인', (WidgetTester tester) async {
        final screenWidths = [300.0, 350.0, 380.0, 420.0, 480.0];
        
        for (final width in screenWidths) {
          await tester.binding.setSurfaceSize(Size(width, 640));
          await tester.pumpWidget(testWidget);
          
          final cardWidth = AppDimensions.getRankingCardWidth(testContext);
          final imageHeight = AppDimensions.getRankingCardImageHeight(testContext);
          final totalHeight = AppDimensions.getRankingCardTotalHeight(testContext);
          
          // 이미지 높이가 전체 높이보다 작아야 함
          expect(imageHeight, lessThan(totalHeight),
            reason: '이미지 높이($imageHeight)가 전체 높이($totalHeight)보다 작아야 함');
          
          // 카드 너비가 최소값보다 커야 함
          expect(cardWidth, greaterThanOrEqualTo(150.0),
            reason: '카드 너비($cardWidth)가 최소값(150)보다 커야 함');
          
          // 카드 너비가 최대값보다 작아야 함
          expect(cardWidth, lessThanOrEqualTo(180.0),
            reason: '카드 너비($cardWidth)가 최대값(180)보다 작아야 함');
        }
      });

      testWidgets('폰트 크기들이 적절한 비율을 유지하는지 확인', (WidgetTester tester) async {
        await tester.binding.setSurfaceSize(Size(400, 640));
        await tester.pumpWidget(testWidget);
        
        final titleSize = AppDimensions.getRankingCardTitleFontSize(testContext);
        final participantSize = AppDimensions.getRankingCardParticipantFontSize(testContext);
        final badgeSize = AppDimensions.getRankingCardRankBadgeFontSize(testContext);
        
        // 제목 폰트가 가장 커야 함
        expect(titleSize, greaterThanOrEqualTo(participantSize));
        expect(titleSize, greaterThanOrEqualTo(badgeSize));
        
        // 모든 폰트 크기가 합리적인 범위 내에 있어야 함
        expect(titleSize, greaterThanOrEqualTo(10.0));
        expect(titleSize, lessThanOrEqualTo(16.0));
      });
    });

    /// 🏗️ 상수 값 검증 테스트
    group('Constants Validation Tests', () {
      test('화면 크기 임계값들이 올바르게 정의되어 있는지 확인', () {
        expect(AppDimensions.smallScreenWidth, equals(360.0));
        expect(AppDimensions.mediumScreenWidth, equals(400.0));
        expect(AppDimensions.largeScreenWidth, equals(450.0));
        
        // 임계값들이 논리적 순서를 유지하는지 확인
        expect(AppDimensions.smallScreenWidth, lessThan(AppDimensions.mediumScreenWidth));
        expect(AppDimensions.mediumScreenWidth, lessThan(AppDimensions.largeScreenWidth));
      });

      test('기존 상수들이 여전히 유효한지 확인 (하위 호환성)', () {
        expect(AppDimensions.rankingCardWidth, equals(180.0));
        expect(AppDimensions.rankingCardImageHeight, equals(160.0));
        expect(AppDimensions.rankingCardTotalHeight, equals(240.0));
        expect(AppDimensions.rankingCardBorderRadius, equals(16.0));
      });
    });

    /// 🚫 에지 케이스 테스트
    group('Edge Cases Tests', () {
      testWidgets('매우 작은 화면에서도 안전하게 작동하는지 확인', (WidgetTester tester) async {
        // Given: 매우 작은 화면 (240px)
        await tester.binding.setSurfaceSize(Size(240, 400));
        await tester.pumpWidget(testWidget);
        
        // When & Then: 예외가 발생하지 않고 값이 반환되어야 함
        expect(() => AppDimensions.getRankingCardWidth(testContext), returnsNormally);
        expect(() => AppDimensions.getRankingCardImageHeight(testContext), returnsNormally);
        expect(() => AppDimensions.getMainPadding(testContext), returnsNormally);
        
        // 최소값이 적용되어야 함
        final width = AppDimensions.getRankingCardWidth(testContext);
        expect(width, equals(150.0)); // 최소값
      });

      testWidgets('매우 큰 화면에서도 안전하게 작동하는지 확인', (WidgetTester tester) async {
        // Given: 매우 큰 화면 (800px)
        await tester.binding.setSurfaceSize(Size(800, 1200));
        await tester.pumpWidget(testWidget);
        
        // When & Then: 최대값이 적용되어야 함
        final width = AppDimensions.getRankingCardWidth(testContext);
        expect(width, equals(180.0)); // 최대값
        
        final padding = AppDimensions.getMainPadding(testContext);
        expect(padding, equals(20.0)); // 최대값
      });
    });
  });
}

/// 🛠️ 테스트 헬퍼 클래스
class AppDimensionsTestHelpers {
  /// 화면 크기별 테스트 데이터 생성
  static List<Map<String, double>> generateScreenSizeTestData() {
    return [
      {'width': 320.0, 'category': 1.0}, // 작은 화면
      {'width': 360.0, 'category': 1.0}, // 작은 화면 경계
      {'width': 380.0, 'category': 2.0}, // 중간 화면
      {'width': 400.0, 'category': 2.0}, // 중간 화면 경계
      {'width': 450.0, 'category': 3.0}, // 큰 화면
      {'width': 500.0, 'category': 3.0}, // 큰 화면
    ];
  }
  
  /// 반응형 값 일관성 검증
  static void validateResponsiveValues({
    required double cardWidth,
    required double imageHeight,
    required double totalHeight,
    required double titleFontSize,
    required double participantFontSize,
  }) {
    // 비율 검증
    expect(imageHeight / totalHeight, lessThan(0.8), 
      reason: '이미지가 전체 카드의 80% 이하를 차지해야 함');
    
    expect(titleFontSize, greaterThanOrEqualTo(participantFontSize),
      reason: '제목 폰트가 참여자 수 폰트보다 크거나 같아야 함');
    
    // 절대값 검증
    expect(cardWidth, inInclusiveRange(140.0, 200.0),
      reason: '카드 너비가 합리적인 범위 내에 있어야 함');
    
    expect(titleFontSize, inInclusiveRange(10.0, 16.0),
      reason: '제목 폰트 크기가 합리적인 범위 내에 있어야 함');
  }
}
