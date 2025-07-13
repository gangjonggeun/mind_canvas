import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Mind Canvas 앱 전용 테마 시스템
/// 
/// Material Design 3 기반으로 심리테스트 앱에 최적화된 테마
/// - 메모리 효율적인 테마 관리
/// - 일관된 텍스트 스타일
/// - 접근성 고려한 색상 대비
class AppTheme {
  AppTheme._();

  /// 라이트 테마
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // ===== 🎨 Color Scheme =====
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        primaryContainer: AppColors.primaryBlueLight,
        secondary: AppColors.secondaryTeal,
        secondaryContainer: AppColors.secondaryTeal,
        surface: AppColors.backgroundCard,
        background: AppColors.backgroundPrimary,
        error: AppColors.statusError,
        onPrimary: AppColors.textWhite,
        onSecondary: AppColors.textWhite,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: AppColors.textWhite,
      ),
      
      // ===== 📱 Scaffold =====
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      
      // ===== 📄 App Bar =====
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundCard,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // ===== 🔘 Card =====
      cardTheme: CardThemeData(
        color: AppColors.backgroundCard,
        elevation: 2,
        shadowColor: AppColors.withOpacity10(AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // ===== 🔲 Button Themes =====
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.textWhite,
          elevation: 2,
          shadowColor: AppColors.withOpacity30(AppColors.primaryBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      
      // ===== 📝 Text Theme =====
      textTheme: const TextTheme(
        // 큰 제목 (32px)
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
        // 중간 제목 (24px)
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
        // 작은 제목 (20px)
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        // 본문 대형 (16px)
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        // 본문 중형 (14px)
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
          height: 1.4,
        ),
        // 본문 소형 (12px)
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.textTertiary,
          height: 1.4,
        ),
        // 라벨 대형 (14px)
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        // 라벨 중형 (12px)
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        // 라벨 소형 (11px)
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textTertiary,
        ),
      ),
      
      // ===== 📊 Divider =====
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),
      
      // ===== 📝 Input Decoration =====
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.statusError),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
  
  /// 다크 테마 (향후 구현 예정)
  static ThemeData get darkTheme {
    // TODO: 다크 모드 구현 시 추가
    return lightTheme;
  }
}

/// 커스텀 텍스트 스타일
class AppTextStyles {
  AppTextStyles._();
  
  /// HTP 제목 스타일 (큰 제목 + 그림자 + 반투명 느낌)
  static const TextStyle htpTitle = TextStyle(
    color: AppColors.textWhite,
    fontSize: 28,  // 조금 작게
    fontWeight: FontWeight.w600,  // 조금 연하게
    height: 1.2,
    shadows: [
      Shadow(
        color: Color(0x80000000),  // 적당한 그림자
        offset: Offset(1, 1),
        blurRadius: 3,
      ),
    ],
  );
  
  /// 카드 제목 스타일
  static const TextStyle cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  /// 카드 부제목 스타일
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
  
  /// 상태 라벨 스타일
  static const TextStyle statusLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
}
