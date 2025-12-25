import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dto/therapy_chat_request.dart';
import '../../domain/usecase/therapy_use_case.dart';

part 'therapy_notifier.freezed.dart';
part 'therapy_notifier.g.dart';

/// 💬 상담 화면 상태 (State)
@freezed
class TherapyState with _$TherapyState {
  const factory TherapyState({
    @Default(false) bool isLoading,      // AI 답변 생성 중 여부
    @Default([]) List<ChatHistory> chatHistory, // 전체 대화 내역 (UI 표시용)
    String? errorMessage,                // 에러 메시지 (Snackbar용)
    String? errorCode,
  }) = _TherapyState;

  factory TherapyState.initial() => const TherapyState();
}

/// 🧠 상담 Notifier
@riverpod
class TherapyNotifier extends _$TherapyNotifier {
  @override
  TherapyState build() {
    return TherapyState.initial();
  }

  /// 📩 메시지 전송
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    print('💬 sendMessage 시작: $message');

    // 1. 사용자 메시지를 UI에 즉시 추가 (Optimistic Update)
    //    isLoading을 true로 변경하여 '입력 중...' 표시
    final userMsg = ChatHistory(role: 'USER', content: message);

    // API 호출 시 보낼 '이전 대화 내역'을 미리 캡처 (현재 사용자 메시지는 제외)
    final historyToSend = List<ChatHistory>.from(state.chatHistory);

    state = state.copyWith(
      chatHistory: [...state.chatHistory, userMsg],
      isLoading: true,
      errorMessage: null,
      errorCode: null,
    );

    try {
      // 2. 비용 절감을 위한 히스토리 자르기 (최근 20개만 전송)
      final truncatedHistory = _truncateHistory(historyToSend, limit: 20);

      final useCase = ref.read(therapyUseCaseProvider);

      // 3. API 호출
      final result = await useCase.sendMessage(
        message: message,
        history: truncatedHistory,
      );

      // 4. 결과 처리
      result.fold(
        onSuccess: (response) {
          print('✅ AI 응답 수신 완료');

          final aiMsg = ChatHistory(role: 'AI', content: response.aiResponse);

          state = state.copyWith(
            isLoading: false,
            chatHistory: [...state.chatHistory, aiMsg], // AI 답변 추가
          );
        },
        onFailure: (message, code) {
          print('❌ 전송 실패: $message');

          // 실패 시 로딩 끄고 에러 표시
          // (선택 사항: 실패했으므로 아까 추가한 사용자 메시지를 지울 수도 있음)
          state = state.copyWith(
            isLoading: false,
            errorMessage: message,
            errorCode: code,
          );
        },
      );
    } catch (e) {
      print('💥 예외 발생: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: '알 수 없는 오류가 발생했습니다.',
        errorCode: 'UNKNOWN',
      );
    }
  }

  
  /// 🧹 대화 내용 초기화 (새로운 상담 시작)
  void clearChat() {
    state = TherapyState.initial();
  }

  /// ✂️ 히스토리 자르기 (최신 N개만 남김)
  List<ChatHistory> _truncateHistory(List<ChatHistory> history, {int limit = 20}) {
    if (history.length <= limit) return history;
    // 리스트의 뒤에서부터 limit개만큼 가져옴
    return history.sublist(history.length - limit);
  }
}