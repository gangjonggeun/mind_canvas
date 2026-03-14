import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
// 경로에 맞게 임포트 확인해주세요!
import 'package:mind_canvas/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mind_canvas/features/profile/presentation/providers/profile_notifier.dart';
import '../../domain/entities/inbox_message.dart';

part 'inbox_notifier.freezed.dart';

// 💡 1. State 정의
@freezed
class InboxState with _$InboxState {
  const InboxState._();
  const factory InboxState({
    @Default([]) List<InboxMessage> messages,
    @Default(0) int currentPage,       // 현재 페이지
    @Default(true) bool hasMore,       // 더 가져올 데이터가 있는지 여부
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _InboxState;

  // 🌟 (수정) extension은 삭제하고 여기에만 둡니다.
  int get unreadCount => messages.where((msg) => !msg.isRead).length;
}

// 💡 2. Notifier 구현
class InboxNotifier extends AutoDisposeNotifier<InboxState> {
  @override
  InboxState build() {
    // 💡 build 내부에서만 watch 가능 (필요시)
    _fetchMessages(page: 0); // 첫 페이지 로드
    return const InboxState();
  }

  // 보상 수령
  Future<void> claimReward(int messageId, int rewardInk) async {
    // 🌟 (수정) 내부 함수이므로 ref.read 사용!
    final result = await ref.read(profileRepositoryProvider).claimMessageReward(messageId);

    if (result.isSuccess) {
      ref.read(profileNotifierProvider.notifier).addCoins(rewardInk);

      state = state.copyWith(
        messages: state.messages.map((msg) {
          if (msg.id == messageId) {
            return msg.copyWith(
              isClaimed: true,
              isRead: true,
            );
          }
          return msg;
        }).toList(),
      );
    } else {
      throw Exception(result.errorCode ?? '보상을 수령하지 못했습니다.');
    }
  } // 🌟 (수정) 누락됐던 닫는 중괄호 추가!!

  // 새로고침
  Future<void> refresh() async {
    state = state.copyWith(
        isLoading: true,
        currentPage: 0,
        hasMore: true
    );
    await _fetchMessages(page: 0, isLoadMore: false);
  }

  // 데이터 불러오기
  Future<void> _fetchMessages({required int page, bool isLoadMore = false}) async {
    if (!isLoadMore) state = state.copyWith(isLoading: true);

    // 🌟 (수정) 메서드 내부이므로 ref.watch -> ref.read로 변경!!
    final repo = ref.read(profileRepositoryProvider);
    final result = await repo.getMessages(page, 10);

    result.fold(
      onSuccess: (pageResponse) {
        final newMessages = pageResponse.content;
        state = state.copyWith(
          messages: isLoadMore ?[...state.messages, ...newMessages] : newMessages,
          currentPage: page,
          hasMore: !pageResponse.last,
          isLoading: false,
        );
      },
      onFailure: (msg, code) => state = state.copyWith(isLoading: false, errorMessage: msg),
    );
  }

  // 다음 페이지 불러오기
  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasMore) return;
    await _fetchMessages(page: state.currentPage + 1, isLoadMore: true);
  }

  // 읽음 처리
  Future<void> markAsRead(int id) async {
    // 🌟 (수정) ref.read로 변경!!
    final repo = ref.read(profileRepositoryProvider);
    final result = await repo.markAsRead(id);

    if (result.isSuccess) {
      final updatedMessages = state.messages.map((m) {
        if (m.id == id) {
          return m.copyWith(isRead: true);
        }
        return m;
      }).toList();

      state = state.copyWith(messages: updatedMessages);
    }
  }

  // 읽은 우편 모두 삭제
  Future<void> deleteAllRead() async {
    // 🌟 (수정) ref.read로 변경!!
    final repo = ref.read(profileRepositoryProvider);
    final result = await repo.deleteReadMessages();

    if (result.isSuccess) {
      final filtered = state.messages.where((m) => !m.isRead).toList();
      state = state.copyWith(messages: filtered);
    }
  }
}

// 💡 3. Provider 선언
final inboxNotifierProvider = NotifierProvider.autoDispose<InboxNotifier, InboxState>(
  InboxNotifier.new,
);