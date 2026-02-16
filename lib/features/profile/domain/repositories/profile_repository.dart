
import 'dart:io';

import '../../../../core/network/page_response.dart';
import '../../../../core/utils/result.dart';
import '../../../recommendation/data/dto/post_response.dart';
import '../../data/models/response/profile_dto.dart';
import '../../data/models/response/setup_profile_response.dart';

/// 🏠 프로필 Repository 인터페이스
abstract class ProfileRepository {
  /// 📝 프로필 설정 (닉네임 + 이미지)
  ///
  /// [nickname] 설정할 닉네임 (필수)
  /// [profileImageUrl] 프로필 이미지 URL (선택적)
  ///
  /// Returns [Result<SetupProfileResponse>] 성공 시 설정된 프로필 정보
  Future<Result<SetupProfileResponse>> setupProfile({
    required String nickname,
    File? imageFile,
  });

  /// 📊 프로필 요약 정보 조회
  Future<Result<ProfileSummaryResponse>> getProfileSummary();

  /// 🌐 언어 설정 변경
  Future<Result<bool>> updateLanguage(String language);

  /// 💰 잉크 사용 내역 조회 (페이징)
  Future<Result<PageResponse<InkHistoryResponse>>> getInkHistory(int page, int size);

  /// 🧠 내 심리 테스트 결과 조회 (페이징)
  Future<Result<PageResponse<MyTestResultSummaryResponse>>> getMyTestResults(int page, int size);

  /// 📝 내가 쓴 게시글 조회 (페이징)
  Future<Result<PageResponse<PostResponse>>> getMyPosts(int page, int size);

  /// ❤️ 좋아요한 게시글 조회 (페이징)
  Future<Result<PageResponse<PostResponse>>> getLikedPosts(int page, int size);

}