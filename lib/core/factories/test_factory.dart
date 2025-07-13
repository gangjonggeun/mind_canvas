// lib/core/factories/test_factory.dart

import 'package:flutter/material.dart';
import '../htp/htp_dashboard_screen.dart';
import '../psytest/psy_test_screen.dart';

/// 테스트 화면 생성 전용 Factory
/// 단일 책임: 오직 테스트 화면 객체 생성만 담당
abstract class TestFactory {
  /// 테스트 타입에 따른 화면 생성
  static Widget createTestScreen(
    TestType type, {
    // 🧪 Mock 테스트를 위한 의존성 주입 가능
    TestConfig? config,
    Map<String, dynamic>? additionalData,
  }) {
    switch (type) {
      case TestType.htp:
        return _createHtpScreen(config, additionalData);
        
      case TestType.mbti:
        return _createMbtiScreen(config, additionalData);
        
      case TestType.persona:
        return _createPersonaScreen(config, additionalData);
        
      case TestType.cognitive:
        return _createCognitiveScreen(config, additionalData);
        
      default:
        throw UnsupportedError('지원하지 않는 테스트 타입: $type');
    }
  }
  
  /// HTP 화면 생성 (복잡한 설정 포함)
  static Widget _createHtpScreen(
    TestConfig? config, 
    Map<String, dynamic>? data,
  ) {
    // 🎨 HTP 전용 설정들
    return const HtpDashboardScreen();
  }
  
  /// MBTI 화면 생성 (질문 데이터 로딩 포함)
  static Widget _createMbtiScreen(
    TestConfig? config, 
    Map<String, dynamic>? data,
  ) {
    // 🧠 MBTI 전용 설정들
    // TODO: 실제로는 질문 데이터 로딩, 사용자 설정 적용 등
    return const PsyTestScreen();
  }
  
  /// 페르소나 화면 생성 (준비중)
  static Widget _createPersonaScreen(
    TestConfig? config, 
    Map<String, dynamic>? data,
  ) {
    // 🎭 페르소나 테스트 (아직 미구현)
    return _createComingSoonScreen('페르소나 테스트');
  }
  
  /// 인지스타일 화면 생성 (준비중)  
  static Widget _createCognitiveScreen(
    TestConfig? config, 
    Map<String, dynamic>? data,
  ) {
    // 💡 인지스타일 테스트 (아직 미구현)
    return _createComingSoonScreen('인지스타일 검사');
  }
  
  /// 준비중 화면 생성
  static Widget _createComingSoonScreen(String testName) {
    return Scaffold(
      appBar: AppBar(
        title: Text(testName),
        backgroundColor: const Color(0xFF3182CE),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction_rounded,
              size: 80,
              color: Color(0xFF718096),
            ),
            const SizedBox(height: 20),
            Text(
              '$testName 준비중',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '곧 만나볼 수 있어요!',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 테스트 타입 열거형
enum TestType {
  htp('HTP', '그림 심리검사'),
  mbti('MBTI', '성격유형검사'), 
  persona('페르소나', '숨겨진 성격'),
  cognitive('인지스타일', '사고방식 분석');
  
  const TestType(this.displayName, this.description);
  
  final String displayName;
  final String description;
}

/// 테스트 설정 클래스 (확장 가능)
class TestConfig {
  final String language;
  final bool isDarkMode;
  final int questionsPerPage;
  final Duration timeLimit;
  
  const TestConfig({
    this.language = 'ko',
    this.isDarkMode = false,
    this.questionsPerPage = 3,
    this.timeLimit = const Duration(minutes: 30),
  });
}
