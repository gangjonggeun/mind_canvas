

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_usecase.dart';
import '../repositories/auth_repository_provider.dart';
part 'auth_usecase_provider.g.dart';

@riverpod
AuthUseCase authUseCase(AuthUseCaseRef ref) {
  // 2번에서 만든 Repository Provider를 읽어와서 UseCase에 주입
  final repository = ref.watch(authRepositoryProvider);
  return AuthUseCase(repository);
}