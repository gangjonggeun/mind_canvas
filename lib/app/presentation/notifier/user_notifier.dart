import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../features/auth/data/models/response/auth_response_dto.dart';
import '../../data/repository/user_repository.dart';
import '../../domain/local/user_model.dart';


part 'user_notifier.g.dart';

/// 👤 전역 유저 상태 관리
/// 앱 어디서든 ref.watch(userNotifierProvider)로 접근 가능
@Riverpod(keepAlive: true) // 🌟 앱 종료 전까지 상태 유지 (로그아웃 전까지)
class UserNotifier extends _$UserNotifier {
  @override
  UserModel? build() {
    return null; // 초기 상태: 비로그인
  }

  void deductCoinsLocal(int amount) {
    if (state == null) return; // 로그인 안 되어 있으면 무시

    final currentCoins = state!.coins;

    // 0보다 작아지지 않게 방어 로직
    final newCoins = (currentCoins - amount) < 0 ? 0 : (currentCoins - amount);

    // 상태 업데이트 (UI가 즉시 변경됨)
    state = state!.copyWith(coins: newCoins);

    print('💸 [UserNotifier] 로컬 차감: -$amount (잔액: $newCoins)');
  }

  /// 🚪 로그인 성공 시 호출 (초기 데이터 세팅)
  /// AuthNotifier 등에서 로그인 성공 후 이 함수를 호출해줘야 함
  Future<void> setAuthData(AuthResponse auth) async {
    print('🔍 [1] setAuthData 진입: AuthResponse 코인 = ${auth.coins}');

    // 1. AuthResponse에 있는 기본 정보로 먼저 세팅 (빠른 UI 반응)
    state = UserModel(
      id: auth.userId, // AuthResponse에 id가 없다면 0이나 임시값. 곧 API로 채움
      email: '', // AuthResponse에 이메일이 없다면 비워둠
      nickname: auth.nickname,
      coins: auth.coins, // ✅ 로그인 시 받은 코인 적용
    );
    print('🔍 [2] state 초기화 완료: 현재 state 코인 = ${state?.coins}');

    // 2. 서버에서 완전한 내 정보 가져오기 (ID, 이메일 등 채우기 위해)
    await refreshProfile();

    print('🔍 [4] 최종 state 코인 = ${state?.coins}');
  }

  /// 🔄 서버에서 최신 정보(코인 포함) 강제 새로고침
  Future<void> refreshProfile() async {
    print('🚀 [UserNotifier] refreshProfile 시작'); // 1. 진입 로그 추가

    try {
      // 2. Repository 호출
      final result = await ref.read(userRepositoryProvider).getMyProfile();

      if (result.isSuccess) {
        print('🔍 [Success] 서버(/me)에서 가져온 코인 = ${result.data?.coins}');
        state = result.data;
        print('👤 유저 정보 갱신 완료: ${state?.nickname}, 코인: ${state?.coins}');
      } else {
        // 🚨 3. 실패 로그 추가 (이게 없어서 로그가 안 떴을 것임)
        print('❌ [Fail] 유저 정보 조회 실패: ${result.message} (Code: ${result.errorCode})');

        // 만약 토큰 만료 에러(401)라면 로그아웃 처리를 하거나 토큰 갱신 로직 필요
      }
    } catch (e, stackTrace) {
      // 4. 예외 발생 시 스택트레이스까지 출력
      print('⚠️ [Error] 유저 정보 갱신 중 예외 발생: $e');
      print(stackTrace);
    }
  }

  /// 📡 [Interceptor용] 서버 헤더(X-User-Coins) 값으로 코인 동기화
  /// Dio Interceptor에서 이 함수를 직접 호출함
  void syncCoins(int newCoins) {
    if (state == null) return; // 비로그인 상태면 무시

    // 값이 다를 때만 업데이트 (불필요한 리빌드 방지)
    if (state!.coins != newCoins) {
      print('💰 [UserNotifier] 코인 동기화: ${state!.coins} -> $newCoins');
      state = state!.copyWith(coins: newCoins);
    }
  }

  /// 🚪 로그아웃
  void logout() {
    state = null;
  }
}