import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// 프로필 관련 로깅 서비스
/// 
/// 기능:
/// - 사용자 행동 추적
/// - 성능 모니터링
/// - 에러 로깅
/// - 분석 데이터 수집
/// 
/// 메모리 최적화:
/// - 가벼운 로그 객체 사용 (JSON 직렬화 최소화)
/// - 배치 처리로 네트워크 호출 최소화
/// - 로그 레벨별 필터링으로 불필요한 처리 방지
class ProfileLoggingService {
  static const String _tag = 'ProfileScreen';
  
  // 싱글톤 패턴 - 메모리 효율성
  static final ProfileLoggingService _instance = ProfileLoggingService._internal();
  factory ProfileLoggingService() => _instance;
  ProfileLoggingService._internal();

  // 로그 배치 처리를 위한 버퍼 (메모리 사용량 제한)
  final List<Map<String, dynamic>> _logBuffer = [];
  static const int _maxBufferSize = 50;

  /// 프로필 화면 진입 로그
  void logProfileScreenEntered(String userId) {
    _logInfo('Profile screen entered', {
      'userId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// 프로필 화면 종료 로그
  void logProfileScreenExited(String userId, Duration sessionTime) {
    _logInfo('Profile screen exited', {
      'userId': userId,
      'sessionTimeMs': sessionTime.inMilliseconds,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// 메뉴 클릭 로그
  void logMenuTapped(String userId, String menuId) {
    _logInfo('Menu tapped', {
      'userId': userId,
      'menuId': menuId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// 잉크 충전 버튼 클릭 로그
  void logInkRechargeButtonTapped(String userId, int currentBalance) {
    _logInfo('Ink recharge button tapped', {
      'userId': userId,
      'currentBalance': currentBalance,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// 프로필 이미지 변경 로그
  void logProfileImageChanged(String userId, bool hadPrevious, bool hasNew) {
    _logInfo('Profile image changed', {
      'userId': userId,
      'hadPrevious': hadPrevious,
      'hasNew': hasNew,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// 테마 변경 로그
  void logThemeChanged(String userId, bool isDarkMode) {
    _logInfo('Theme changed', {
      'userId': userId,
      'isDarkMode': isDarkMode,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// 새로고침 로그
  void logProfileRefreshed(String userId) {
    _logInfo('Profile refreshed', {
      'userId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// 프로필 데이터 로드 성공 로그
  void logProfileDataLoaded(String userId, int loadTimeMs) {
    _logInfo('Profile data loaded', {
      'userId': userId,
      'loadTimeMs': loadTimeMs,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// 프로필 데이터 로드 실패 로그
  void logProfileDataLoadFailed(String userId, String errorCode, int loadTimeMs) {
    _logError('Profile data load failed', {
      'userId': userId,
      'errorCode': errorCode,
      'loadTimeMs': loadTimeMs,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// 메모리 사용량 로그 (성능 모니터링)
  void logMemoryUsage(String context, int memoryUsageBytes) {
    if (kDebugMode) {
      _logInfo('Memory usage', {
        'context': context,
        'memoryBytes': memoryUsageBytes,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  /// 네트워크 요청 로그
  void logNetworkRequest(String endpoint, String method, int? statusCode, int? responseTimeMs) {
    final data = <String, dynamic>{
      'endpoint': endpoint,
      'method': method,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    
    if (statusCode != null) data['statusCode'] = statusCode;
    if (responseTimeMs != null) data['responseTimeMs'] = responseTimeMs;

    if (statusCode != null && statusCode >= 400) {
      _logError('Network request failed', data);
    } else {
      _logInfo('Network request', data);
    }
  }

  /// 사용자 상호작용 패턴 로그
  void logUserInteraction(String userId, String action, Map<String, dynamic>? metadata) {
    final data = <String, dynamic>{
      'userId': userId,
      'action': action,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    
    if (metadata != null) {
      data['metadata'] = metadata;
    }
    
    _logInfo('User interaction', data);
  }

  /// 에러 로그 (최소한의 정보만 포함)
  void logError(String userId, String errorType, String errorMessage) {
    _logError('Profile error', {
      'userId': userId,
      'errorType': errorType,
      'message': errorMessage,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// 성능 메트릭 로그
  void logPerformanceMetric(String metricName, double value) {
    if (kDebugMode) {
      _logInfo('Performance metric', {
        'metric': metricName,
        'value': value,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  // Private 로깅 메서드들
  void _logInfo(String message, Map<String, dynamic> data) {
    _log(LogLevel.info, message, data);
  }

  void _logError(String message, Map<String, dynamic> data) {
    _log(LogLevel.error, message, data);
  }

  void _log(LogLevel level, String message, Map<String, dynamic> data) {
    // 메모리 최적화: 작은 로그 객체 생성
    final logEntry = <String, dynamic>{
      'level': level.index,
      'message': message,
      'tag': _tag,
      ...data,
    };

    // 개발 환경에서만 콘솔 출력
    if (kDebugMode) {
      final emoji = _getLogEmoji(level);
      developer.log(
        '$emoji [$_tag] $message',
        name: _tag,
        level: _getLogLevelValue(level),
      );
    }

    // 버퍼에 추가 (메모리 사용량 제한)
    _addToBuffer(logEntry);

    // 에러인 경우 즉시 처리
    if (level == LogLevel.error) {
      _flushErrorLog(logEntry);
    }
  }

  void _addToBuffer(Map<String, dynamic> logEntry) {
    _logBuffer.add(logEntry);
    
    // 버퍼 크기 제한으로 메모리 사용량 관리
    if (_logBuffer.length >= _maxBufferSize) {
      _flushBuffer();
    }
  }

  void _flushBuffer() {
    if (_logBuffer.isEmpty) return;

    // 프로덕션 환경에서는 분석 서비스로 배치 전송
    if (kReleaseMode) {
      _sendBatchToAnalyticsService(List.from(_logBuffer));
    }

    _logBuffer.clear();
  }

  void _flushErrorLog(Map<String, dynamic> errorLog) {
    if (kReleaseMode) {
      _sendToCrashAnalyticsService(errorLog);
    }
  }

  String _getLogEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.error:
        return '❌';
    }
  }

  int _getLogLevelValue(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return 800;
      case LogLevel.error:
        return 1000;
    }
  }

  // 실제 구현에서는 Firebase Analytics, Crashlytics 등 사용
  void _sendBatchToAnalyticsService(List<Map<String, dynamic>> logs) {
    // TODO: 실제 분석 서비스 연동
    // Firebase Analytics.logEvent() 등
  }

  void _sendToCrashAnalyticsService(Map<String, dynamic> errorLog) {
    // TODO: 실제 크래시 분석 서비스 연동
    // Firebase Crashlytics.recordError() 등
  }

  /// 앱 종료 시 남은 로그 플러시
  void dispose() {
    _flushBuffer();
  }
}

enum LogLevel {
  info,
  error,
}
