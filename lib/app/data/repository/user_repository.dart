import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/auth/token_manager.dart'; // TokenManager import 확인
import '../../../../core/network/api_response_dto.dart';
import '../../../../core/utils/result.dart';
import '../../../core/auth/token_manager_provider.dart';
import '../../domain/local/user_model.dart';
import '../data_source/user_data_source.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final dataSource = ref.watch(userDataSourceProvider);
  // ✅ [수정] TokenManager 주입
  final tokenManager = ref.watch(tokenManagerProvider);

  return UserRepository(dataSource, tokenManager);
}

class UserRepository {
  final UserDataSource _dataSource;
  final TokenManager _tokenManager; // ✅ [추가]

  UserRepository(this._dataSource, this._tokenManager);

  Future<Result<UserModel>> getMyProfile() async {
    try {
      // ✅ [1] 유효한 토큰 가져오기 (UserAnalysisRepository와 동일 방식)
      final validToken = await _tokenManager.getValidAccessToken();

      if (validToken == null) {
        return Result.failure('로그인이 필요한 서비스입니다.', 'AUTHENTICATION_REQUIRED');
      }

      // ✅ [2] 헤더에 토큰 실어서 호출 ('Bearer ' 접두어 필수)
      final response = await _dataSource.getMyProfile(validToken);

      if (response.success && response.data != null) {
        return Result.success(response.data!);
      } else {
        return Result.failure(response.message ?? '정보 조회 실패', response.error?.code);
      }
    } on DioException catch (e) {
      // Dio 에러 핸들링 (기존 로직 유지 또는 UserAnalysisRepository의 _handleDioException 복사 사용)
      return Result.failure('네트워크 오류가 발생했습니다. (${e.response?.statusCode})');
    } catch (e) {
      return Result.failure('알 수 없는 오류가 발생했습니다.');
    }
  }
}