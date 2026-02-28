// =============================================================
// 📁 data/repositories/htp_repository_provider.dart
// =============================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';


import '../../../../../core/auth/token_manager_provider.dart';
import '../../../domain/repositories/htp_repository.dart';
import '../datasources/htp_api_data_source.dart';
import 'htp_repository_impl.dart';

part 'htp_repository_provider.g.dart';

/// 🏭 HtpRepository Provider
///
/// <p><strong>의존성:</strong></p>
/// - HtpApiDataSource (API 통신)
/// - TokenManager (JWT 토큰)
@riverpod
HtpRepository htpRepository(HtpRepositoryRef ref) {
  // 1. 의존성 조회
  final apiDataSource = ref.watch(htpApiDataSourceProvider);
  final tokenManager = ref.watch(tokenManagerProvider);

  // 2. 구현체 주입
  return HtpRepositoryImpl(
    htpApiDataSource: apiDataSource, // Impl 생성자 변수명과 일치시킴
    tokenManager: tokenManager,
  );
}