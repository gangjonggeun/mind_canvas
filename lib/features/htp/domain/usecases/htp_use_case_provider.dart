// =============================================================
// 📁 domain/usecases/htp_use_case_provider.dart
// =============================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/model/repositories/htp_repository_provider.dart';
import 'htp_use_case.dart';

part 'htp_use_case_provider.g.dart';

/// 🏭 HtpUseCase Provider
@riverpod
HtpUseCase htpUseCase(HtpUseCaseRef ref) {
  final repository = ref.watch(htpRepositoryProvider);
  return HtpUseCase(repository);
}