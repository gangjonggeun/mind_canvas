import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'interceptors/coin_sync_interceptor.dart';

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
  // dio.interceptors.add(InterceptorsWrapper(
  //   onRequest: (options, handler) async {
  //     // 예: SecureStorage나 AuthNotifier에서 토큰을 가져오는 로직
  //     // final token = await SecureStorage.getToken();
  //     // 현재 프로젝트 구조상 AuthNotifier나 Repository에서 토큰을 관리한다면
  //     // ref.read()를 통해 접근해야 할 수도 있습니다.
  //
  //     // 임시 코드: 저장된 토큰이 있다고 가정
  //     const String? token = null; // ⚠️ 실제로는 저장된 Access Token을 넣어야 함!
  //
  //     if (token != null) {
  //       options.headers['Authorization'] = 'Bearer $token';
  //       print('🔑 토큰 탑재 완료');
  //     } else {
  //       print('⚠️ 토큰 없음: 인증이 필요한 API는 실패할 수 있음');
  //     }
  //
  //     handler.next(options);
  //   },
  // ));
  dio.interceptors.add(CoinSyncInterceptor(ref));

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

        else if (options.path.contains('/taro/')) {
          options.receiveTimeout = const Duration(minutes: 5);
          options.sendTimeout = const Duration(minutes: 3);
          // Multipart는 자동으로 Content-Type 설정됨
          print('⏱️ taro API 타임아웃 연장: 수신 5분, 전송 3분');
        }
        // 🧠 기타 AI 분석 API → 타임아웃 3분
        else if (options.path.contains('/analysis') ||
            options.path.contains('/ai/')) {
          options.receiveTimeout = const Duration(minutes: 3);
          print('⏱️ AI API 타임아웃 연장: 수신 3분');
        }
        else if (options.path.contains('/recommendation')) {
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

  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: true, // ⚠️ 헤더 확인을 위해 true로 변경하는 것 추천 (X-User-Coins 확인용)
    error: true,
    compact: true,
    maxWidth: 90,
  ));

  return dio;
}