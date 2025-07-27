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

  // ===== result 결과 창 컬러 =====
  static const Color grey700 = Color(0xFF616161);
  static const Color slateGrey = Color(0xFF4A5568);

  // ===== 🎨 Primary Brand Colors =====
  static const Color primary = Color(0xFF6B73FF);           // 메인 프라이머리 색상
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

/// 타로 전용 색상 시스템
/// 
/// 신비로운 분위기의 타로 카드 인터페이스를 위한 특화 색상
class TaroColors {
  TaroColors._();
  
  // ===== 🔮 Primary Taro Colors =====
  static const Color mysticalPurple = Color(0xFF6B46C1);     // 신비로운 보라
  static const Color deepIndigo = Color(0xFF4C1D95);         // 깊은 남보라
  static const Color cosmicBlue = Color(0xFF3730A3);         // 우주적 블루
  static const Color enchantedTeal = Color(0xFF0F766E);      // 마법의 틸
  static const Color goldenAmber = Color(0xFFD97706);        // 황금 앰버
  static const Color mysticSilver = Color(0xFF64748B);       // 신비로운 은색
  
  // ===== 🌙 Background Colors =====
  static const Color backgroundDark = Color(0xFF111827);      // 어두운 배경
  static const Color backgroundMystic = Color(0xFF1F2937);    // 신비로운 배경
  static const Color backgroundCard = Color(0xFF374151);      // 카드 배경
  static const Color backgroundOverlay = Color(0x80000000);   // 오버레이 (50% 검은색)
  static const Color backgroundGradientStart = Color(0xFF1E293B); // 그라데이션 시작
  static const Color backgroundGradientEnd = Color(0xFF0F172A);   // 그라데이션 끝
  
  // ===== ✨ Accent Colors =====
  static const Color accentGold = Color(0xFFFBBF24);         // 액센트 골드
  static const Color accentSilver = Color(0xFFE5E7EB);       // 액센트 실버
  static const Color accentCrystal = Color(0xFFDDD6FE);      // 크리스탈 색상
  static const Color accentAura = Color(0xFFFEF3C7);         // 오라 색상
  
  // ===== 🃏 Card States =====
  static const Color cardSelected = Color(0xFFFBBF24);       // 선택된 카드
  static const Color cardHover = Color(0xFFDDD6FE);          // 호버 상태
  static const Color cardDisabled = Color(0xFF6B7280);       // 비활성 상태
  static const Color cardBorder = Color(0xFF9CA3AF);         // 카드 테두리
  static const Color cardShadow = Color(0x40000000);         // 카드 그림자 (25% 검은색)
  
  // ===== 📝 Text Colors for Taro =====
  static const Color textMystic = Color(0xFFF9FAFB);         // 신비로운 텍스트
  static const Color textSecondary = Color(0xFFD1D5DB);      // 보조 텍스트
  static const Color textMuted = Color(0xFF9CA3AF);          // 흐린 텍스트
  static const Color textAccent = Color(0xFFFBBF24);         // 강조 텍스트
  static const Color textWarning = Color(0xFFF59E0B);        // 경고 텍스트
  
  // ===== 🌈 Gradient Collections =====
  static const List<Color> gradientMystic = [
    Color(0xFF6B46C1),
    Color(0xFF3730A3),
  ];
  
  static const List<Color> gradientCosmic = [
    Color(0xFF1E293B),
    Color(0xFF0F172A),
  ];
  
  static const List<Color> gradientGolden = [
    Color(0xFFFBBF24),
    Color(0xFFD97706),
  ];
  
  static const List<Color> gradientEnchanted = [
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
  ];
  
  // ===== 🎭 Spread Type Colors =====
  static const Color spread3Card = Color(0xFF10B981);        // 3장 스프레드
  static const Color spread5Card = Color(0xFF3B82F6);        // 5장 스프레드
  static const Color spread7Card = Color(0xFF8B5CF6);        // 7장 스프레드
  static const Color spread10Card = Color(0xFFEF4444);       // 10장 스프레드
  
  // ===== 🔮 Status Colors =====
  static const Color statusReading = Color(0xFF8B5CF6);      // 리딩 중
  static const Color statusComplete = Color(0xFF10B981);     // 완료
  static const Color statusError = Color(0xFFEF4444);        // 오류
  static const Color statusLoading = Color(0xFFF59E0B);      // 로딩
  
  // ===== 🌟 Helper Methods =====
  
  /// 투명도 적용된 색상 반환
  static Color withMysticOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  /// 스프레드 타입별 색상 반환
  static Color getSpreadColor(int cardCount) {
    switch (cardCount) {
      case 3:
        return spread3Card;
      case 5:
        return spread5Card;
      case 7:
        return spread7Card;
      case 10:
        return spread10Card;
      default:
        return mysticalPurple;
    }
  }
  
  /// 카드 상태별 색상 반환
  static Color getCardStateColor(bool isSelected, bool isHovered, bool isDisabled) {
    if (isDisabled) return cardDisabled;
    if (isSelected) return cardSelected;
    if (isHovered) return cardHover;
    return cardBorder;
  }
}
