import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_storage.dart';
// 기타 경로 임포트...

class AuthInterceptor extends Interceptor {
  final Ref ref;
  final Dio dio;

  AuthInterceptor({required this.ref, required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final path = options.path;
    if (path.contains('/auth/google') ||
        path.contains('/auth/apple') ||
        path.contains('/auth/guest') ||
        path.contains('/auth/refresh')) {
      return handler.next(options);
    }
    // 1. 헤더에 Access Token 주입
    final accessToken = await AuthStorage.loadAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final path = err.requestOptions.path;

      // 1. 로그인/리프레시 API는 제외
      if (path.contains('/auth/google') ||
          path.contains('/auth/apple') ||
          path.contains('/auth/guest') ||
          path.contains('/auth/refresh')) {
        return handler.next(err);
      }

      // ✨[무한루프 방지 핵심 코드] 이미 한 번 재시도했는데 또 401이 났다면? 즉시 차단!
      if (err.requestOptions.extra['isRetry'] == true) {
        print('🛑 무한 루프 감지: 재시도한 요청이 또 401입니다. 강제 로그아웃 처리합니다.');
        await _forceLogout();
        return handler.next(err);
      }

      print('⚠️ Access Token 만료 감지. Refresh 시도... (경로: $path)');

      final refreshToken = await AuthStorage.loadRefreshToken();
      if (refreshToken == null) {
        await _forceLogout();
        return handler.next(err);
      }

      try {
        final tokenDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
        final refreshResponse = await tokenDio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        final responseData = refreshResponse.data['data'] ?? refreshResponse.data;
        final newAccessToken = responseData['accessToken'] ?? responseData['access_token'];
        final newRefreshToken = responseData['refreshToken'] ?? responseData['refresh_token'];

        await AuthStorage.saveAccessToken(newAccessToken);
        if (newRefreshToken != null) await AuthStorage.saveRefreshToken(newRefreshToken);

        // 2. 헤더 교체
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        // ✨ [무한루프 방지 마커 추가] 이 요청은 "재시도된 요청"임을 표시!
        err.requestOptions.extra['isRetry'] = true;

        // 3. 재시도
        final retryResponse = await dio.fetch(err.requestOptions);
        return handler.resolve(retryResponse);

      } catch (e) {
        print('❌ Refresh Token 갱신 실패. 재로그인 필요.');
        await _forceLogout();
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  /// 강제 로그아웃 처리 로직
  Future<void> _forceLogout() async {
    await AuthStorage.clearAll();


  }
}