
import '../../../../core/utils/result.dart';
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
    String? profileImageUrl,
  });
}