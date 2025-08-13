import 'package:freezed_annotation/freezed_annotation.dart';

// ✅ 필수: part 파일들 추가
part 'setup_profile_request.freezed.dart';
part 'setup_profile_request.g.dart';

@freezed
class SetupProfileRequest with _$SetupProfileRequest {
  const factory SetupProfileRequest({
    @JsonKey(name: 'nickname') required String nickname,
    // 추가 필드들 (필요시)
    @JsonKey(name: 'profileImageUrl') String? profileImageUrl,
  }) = _SetupProfileRequest;

  factory SetupProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$SetupProfileRequestFromJson(json);
}