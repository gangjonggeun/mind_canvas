import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/dto/anger_vent_request.dart';
import '../../data/dto/therapy_chat_request.dart';
import '../../domain/usecase/therapy_use_case.dart';

part 'anger_vent_notifier.freezed.dart';
part 'anger_vent_notifier.g.dart';

@freezed
class AngerVentState with _$AngerVentState {
  const factory AngerVentState({
    @Default(false) bool isResponding,
    @Default([]) List<ChatHistory> messages,
    String? errorMessage,
  }) = _AngerVentState;

  factory AngerVentState.initial() => const AngerVentState();
}

@riverpod
class AngerVentNotifier extends _$AngerVentNotifier {
  static const String _boxName = 'chat_cache_box';
  static const String _cacheKey = 'anger_vent_history_cache';

  @override
  AngerVentState build() {
    // 💡 1. 화풀기 캐시 불러오기
    final box = Hive.box<String>(_boxName);
    final cachedData = box.get(_cacheKey);

    List<ChatHistory> initialHistory =[];
    if (cachedData != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(cachedData);
        initialHistory = decodedList.map((e) => ChatHistory.fromJson(e)).toList();
      } catch (e) {
        print('⚠️ AngerVent 캐시 파싱 실패: $e');
      }
    }

    return AngerVentState(messages: initialHistory);
  }

  /// 💾 Hive 저장 헬퍼
  void _saveToHive(List<ChatHistory> history) {
    final box = Hive.box<String>(_boxName);
    final encoded = jsonEncode(history.map((e) => e.toJson()).toList());
    box.put(_cacheKey, encoded);
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final userMessage = ChatHistory(role: 'USER', content: message);
    final currentHistory = List<ChatHistory>.from(state.messages);

    final updatedHistory = [...currentHistory, userMessage];
    state = state.copyWith(
      messages: updatedHistory,
      isResponding: true,
      errorMessage: null,
    );

    // 💡 2. 사용자 메시지 전송 즉시 캐시 저장
    _saveToHive(updatedHistory);

    try {
      final useCase = ref.read(therapyUseCaseProvider);

      final result = await useCase.sendAngerVentMessage(
        message: message,
        history: _truncateHistory(currentHistory, limit: 10), // 화풀기는 짧게 기억해도 무방
      );

      result.fold(
        onSuccess: (response) {
          final aiMessage = ChatHistory(role: 'AI', content: response.aiResponse);

          final finalHistory =[...state.messages, aiMessage];
          state = state.copyWith(
            messages: finalHistory,
            isResponding: false,
          );

          // 💡 3. AI 답변 수신 후 캐시 저장
          _saveToHive(finalHistory);
        },
        onFailure: (message, code) {
          state = state.copyWith(
            isResponding: false,
            errorMessage: message,
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

  /// 🧹 대화 내용 초기화 (초기화 버튼 연동용)
  void clearChat() {
    state = const AngerVentState();
    Hive.box<String>(_boxName).delete(_cacheKey); // 💡 캐시 삭제
  }

  /// ✂️ 토큰 비용 관리를 위해 서버로 보낼 내역 개수 제한
  List<ChatHistory> _truncateHistory(List<ChatHistory> history, {int limit = 5}) {
    if (history.length <= limit) return history;
    return history.sublist(history.length - limit);
  }
}