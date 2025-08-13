import 'package:mind_canvas/core/utils/result.dart';
import '../repositories/profile_repository.dart';
import '../../data/models/response/setup_profile_response.dart';

/// 👤 프로필 관련 모든 UseCase를 담당하는 통합 클래스
///
/// 프로필 설정, 닉네임 변경, 이미지 업로드 등 모든 프로필 관련 비즈니스 로직을 담당합니다.
class ProfileUseCase {
  final ProfileRepository _profileRepository;

  ProfileUseCase(this._profileRepository);

  // =============================================================
  // 📝 프로필 설정 (신규/전체 업데이트)
  // =============================================================

  /// 프로필 설정 실행
  ///
  /// 주로 신규 가입 후 초기 프로필 설정이나 전체 프로필 대폭 수정 시 사용
  ///
  /// [nickname] 설정할 닉네임 (필수)
  /// [profileImageUrl] 프로필 이미지 URL (선택적)
  Future<Result<SetupProfileResponse>> setupProfile({
    required String nickname,
    String? profileImageUrl,
  }) async {
    print('📝 ProfileUseCase.setupProfile 시작: nickname=$nickname');

    // 1. 비즈니스 로직 검증
    final validationResult = _validateNickname(nickname);
    if (validationResult.isFailure) {
      return Result.failure(validationResult.message!, validationResult.errorCode);
    }

    // 2. 프로필 이미지 URL 검증 (선택적)
    if (profileImageUrl != null) {
      final imageValidation = _validateImageUrl(profileImageUrl);
      if (imageValidation.isFailure) {
        return Result.failure(imageValidation.message!, imageValidation.errorCode);
      }
    }

    // 3. Repository를 통해 데이터 계층 호출
    final result = await _profileRepository.setupProfile(
      nickname: nickname.trim(), // 공백 제거
      profileImageUrl: profileImageUrl?.trim(),
    );

    // 4. 결과 로깅
    result.fold(
      onSuccess: (response) => print('✅ 프로필 설정 성공: ${response.nickname}'),
      onFailure: (error, code) => print('❌ 프로필 설정 실패: $error'),
    );

    return result;
  }

  // =============================================================
  // 🏷️ 닉네임 개별 변경 (추후 확장용)
  // =============================================================

  /// 닉네임만 개별 변경
  ///
  /// 빠른 닉네임 변경을 위한 경량 메서드 (추후 구현)
  Future<Result<void>> updateNickname(String nickname) async {
    // TODO: 나중에 닉네임 전용 API가 생기면 구현
    // 현재는 setupProfile을 사용
    final result = await setupProfile(nickname: nickname);

    // SetupProfileResponse -> void 변환
    return result.fold(
      onSuccess: (_) => Result.success(null),
      onFailure: (error, code) => Result.failure(error, code),
    );
  }

  // =============================================================
  // 🖼️ 프로필 이미지 변경 (추후 확장용)
  // =============================================================

  /// 프로필 이미지만 변경 (추후 구현)
  Future<Result<void>> updateProfileImage(String imageUrl) async {
    // TODO: 이미지 전용 API 구현 시 추가
    throw UnimplementedError('프로필 이미지 변경 기능은 곧 구현될 예정입니다');
  }

  // =============================================================
  // 🔍 프로필 조회 (추후 확장용)
  // =============================================================

  /// 내 프로필 정보 조회 (추후 구현)
  Future<Result<SetupProfileResponse>> getMyProfile() async {
    // TODO: 프로필 조회 API 구현 시 추가
    throw UnimplementedError('프로필 조회 기능은 곧 구현될 예정입니다');
  }

  // =============================================================
  // 🔧 내부 검증 메서드들
  // =============================================================

  /// 닉네임 유효성 검증
  Result<void> _validateNickname(String nickname) {
    final trimmed = nickname.trim();

    // 빈 값 체크
    if (trimmed.isEmpty) {
      return Result.failure('닉네임을 입력해주세요');
    }

    // 길이 검증
    if (trimmed.length < 2) {
      return Result.failure('닉네임은 2글자 이상이어야 합니다');
    }

    if (trimmed.length > 15) {
      return Result.failure('닉네임은 15글자 이하여야 합니다');
    }

    // 허용 문자 검증 (서버와 동일한 규칙)
    final nicknameRegex = RegExp(r'^[가-힣a-zA-Z0-9._-]+$');
    if (!nicknameRegex.hasMatch(trimmed)) {
      return Result.failure('닉네임은 한글, 영문, 숫자, 언더스코어(_), 하이픈(-), 점(.)만 사용 가능합니다');
    }

    // 금지어 체크 (클라이언트 레벨 사전 검증)
    final forbiddenWords = ['admin', 'test', 'system', '관리자', '운영자'];
    final lowerNickname = trimmed.toLowerCase();

    for (final word in forbiddenWords) {
      if (lowerNickname.contains(word.toLowerCase())) {
        return Result.failure('사용할 수 없는 닉네임입니다');
      }
    }

    return Result.success(null);
  }

  /// 프로필 이미지 URL 유효성 검증
  Result<void> _validateImageUrl(String imageUrl) {
    final trimmed = imageUrl.trim();

    if (trimmed.isEmpty) {
      return Result.success(null); // 빈 URL은 허용 (null로 처리됨)
    }

    // 기본 URL 형식 검증
    final urlRegex = RegExp(r'^https?://[^\s]+$');
    if (!urlRegex.hasMatch(trimmed)) {
      return Result.failure('올바른 이미지 URL 형식이 아닙니다');
    }

    // HTTPS 권장 (경고만, 에러는 아님)
    if (!trimmed.startsWith('https://')) {
      print('⚠️ HTTPS URL 사용을 권장합니다: $trimmed');
    }

    // URL 길이 제한
    if (trimmed.length > 500) {
      return Result.failure('이미지 URL이 너무 깁니다 (최대 500자)');
    }

    return Result.success(null);
  }
}