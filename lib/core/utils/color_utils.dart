import 'package:flutter/material.dart';

/// 🎨 색상 유틸리티 클래스 v2.0
/// 파스텔 배경에서도 아름다우면서 가독성 좋은 색상 전문 클래스
class ColorUtils {
  ColorUtils._();

  /// 🎨 스마트 텍스트 색상 결정 (파스텔에서도 예쁜 색상)
  static Color getSmartTextColor(String bgGradientStart, {String? tag}) {
    try {
      final bgColor = Color(int.parse(bgGradientStart, radix: 16));
      final luminance = bgColor.computeLuminance();
      final saturation = HSVColor.fromColor(bgColor).saturation;
      
      // 파스텔 색상 감지 (높은 명도 + 낮은 채도)
      final isPastel = luminance > 0.7 && saturation < 0.6;
      
      if (isPastel) {
        // 🌈 파스텔 배경 → 태그별 아름다운 중간톤 색상 (가독성 + 미감)
        return _getPastelFriendlyColor(tag, bgColor) ?? const Color(0xFF2D3748);
      } else if (luminance > 0.5) {
        // 일반 밝은 색 → 태그별 색상 또는 어두운 텍스트
        return _getTagBasedColor(tag) ?? const Color(0xFF2D3748);
      } else {
        // 어두운 색 → 밝은 텍스트
        return Colors.white;
      }
    } catch (e) {
      return const Color(0xFF2D3748); // 안전한 기본값
    }
  }

  /// 🌈 파스텔 배경용 아름다운 색상 팔레트
  static Color? _getPastelFriendlyColor(String? tag, Color bgColor) {
    if (tag == null) return null;
    
    // Mind Canvas MBTI 전용 - 전문적이고 신뢰감 있는 색상
    if (tag == 'MBTI' || tag == 'ENFP' || tag == '심리성장') {
      return Color(0xFF4338CA); // 딥 인디고 (전문성 + 신뢰성)
    }
    
    // 배경색의 색조(Hue)를 분석해서 조화로운 색상 선택
    final bgHue = HSVColor.fromColor(bgColor).hue;
    
    final pastelColors = {
      // 연애/감정계열 → 로맨틱 핑크/레드 톤
      '연애': _getHarmonious(bgHue, [
        Color(0xFFD81B60), // 딥 핑크
        Color(0xFFE91E63), // 미디엄 핑크
        Color(0xFFC2185B), // 다크 핑크
      ]),
      '감정': _getHarmonious(bgHue, [
        Color(0xFF8E24AA), // 딥 퍼플
        Color(0xFF9C27B0), // 미디엄 퍼플
        Color(0xFF7B1FA2), // 다크 퍼플
      ]),
      '사랑': _getHarmonious(bgHue, [
        Color(0xFFE91E63),
        Color(0xFFAD1457),
        Color(0xFFC2185B),
      ]),
      
      // 심리검사계열 → 전문적인 그레이/네이비 톤
      'HTP': _getHarmonious(bgHue, [
        Color(0xFF455A64), // 블루 그레이
        Color(0xFF37474F), // 딥 그레이
        Color(0xFF263238), // 다크 그레이
      ]),
      '그림검사': _getHarmonious(bgHue, [
        Color(0xFF5D4037), // 따뜻한 브라운
        Color(0xFF6D4C41), // 미디엄 브라운
        Color(0xFF4E342E), // 딥 브라운
      ]),
    };
    
    return pastelColors[tag];
  }
  
  /// 🎨 배경 색조와 조화로운 색상 선택
  static Color _getHarmonious(double bgHue, List<Color> candidates) {
    // 배경이 따뜻한 톤(빨강~노랑)인지 차가운 톤(파랑~보라)인지 판단
    final isWarmBackground = (bgHue >= 0 && bgHue <= 60) || (bgHue >= 300);
    
    if (isWarmBackground) {
      // 따뜻한 배경 → 차가운 톤 텍스트 (대비)
      return candidates.last; // 가장 진한 색
    } else {
      // 차가운 배경 → 따뜻한 톤 텍스트 (조화)
      return candidates.first; // 가장 밝은 색
    }
  }

  /// 🎥 태그별 색상 매핑 (비파스텔 배경에서만 사용)
  static Color? _getTagBasedColor(String? tag) {
    if (tag == null) return null;
    
    final tagColors = {
      // 연애/감정계열
      '연애': Color(0xFFE91E63),
      '감정': Color(0xFF9C27B0),
      '사랑': Color(0xFFE91E63),
      
      // MBTI계열 (진한 블루로 통일)
      'MBTI': Color(0xFF1976D2),
      'ENFP': Color(0xFF1976D2),
      'INFP': Color(0xFF1976D2),
      
      // 심리검사계열 (진한 회색으로 통일)
      'HTP': Color(0xFF37474F),
      '그림검사': Color(0xFF37474F),
      '심리분석': Color(0xFF37474F),
      
      // 성격계열
      '성격': Color(0xFF1976D2),
      '특성': Color(0xFF0277BD),
    };
    
    return tagColors[tag];
  }

  /// 🎨 스마트 오버레이 색상 (버튼, 배지용)
  static Color getSmartOverlayColor(String bgGradientStart) {
    final textColor = getSmartTextColor(bgGradientStart);
    
    // 텍스트가 어두우면 어두운 오버레이, 밝으면 밝은 오버레이
    return textColor.computeLuminance() > 0.5 ? Colors.white : Colors.black;
  }

  /// ✨ 파스텔 배경용 강화된 외곽선 스타일 (색상 살리기)
  static List<Shadow> getReadableShadows(String bgGradientStart) {
    try {
      final bgColor = Color(int.parse(bgGradientStart, radix: 16));
      final luminance = bgColor.computeLuminance();
      final saturation = HSVColor.fromColor(bgColor).saturation;
      
      final isPastel = luminance > 0.7 && saturation < 0.6;
      
      if (isPastel) {
        // 🌈 파스텔 → 색상을 살리면서 가독성 확보하는 외곽선
        return [
          // 강한 화이트 외곽선 (배경과 분리)
          Shadow(
            color: Colors.white.withOpacity(0.9),
            offset: const Offset(0, 0),
            blurRadius: 3,
          ),
          // 부드러운 검은 외곽선 (텍스트 정의)
          Shadow(
            color: Colors.black.withOpacity(0.4),
            offset: const Offset(1, 1),
            blurRadius: 2,
          ),
          // 추가 하이라이트
          Shadow(
            color: Colors.white.withOpacity(0.7),
            offset: const Offset(-0.5, -0.5),
            blurRadius: 1,
          ),
        ];
      } else if (luminance > 0.5) {
        // 밝은 색 → 가벼운 그림자
        return [
          Shadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ];
      } else {
        // 어두운 색 → 밝은 외곽선
        return [
          Shadow(
            color: Colors.white.withOpacity(0.2),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ];
      }
    } catch (e) {
      // 안전한 기본값
      return [
        Shadow(
          color: Colors.white.withOpacity(0.8),
          offset: const Offset(0, 0),
          blurRadius: 2,
        ),
        Shadow(
          color: Colors.black.withOpacity(0.3),
          offset: const Offset(1, 1),
          blurRadius: 1,
        ),
      ];
    }
  }

  /// 🎭 반투명 배경 패널 색상 (극강 가독성)
  static Color getReadableBackgroundPanel(String bgGradientStart) {
    final textColor = getSmartTextColor(bgGradientStart);
    
    if (textColor.computeLuminance() > 0.5) {
      // 밝은 텍스트 → 어두운 반투명 배경
      return Colors.black.withOpacity(0.6);
    } else {
      // 어두운 텍스트 → 밝은 반투명 배경
      return Colors.white.withOpacity(0.85);
    }
  }

  /// 🎨 태그별 그래디언트 생성 (미리 정의된 조화로운 색상)
  static LinearGradient getHarmoniousGradient(String? tag) {
    final gradients = {
      '연애': LinearGradient(
        colors: [Color(0xFFFFE5EA), Color(0xFFFF8FA3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'MBTI': LinearGradient(
        colors: [Color(0xFFF8F9FF), Color(0xFFE8EAFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'HTP': LinearGradient(
        colors: [Color(0xFFFFF8E1), Color(0xFFFFCC80)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    };
    
    return gradients[tag] ?? LinearGradient(
      colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// 🎯 색상 대비율 계산 (WCAG 기준)
  static double getContrastRatio(Color color1, Color color2) {
    final lum1 = color1.computeLuminance();
    final lum2 = color2.computeLuminance();
    
    final lightest = lum1 > lum2 ? lum1 : lum2;
    final darkest = lum1 > lum2 ? lum2 : lum1;
    
    return (lightest + 0.05) / (darkest + 0.05);
  }

  /// ✅ 색상 접근성 검사 (4.5:1 비율 권장)
  static bool isAccessible(Color background, Color foreground) {
    return getContrastRatio(background, foreground) >= 4.5;
  }

  /// 🔄 색상 파싱 안전 래퍼
  static Color? safeParseColor(String colorString) {
    try {
      return Color(int.parse(colorString, radix: 16));
    } catch (e) {
      return null;
    }
  }
}

/// 🎨 색상 확장 메서드
extension ColorExtensions on Color {
  /// 색상이 파스텔인지 확인
  bool get isPastel {
    final hsv = HSVColor.fromColor(this);
    return hsv.value > 0.7 && hsv.saturation < 0.6;
  }
  
  /// 색상이 밝은지 확인
  bool get isLight => computeLuminance() > 0.5;
  
  /// 색상이 어두운지 확인
  bool get isDark => computeLuminance() <= 0.5;
  
  /// 반대색 얻기
  Color get opposite => isLight ? Colors.black : Colors.white;
}
