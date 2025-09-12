import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../domain/models/test_ranking_item.dart';
import '../../domain/repositories/test_repository.dart';
import '../../data/repositories/test_repository_provider.dart';

part 'test_list_notifier.g.dart';

/// 테스트 목록 상태 관리
@riverpod
class TestListNotifier extends _$TestListNotifier {
  @override
  TestListState build() {
    return const TestListState.initial();
  }

  /// 최신 테스트 목록 로드
  Future<void> loadLatestTests({int page = 0, int size = 20}) async {
    // 첫 페이지 로딩 시 로딩 상태로 변경
    if (page == 0) {
      state = const TestListState.loading();
    }

    try {
      final repository = ref.read(testRepositoryProvider);
      final result = await repository.getLatestTests(page: page, size: size);

      result.fold(
        onSuccess: (data) => _handleLoadSuccess(data, page),
        onFailure: (message, errorCode) => _handleLoadFailure(message, errorCode),
      );
    } catch (e) {
      state = TestListState.error('예상치 못한 오류가 발생했습니다: $e');
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadLatestTests(page: 0, size: 20);
  }

  /// 무한 스크롤을 위한 다음 페이지 로드
  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is _Loaded && currentState.hasMore && !currentState.isLoadingMore) {
      // 다음 페이지 로딩 상태 설정
      state = currentState.copyWith(isLoadingMore: true);

      final nextPage = currentState.currentPage + 1;
      await loadLatestTests(page: nextPage, size: 20);
    }
  }

  /// 로드 성공 처리
  void _handleLoadSuccess(TestListResult data, int page) {
    if (page == 0) {
      // 첫 페이지 로드
      state = TestListState.loaded(
        items: data.tests,
        hasMore: data.hasMore,
        currentPage: page,
        isLoadingMore: false,
      );
    } else {
      // 추가 페이지 로드 (기존 아이템에 추가)
      final currentState = state;
      if (currentState is _Loaded) {
        state = TestListState.loaded(
          items: [...currentState.items, ...data.tests],
          hasMore: data.hasMore,
          currentPage: page,
          isLoadingMore: false,
        );
      }
    }
  }

  /// 로드 실패 처리
  void _handleLoadFailure(String message, String? errorCode) {
    final currentState = state;

    // 추가 페이지 로딩 실패인 경우 기존 상태 유지하고 로딩만 해제
    if (currentState is _Loaded && currentState.isLoadingMore) {
      state = currentState.copyWith(isLoadingMore: false);
      // TODO: 스낵바나 토스트로 에러 메시지 표시
      print('추가 페이지 로드 실패: $message');
    } else {
      // 첫 페이지 로딩 실패인 경우 에러 상태로 변경
      state = TestListState.error(message);
    }
  }

  /// 현재 로딩 상태 확인
  bool get isLoading {
    return state is _Loading ||
        (state is _Loaded && (state as _Loaded).isLoadingMore);
  }

  /// 현재 에러 상태 확인
  bool get hasError {
    return state is _Error;
  }
}

/// 테스트 목록 상태 정의
sealed class TestListState {
  const TestListState();

  const factory TestListState.initial() = _Initial;
  const factory TestListState.loading() = _Loading;
  const factory TestListState.loaded({
    required List<TestRankingItem> items,
    required bool hasMore,
    required int currentPage,
    required bool isLoadingMore,
  }) = _Loaded;
  const factory TestListState.error(String message) = _Error;

  /// 패턴 매칭
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(List<TestRankingItem> items, bool hasMore, int currentPage, bool isLoadingMore) loaded,
    required T Function(String message) error,
  }) {
    return switch (this) {
      _Initial() => initial(),
      _Loading() => loading(),
      _Loaded(:final items, :final hasMore, :final currentPage, :final isLoadingMore) => loaded(items, hasMore, currentPage, isLoadingMore),
      _Error(:final message) => error(message),
    };
  }

  /// 옵셔널 패턴 매칭
  T? maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(List<TestRankingItem> items, bool hasMore, int currentPage, bool isLoadingMore)? loaded,
    T Function(String message)? error,
    required T Function() orElse,
  }) {
    return switch (this) {
      _Initial() => initial?.call() ?? orElse(),
      _Loading() => loading?.call() ?? orElse(),
      _Loaded(:final items, :final hasMore, :final currentPage, :final isLoadingMore) => loaded?.call(items, hasMore, currentPage, isLoadingMore) ?? orElse(),
      _Error(:final message) => error?.call(message) ?? orElse(),
    };
  }
}

// 상태 구현 클래스들
final class _Initial extends TestListState {
  const _Initial();
}

final class _Loading extends TestListState {
  const _Loading();
}

final class _Loaded extends TestListState {
  final List<TestRankingItem> items;
  final bool hasMore;
  final int currentPage;
  final bool isLoadingMore;

  const _Loaded({
    required this.items,
    required this.hasMore,
    required this.currentPage,
    required this.isLoadingMore,
  });

  /// copyWith 메서드 (상태 업데이트용)
  _Loaded copyWith({
    List<TestRankingItem>? items,
    bool? hasMore,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return _Loaded(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final class _Error extends TestListState {
  final String message;
  const _Error(this.message);
}
