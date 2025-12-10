// =============================================================
// 📁 features/taro/presentation/providers/taro_analysis_notifier.dart
// =============================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dto/request/submit_taro_request.dart';
import '../../domain/models/TaroResultEntity.dart';
import '../../domain/usecases/taro_use_case.dart';



part 'taro_analysis_notifier.g.dart';

/// 🔮 타로 분석 상태 관리 Notifier
///
/// UI 상태(로딩, 에러, 데이터)를 관리하고 UseCase를 실행합니다.
@Riverpod(keepAlive: true)
class TaroAnalysis extends _$TaroAnalysis {
  @override
  FutureOr<TaroResultEntity?> build() async {
    // 초기 상태: null (분석 전)
    return null;
  }

  /// 🔮 타로 상담 실행 (✅ 결과 반환)
  Future<TaroResultEntity?> analyzeTaro(SubmitTaroRequest request) async {
    // 1. 로딩 상태로 변경
    state = const AsyncValue.loading();

    // 2. UseCase 호출
    final useCase = ref.read(taroUseCaseProvider);
    final result = await useCase.analyzeTaro(request);

    // 3. Result → AsyncValue 변환 및 결과 반환
    return result.fold(
      onSuccess: (data) {
        print('✅ [Notifier] 타로 분석 성공');
        state = AsyncValue.data(data);
        return data; // UI에서 화면 이동 등에 사용
      },
      onFailure: (message, errorCode) {
        print('❌ [Notifier] 타로 분석 실패: $message');
        state = AsyncValue.error(message, StackTrace.current);
        return null; // 실패 시 null 반환
      },
    );
  }

  /// 상태 초기화 (재상담 시 사용)
  void reset() {
    state = const AsyncValue.data(null);
  }
}