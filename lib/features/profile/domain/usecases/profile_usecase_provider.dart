import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../usecases/profile_usecase.dart';
import '../../data/repositories/profile_repository_impl.dart';

/// 👤 ProfileUseCase Provider
///
/// 프로필 관련 모든 비즈니스 로직을 담당하는 UseCase의 싱글톤 Provider
final profileUseCaseProvider = Provider<ProfileUseCase>((ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return ProfileUseCase(profileRepository);
});