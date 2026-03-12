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
  Future<void> loadTestDetail({int? testId, String? tag}) async {
    print('🔍 loadTestDetail 시작: $testId');
    print('🔍 현재 상태: isLoading=${state.isLoading}, hasDetail=${state.testDetail != null}');

    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      errorCode: null,
    );

    print('📱 로딩 상태 설정 후: isLoading=${state.isLoading}');

    try {
      final testUseCase = ref.read(testUseCaseProvider);

      // 💡 ID 또는 Tag에 따라 분기 처리
      Result<TestDetailResponse> result;
      if (tag != null) {
        result = await testUseCase.getTestDetailByTag(tag);
      } else if (testId != null) {
        result = await testUseCase.getTestDetail(testId);
      } else {
        state = state.copyWith(isLoading: false, errorMessage: '요청 정보가 없습니다.');
        return;
      }

      result.fold(
        onSuccess: (testDetail) {
          state = state.copyWith(
            isLoading: false,
            testDetail: testDetail,
          );
        },
        onFailure: (message, errorCode) {
          state = state.copyWith(
            isLoading: false,
            testDetail: null,
            errorMessage: message,
            errorCode: errorCode,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '오류가 발생했습니다: $e',
        errorCode: 'UNKNOWN_ERROR',
      );
    }
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
