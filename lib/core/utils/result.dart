// =============================================================
// 📁 core/utils/result.dart - fold 메서드 추가
//import 'package:mind_canvas/core/utils/result.dart';
// =============================================================

/// 🎯 Result 패턴 (Dart 버전)
///
/// Exception 대신 사용하는 안전한 결과 타입입니다.
class Result<T> {
  final bool _success;
  final T? _data;
  final String? _message;
  final String? _errorCode;

  // Private 생성자
  const Result._({
    required bool success,
    T? data,
    String? message,
    String? errorCode,
  }) : _success = success,
        _data = data,
        _message = message,
        _errorCode = errorCode;

  // =============================================================
  // 🏭 팩토리 메서드들
  // =============================================================

  /// ✅ 성공 결과 생성
  static Result<T> success<T>(T data, [String? message]) {
    return Result._(
      success: true,
      data: data,
      message: message ?? '성공적으로 처리되었습니다',
    );
  }

  /// ❌ 실패 결과 생성
  static Result<T> failure<T>(String message, [String? errorCode]) {
    return Result._(
      success: false,
      message: message,
      errorCode: errorCode,
    );
  }

  /// 🔄 로딩 결과 생성
  static Result<T> loading<T>([String? message]) {
    return Result._(
      success: false,
      message: message ?? '처리 중입니다...',
      errorCode: 'LOADING',
    );
  }

  // =============================================================
  // 🔍 Getter들
  // =============================================================

  bool get isSuccess => _success;
  bool get isFailure => !_success;
  bool get isLoading => _errorCode == 'LOADING';

  T? get data => _data;
  String? get message => _message;
  String? get errorCode => _errorCode;

  bool get hasData => _success && _data != null;

  // =============================================================
  // 🎯 fold 메서드 (핵심!)
  // =============================================================

  /// 🎯 결과에 따라 다른 동작 수행 (fold pattern)
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String message, String? errorCode) onFailure,
  }) {
    if (_success) {
      return onSuccess(_data as T);
    } else {
      return onFailure(_message ?? '알 수 없는 오류', _errorCode);
    }
  }

  /// 🎯 간단한 fold (에러 코드 불필요한 경우)
  R foldSimple<R>({
    required R Function(T data) onSuccess,
    required R Function(String message) onFailure,
  }) {
    if (_success && _data != null) {
      return onSuccess(_data as T);
    } else {
      return onFailure(_message ?? '알 수 없는 오류');
    }
  }

  // =============================================================
  // 🔄 함수형 프로그래밍 메서드들
  // =============================================================

  /// 🗺️ 성공 시 데이터 변환
  Result<R> map<R>(R Function(T data) mapper) {
    if (_success && _data != null) {
      try {
        final newData = mapper(_data as T);
        return Result.success(newData, _message);
      } catch (e) {
        return Result.failure('데이터 변환 중 오류: $e');
      }
    } else {
      return Result.failure(_message ?? '변환할 데이터가 없습니다', _errorCode);
    }
  }

  /// 🔗 성공 시 다른 Result 체이닝
  Result<R> flatMap<R>(Result<R> Function(T data) mapper) {
    if (_success && _data != null) {
      try {
        return mapper(_data as T);
      } catch (e) {
        return Result.failure('체이닝 중 오류: $e');
      }
    } else {
      return Result.failure(_message ?? '체이닝할 데이터가 없습니다', _errorCode);
    }
  }

  /// 🔄 실패 시 대체 Result 반환
  Result<T> orElse(Result<T> alternative) {
    return _success ? this : alternative;
  }

  // =============================================================
  // 🎭 부작용(Side Effect) 메서드들
  // =============================================================

  /// 🎉 성공 시 동작 수행
  Result<T> onSuccess(void Function(T data) action) {
    if (_success && _data != null) {
      action(_data as T);
    }
    return this;
  }

  /// 😱 실패 시 동작 수행
  Result<T> onFailure(void Function(String message, String? errorCode) action) {
    if (!_success) {
      action(_message ?? '알 수 없는 오류', _errorCode);
    }
    return this;
  }

  // =============================================================
  // 🔧 유틸리티 메서드들
  // =============================================================

  /// 데이터 가져오기 (실패 시 기본값)
  T getOrDefault(T defaultValue) {
    return (_success && _data != null) ? _data as T : defaultValue;
  }

  /// 데이터 가져오기 (실패 시 예외 발생)
  T getOrThrow() {
    if (_success && _data != null) {
      return _data as T;
    } else {
      throw Exception(_message ?? '데이터가 없습니다');
    }
  }

  @override
  String toString() {
    if (_success) {
      return 'Result.success(data: $data, message: $_message)';
    } else {
      return 'Result.failure(message: $_message, errorCode: $_errorCode)';
    }
  }
}

// =============================================================
// 🏭 Results 헬퍼 클래스 (기존 코드와 호환성)
// =============================================================

class Results {
  /// ✅ 성공 결과 생성
  static Result<T> success<T>(T data, [String? message]) {
    return Result.success(data, message);
  }

  /// ❌ 실패 결과 생성
  static Result<T> failure<T>(String message, [String? errorCode]) {
    return Result.failure(message, errorCode);
  }

  /// 🔄 로딩 결과 생성
  static Result<T> loading<T>([String? message]) {
    return Result.loading(message);
  }
}