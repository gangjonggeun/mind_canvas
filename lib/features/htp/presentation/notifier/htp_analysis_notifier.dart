
import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../../psy_result/data/model/response/test_result_response.dart';
import '../../data/model/request/htp_basic_request.dart';
import '../../data/model/request/htp_premium_request.dart';
import '../../domain/usecases/htp_use_case_provider.dart';

part 'htp_analysis_notifier.g.dart';
part 'htp_analysis_notifier.freezed.dart';
@freezed
class HtpTestState with _$HtpTestState {
  const factory HtpTestState({
    @Default(false) bool isSubmitting,
    @Default(false) bool isCompleted,
    TestResultResponse? result, // ✅ TestResultResponse로 통합
    String? errorMessage,
  }) = _HtpTestState;

  factory HtpTestState.initial() => const HtpTestState();
}


@riverpod
class HtpAnalysis extends _$HtpAnalysis {
  @override
  HtpTestState build() {
    return HtpTestState.initial();
  }

  /// 🖼️ 1. HTP 기본 분석 (Basic)
  Future<void> analyzeBasic({
    required List<File> imageFiles,
    required DrawingProcess drawingProcess,
  }) async {
    state = state.copyWith(isSubmitting: true, isCompleted: false, errorMessage: null);

    final useCase = ref.read(htpUseCaseProvider);
    // ✅ UseCase와 Repository의 리턴 타입도 TestResultResponse로 맞춰야 합니다.
    final result = await useCase.analyzeBasic(
      imageFiles: imageFiles,
      drawingProcess: drawingProcess,
    );

    _handleResult(result);
  }

  /// 🧠 2. HTP 프리미엄 분석 (Premium)
  Future<void> analyzePremium({
    required List<File> imageFiles,
    required HtpPremiumRequest request,
  }) async {
    state = state.copyWith(isSubmitting: true, isCompleted: false, errorMessage: null);

    final useCase = ref.read(htpUseCaseProvider);
    final result = await useCase.analyzePremium(
      imageFiles: imageFiles,
      request: request,
    );

    _handleResult(result);
  }

  /// 🛠️ 공통 결과 처리 로직
  void _handleResult(Result<TestResultResponse> result) {
    result.fold(
      onSuccess: (data) {
        print('✅ [Notifier] HTP 분석 접수 성공 (resultKey: ${data.resultKey})');
        state = state.copyWith(
          isSubmitting: false,
          isCompleted: true,
          result: data,
        );
      },
      onFailure: (message, errorCode) {
        print('❌ [Notifier] HTP 분석 실패: $message');
        state = state.copyWith(
          isSubmitting: false,
          isCompleted: false,
          errorMessage: message,
        );
      },
    );
  }

  void reset() {
    state = HtpTestState.initial();
  }
}