// test/core/factories/test_factory_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mind_canvas/core/htp/htp_dashboard_screen.dart';
import 'package:mind_canvas/features/info/factories/test_factory.dart';
import 'package:mind_canvas/features/psytest/psy_test_screen.dart';


void main() {
  group('TestFactory Tests', () {
    testWidgets('should create HTP screen correctly', (tester) async {
      // ✅ Factory 패턴으로 객체 생성 테스트
      final screen = TestFactory.createTestScreen(TestType.htp);
      
      // 타입 검증
      expect(screen, isA<HtpDashboardScreen>());
      
      // 위젯 렌더링 테스트
      await tester.pumpWidget(
        MaterialApp(home: screen),
      );
      
      // HTP 관련 요소들이 제대로 렌더링 되는지 확인
      expect(find.text('HTP 심리검사'), findsOneWidget);
    });
    
    testWidgets('should create MBTI screen correctly', (tester) async {
      // ✅ Factory로 MBTI 화면 생성
      final screen = TestFactory.createTestScreen(TestType.mbti);
      
      expect(screen, isA<PsyTestScreen>());
      
      await tester.pumpWidget(
        MaterialApp(home: screen),
      );
      
      // MBTI 관련 요소들 확인
      expect(find.text('MBTI 검사'), findsOneWidget);
    });
    
    testWidgets('should create coming soon screen for unimplemented tests', (tester) async {
      // ✅ 미구현 테스트에 대한 준비중 화면 테스트
      final screen = TestFactory.createTestScreen(TestType.persona);
      
      await tester.pumpWidget(
        MaterialApp(home: screen),
      );
      
      expect(find.text('페르소나 테스트 준비중'), findsOneWidget);
      expect(find.text('곧 만나볼 수 있어요!'), findsOneWidget);
      expect(find.byIcon(Icons.construction_rounded), findsOneWidget);
    });
    
    test('should throw error for unsupported test type', () {
      // ✅ 지원하지 않는 타입에 대한 에러 처리 테스트
      expect(
        () => TestFactory.createTestScreen(null as TestType),
        throwsA(isA<UnsupportedError>()),
      );
    });
    
    testWidgets('should apply custom config when provided', (tester) async {
      // ✅ 설정 적용 테스트
      final config = TestConfig(
        language: 'en',
        isDarkMode: true,
        questionsPerPage: 5,
      );
      
      final screen = TestFactory.createTestScreen(
        TestType.mbti,
        config: config,
      );
      
      expect(screen, isA<PsyTestScreen>());
      
      // TODO: 실제로는 화면 내부에서 config가 적용되었는지 확인하는 로직 추가
    });
  });
  
  group('TestType enum tests', () {
    test('should have correct display names', () {
      expect(TestType.htp.displayName, equals('HTP'));
      expect(TestType.mbti.displayName, equals('MBTI'));
      expect(TestType.persona.displayName, equals('페르소나'));
      expect(TestType.cognitive.displayName, equals('인지스타일'));
    });
    
    test('should have correct descriptions', () {
      expect(TestType.htp.description, equals('그림 심리검사'));
      expect(TestType.mbti.description, equals('성격유형검사'));
      expect(TestType.persona.description, equals('숨겨진 성격'));
      expect(TestType.cognitive.description, equals('사고방식 분석'));
    });
  });
}
