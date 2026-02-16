import 'dart:io';

import 'package:mind_canvas/core/utils/result.dart';
import '../../../../core/network/page_response.dart';
import '../../../recommendation/data/dto/post_response.dart';
import '../../data/models/response/profile_dto.dart';
import '../repositories/profile_repository.dart';
import '../../data/models/response/setup_profile_response.dart';

/// 👤 프로필 관련 모든 UseCase를 담당하는 통합 클래스
class ProfileUseCase {
  final ProfileRepository _profileRepository;

  // 📌 페이지 사이즈 정책 상수 정의 (여기서 관리하면 유지보수가 편함)
  static const int _defaultPageSize = 10;

  ProfileUseCase(this._profileRepository);

  // =============================================================
  // 📝 프로필 설정
  // =============================================================
  Future<Result<SetupProfileResponse>> setupProfile({
    required String nickname,
    File? imageFile, // 👈 String? profileImageUrl 대신 File?로 변경
  }) async {
    // 1. 닉네임 유효성 검증
    final validationResult = _validateNickname(nickname);
    if (validationResult.isFailure) {
      return Result.failure(validationResult.message!, validationResult.errorCode);
    }

    // 2. 이미지 파일 검증 (선택 사항)
    if (imageFile != null) {
      // 예: 10MB 이상 업로드 제한
      final fileSizeInBytes = await imageFile.length();
      if (fileSizeInBytes > 10 * 1024 * 1024) {
        return Result.failure('이미지 크기는 10MB를 초과할 수 없습니다.');
      }
    }

    // 3. Repository 호출 (File 전달)
    return await _profileRepository.setupProfile(
      nickname: nickname.trim(),
      imageFile: imageFile, // 👈 변경된 파라미터 전달
    );
  }

  /// 요약 정보 조회
  Future<Result<ProfileSummaryResponse>> getSummary() =>
      _profileRepository.getProfileSummary();

  /// 언어 설정 변경 (void -> bool 변경)
  Future<Result<bool>> changeLanguage(String lang) =>
      _profileRepository.updateLanguage(lang);

  // =============================================================
  // 📄 페이징 관련 메서드 (size 기본값 적용)
  // =============================================================

  /// 잉크 내역 조회
  /// [size] 파라미터를 선택적으로 받되, 없으면 기본값(_defaultPageSize) 사용
  Future<Result<PageResponse<InkHistoryResponse>>> getInkHistory(int page, int size ) {
    return _profileRepository.getInkHistory(page, size);
  }

  /// 내 심리 테스트 결과 조회
  Future<Result<PageResponse<MyTestResultSummaryResponse>>> getTestResults(int page, int size ) {
    return _profileRepository.getMyTestResults(page, size);
  }

  /// 내 게시글 조회
  Future<Result<PageResponse<PostResponse>>> getMyPosts(int page, int size ) {
    return _profileRepository.getMyPosts(page, size);
  }

  /// 좋아요한 게시글 조회
  Future<Result<PageResponse<PostResponse>>> getLikedPosts(int page, int size) {
    return _profileRepository.getLikedPosts(page, size);
  }

  // =============================================================
  // 🏷️ 닉네임 개별 변경
  // =============================================================

  Future<Result<bool>> updateNickname(String nickname) async {
    // setupProfile 재사용
    final result = await setupProfile(nickname: nickname);

    // SetupProfileResponse -> bool 변환 (성공 시 true)
    return result.fold(
      onSuccess: (_) => Result.success(true),
      onFailure: (error, code) => Result.failure(error, code),
    );
  }

  // =============================================================
  // 🔧 내부 검증 메서드들 (void -> bool 변경)
  // =============================================================

  /// 닉네임 유효성 검증
  Result<bool> _validateNickname(String nickname) {
    final trimmed = nickname.trim();

    if (trimmed.isEmpty) return Result.failure('닉네임을 입력해주세요');
    if (trimmed.length < 2) return Result.failure('닉네임은 2글자 이상이어야 합니다');
    if (trimmed.length > 15) return Result.failure('닉네임은 15글자 이하여야 합니다');

    final nicknameRegex = RegExp(r'^[가-힣a-zA-Z0-9._-]+$');
    if (!nicknameRegex.hasMatch(trimmed)) {
      return Result.failure('특수문자는 사용 불가능합니다 (언더스코어, 하이픈, 점 제외)');
    }

    final forbiddenWords = ['admin', 'test', 'system', '관리자', '운영자'];
    final lowerNickname = trimmed.toLowerCase();
    for (final word in forbiddenWords) {
      if (lowerNickname.contains(word)) {
        return Result.failure('사용할 수 없는 닉네임입니다');
      }
    }

    return Result.success(true); // null 대신 true 반환
  }

  /// 이미지 URL 검증
  Result<bool> _validateImageUrl(String imageUrl) {
    final trimmed = imageUrl.trim();

    if (trimmed.isEmpty) return Result.success(true);

    final urlRegex = RegExp(r'^https?://[^\s]+$');
    if (!urlRegex.hasMatch(trimmed)) {
      return Result.failure('올바른 이미지 URL 형식이 아닙니다');
    }

    if (trimmed.length > 500) {
      return Result.failure('이미지 URL이 너무 깁니다');
    }

    return Result.success(true); // null 대신 true 반환
  }
}