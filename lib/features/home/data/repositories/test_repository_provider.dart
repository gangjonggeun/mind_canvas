import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/auth/token_manager_provider.dart';
import '../../../../core/network/dio_provider.dart';
import '../../domain/repositories/test_repository.dart';
import '../models/datasources/test_api_data_source.dart';
import '../models/repositories/test_repository_impl.dart';

part 'test_repository_provider.g.dart';

/// TestRepository Provider
@riverpod
TestRepository testRepository(TestRepositoryRef ref) {
  final dio = ref.read(dioProvider);
  final tokenManager = ref.read(tokenManagerProvider);
  final apiDataSource = TestApiDataSource(dio);

  return TestRepositoryImpl(
    testApiDataSource: apiDataSource,
    tokenManager: tokenManager,
  );
}