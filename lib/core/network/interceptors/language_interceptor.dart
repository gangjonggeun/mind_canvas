import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Hive나 SharedPreference에서 언어 설정 가져오기 위한 import 필요

class LanguageInterceptor extends Interceptor {
  // 언어 설정을 관리하는 Provider나 저장소 접근
  // 예: final String currentCode;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 1. 사용자 설정 언어 가져오기 (Hive or State)
    // 예시: var lang = Hive.box('settings').get('language', defaultValue: 'ko');
    String langCode = 'ko'; // 실제로는 변수 값

    // 2. 헤더 추가
    options.headers['Accept-Language'] = langCode;

    super.onRequest(options, handler);
  }
}