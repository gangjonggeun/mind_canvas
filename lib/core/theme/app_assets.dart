/// Mind Canvas 앱 전용 에셋 경로 관리
/// 
/// 타입 안전한 에셋 경로 관리 시스템
/// - 컴파일 타임 에러 방지
/// - 중앙집중식 에셋 관리
/// - 메모리 효율적인 에셋 로딩
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;

/// 디자인 시스템 상수
/// 반응형 디자인 시스템 상수
class AppDimensions {
  AppDimensions._();

  // ===== 📱 화면 크기 임계값 =====
  static const double smallScreenWidth = 360.0;   // 작은 폰 (기본 기준)
  static const double mediumScreenWidth = 400.0;  // 중간 폰
  static const double largeScreenWidth = 450.0;   // 큰 폰

  // ===== 🎯 랭킹 카드 반응형 디자인 =====
  /// 화면 크기에 따른 랭킹 카드 너비
  static double getRankingCardWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth <= smallScreenWidth) {
      return 150.0;  // 작은 폰: 좌우 여백 고려하여 작게
    } else if (screenWidth <= mediumScreenWidth) {
      return 165.0;  // 중간 폰
    } else {
      return 180.0;  // 큰 폰: 기존 크기 유지
    }
  }

  /// 화면 크기에 따른 랭킹 카드 이미지 높이
  static double getRankingCardImageHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth <= smallScreenWidth) {
      return 130.0;  // 작은 폰: 비율 유지하면서 작게
    } else if (screenWidth <= mediumScreenWidth) {
      return 145.0;  // 중간 폰
    } else {
      return 160.0;  // 큰 폰: 기존 크기
    }
  }

  /// 화면 크기에 따른 랭킹 카드 전체 높이
  static double getRankingCardTotalHeight(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth <= smallScreenWidth) {
      return 210.0;  // 작은 폰
    } else if (screenWidth <= mediumScreenWidth) {
      return 225.0;  // 중간 폰
    } else {
      return 240.0;  // 큰 폰
    }
  }

  // ===== 📝 폰트 크기 반응형 =====
  /// 화면 크기에 따른 카드 제목 폰트 크기
  static double getRankingCardTitleFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth <= smallScreenWidth) {
      return 12.0;   // 작은 폰: 작게
    } else if (screenWidth <= mediumScreenWidth) {
      return 12.5;   // 중간 폰
    } else {
      return 13.0;   // 큰 폰: 기존 크기
    }
  }

  /// 화면 크기에 따른 참여자 수 폰트 크기
  static double getRankingCardParticipantFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth <= smallScreenWidth) {
      return 10.0;   // 작은 폰
    } else if (screenWidth <= mediumScreenWidth) {
      return 10.5;   // 중간 폰
    } else {
      return 11.0;   // 큰 폰
    }
  }

  /// 화면 크기에 따른 랭킹 배지 폰트 크기
  static double getRankingCardRankBadgeFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth <= smallScreenWidth) {
      return 10.0;   // 작은 폰
    } else if (screenWidth <= mediumScreenWidth) {
      return 10.5;   // 중간 폰
    } else {
      return 11.0;   // 큰 폰
    }
  }

  // ===== 📏 패딩 및 여백 반응형 =====
  /// 화면 크기에 따른 카드 패딩
  static double getRankingCardPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth <= smallScreenWidth) {
      return 10.0;   // 작은 폰: 패딩 줄임
    } else if (screenWidth <= mediumScreenWidth) {
      return 11.0;   // 중간 폰
    } else {
      return 12.0;   // 큰 폰: 기존 크기
    }
  }

  /// 화면 크기에 따른 카드 간 간격
  static double getRankingCardSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth <= smallScreenWidth) {
      return 8.0;    // 작은 폰: 간격 줄임
    } else if (screenWidth <= mediumScreenWidth) {
      return 10.0;   // 중간 폰
    } else {
      return 12.0;   // 큰 폰: 기존 간격
    }
  }

  // ===== 📱 전체 레이아웃 반응형 =====
  /// 화면 크기에 따른 메인 패딩
  static double getMainPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth <= smallScreenWidth) {
      return 16.0;   // 작은 폰: 좌우 여백 줄임
    } else if (screenWidth <= mediumScreenWidth) {
      return 18.0;   // 중간 폰
    } else {
      return 20.0;   // 큰 폰: 기존 크기
    }
  }

  // ===== 🎨 기존 상수들 (호환성 유지) =====
  static const double rankingCardBorderRadius = 16.0;
  static const double fallbackIconSize = 40.0;
  static const double fallbackTextSize = 12.0;

  // 기존 상수들 (단계적 마이그레이션을 위해 유지)
  static const double rankingCardWidth = 180.0;
  static const double rankingCardImageHeight = 160.0;
  static const double rankingCardTotalHeight = 240.0;
  static const double rankingCardPadding = 12.0;
  static const double rankingCardTitleFontSize = 13.0;
  static const double rankingCardParticipantFontSize = 11.0;
  static const double rankingCardRankBadgeFontSize = 11.0;
}

class AppAssets {
  AppAssets._();

  // ===== 📁 Base Paths =====
  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _animationsPath = 'assets/animations';
  static const String _fontsPath = 'assets/fonts';
  static const String _illustrationsPath = 'assets/illustrations';

  // ===== 🖼️ Images (WebP 변환 완료) =====
  // HTP 페이지 뷰 이미지 - WebP 버전
  static const String htpPageViewHigh = '$_imagesPath/htp_pageview/htp_view_pager_high.webp';
  static const String htpPageViewMid = '$_imagesPath/htp_pageview/htp_view_pager_mid.webp';
  static const String htpPageViewLow = '$_imagesPath/htp_pageview/htp_view_pager_low.webp';
  
  // 타로 카드 이미지 - WebP 버전
  static const String taroHigh = '$_imagesPath/taro_pageview/taro_high.webp';
  static const String taro2High = '$_imagesPath/taro_pageview/taro2_high.webp';
  
  // 페르소나 테스트 이미지 - WebP 버전
  static const String personaPageViewHigh = '$_imagesPath/persona_pageview/persona_pageview_high.webp';
  
  // 기타 이미지 - WebP 버전
  static const String treeHizzi = '$_imagesPath/tree_hizzi.webp';

  // ===== 🎨 Illustrations (WebP 변환 완료) =====
  static const String mbtiItemHigh = '$_illustrationsPath/item/mbti_item_high.webp';
  static const String personaItemHigh = '$_illustrationsPath/item/persona_item_high.webp';
  static const String headspaceItemHigh = '$_illustrationsPath/item/headspace_item_high.webp';

  // ===== 🎯 Icons (PNG 유지 - 작은 파일) =====
  static const String htpTreeIcon = '$_iconsPath/htp_tree_128_icon.png';
  static const String taroIcon = '$_iconsPath/taro_icon.png'; // 타로 아이콘 (추후 추가)
  
  // TODO: 다른 아이콘들 추가 예정
  // static const String personalityIcon = '$_iconsPath/personality_icon.png';
  // static const String freeDrawIcon = '$_iconsPath/free_draw_icon.png';
  // static const String emotionIcon = '$_iconsPath/emotion_icon.png';

  // ===== 🎭 Animations =====
  // TODO: Lottie 애니메이션 파일들 추가 예정
  // static const String loadingAnimation = '$_animationsPath/loading.json';
  // static const String successAnimation = '$_animationsPath/success.json';

  // ===== 🔤 Fonts =====
  // TODO: 커스텀 폰트 추가 시
  // static const String pretendardRegular = '$_fontsPath/Pretendard-Regular.ttf';
  // static const String pretendardBold = '$_fontsPath/Pretendard-Bold.ttf';

  // ===== 🌐 Network Images (Fallback URLs) =====
  static const String fallbackImageMind = 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=300&fit=crop&auto=format';
  static const String fallbackImageAnalysis = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop&auto=format';
  static const String fallbackImagePromo = 'https://images.unsplash.com/photo-1493612276216-ee3925520721?w=600&h=200&fit=crop&auto=format';

  // ===== 🔄 Fallback 지원 (이전 버전 호환성) =====
  // WebP 지원 안될 때 PNG 대체
  static const String htpPageViewHighPng = '$_imagesPath/htp_pageview/htp_view_pager_high.png';
  static const String htpPageViewMidPng = '$_imagesPath/htp_pageview/htp_view_pager_mid.png';
  static const String htpPageViewLowPng = '$_imagesPath/htp_pageview/htp_view_pager_low.png';
  static const String taroHighPng = '$_imagesPath/taro_pageview/taro_high.png';
  static const String taro2HighPng = '$_imagesPath/taro_pageview/taro2_high.png';
  static const String personaPageViewHighPng = '$_imagesPath/persona_pageview/persona_pageview_high.png';
  static const String mbtiItemHighPng = '$_illustrationsPath/mbti_item_high.png';
  static const String personaItemHighPng = '$_illustrationsPath/persona_item_high.png';
  static const String headspaceItemHighPng = '$_illustrationsPath/headspace_item_high.png';

  /// 에셋 존재 여부 검증 (디버그 모드에서만)
  static bool isAssetExists(String assetPath) {
    // TODO: 개발 환경에서 에셋 존재 여부 확인 로직 추가
    // assert 모드에서만 동작하도록 구현
    return true;
  }

  /// 🛟 WebP 지원 여부에 따른 이미지 경로 반환
  static String getImagePath(String webpPath, String pngPath) {
    // 일단 WebP 우선 반환 (Flutter 3.0+ 에서 기본 지원)
    return webpPath;
    
    // TODO: 나중에 실제 WebP 지원 여부 검사 로직 추가
    // if (Platform.isIOS && iosVersionLessThan14) {
    //   return pngPath; // iOS 14 미만에서는 PNG 사용
    // }
    // return webpPath;
  }
}

/// 이미지 로딩 헬퍼 클래스
class AppImageHelper {
  AppImageHelper._();

  /// 고선명도 에셋 이미지 로딩 (최고 품질 우선)
  static Widget assetImage(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    String? semanticLabel,
    bool isHighQuality = true,
  }) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      semanticLabel: semanticLabel,
      // 🎯 최고 품질 설정
      filterQuality: isHighQuality ? FilterQuality.high : FilterQuality.medium,
      isAntiAlias: true,
      gaplessPlayback: true,  // 이미지 전환 시 깜빡임 방지
      errorBuilder: (context, error, stackTrace) {
        print('❌ Error loading asset image: $assetPath - $error');
        return _buildErrorWidget(width, height, assetPath);
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return _buildLoadingWidget(width, height);
      },
    );
  }

  /// 로딩 위젯 빌더
  static Widget _buildLoadingWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF667EEA).withOpacity(0.1),
            const Color(0xFF764BA2).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF667EEA).withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '이미지 로딩 중...',
            style: const TextStyle(
              color: Color(0xFF718096),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 에러 위젯 빌더
  static Widget _buildErrorWidget(double? width, double? height, String assetPath) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.withOpacity(0.1),
            Colors.orange.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            color: const Color(0xFF718096),
            size: 32,
          ),
          const SizedBox(height: 6),
          Text(
            '이미지 로딩 실패',
            style: const TextStyle(
              color: Color(0xFF718096),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 에셋 경로에 따른 기본 아이콘 반환
  static IconData _getAssetIcon(String assetPath) {
    if (assetPath.contains('mbti')) {
      return Icons.psychology;
    } else if (assetPath.contains('htp') || assetPath.contains('persona')) {
      return Icons.home;
    } else if (assetPath.contains('headspace')) {
      return Icons.self_improvement;
    } else {
      return Icons.image;
    }
  }

  /// 고선명도 네트워크 이미지 로딩 (cached_network_image 사용)
  static Widget networkImage(
    String imageUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    String? semanticLabel,
    Widget? placeholder,
    Widget? errorWidget,
    bool isHighQuality = true,
    Duration? fadeInDuration,
  }) {
    // Import 해야 함: import 'package:cached_network_image/cached_network_image.dart';
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      // 🎯 최고 품질 설정
      filterQuality: isHighQuality ? FilterQuality.high : FilterQuality.medium,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 200),
      placeholder: (context, url) => placeholder ?? _buildNetworkLoadingWidget(width, height),
      errorWidget: (context, url, error) {
        print('❌ Network image load failed: $imageUrl - $error');
        return errorWidget ?? _buildNetworkErrorWidget(width, height);
      },
      // 메모리 최적화
      memCacheWidth: width != null ? (width * 2).round() : null,
      memCacheHeight: height != null ? (height * 2).round() : null,
      maxWidthDiskCache: 1200,
      maxHeightDiskCache: 1200,
    );
  }

  /// 네트워크 이미지 로딩 위젯
  static Widget _buildNetworkLoadingWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF667EEA).withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '로딩 중...',
            style: const TextStyle(
              color: Color(0xFF718096),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 네트워크 이미지 에러 위젯
  static Widget _buildNetworkErrorWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            color: const Color(0xFF94A3B8),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            '이미지 로딩 실패',
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
