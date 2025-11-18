import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

/// 🌐 Dio HTTP 클라이언트 Provider
@riverpod
Dio dio(DioRef ref) {
  final dio = Dio();

  // =============================================================
  // 🔧 기본 설정
  // =============================================================

  dio.options.baseUrl = "http://192.168.219.103:8080/api/v1";

  // ✅ 기본 헤더 설정 (핵심!)
  dio.options.headers = {
    'Content-Type': 'application/json; charset=utf-8',  // ✅ charset 추가
    'Accept': 'application/json',
  };

  // ✅ 타임아웃 설정
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  dio.options.sendTimeout = const Duration(seconds: 60);

  // =============================================================
  // 🔍 인터셉터 추가
  // =============================================================

  // 1. 로깅 인터셉터 (디버그 모드만)
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 90,
  ));

  // 2. ✅ 동적 타임아웃 및 헤더 관리 인터셉터
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // 🔍 요청 URL 로깅
        print('📤 API 요청: ${options.method} ${options.path}');
        print('📋 Content-Type: ${options.headers['Content-Type']}');

        // 🎨 HTP 분석 API → 타임아웃 5분, Multipart 허용
        if (options.path.contains('/htp/')) {
          options.receiveTimeout = const Duration(minutes: 5);
          options.sendTimeout = const Duration(minutes: 3);
          // Multipart는 자동으로 Content-Type 설정됨
          print('⏱️ HTP API 타임아웃 연장: 수신 5분, 전송 3분');
        }

        // 🧠 기타 AI 분석 API → 타임아웃 3분
        else if (options.path.contains('/analysis') ||
            options.path.contains('/ai/')) {
          options.receiveTimeout = const Duration(minutes: 3);
          print('⏱️ AI API 타임아웃 연장: 수신 3분');
        }

        // 🔐 인증 API → 타임아웃 1분
        else if (options.path.contains('/auth/')) {
          options.receiveTimeout = const Duration(seconds: 60);
          print('⏱️ Auth API 타임아웃: 1분');
        }

        handler.next(options);
      },
      onError: (DioException error, handler) {
        // 에러 로깅 개선
        print('❌ API 오류 발생: ${error.type}');
        print('   URL: ${error.requestOptions.path}');
        print('   Status: ${error.response?.statusCode}');

        if (error.type == DioExceptionType.connectionTimeout) {
          print('❌ 연결 타임아웃: 서버 연결에 실패했습니다');
        } else if (error.type == DioExceptionType.sendTimeout) {
          print('❌ 전송 타임아웃: 데이터 전송 시간 초과');
        } else if (error.type == DioExceptionType.receiveTimeout) {
          print('❌ 수신 타임아웃: 서버 응답 시간 초과');
        } else if (error.response?.statusCode == 415) {
          print('❌ 415 오류: Content-Type 문제');
          print('   요청 Content-Type: ${error.requestOptions.headers['Content-Type']}');
        }

        handler.next(error);
      },
    ),
  );

  return dio;
}