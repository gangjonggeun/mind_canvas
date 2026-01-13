import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_response_dto.dart';
import '../../../../core/network/dio_provider.dart';
import '../../domain/local/user_model.dart';

part 'user_data_source.g.dart';

@riverpod
UserDataSource userDataSource(UserDataSourceRef ref) {
  final dio = ref.watch(dioProvider);
  return UserDataSource(dio);
}

@RestApi()
abstract class UserDataSource {
  factory UserDataSource(Dio dio, {String baseUrl}) = _UserDataSource;

  /// 👤 내 정보 조회 (코인 싱크 및 프로필 갱신용)
  @GET('/users/me')
  Future<ApiResponse<UserModel>> getMyProfile(
      @Header('Authorization') String token,
      );
}