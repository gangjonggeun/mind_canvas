// =============================================================
// 📁 features/taro/presentation/providers/taro_analysis_notifier.dart
// =============================================================

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dto/request/submit_taro_request.dart';
import '../../domain/models/TaroResultEntity.dart';
import '../../domain/usecases/taro_use_case.dart';



part 'taro_analysis_notifier.g.dart';
part 'taro_analysis_notifier.freezed.dart';


@freezed
class TarotAnalysisState with _$TarotAnalysisState {
  const factory TarotAnalysisState({
    @Default(false) bool isSubmitting,
    @Default(false) bool isCompleted,
    TaroResultEntity? result,
    String? errorMessage,
  }) = _TarotAnalysisState;
}

@riverpod
class TaroAnalysis extends _$TaroAnalysis {

  @override
  TarotAnalysisState build() {
    return const TarotAnalysisState();
  }
  /// 🔮 타로 상담 실행
  Future<void> analyzeTaro(SubmitTaroRequest request) async {
    // 1. 제출 상태로 변경
    state = state.copyWith(
      isSubmitting: true,
      isCompleted: false,
      errorMessage: null,
      result: null,
    );

    final useCase = ref.read(taroUseCaseProvider);
    final result = await useCase.analyzeTaro(request);

    result.fold(
      onSuccess: (data) {
        state = state.copyWith(
          isSubmitting: false,
          isCompleted: true,
          result: data, // 서버에서 비동기면 id가 "PENDING"인 데이터가 들어옴
        );
      },
      onFailure: (message, errorCode) {
        state = state.copyWith(
          isSubmitting: false,
          isCompleted: false,
          errorMessage: message,
        );
      },
    );
  }

  void reset() {
    state = const TarotAnalysisState(); // 초기 상태로 (isSubmitting: false 등)
  }

}