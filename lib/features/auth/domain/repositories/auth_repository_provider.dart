import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/auth_api_data_source_provider.dart'; // 2단계에서 만든 Provider
import '../../data/repositories/auth_repository_impl.dart';
import 'auth_repository.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  // 2단계에서 만든 DataSource Provider를 통해 DataSource 인스턴스를 가져옵니다.
  final dataSource = ref.watch(authApiDataSourceProvider);

  // DataSource를 Repository 구현체(Impl)에 주입하여 생성합니다.
  // 여기서 반환 타입이 인터페이스(AuthRepository)인 것이 중요합니다.
  return AuthRepositoryImpl(dataSource);
}