import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// DTO와 UseCase의 정확한 경로로 수정해주세요.
import '../../data/dto/anger_vent_request.dart'; // ChatHistory DTO가 여기 있음
import '../../data/dto/therapy_chat_request.dart';
import '../../domain/usecase/therapy_use_case.dart';

part 'anger_vent_notifier.freezed.dart';
part 'anger_vent_notifier.g.dart';

/// 🔥 화풀기 채팅 상태 (State)
@freezed
class AngerVentState with _$AngerVentState {
  const factory AngerVentState({
    @Default(false) bool isResponding,         // AI 응답 대기 중 (Typing Indicator)
    @Default([]) List<ChatHistory> messages,    // 전체 대화 목록
    String? errorMessage,                     // 메시지 전송 실패 시 에러
  }) = _AngerVentState;

  factory AngerVentState.initial() => const AngerVentState();
}


/// 🔥 화풀기 채팅 Notifier
@riverpod
class AngerVentNotifier extends _$AngerVentNotifier {
  @override
  AngerVentState build() {
    return AngerVentState.initial();
  }

  /// 💬 메시지 전송
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final userMessage = ChatHistory(role: 'USER', content: message);

    // 이전 대화 기록을 가져옴
    final currentHistory = List<ChatHistory>.from(state.messages);

    // 1. UI에 사용자 메시지를 즉시 반영하고, 로딩 상태로 변경
    state = state.copyWith(
      messages: [...currentHistory, userMessage],
      isResponding: true,
      errorMessage: null, // 이전 에러 메시지 초기화
    );

    try {
      final useCase = ref.read(therapyUseCaseProvider);

      // 2. UseCase를 통해 API 호출
      final result = await useCase.sendAngerVentMessage(
        message: message,
        history: currentHistory, // 현재 메시지를 제외한 이전 히스토리 전송
      );

      // 3. 결과 처리
      result.fold(
        onSuccess: (response) {
          final aiMessage = ChatHistory(role: 'AI', content: response.aiResponse);
          state = state.copyWith(
            messages: [...state.messages, aiMessage], // AI 답변 추가
            isResponding: false,
          );
        },
        onFailure: (message, code) {
          state = state.copyWith(
            isResponding: false,
            errorMessage: message, // UI에 에러 메시지 표시
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isResponding: false,
        errorMessage: '메시지 전송 중 알 수 없는 오류가 발생했습니다.',
      );
    }
  }
}