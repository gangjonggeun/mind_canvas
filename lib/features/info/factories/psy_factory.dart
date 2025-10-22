// lib/core/factories/psy_factory.dart

import 'package:flutter/material.dart';

import '../../../core/models/psy_types.dart';
import '../../htp/htp_dashboard_screen.dart';
import '../../psytest/psy_test_screen.dart';


/// 심리검사 화면 생성 전용 Factory
/// 단일 책임: 오직 심리검사 화면 객체 생성만 담당
abstract class PsyFactory {
  /// 심리검사 타입에 따른 화면 생성
  static Widget createTestScreen(
    PsyTestType type, {
    PsyTestConfig? config,
    PsyTestInfo? testInfo,
    Map<String, dynamic>? additionalData,
  }) {
    switch (type) {
      case PsyTestType.htp:
        return _createHtpScreen(config, testInfo, additionalData);
        
      case PsyTestType.mbti:
        return _createMbtiScreen(config, testInfo, additionalData);
        
      case PsyTestType.persona:
        return _createPersonaScreen(config, testInfo, additionalData);
        
      case PsyTestType.cognitive:
        return _createCognitiveScreen(config, testInfo, additionalData);
        
      default:
        throw UnsupportedError('지원하지 않는 심리검사 타입: $type');
    }
  }
  
  /// HTP 화면 생성 (복잡한 설정 포함)
  static Widget _createHtpScreen(
    PsyTestConfig? config,
    PsyTestInfo? testInfo,
    Map<String, dynamic>? data,
  ) {
    // 🎨 HTP 전용 설정들
    // TODO: 실제로는 그리기 도구 설정, 저장 옵션 등을 적용
    return const HtpDashboardScreen();
  }
  
  /// MBTI 화면 생성 (질문 데이터 로딩 포함)
  static Widget _createMbtiScreen(
    PsyTestConfig? config,
    PsyTestInfo? testInfo,
    Map<String, dynamic>? data,
  ) {
    // 🧠 MBTI 전용 설정들
    // TODO: 실제로는 질문 데이터 로딩, 사용자 설정 적용 등
    return const PsyTestScreen(testId: 1,);
  }
  
  /// 페르소나 화면 생성 (준비중)
  static Widget _createPersonaScreen(
    PsyTestConfig? config,
    PsyTestInfo? testInfo,
    Map<String, dynamic>? data,
  ) {
    return _createComingSoonScreen(
      testInfo?.title ?? '페르소나 테스트',
      testInfo?.description ?? '숨겨진 성격을 발견하는 심리검사',
      Color(testInfo?.primaryColor ?? 0xFF805AD5),
    );
  }
  
  /// 인지스타일 화면 생성 (준비중)  
  static Widget _createCognitiveScreen(
    PsyTestConfig? config,
    PsyTestInfo? testInfo,
    Map<String, dynamic>? data,
  ) {
    return _createComingSoonScreen(
      testInfo?.title ?? '인지스타일 검사',
      testInfo?.description ?? '사고방식과 학습 스타일을 분석하는 검사',
      Color(testInfo?.primaryColor ?? 0xFFD69E2E),
    );
  }
  
  /// 준비중 화면 생성
  static Widget _createComingSoonScreen(
    String testName,
    String description,
    Color primaryColor,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(testName),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 아이콘
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.psychology_rounded,
                    size: 60,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 30),
                
                // 제목
                Text(
                  '$testName',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // 설명
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF718096),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                
                // 상태 메시지
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.construction_rounded,
                        size: 20,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '준비중이에요, 곧 만나요!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                // 알림 설정 버튼 (미래 기능)
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: 알림 설정 기능
                  },
                  icon: Icon(Icons.notifications_none_rounded, size: 20),
                  label: const Text(
                    '출시 알림 받기',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor.withOpacity(0.5)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// 테스트 가능 여부 확인
  static bool isTestAvailable(PsyTestType type) {
    switch (type) {
      case PsyTestType.htp:
      case PsyTestType.mbti:
        return true;
      case PsyTestType.persona:
      case PsyTestType.cognitive:
        return false;
    }
  }
  
  /// 사용 가능한 테스트 목록 반환
  static List<PsyTestType> get availableTests {
    return PsyTestType.values.where((type) => isTestAvailable(type)).toList();
  }
}
