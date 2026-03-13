import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dto/therapy_chat_request.dart';
import '../../domain/usecase/therapy_use_case.dart';

part 'therapy_notifier.freezed.dart';
part 'therapy_notifier.g.dart';

@freezed
class TherapyState with _$TherapyState {
  const factory TherapyState({
    @Default(false) bool isLoading,
    @Default([]) List<ChatHistory> chatHistory,
    String? errorMessage,
    String? errorCode,
  }) = _TherapyState;

  factory TherapyState.initial() => const TherapyState();
}

@riverpod
class TherapyNotifier extends _$TherapyNotifier {
  static const String _boxName = 'chat_cache_box';
  static const String _cacheKey = 'therapy_history_cache';

  @override
  TherapyState build() {
    // 💡 1. 앱(화면) 시작 시 Hive에서 기존 대화 내역 불러오기
    final box = Hive.box<String>(_boxName);
    final cachedData = box.get(_cacheKey);

    List<ChatHistory> initialHistory =[];
    if (cachedData != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(cachedData);
        // ChatHistory에 fromJson이 있다고 가정 (없으면 역할/내용 매핑 필요)
        initialHistory = decodedList.map((e) => ChatHistory.fromJson(e)).toList();
      } catch (e) {
        print('⚠️ Therapy 캐시 파싱 실패: $e');
      }
    }

    // 불러온 데이터로 초기 상태 설정
    return TherapyState(chatHistory: initialHistory);
  }

  /// 💾 Hive에 현재 대화 내역 저장하는 헬퍼 함수
  void _saveToHive(List<ChatHistory> history) {
    final box = Hive.box<String>(_boxName);
    final encoded = jsonEncode(history.map((e) => e.toJson()).toList());
    box.put(_cacheKey, encoded);
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final userMsg = ChatHistory(role: 'USER', content: message);
    final historyToSend = List<ChatHistory>.from(state.chatHistory);

    // 사용자 메시지 UI 반영
    final updatedHistory = [...state.chatHistory, userMsg];
    state = state.copyWith(
      chatHistory: updatedHistory,
      isLoading: true,
      errorMessage: null,
      errorCode: null,
    );

    // 💡 2. 사용자 메시지 전송 직후 로컬 저장
    _saveToHive(updatedHistory);

    try {
      final truncatedHistory = _truncateHistory(historyToSend, limit: 20);
      final useCase = ref.read(therapyUseCaseProvider);

      final result = await useCase.sendMessage(
        message: message,
        history: truncatedHistory,
      );

      result.fold(
        onSuccess: (response) {
          final aiMsg = ChatHistory(role: 'AI', content: response.aiResponse);

          final finalHistory =[...state.chatHistory, aiMsg];
          state = state.copyWith(
            isLoading: false,
            chatHistory: finalHistory,
          );

          // 💡 3. AI 답변 수신 후 로컬 저장
          _saveToHive(finalHistory);
        },
        onFailure: (message, code) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: message,
            errorCode: code,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '알 수 없는 오류가 발생했습니다.',
        errorCode: 'UNKNOWN',
      );
    }
  }

  /// 🧹 대화 내용 초기화 (새로운 상담 시작 버튼 누를 때 호출)
  void clearChat() {
    state = const TherapyState(); // 상태 초기화
    Hive.box<String>(_boxName).delete(_cacheKey); // 💡 Hive 캐시 삭제
  }

  List<ChatHistory> _truncateHistory(List<ChatHistory> history, {int limit = 5}) {
    if (history.length <= limit) return history;
    return history.sublist(history.length - limit);
  }
}