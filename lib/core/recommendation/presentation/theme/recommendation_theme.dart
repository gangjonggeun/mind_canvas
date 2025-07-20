import 'package:flutter/material.dart';

/// 🎨 추천 시스템 전용 색상 팔레트
/// 
/// 라이트모드와 다크모드를 모두 지원하는 색상 시스템
/// - 메모리 효율적인 상수 기반 구조
/// - 접근성을 고려한 대비율
/// - 브랜드 일관성 유지
class RecommendationColors {
  RecommendationColors._();

  // ✨ 메인 브랜드 색상
  static const Color primary = Color(0xFF6B73FF);
  static const Color primaryDark = Color(0xFF5A63E8);
  static const Color primaryLight = Color(0xFF8B93FF);
  
  static const Color secondary = Color(0xFF4ECDC4);
  static const Color secondaryDark = Color(0xFF3BB8B0);
  static const Color secondaryLight = Color(0xFF6ED7D0);
  
  static const Color accent = Color(0xFF9F7AEA);
  static const Color accentDark = Color(0xFF8B5CF6);
  static const Color accentLight = Color(0xFFB794F6);

  // 🎯 카테고리별 색상
  static const Color dramaMovie = Color(0xFFE53E3E);
  static const Color game = Color(0xFF3182CE);
  static const Color bookWebtoon = Color(0xFFD69E2E);
  static const Color musicPlaylist = Color(0xFF805AD5);
  static const Color travel = Color(0xFF38A169);
  static const Color food = Color(0xFFDD6B20);

  // 📊 상태별 색상
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFD69E2E);
  static const Color error = Color(0xFFE53E3E);
  static const Color info = Color(0xFF3182CE);

  // 🌞 라이트 모드 색상
  static const Color lightBackground = Color(0xFFF7F9FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSecondaryBackground = Color(0xFFF8FAFC);
  static const Color lightPrimaryText = Color(0xFF2D3748);
  static const Color lightSecondaryText = Color(0xFF64748B);
  static const Color lightTertiaryText = Color(0xFF94A3B8);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightDivider = Color(0xFFE2E8F0);

  // 🌙 다크 모드 색상
  static const Color darkBackground = Color(0xFF1A202C);
  static const Color darkSurface = Color(0xFF2D3748);
  static const Color darkSecondaryBackground = Color(0xFF4A5568);
  static const Color darkPrimaryText = Color(0xFFE2E8F0);
  static const Color darkSecondaryText = Color(0xFFA0AEC0);
  static const Color darkTertiaryText = Color(0xFF718096);
  static const Color darkBorder = Color(0xFF4A5568);
  static const Color darkDivider = Color(0xFF4A5568);

  // 💫 그라데이션 색상
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, Color(0xFF44A08D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFF667EEA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 🎨 컨텍스트별 색상 가져오기
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : lightBackground;
  }

  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurface
        : lightSurface;
  }

  static Color getPrimaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkPrimaryText
        : lightPrimaryText;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSecondaryText
        : lightSecondaryText;
  }

  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBorder
        : lightBorder;
  }

  // 📈 유사도별 색상
  static Color getSimilarityColor(double similarity) {
    if (similarity >= 0.8) return success;
    if (similarity >= 0.6) return warning;
    if (similarity >= 0.4) return Color(0xFFED8936);
    return error;
  }

  // 🏷️ 성격 태그별 색상
  static const Map<String, Color> personalityColors = {
    'creative': Color(0xFF9F7AEA),
    'social': Color(0xFF4ECDC4),
    'planned': Color(0xFF3182CE),
    'adventurous': Color(0xFFE53E3E),
    'curious': Color(0xFFD69E2E),
    'traditional': Color(0xFF38A169),
    'spontaneous': Color(0xFFED8936),
    'analytical': Color(0xFF805AD5),
    'empathetic': Color(0xFFE53E3E),
    'independent': Color(0xFF667EEA),
  };

  // 📱 플랫폼별 색상 (iOS/Android 적응)
  static Color getAdaptiveAccentColor(BuildContext context) {
    final platform = Theme.of(context).platform;
    switch (platform) {
      case TargetPlatform.iOS:
        return const Color(0xFF007AFF); // iOS Blue
      case TargetPlatform.android:
        return primary; // Material You
      default:
        return primary;
    }
  }
}

/// 🎭 추천 시스템 테마 확장
class RecommendationTheme {
  RecommendationTheme._();

  // 📏 스페이싱 상수
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 20.0;
  static const double spacingXXL = 24.0;
  static const double spacingXXXL = 32.0;

  // 📐 보더 반지름
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;

  // 🎯 그림자
  static List<BoxShadow> getLightShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: (isDark ? Colors.black : Colors.black).withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ];
  }

  static List<BoxShadow> getMediumShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: (isDark ? Colors.black : Colors.black).withOpacity(0.1),
        blurRadius: 15,
        offset: const Offset(0, 6),
      ),
    ];
  }

  static List<BoxShadow> getHeavyShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: (isDark ? Colors.black : Colors.black).withOpacity(0.15),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ];
  }

  // ✨ 특수 효과
  static List<BoxShadow> getGlowShadow(Color color) {
    return [
      BoxShadow(
        color: color.withOpacity(0.3),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ];
  }

  // 📱 반응형 크기
  static double getResponsiveSize(BuildContext context, {
    required double mobile,
    required double tablet,
    double? desktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return desktop ?? tablet;
    if (screenWidth > 600) return tablet;
    return mobile;
  }

  // 🎨 컨테이너 데코레이션
  static BoxDecoration getCardDecoration(BuildContext context, {
    Color? color,
    double? radius,
    List<BoxShadow>? shadows,
    Border? border,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: color ?? (isDark ? RecommendationColors.darkSurface : RecommendationColors.lightSurface),
      borderRadius: BorderRadius.circular(radius ?? radiusL),
      boxShadow: shadows ?? getLightShadow(context),
      border: border,
    );
  }

  static BoxDecoration getGradientDecoration({
    required LinearGradient gradient,
    double? radius,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius ?? radiusL),
      boxShadow: shadows,
    );
  }

  // 📝 텍스트 스타일
  static TextStyle getHeadingStyle(BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 24,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? RecommendationColors.getPrimaryTextColor(context),
      height: 1.2,
    );
  }

  static TextStyle getBodyStyle(BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? RecommendationColors.getSecondaryTextColor(context),
      height: 1.4,
    );
  }

  static TextStyle getCaptionStyle(BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 12,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? RecommendationColors.getSecondaryTextColor(context),
      height: 1.3,
    );
  }
}
