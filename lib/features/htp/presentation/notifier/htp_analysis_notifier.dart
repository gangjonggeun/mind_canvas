
import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/model/request/htp_basic_request.dart';
import '../../data/model/request/htp_premium_request.dart';
import '../../data/model/response/htp_response.dart';
import '../../domain/usecases/htp_use_case_provider.dart';

part 'htp_analysis_notifier.g.dart';

/// 🎨 HTP 분석 상태 관리 Notifier
@riverpod
class HtpAnalysis extends _$HtpAnalysis {
  @override
  FutureOr<HtpResponse?> build() async {
    // 초기 상태: null (아직 분석 안 함)
    return null;
  }

  /// 🖼️ 기본 분석 실행 (✅ 결과 반환)
  Future<HtpResponse?> analyzeBasic({
    required List<File> imageFiles,
    required DrawingProcess drawingProcess,
  }) async {
    // 로딩 상태로 변경
    state = const AsyncValue.loading();

    // UseCase 호출
    final useCase = ref.read(htpUseCaseProvider);
    final result = await useCase.analyzeBasic(
      imageFiles: imageFiles,
      drawingProcess: drawingProcess,
    );

    // Result → AsyncValue 변환 및 결과 반환
    return result.fold(
      onSuccess: (data) {
        print('✅ [Notifier] 기본 분석 성공');
        state = AsyncValue.data(data);
        return data; // ✅ 결과 반환
      },
      onFailure: (message, errorCode) {
        print('❌ [Notifier] 기본 분석 실패: $message');
        state = AsyncValue.error(message, StackTrace.current);
        return null; // ✅ 실패 시 null 반환
      },
    );
  }

  /// 🧠 프리미엄 분석 실행 (✅ 결과 반환)
  Future<HtpResponse?> analyzePremium({
    required List<File> imageFiles,
    required HtpPremiumRequest request,
  }) async {
    // 로딩 상태로 변경
    state = const AsyncValue.loading();

    // UseCase 호출
    final useCase = ref.read(htpUseCaseProvider);
    final result = await useCase.analyzePremium(
      imageFiles: imageFiles,
      request: request,
    );

    // Result → AsyncValue 변환 및 결과 반환
    return result.fold(
      onSuccess: (data) {
        print('✅ [Notifier] 프리미엄 분석 성공');
        state = AsyncValue.data(data);
        return data; // ✅ 결과 반환
      },
      onFailure: (message, errorCode) {
        print('❌ [Notifier] 프리미엄 분석 실패: $message');
        state = AsyncValue.error(message, StackTrace.current);
        return null; // ✅ 실패 시 null 반환
      },
    );
  }

  /// 🔄 상태 초기화 (새로운 분석 시작 전)
  void reset() {
    state = const AsyncValue.data(null);
  }
}