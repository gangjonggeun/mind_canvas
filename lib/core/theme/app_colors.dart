import 'package:flutter/material.dart';

/// Mind Canvas 앱 전용 색상 시스템
/// 
/// 심리테스트 앱에 최적화된 차분하고 전문적인 색상 팔레트
/// - 메모리 효율적인 const 색상 정의
/// - 일관된 브랜딩 색상 관리
/// - 접근성 고려한 명도 대비
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ===== 🎨 Primary Brand Colors =====
  static const Color primaryBlue = Color(0xFF6B73FF);
  static const Color primaryBlueDark = Color(0xFF5A63E8);
  static const Color primaryBlueLight = Color(0xFF8E8FFF);
  
  // ===== 🌈 Secondary Colors =====
  static const Color secondaryTeal = Color(0xFF4ECDC4);
  static const Color secondaryPurple = Color(0xFF667EEA);
  static const Color secondaryIndigo = Color(0xFF764BA2);
  static const Color secondaryMint = Color(0xFF38B2AC);
  
  // ===== 🎯 Background Colors =====
  static const Color backgroundPrimary = Color(0xFFF7F9FC);  // 메인 배경
  static const Color backgroundSecondary = Color(0xFFF8FAFF); // 카드 배경
  static const Color backgroundTertiary = Color(0xFFF0F4FF);  // 강조 배경
  static const Color backgroundCard = Color(0xFFFFFFFF);      // 카드 기본
  
  // ===== 📝 Text Colors =====
  static const Color textPrimary = Color(0xFF2D3748);    // 메인 텍스트
  static const Color textSecondary = Color(0xFF64748B);  // 보조 텍스트
  static const Color textTertiary = Color(0xFF94A3B8);   // 부가 텍스트
  static const Color textWhite = Color(0xFFFFFFFF);      // 흰색 텍스트
  static const Color textWhite70 = Color(0xB3FFFFFF);    // 반투명 흰색
  
  // ===== 🚨 Status Colors =====
  static const Color statusSuccess = Color(0xFF48BB78);   // 성공
  static const Color statusWarning = Color(0xFFED8936);   // 경고
  static const Color statusError = Color(0xFFE53E3E);     // 오류
  static const Color statusInfo = Color(0xFF3182CE);      // 정보
  
  // ===== 🎭 HTP Specific Colors =====
  static const Color htpBackground = Color(0xFFE3F2FD);   // HTP 배경 (밝은 하늘색 #E3F2FD)
  static const Color htpAccent = Color(0xFF6B73FF);       // HTP 강조색
  static const Color htpTextContainer = Color(0x4D000000); // HTP 텍스트 컨테이너 (30% 검은색)
  static const Color htpTextContainerShadow = Color(0x33000000); // HTP 컨테이너 그림자 (20% 검은색)
  
  // ===== 🔘 Border Colors =====
  static const Color borderLight = Color(0xFFE2E8F0);     // 연한 테두리
  static const Color borderMedium = Color(0xFFCBD5E0);    // 중간 테두리
  static const Color borderDark = Color(0xFFA0AEC0);      // 진한 테두리
  
  // ===== ✨ Gradient Colors =====
  static const List<Color> gradientBlue = [
    Color(0xFF6B73FF),
    Color(0xFF8E8FFF),
  ];
  
  static const List<Color> gradientTeal = [
    Color(0xFF4ECDC4),
    Color(0xFF6B73FF),
  ];
  
  static const List<Color> gradientPurple = [
    Color(0xFF667EEA),
    Color(0xFF764BA2),
  ];
  
  static const List<Color> gradientPromo = [
    Color(0xFF6B73FF),
    Color(0xFF4ECDC4),
  ];
  
  // ===== 🎨 Opacity Variants =====
  /// 투명도 10%
  static Color withOpacity10(Color color) => color.withOpacity(0.1);
  
  /// 투명도 20%
  static Color withOpacity20(Color color) => color.withOpacity(0.2);
  
  /// 투명도 30%
  static Color withOpacity30(Color color) => color.withOpacity(0.3);
  
  /// 투명도 80%
  static Color withOpacity80(Color color) => color.withOpacity(0.8);
  
  // ===== 🌙 Dark Mode Colors (Future) =====
  // TODO: 다크 모드 지원 시 추가 예정
  // static const Color darkBackgroundPrimary = Color(0xFF1A202C);
  // static const Color darkTextPrimary = Color(0xFFE2E8F0);
}

/// 심리테스트별 테마 색상
class PsychTestColors {
  PsychTestColors._();
  
  /// HTP 검사 색상
  static const Color htpPrimary = Color(0xFF6B73FF);
  static const Color htpBackground = Color(0xFFE3F2FD); // 밝은 하늘색
  
  /// 타로 카드 색상
  static const Color taroPrimary = Color(0xFF667EEA);
  static const Color taroSecondary = Color(0xFF764BA2);
  static const Color taroBackground = Color(0xFFF0F4FF);
  
  /// 자유화 검사 색상
  static const Color freeDrawPrimary = Color(0xFF4ECDC4);
  static const Color freeDrawBackground = Color(0xFFE6FFFA);
  
  /// 성격 유형 검사 색상
  static const Color personalityPrimary = Color(0xFF667EEA);
  static const Color personalityBackground = Color(0xFFF0F4FF);
  
  /// 정서 분석 색상
  static const Color emotionPrimary = Color(0xFF38B2AC);
  static const Color emotionBackground = Color(0xFFE6FFFA);
}
