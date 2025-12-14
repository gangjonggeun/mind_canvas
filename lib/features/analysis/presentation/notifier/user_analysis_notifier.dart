import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dto/psychological_profile_response.dart';
import '../../domain/usecase/user_analysis_use_case.dart';



part 'user_analysis_notifier.freezed.dart';
part 'user_analysis_notifier.g.dart';

/// 📊 사용자 분석 상태 (State)
@freezed
class UserAnalysisState with _$UserAnalysisState {
  const factory UserAnalysisState({
    @Default(false) bool isLoading,
    PsychologicalProfileResponse? profile, // MBTI, Big5 통계 데이터
    String? errorMessage,
    String? errorCode,
  }) = _UserAnalysisState;

  factory UserAnalysisState.initial() => const UserAnalysisState();
}

/// 📊 사용자 분석 Notifier
/// 마이페이지/분석 탭의 상태 관리
@riverpod
class UserAnalysisNotifier extends _$UserAnalysisNotifier {
  @override
  UserAnalysisState build() {
    return UserAnalysisState.initial();
  }

  /// 내 심리 프로필(통계) 로드
  Future<void> loadMyProfile() async {
    print('🔍 loadMyProfile 시작');
    print('🔍 현재 상태: isLoading=${state.isLoading}, hasProfile=${state.profile != null}');

    // 1. 로딩 상태 시작
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      errorCode: null,
    );

    print('📱 로딩 상태 설정 후: isLoading=${state.isLoading}');

    try {
      print('🌐 UseCase 호출 시작');
      final useCase = ref.read(userAnalysisUseCaseProvider);
      final result = await useCase.getMyProfile();
      print('📦 UseCase 응답 받음: isSuccess=${result.isSuccess}');

      // 2. 결과 처리
      result.fold(
        onSuccess: (profileData) {
          print('✅ 성공 - 상태 업데이트 전: isLoading=${state.isLoading}');

          state = state.copyWith(
            isLoading: false,
            profile: profileData,
            errorMessage: null,
            errorCode: null,
          );

          print('✅ 성공 - 상태 업데이트 후: isLoading=${state.isLoading}, hasProfile=${state.profile != null}');
        },
        onFailure: (message, errorCode) {
          print('❌ 실패 처리: $message ($errorCode)');

          state = state.copyWith(
            isLoading: false,
            profile: null, // 실패 시 기존 데이터를 유지할지, 날릴지는 정책에 따라 결정 (여기선 초기화)
            errorMessage: message,
            errorCode: errorCode,
          );

          print('❌ 실패 - 상태 업데이트 완료');
        },
      );
    } catch (e) {
      print('💥 예외 발생: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: '통계 정보를 불러오는 중 알 수 없는 오류가 발생했습니다',
        errorCode: 'UNKNOWN_ERROR',
      );
    }

    print('🏁 최종 상태: isLoading=${state.isLoading}, hasProfile=${state.profile != null}');
  }
}