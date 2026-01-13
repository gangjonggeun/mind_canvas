import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/presentation/notifier/user_notifier.dart';

/// 💰 서버 헤더(X-User-Coins)를 감지하여 코인 잔액을 동기화하는 인터셉터
class CoinSyncInterceptor extends Interceptor {
  final Ref ref;

  CoinSyncInterceptor(this.ref);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 1. 헤더에서 'X-User-Coins' 값 찾기
    // (Dio는 헤더 이름을 소문자로 처리할 수 있으니 대소문자 주의, 보통 list로 반환됨)
    final coinHeader = response.headers.value('X-User-Coins');

    if (coinHeader != null) {
      try {
        final int updatedCoins = int.parse(coinHeader);
        print('💰 [CoinSync] 서버 헤더 감지됨: $updatedCoins 코인');

        // 2. UserNotifier의 코인 값 강제 업데이트
        // (주의: build 단계가 아니라 콜백이므로 ref.read 사용 가능)
        ref.read(userNotifierProvider.notifier).syncCoins(updatedCoins);

      } catch (e) {
        print('⚠️ [CoinSync] 코인 헤더 파싱 실패: $e');
      }
    }

    // 3. 다음 처리로 넘김
    super.onResponse(response, handler);
  }
}