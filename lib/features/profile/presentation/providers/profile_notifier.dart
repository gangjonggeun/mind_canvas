import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/app_language_provider.dart';
import '../../data/models/response/profile_dto.dart';
import '../../domain/usecases/profile_usecase_provider.dart';

part 'profile_notifier.freezed.dart';

part 'profile_notifier.g.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    ProfileSummaryResponse? summary,
    String? errorMessage,
  }) = _ProfileState;

  factory ProfileState.initial() => const ProfileState();
}

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  ProfileState build() {
    // 생성 시점에는 초기 상태만 반환 (데이터 로드는 UI에서 init 시점이나 필요할 때 호출)
    return ProfileState.initial();
  }

  /// 📊 프로필 정보 로드
  Future<void> loadProfileSummary() async {
    // 로딩 시작 시 에러 메시지 초기화 중요!
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await ref.read(profileUseCaseProvider).getSummary();

    result.fold(
      onSuccess: (data) {
        state = state.copyWith(isLoading: false, summary: data);
      },
      onFailure: (msg, code) {
        state = state.copyWith(isLoading: false, errorMessage: msg);
      },
    );
  }

  /// 📝 프로필 수정 (닉네임, 이미지) - 추가됨!
  /// 반환값을 bool로 주어 UI에서 토스트 메시지 등을 띄울 수 있게 함
  Future<bool> updateProfile({
    required String nickname,
    File? imageFile,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await ref.read(profileUseCaseProvider).setupProfile(
          nickname: nickname,
          isTermsAgreed: true,
          imageFile: imageFile,
        );

    return result.fold(
      onSuccess: (setupResponse) {
        // 방법 1: 수정 성공 후 전체 정보를 다시 로드하여 동기화 (가장 안전함)
        loadProfileSummary();

        // 방법 2: setupResponse 데이터를 이용해 로컬 state만 즉시 업데이트 (빠른 반응성)
        // 만약 SetupProfileResponse가 ProfileSummaryResponse와 필드가 같다면 copyWith로 덮어쓰기 가능
        // 여기서는 안전하게 재로딩을 호출했습니다.
        return true;
      },
      onFailure: (msg, code) {
        state = state.copyWith(isLoading: false, errorMessage: msg);
        return false;
      },
    );
  }

  /// 🌐 언어 변경 및 상태 동기화
  Future<void> changeLanguage(String languageCode) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result =
        await ref.read(profileUseCaseProvider).changeLanguage(languageCode);

    result.fold(
      onSuccess: (_) {
        ref.read(appLanguageProvider.notifier).setLanguage(languageCode);
        // 언어가 바뀌었으니 프로필 정보(혹은 다국어 데이터)를 갱신
        loadProfileSummary();
      },
      onFailure: (msg, code) {
        state = state.copyWith(isLoading: false, errorMessage: msg);
      },
    );
  }
}
