import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/presentation/providers/auth_provider.dart';
import '../../auth/token_manager_provider.dart';

class AuthInterceptor extends Interceptor {
  final ProviderRef ref;
  final Dio dio;

  AuthInterceptor({required this.ref, required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 1. 인증이 필요 없는 API는 그냥 통과 (로그인 등)
    if (options.path.contains('/auth/login') || options.path.contains('/auth/refresh')) {
      return handler.next(options);
    }

    final tokenManager = ref.read(tokenManagerProvider);

    // 2. 🚀[핵심] TokenManager의 getValidAccessToken() 호출!
    // 이 함수 하나가 알아서 만료 검사, 동시 갱신 방지(Queue), 갱신 실패 처리를 다 해줍니다.
    final authHeader = await tokenManager.getValidAccessToken();

    if (authHeader != null) {
      // TokenManager의 authorizationHeader는 이미 "Bearer xxxx" 형태를 띕니다.
      options.headers['Authorization'] = authHeader;
    }

    return handler.next(options);
  }
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러가 발생했고, 그 요청이 리프레시나 로그인 관련이 아니라면
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains('/auth/')) {
      print('🚨 [AuthInterceptor] 401 발생! 토큰이 만료되었거나 서버에서 거부함.');

      // 1. 토큰 즉시 삭제 (메모리+스토리지)
      await ref.read(tokenManagerProvider).clearTokens();

      // 2. AuthNotifier를 통해 로그아웃 처리 (UI 리다이렉트 유도)
      // 이 호출이 되면 GoRouter가 감지하여 로그인 화면으로 보냅니다.
      ref.read(authNotifierProvider.notifier).logout();

      return handler.reject(err);
    }

    // 리프레시 자체에서 401이 떴다면? (재시도 절대 금지)
    if (err.requestOptions.path.contains('/auth/refresh') && err.response?.statusCode == 401) {
      print('🚨 [AuthInterceptor] 리프레시 토큰마저 만료됨! 하드 로그아웃 실행.');
      await ref.read(tokenManagerProvider).clearTokens();
      ref.read(authNotifierProvider.notifier).logout();
    }

    return handler.next(err);
  }
}