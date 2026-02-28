import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../psy_result/data/model/response/test_result_response.dart';

part 'psy_analysis_state.freezed.dart';

@freezed
class PsyAnalysisState with _$PsyAnalysisState {
  const factory PsyAnalysisState({
    @Default(false) bool isSubmitting,
    @Default(false) bool isCompleted,
    TestResultResponse? result,
    String? errorMessage,
  }) = _PsyAnalysisState;

  factory PsyAnalysisState.initial() => const PsyAnalysisState();
}