import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

import '../../../../core/auth/token_manager_provider.dart';
import '../../../../core/network/dio_provider.dart'; // Dio Provider 경로 확인 필요
import '../../domain/repository/user_analysis_repository.dart';
import '../data_source/user_analysis_data_source.dart';
import '../repository/user_analysis_repository_impl.dart';


part 'user_analysis_repository_provider.g.dart';

/// 🌐 UserAnalysisDataSource Provider
/// (Retrofit 클라이언트 생성)
@riverpod
UserAnalysisDataSource userAnalysisDataSource(UserAnalysisDataSourceRef ref) {
  final dio = ref.watch(dioProvider); // 전역 Dio 인스턴스
  // baseUrl은 Dio 설정이나 환경변수에서 가져온다고 가정
  return UserAnalysisDataSource(dio);
}

/// 📦 UserAnalysisRepository Provider
/// (UseCase에서 이 친구를 구독함)
@riverpod
UserAnalysisRepository userAnalysisRepository(UserAnalysisRepositoryRef ref) {
  final dataSource = ref.watch(userAnalysisDataSourceProvider);
  final tokenManager = ref.read(tokenManagerProvider);

  return UserAnalysisRepositoryImpl(dataSource, tokenManager);
}
