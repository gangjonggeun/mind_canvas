// =============================================================
// 📁 lib/features/info/presentation/notifiers/test_detail_notifier.dart
// =============================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../data/models/response/test_detail_response.dart';
import '../../domain/usecases/test_use_case.dart';

part 'test_detail_notifier.freezed.dart';
part 'test_detail_notifier.g.dart';

/// 🔍 테스트 상세 정보 상태
@freezed
class TestDetailState with _$TestDetailState {
  const factory TestDetailState({
    @Default(false) bool isLoading,
    TestDetailResponse? testDetail,
    String? errorMessage,
    String? errorCode,
  }) = _TestDetailState;

  factory TestDetailState.initial() => const TestDetailState();
}

/// 🔍 테스트 상세 정보 Notifier (TestListNotifier와 동일한 패턴)
@riverpod
class TestDetailNotifier extends _$TestDetailNotifier {
  @override
  TestDetailState build() {
    return TestDetailState.initial();
  }

  /// 테스트 상세 정보 로드
  Future<void> loadTestDetail(int testId) async {
    print('🔍 loadTestDetail 시작: $testId');
    print('🔍 현재 상태: isLoading=${state.isLoading}, hasDetail=${state.testDetail != null}');

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      errorCode: null,
    );

    print('📱 로딩 상태 설정 후: isLoading=${state.isLoading}');

    try {
      print('🌐 UseCase 호출 시작');
      final testUseCase = ref.read(testUseCaseProvider);
      final result = await testUseCase.getTestDetail(testId);
      print('📦 UseCase 응답 받음: ${result.isSuccess}');

      result.fold(
        onSuccess: (testDetail) {
          print('✅ 성공 - 상태 업데이트 전: isLoading=${state.isLoading}');
          state = state.copyWith(
            isLoading: false,
            testDetail: testDetail,
            errorMessage: null,
            errorCode: null,
          );
          print('✅ 성공 - 상태 업데이트 후: isLoading=${state.isLoading}, hasDetail=${state.testDetail != null}');
        },
        onFailure: (message, errorCode) {
          print('❌ 실패 처리: $message');
          state = state.copyWith(
            isLoading: false,
            testDetail: null,
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
        errorMessage: '테스트 상세 정보를 불러오는 중 오류가 발생했습니다',
        errorCode: 'UNKNOWN_ERROR',
      );
    }

    print('🏁 최종 상태: isLoading=${state.isLoading}, hasDetail=${state.testDetail != null}');
  }

  void reset() {
    state = TestDetailState.initial();
  }

  void clearError() {
    state = state.copyWith(
      errorMessage: null,
      errorCode: null,
    );
  }
}
