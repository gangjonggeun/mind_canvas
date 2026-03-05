import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'token_manager.dart';
import '../../features/auth/data/models/response/auth_response_dto.dart';

part 'token_manager_provider.g.dart';

/// 🏭 TokenManager 싱글톤 Provider
///
/// 앱 전체에서 하나의 TokenManager 인스턴스를 공유
/// 메모리 효율성을 위해 keepAlive 사용
@Riverpod(keepAlive: true)
TokenManager tokenManager(TokenManagerRef ref) {
  final manager = TokenManager();
  ref.onDispose(manager.dispose);
  return manager;
}

@riverpod
bool isLoggedIn(IsLoggedInRef ref) {
  // 단순화된 getter를 사용
  return ref.watch(tokenManagerProvider).isLoggedIn;
}

@riverpod
bool canMakeApiCall(CanMakeApiCallRef ref) {
  // 단순화된 getter를 사용
  return ref.watch(tokenManagerProvider).canMakeApiCall;
}
