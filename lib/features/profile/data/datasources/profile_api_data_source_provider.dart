import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
import 'profile_api_data_source.dart';

/// 🏭 프로필 API 데이터 소스 프로바이더
final profileApiDataSourceProvider = Provider<ProfileApiDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileApiDataSource(dio);
});