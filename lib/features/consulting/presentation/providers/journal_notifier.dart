import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dto/journal_response.dart';
import '../../domain/usecase/therapy_use_case.dart';

part 'journal_notifier.freezed.dart';
part 'journal_notifier.g.dart';

/// 📘 일기 작성 상태 (State)
/// 채팅 상태와 완전히 분리됨
@freezed
class JournalState with _$JournalState {
  const factory JournalState({
    @Default(false) bool isLoading,       // 분석 로딩 중
    JournalResponse? analysisResult,      // 성공 시 담길 AI 분석 결과
    String? errorMessage,                 // 실패 시 에러 메시지
    String? errorCode,
  }) = _JournalState;

  factory JournalState.initial() => const JournalState();
}

/// 📝 일기 작성 Notifier
@riverpod
class JournalNotifier extends _$JournalNotifier {
  @override
  JournalState build() {
    return JournalState.initial();
  }

  /// 📤 일기 제출 및 AI 분석 요청
  Future<void> submitJournal({
    required String date,    // "yyyy-MM-dd"
    required String content, // 일기 내용
  }) async {
    if (content.trim().isEmpty) return;

    print('📝 JournalNotifier - submitJournal 시작');

    // 1. 로딩 상태 및 초기화
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      errorCode: null,
      analysisResult: null, // 이전 결과가 있다면 초기화
    );

    try {
      // UseCase는 기존 TherapyUseCase를 재사용 (또는 JournalUseCase로 분리 가능)
      final useCase = ref.read(therapyUseCaseProvider);

      // 2. API 호출
      final result = await useCase.createJournal(
        date: date,
        content: content,
      );

      // 3. 결과 처리
      result.fold(
        onSuccess: (response) {
          print('✅ JournalNotifier - 분석 완료');
          state = state.copyWith(
            isLoading: false,
            analysisResult: response, // 결과 저장 -> UI에서 감지 후 이동
          );
        },
        onFailure: (message, code) {
          print('❌ JournalNotifier - 실패: $message');
          state = state.copyWith(
            isLoading: false,
            errorMessage: message,
            errorCode: code,
          );
        },
      );
    } catch (e) {
      print('💥 JournalNotifier - 예외 발생: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: '일기를 저장하는 중 알 수 없는 오류가 발생했습니다.',
        errorCode: 'UNKNOWN',
      );
    }
  }

  /// 🔄 상태 초기화 (결과 화면에서 나갈 때 등)
  void resetState() {
    state = JournalState.initial();
  }
}