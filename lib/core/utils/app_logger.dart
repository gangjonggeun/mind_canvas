import 'package:logger/logger.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

/// 🎯 Mind Canvas 전용 로거 설정
/// 
/// **특징:**
/// - 개발/프로덕션 환경 자동 구분
/// - 색상/이모지로 가독성 향상  
/// - 메모리 효율적인 로깅
/// - 파일 출력 지원 (필요시)
class AppLogger {
  static late final Logger _logger;
  static bool _isInitialized = false;

  /// 🏷️ 로그 태그 상수들
  static const String tagUI = '🎨 UI';
  static const String tagAPI = '🌐 API';
  static const String tagCache = '💾 Cache';
  static const String tagAuth = '🔐 Auth';
  static const String tagNavigation = '🧭 Nav';
  static const String tagState = '📊 State';
  static const String tagHTP = '🏠 HTP';
  static const String tagTaro = '🔮 Taro';
  static const String tagAnalysis = '📈 Analysis';
  static const String tagRecommendation = '🎬 Recommend';

  /// 🚀 로거 초기화
  static void initialize() {
    if (_isInitialized) return;

    _logger = Logger(
      filter: _getLogFilter(),
      printer: _getLogPrinter(),
      output: _getLogOutput(),
      level: _getLogLevel(),
    );

    _isInitialized = true;
    
    // 초기화 완료 로그
    i('Logger 초기화 완료! 🎉');
    if (kDebugMode) {
      d('디버그 모드 활성화 - 모든 로그가 표시됩니다');
    }
  }

  /// 🎯 로그 레벨 결정
  static Level _getLogLevel() {
    if (kDebugMode) {
      return Level.debug; // 개발시: 모든 로그 표시
    } else if (kProfileMode) {
      return Level.info;  // 프로파일링: 중요한 로그만
    } else {
      return Level.error; // 릴리즈: 에러만
    }
  }

  /// 🎨 프린터 설정 (색상, 이모지)
  static LogPrinter _getLogPrinter() {
    return PrettyPrinter(
      methodCount: kDebugMode ? 2 : 0,        // 스택트레이스 깊이
      errorMethodCount: 8,                     // 에러시 더 많은 정보
      lineLength: 120,                         // 콘솔 라인 길이
      colors: true,                            // 색상 활성화
      printEmojis: true,                       // 이모지 활성화  
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      excludeBox: {
        Level.debug: true,   // debug는 박스 제거 (간결)
        Level.trace: true,   // trace도 박스 제거
      },
      noBoxingByDefault: kReleaseMode,        // 릴리즈에서는 박스 없음
    );
  }

  /// 🔍 필터 설정 (어떤 로그를 표시할지)
  static LogFilter _getLogFilter() {
    return ProductionFilter(); // 릴리즈에서 자동으로 필터링
  }

  /// 📤 출력 설정
  static LogOutput _getLogOutput() {
    if (kDebugMode) {
      return ConsoleOutput(); // 개발시: 콘솔만
    } else {
      // 필요시 파일 출력 추가 가능
      return ConsoleOutput();
    }
  }

  /// ===== 🎯 편의 메서드들 =====

  /// 🟢 디버그 로그 (개발시에만 표시)
  static void d(String message, [String tag = '']) {
    _ensureInitialized();
    _logger.d('${tag.isNotEmpty ? '[$tag] ' : ''}$message');
  }

  /// 🔵 정보 로그 (중요한 정보)
  static void i(String message, [String tag = '']) {
    _ensureInitialized();
    _logger.i('${tag.isNotEmpty ? '[$tag] ' : ''}$message');
  }

  /// 🟡 경고 로그 (주의 필요)
  static void w(String message, [String tag = '']) {
    _ensureInitialized();
    _logger.w('${tag.isNotEmpty ? '[$tag] ' : ''}$message');
  }

  /// 🔴 에러 로그 (문제 발생)
  static void e(String message, [Object? error, StackTrace? stackTrace, String tag = '']) {
    _ensureInitialized();
    _logger.e('${tag.isNotEmpty ? '[$tag] ' : ''}$message', error: error, stackTrace: stackTrace);
  }

  /// 🟣 추적 로그 (매우 상세한 정보) - trace 대신 debug 사용
  static void t(String message, [String tag = '']) {
    _ensureInitialized();
    _logger.d('[TRACE]${tag.isNotEmpty ? '[$tag] ' : ''} $message');
  }

  /// ===== 🎨 특화 메서드들 (Mind Canvas 전용) =====

  /// 🎨 UI 관련 로그
  static void ui(String message) => d(message, tagUI);

  /// 🌐 API 관련 로그  
  static void api(String message) => i(message, tagAPI);

  /// 💾 캐시 관련 로그
  static void cache(String message) => d(message, tagCache);

  /// 🔐 인증 관련 로그
  static void auth(String message) => i(message, tagAuth);

  /// 🧭 네비게이션 로그
  static void navigation(String message) => d(message, tagNavigation);

  /// 📊 상태 관리 로그  
  static void state(String message) => d(message, tagState);

  /// 🏠 HTP 관련 로그
  static void htp(String message) => i(message, tagHTP);

  /// 🔮 타로 관련 로그
  static void taro(String message) => i(message, tagTaro);

  /// 📈 분석 관련 로그
  static void analysis(String message) => i(message, tagAnalysis);

  /// 🎬 추천 관련 로그 - 명시적으로 정의
  static void recommendation(String message) => i(message, tagRecommendation);

  /// ===== 🛠️ 내부 메서드들 =====

  /// 초기화 확인 - void 반환으로 변경
  static void _ensureInitialized() {
    if (!_isInitialized) {
      initialize();
    }
  }

  /// 🧹 정리 (앱 종료시 호출)
  static void dispose() {
    if (_isInitialized) {
      i('Logger 정리 완료 👋');
      _isInitialized = false;
    }
  }
}

/// 🎯 글로벌 로거 인스턴스 (편의용) - 타입을 명시적으로 선언
class Logger_ {
  // 🟢 디버그 로그 (개발시에만 표시)
  static void d(String message, [String tag = '']) => AppLogger.d(message, tag);

  // 🔵 정보 로그 (중요한 정보)
  static void i(String message, [String tag = '']) => AppLogger.i(message, tag);

  // 🟡 경고 로그 (주의 필요)
  static void w(String message, [String tag = '']) => AppLogger.w(message, tag);

  // 🔴 에러 로그 (문제 발생)
  static void e(String message, [Object? error, StackTrace? stackTrace, String tag = '']) => 
      AppLogger.e(message, error, stackTrace, tag);

  // 🟣 추적 로그
  static void t(String message, [String tag = '']) => AppLogger.t(message, tag);

  // ===== 🎨 특화 메서드들 =====
  static void ui(String message) => AppLogger.ui(message);
  static void api(String message) => AppLogger.api(message);
  static void cache(String message) => AppLogger.cache(message);
  static void auth(String message) => AppLogger.auth(message);
  static void navigation(String message) => AppLogger.navigation(message);
  static void state(String message) => AppLogger.state(message);
  static void htp(String message) => AppLogger.htp(message);
  static void taro(String message) => AppLogger.taro(message);
  static void analysis(String message) => AppLogger.analysis(message);
  
  /// 🎬 추천 관련 로그 - 명시적 정의
  static void recommendation(String message) => AppLogger.recommendation(message);
}

/// 편의용 글로벌 인스턴스
// const logger = Logger_();

/// ===== 🎨 사용법 예시 =====
/// 
/// ```dart
/// // 기본 사용법
/// logger.d('디버그 메시지');
/// logger.i('정보 메시지'); 
/// logger.w('경고 메시지');
/// logger.e('에러 메시지', error, stackTrace);
/// 
/// // 태그와 함께 사용
/// logger.d('UI 업데이트 완료', AppLogger.tagUI);
/// logger.api('API 호출 성공');
/// logger.cache('캐시에서 데이터 로드');
/// 
/// // 특화 메서드 사용
/// logger.recommendation('추천 컨텐츠 로딩 시작');
/// logger.htp('HTP 그리기 시작');
/// logger.taro('타로 카드 선택: ${card.name}');
/// ```
