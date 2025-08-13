import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_canvas/core/auth/token_manager.dart';
import 'package:mind_canvas/core/auth/token_manager_provider.dart';
import 'package:mind_canvas/core/utils/result.dart';
import 'package:mind_canvas/core/network/api_response_dto.dart';  // ← 이거 추가!

import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_api_data_source.dart';
import '../datasources/profile_api_data_source_provider.dart';
import '../models/request/setup_profile_request.dart';
import '../models/response/setup_profile_response.dart';

// --- Provider ---
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final apiDataSource = ref.watch(profileApiDataSourceProvider);
  final tokenManager = ref.watch(tokenManagerProvider);
  return ProfileRepositoryImpl(apiDataSource, tokenManager);
});

// --- Repository 구현체 ---
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiDataSource _apiDataSource;
  final TokenManager _tokenManager;

  ProfileRepositoryImpl(this._apiDataSource, this._tokenManager);

  @override
  Future<Result<SetupProfileResponse>> setupProfile({
    required String nickname,
    String? profileImageUrl,
  }) async {
    try {
      // 1. 유효한 토큰 확인
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) {
        print('❌ 유효하지 않은 토큰');
        return Result.failure('인증 토큰이 유효하지 않습니다');
      }

      // 2. 요청 데이터 생성
      final request = SetupProfileRequest(
        nickname: nickname,
        profileImageUrl: profileImageUrl,
      );

      print('📝 프로필 설정 요청: nickname=$nickname, hasImage=${profileImageUrl != null}');

      // 3. API 호출
      final response = await _apiDataSource.setupProfile(validToken, request);

      // 4. 응답 처리 (이제 isSuccess 인식됨!)
      if (response.isSuccess && response.data != null) {
        print('✅ 프로필 설정 성공: ${response.data!}');
        return Result.success(response.data!);
      } else {
        print('❌ 프로필 설정 실패: ${response.errorMessage}');
        return Result.failure(response.errorMessage ?? '프로필 설정에 실패했습니다');
      }

    } catch (e) {
      print('❌ 프로필 설정 오류: $e');
      return Result.failure('네트워크 오류: ${e.toString()}');
    }
  }
}