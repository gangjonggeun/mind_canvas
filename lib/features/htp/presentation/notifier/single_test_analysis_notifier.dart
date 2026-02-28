// features/single_test/presentation/notifier/single_test_analysis_notifier.dart

import 'dart:io';
import 'package:mind_canvas/features/htp/presentation/notifier/psy_analysis_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


import '../../../../core/utils/result.dart';
import '../../../psy_result/data/model/response/test_result_response.dart';
import '../../data/model/request/htp_basic_request.dart';
import '../../data/model/request/single_test_request.dart';
import '../../domain/usecases/single_test_usecase.dart';
import '../enum/single_test_type.dart';

// 각 검사별 UseCase들 임포트
// import 'starry_sea_usecase...';
// import 'pitr_usecase...';

part 'single_test_analysis_notifier.g.dart';

@riverpod
class SingleTestAnalysis extends _$SingleTestAnalysis {
  @override
  PsyAnalysisState build() => PsyAnalysisState.initial();

  /// 💡 통합 제출 메서드
  Future<void> submitTest({
    required SingleTestType testType,
    required File imageFile,
    required Map<String, String> pdiAnswers,
    required DrawingProcess drawingProcess, // ✅ 추가됨
  }) async {
    state = state.copyWith(isSubmitting: true, isCompleted: false, errorMessage: null);

    try {
      // 🚀 1. DTO로 포장하기
      final requestDTO = SingleTestRequest(
        answers: pdiAnswers,
        drawingProcess: drawingProcess,
      );

      final useCase = ref.read(singleTestUseCaseProvider);

      // 🚀 2. UseCase로 DTO 통째로 전달
      final result = await useCase.analyze(
        testType: testType,
        imageFile: imageFile,
        request: requestDTO, // 👈 맵 대신 DTO 하나만 넘김
      );

      result.fold(
        onSuccess: (data) => state = state.copyWith(isSubmitting: false, isCompleted: true, result: data),
        onFailure: (msg, code) => state = state.copyWith(isSubmitting: false, errorMessage: msg),
      );

    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: '서버 통신 중 오류가 발생했습니다.');
    }
  }
}