import 'package:riverpod_annotation/riverpod_annotation.dart';
 // TokenManager Provider
import '../../../../core/auth/token_manager_provider.dart';
import '../../data/datasources/auth_api_data_source_provider.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'auth_repository.dart';

part 'auth_repository_provider.g.dart';

/// 🔑 AuthRepository Provider
///
/// TokenManager와 AuthApiDataSource를 주입받아 AuthRepositoryImpl을 생성합니다.
/// Riverpod의 의존성 주입을 통해 테스트 가능하고 관리하기 쉬운 구조를 제공합니다.
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  // AuthApiDataSource Provider를 통해 DataSource 인스턴스 가져오기
  final dataSource = ref.watch(authApiDataSourceProvider);

  // TokenManager Provider를 통해 TokenManager 인스턴스 가져오기
  final tokenManager = ref.watch(tokenManagerProvider);

  // 의존성을 주입하여 Repository 구현체 생성
  final repository = AuthRepositoryImpl(dataSource, tokenManager);

  // 🚀 [핵심 연결고리] TokenManager가 갱신이 필요할 때 Repository의 함수를 쓰도록 권한 위임
  tokenManager.onTokenRefresh = () async {
    final result = await repository.refreshTokens();
    return result.isSuccess; // 성공하면 true 반환, 실패하면 false 반환
  };

  return repository;
}