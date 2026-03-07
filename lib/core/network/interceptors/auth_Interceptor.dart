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
    // 1. 헤더에 Access Token 주입
    final accessToken = await AuthStorage.loadAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 🚨 401 Unauthorized 에러 (Access Token 만료) 발생 시
    if (err.response?.statusCode == 401) {
      print('⚠️ Access Token 만료 감지. Refresh 시도...');

      final refreshToken = await AuthStorage.loadRefreshToken();

      if (refreshToken == null) {
        // 리프레시 토큰조차 없으면 로그아웃 처리
        await _forceLogout();
        return handler.next(err);
      }

      try {
        // 💡 주의: 여기서 기존 dio 객체를 쓰면 무한 루프에 빠질 수 있으므로
        // 토큰 갱신 전용 새로운 Dio 인스턴스를 생성하거나 별도 패키지(http 등)를 사용합니다.
        final tokenDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));

        // 1. 서버에 토큰 갱신 요청
        final refreshResponse = await tokenDio.post(
          '/api/auth/refresh', // ⬅️ 서버의 토큰 갱신 엔드포인트에 맞게 수정하세요.
          data: {'refreshToken': refreshToken},
        );

        // 2. 성공 시 새 토큰 파싱
        final newAccessToken = refreshResponse.data['data']['accessToken'];
        final newRefreshToken = refreshResponse.data['data']['refreshToken'];

        // 3. Storage에 새 토큰 저장
        await AuthStorage.saveAccessToken(newAccessToken);
        if (newRefreshToken != null) {
          await AuthStorage.saveRefreshToken(newRefreshToken);
        }

        print('✅ 토큰 갱신 성공! 실패했던 요청 재시도...');

        // 4. 원래 실패했던 요청의 헤더를 새 토큰으로 변경
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        // 5. 원래 하려던 요청을 다시 실행 (사용자는 실패했는지 모름!)
        final retryResponse = await dio.fetch(err.requestOptions);

        // 6. 재시도 성공 결과를 반환
        return handler.resolve(retryResponse);

      } on DioException catch (e) {
        // 🚨 Refresh Token 마저 만료된 경우 (401 에러 등)
        print('❌ Refresh Token 만료. 재로그인 필요.');
        await _forceLogout();
        return handler.next(e);
      }
    }

    // 401이 아닌 다른 에러는 그대로 패스
    return handler.next(err);
  }

  /// 강제 로그아웃 처리 로직
  Future<void> _forceLogout() async {
    await AuthStorage.clearAll();


  }
}