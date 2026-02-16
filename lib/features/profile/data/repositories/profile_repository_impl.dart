import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_canvas/core/auth/token_manager.dart';
import 'package:mind_canvas/core/auth/token_manager_provider.dart';
import 'package:mind_canvas/core/utils/result.dart';
import 'package:mind_canvas/core/network/api_response_dto.dart';  // ← 이거 추가!

import '../../../../core/network/page_response.dart';
import '../../../recommendation/data/dto/post_response.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_api_data_source.dart';
import '../datasources/profile_api_data_source_provider.dart';
import '../models/request/setup_profile_request.dart';
import '../models/response/profile_dto.dart';
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

  // 🔐 토큰을 가져오는 공통 헬퍼 메서드
  Future<String> _getBearerToken() async {
    final token = await _tokenManager.getValidAccessToken();
    if (token == null) throw Exception('AUTHENTICATION_ERROR');
    return token;
  }

  @override
  Future<Result<ProfileSummaryResponse>> getProfileSummary() async {
    try {
      final token = await _getBearerToken();
      final response = await _apiDataSource.getProfileSummary(token);

      if (response.isSuccess && response.data != null) {
        return Result.success(response.data!);
      } else {
        return Result.failure(response.errorMessage ?? '프로필 정보를 불러오지 못했습니다');
      }
    } catch (e) {
      return Result.failure('프로필 정보를 불러오지 못했습니다', 'SERVER_ERROR');
    }
  }

  @override
  Future<Result<PageResponse<PostResponse>>> getMyPosts(int page, int size) async {
    try {
      final token = await _getBearerToken();
      final response = await _apiDataSource.getMyPosts(token, {'page': page, 'size': size});

      if (response.isSuccess && response.data != null) {
        return Result.success(response.data!);
      } else {
        return Result.failure(response.errorMessage ?? '글 불러오기 실패');
      }
    } catch (e) {
      return Result.failure('작성한 글을 불러오지 못했습니다: $e');
    }
  }

  @override
  Future<Result<SetupProfileResponse>> setupProfile({
    required String nickname,
    File? imageFile, // 👈 파일 객체 받음
  }) async {
    try {
      final token = await _getBearerToken();

      // 1. FormData 생성 (Multipart 요청 준비)
      final map = <String, dynamic>{
        'nickname': nickname, // @RequestParam("nickname")에 매핑
      };

      if (imageFile != null) {
        // 2. 파일이 있으면 MultipartFile로 변환하여 추가
        // 백엔드의 @RequestPart("profileImage") 이름과 맞춰야 함
        map['profileImage'] = await MultipartFile.fromFile(
          imageFile.path,
          // 필요하다면 contentType 지정 (예: image/jpeg, image/webp)
          // contentType: MediaType('image', 'jpeg'),
        );
      }

      final formData = FormData.fromMap(map);

      // 3. API 호출
      final response = await _apiDataSource.setupProfile(token, formData);

      if (response.isSuccess && response.data != null) {
        return Result.success(response.data!);
      } else {
        return Result.failure(response.errorMessage ?? '프로필 설정에 실패했습니다');
      }
    } catch (e) {
      return Result.failure('프로필 설정 중 오류 발생: $e');
    }
  }

  // 👇 구현 완료: 잉크 사용 내역 조회
  @override
  Future<Result<PageResponse<InkHistoryResponse>>> getInkHistory(int page, int size) async {
    try {
      final token = await _getBearerToken();
      // API 정의에 따라 쿼리 파라미터 전달 (Map 방식 유지)
      final response = await _apiDataSource.getInkHistory(token, {'page': page, 'size': size});

      if (response.isSuccess && response.data != null) {
        return Result.success(response.data!);
      } else {
        return Result.failure(response.errorMessage ?? '잉크 내역을 불러오지 못했습니다');
      }
    } catch (e) {
      return Result.failure('잉크 내역 조회 중 오류 발생: $e');
    }
  }

  // 👇 구현 완료: 내 심리 테스트 결과 조회
  @override
  Future<Result<PageResponse<MyTestResultSummaryResponse>>> getMyTestResults(int page, int size) async {
    try {
      final token = await _getBearerToken();
      final queries = {'page': page, 'size': size};

      // DataSource 호출
      final response = await _apiDataSource.getMyTestResults(token, queries);

      if (response.isSuccess && response.data != null) {
        return Result.success(response.data!);
      } else {
        return Result.failure(response.errorMessage ?? '테스트 결과를 불러오지 못했습니다');
      }
    } catch (e) {
      return Result.failure('테스트 결과 조회 중 오류 발생: $e');
    }
  }

  // 👇 구현 완료: 언어 설정 변경
  @override
  Future<Result<bool>> updateLanguage(String language) async {
    try {
      final token = await _getBearerToken();
      final body = {'language': language};

      final response = await _apiDataSource.updateLanguage(token, body);

      if (response.isSuccess) {
        // ✅ 수정됨: null 대신 true 반환
        return Result.success(true);
      } else {
        return Result.failure(response.errorMessage ?? '언어 설정 변경 실패');
      }
    } catch (e) {
      return Result.failure('언어 설정 변경 중 오류 발생: $e');
    }
  }

  // 👇 구현 완료: 좋아요한 게시글 조회
  @override
  Future<Result<PageResponse<PostResponse>>> getLikedPosts(int page, int size) async {
    try {
      final token = await _getBearerToken();
      // 인터페이스엔 page만 있지만, 보통 페이징은 size도 필요하므로 기본값 10 설정 혹은 API 스펙에 맞춤
      final response = await _apiDataSource.getLikedPosts(token, {'page': page, 'size': 10});

      if (response.isSuccess && response.data != null) {
        return Result.success(response.data!);
      } else {
        return Result.failure(response.errorMessage ?? '좋아요한 글을 불러오지 못했습니다');
      }
    } catch (e) {
      return Result.failure('좋아요한 글 조회 중 오류 발생: $e');
    }
  }
}