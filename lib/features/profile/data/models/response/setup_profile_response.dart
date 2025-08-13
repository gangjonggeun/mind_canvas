import 'package:freezed_annotation/freezed_annotation.dart';

part 'setup_profile_response.freezed.dart';
part 'setup_profile_response.g.dart';

/// 📝 프로필 설정 응답 DTO (클라이언트)
///
/// 서버의 SetupProfileResponse와 정확히 일치하는 구조
@freezed
class SetupProfileResponse with _$SetupProfileResponse {
  const factory SetupProfileResponse({
    /// 설정된 닉네임
    @JsonKey(name: 'nickname') required String nickname,

    /// 프로필 이미지 URL (nullable)
    @JsonKey(name: 'profileImageUrl') String? profileImageUrl,

    /// 프로필 완성 여부 (실시간 계산값)
    @JsonKey(name: 'isProfileComplete') required bool isProfileComplete,

    /// 업데이트 시간 (ISO 8601 형식)
    @JsonKey(name: 'updatedAt') required String updatedAt,
  }) = _SetupProfileResponse;

  factory SetupProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$SetupProfileResponseFromJson(json);
}