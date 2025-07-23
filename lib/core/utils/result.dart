/// 🔄 Result 패턴 - 추상클래스 버전 (네트워크 통신 최적화)
/// 
/// **장점:**
/// - 빌드 오류 없음 ✅
/// - JSON 직렬화 문제 없음 ✅
/// - 네트워크 에러 처리 최적화 ✅
/// - 메모리 효율적 ✅
abstract class Result<T> {
  const Result();

  /// 성공 여부 확인
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  bool get isLoading => this is Loading<T>;

  /// 데이터 안전하게 가져오기
  T? get dataOrNull {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return null;
  }

  /// 에러 메시지 가져오기
  String? get errorMessage {
    if (this is Failure<T>) {
      return (this as Failure<T>).message;
    }
    return null;
  }

  /// 편의 메서드 - when 패턴
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, String? code) failure,
    required R Function() loading,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else if (this is Failure<T>) {
      final failure_ = this as Failure<T>;
      return failure(failure_.message, failure_.code);
    } else if (this is Loading<T>) {
      return loading();
    } else {
      throw StateError('Unknown Result type: ${runtimeType}');
    }
  }

  /// 편의 메서드 - map (성공시에만 변환)
  Result<R> map<R>(R Function(T) mapper) {
    if (this is Success<T>) {
      try {
        final newData = mapper((this as Success<T>).data);
        return Success(newData);
      } catch (e) {
        return Failure('Data transformation failed: ${e.toString()}');
      }
    } else if (this is Failure<T>) {
      return Failure<R>((this as Failure<T>).message, (this as Failure<T>).code);
    } else {
      return Loading<R>();
    }
  }
}

/// ✅ 성공 결과
class Success<T> extends Result<T> {
  final T data;
  
  const Success(this.data);

  @override
  String toString() => 'Success(data: $data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success && runtimeType == other.runtimeType && data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// ❌ 실패 결과
class Failure<T> extends Result<T> {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  String toString() => 'Failure(message: $message, code: $code)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

/// ⏳ 로딩 상태
class Loading<T> extends Result<T> {
  const Loading();

  @override
  String toString() => 'Loading()';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Loading && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// 🎯 편의 생성자들
class Results {
  /// 성공 결과 생성
  static Result<T> success<T>(T data) => Success(data);
  
  /// 실패 결과 생성
  static Result<T> failure<T>(String message, [String? code]) => Failure(message, code);
  
  /// 로딩 상태 생성
  static Result<T> loading<T>() => Loading<T>();

  /// HTTP 상태 코드 기반 실패 생성
  static Result<T> httpFailure<T>(int statusCode, String message) {
    final code = 'HTTP_$statusCode';
    return Failure(message, code);
  }

  /// 네트워크 에러 생성
  static Result<T> networkError<T>([String? message]) {
    return Failure(message ?? '네트워크 연결을 확인해주세요', 'NETWORK_ERROR');
  }

  /// 타임아웃 에러 생성
  static Result<T> timeoutError<T>([String? message]) {
    return Failure(message ?? '요청 시간이 초과되었습니다', 'TIMEOUT_ERROR');
  }
}

/// ===== 🎨 사용법 예시 =====
/// 
/// ```dart
/// // 기본 사용법
/// Result<String> result = Success('데이터');
/// Result<String> result = Failure('에러 발생', 'ERROR_CODE');
/// Result<String> result = Loading();
/// 
/// // 편의 생성자 사용
/// Result<String> result = Results.success('데이터');
/// Result<String> result = Results.failure('에러');
/// Result<String> result = Results.networkError();
/// 
/// // 패턴 매칭
/// final message = result.when(
///   success: (data) => '성공: $data',
///   failure: (message, code) => '실패: $message ($code)',
///   loading: () => '로딩 중...',
/// );
/// 
/// // 데이터 변환
/// final mappedResult = result.map((data) => data.length);
/// 
/// // 네트워크 서비스에서 사용
/// Future<Result<List<Movie>>> getMovies() async {
///   try {
///     final response = await dio.get('/movies');
///     return Results.success(response.data);
///   } on DioException catch (e) {
///     if (e.type == DioExceptionType.connectionTimeout) {
///       return Results.timeoutError();
///     } else if (e.type == DioExceptionType.connectionError) {
///       return Results.networkError();
///     } else {
///       return Results.httpFailure(e.response?.statusCode ?? 0, e.message ?? '알 수 없는 오류');
///     }
///   } catch (e) {
///     return Results.failure('예상치 못한 오류: ${e.toString()}');
///   }
/// }
/// ```
