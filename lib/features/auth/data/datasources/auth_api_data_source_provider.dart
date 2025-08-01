
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_provider.dart'; // 1단계에서 만든 Dio Provider
import 'auth_api_data_source.dart';

part 'auth_api_data_source_provider.g.dart';

@riverpod
AuthApiDataSource authApiDataSource(AuthApiDataSourceRef ref) {
  // 1단계에서 만든 dioProvider를 지켜보고 있다가, Dio 인스턴스를 가져옵니다.
  final dio = ref.watch(dioProvider);

  // Retrofit을 사용하므로, Dio를 주입하여 DataSource를 생성합니다.
  return AuthApiDataSource(dio);
}