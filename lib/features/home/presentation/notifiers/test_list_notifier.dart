// =============================================================
// 📁 lib/features/test/presentation/notifiers/test_list_notifier.dart
// =============================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../domain/models/test_ranking_item.dart';
import '../../domain/repositories/test_repository.dart';
import '../../data/repositories/test_repository_provider.dart';

part 'test_list_notifier.g.dart';

/// 🧠 테스트 목록 상태 관리 (전체 API 지원)
///
/// 서버의 모든 테스트 목록 API를 지원하는 통합 노티파이어
/// 메모리 효율성을 위한 페이징 및 무한 스크롤 지원
@riverpod
class TestListNotifier extends _$TestListNotifier {
  @override
  TestListState build() {
    return const TestListState.initial();
  }

  // =============================================================
  // 🌟 최신순 테스트 목록 (기존 유지)
  // =============================================================

  /// 최신 테스트 목록 로드
  Future<void> loadLatestTests({int page = 0, int size = 20}) async {
    await _loadTests(
      page: page,
      size: size,
      apiCall: (repo) => repo.getLatestTests(page: page, size: size),
      loadType: TestLoadType.latest,
    );
  }

  // =============================================================
  // 🔥 인기도 기준 테스트 목록
  // =============================================================

  /// 인기도 기준 테스트 목록 로드 (페이징)
  Future<void> loadPopularTestsList({int page = 0, int size = 20}) async {
    await _loadTests(
      page: page,
      size: size,
      apiCall: (repo) => repo.getPopularTestsList(page: page, size: size),
      loadType: TestLoadType.popularList,
    );
  }

  /// 홈 화면용 인기 테스트 TOP 5 로드
  Future<void> loadPopularTests() async {
    await _loadTests(
      page: 0,
      size: 5,
      apiCall: (repo) => repo.getPopularTests(),
      loadType: TestLoadType.popular,
    );
  }

  // =============================================================
  // 👁️ 조회수 기준 테스트 목록
  // =============================================================

  /// 조회수 기준 테스트 목록 로드
  Future<void> loadMostViewedTests({int page = 0, int size = 20}) async {
    await _loadTests(
      page: page,
      size: size,
      apiCall: (repo) => repo.getMostViewedTests(page: page, size: size),
      loadType: TestLoadType.mostViewed,
    );
  }

  // =============================================================
  // 📈 트렌딩 테스트 목록
  // =============================================================

  /// 트렌딩 테스트 목록 로드 (7일간 급상승)
  Future<void> loadTrendingTests({int page = 0, int size = 20}) async {
    await _loadTests(
      page: page,
      size: size,
      apiCall: (repo) => repo.getTrendingTests(page: page, size: size),
      loadType: TestLoadType.trending,
    );
  }

  // =============================================================
  // 🔤 가나다순 테스트 목록
  // =============================================================

  /// 가나다순 테스트 목록 로드
  Future<void> loadAlphabeticalTests({int page = 0, int size = 20}) async {
    await _loadTests(
      page: page,
      size: size,
      apiCall: (repo) => repo.getAlphabeticalTests(page: page, size: size),
      loadType: TestLoadType.alphabetical,
    );
  }

  // =============================================================
  // 🔄 공통 액션들
  // =============================================================

  /// 새로고침 (현재 로드 타입 기준)
  Future<void> refresh() async {
    final currentState = state;
    if (currentState is _Loaded) {
      await _refreshByLoadType(currentState.loadType);
    } else {
      // 기본값은 최신순
      await loadLatestTests(page: 0, size: 20);
    }
  }

  /// 무한 스크롤을 위한 다음 페이지 로드
  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is _Loaded &&
        currentState.hasMore &&
        !currentState.isLoadingMore &&
        currentState.loadType != TestLoadType.popular) { // TOP 5는 페이징 없음

      // 다음 페이지 로딩 상태 설정
      state = currentState.copyWith(isLoadingMore: true);

      final nextPage = currentState.currentPage + 1;
      await _loadNextPageByType(currentState.loadType, nextPage);
    }
  }

  /// 로드 타입 변경
  Future<void> changeLoadType(TestLoadType newType) async {
    // 이미 같은 타입이면 새로고침만
    final currentState = state;
    if (currentState is _Loaded && currentState.loadType == newType) {
      await refresh();
      return;
    }

    // 새로운 타입으로 로드
    await _refreshByLoadType(newType);
  }

  // =============================================================
  // 🔧 내부 헬퍼 메서드들
  // =============================================================

  /// 공통 테스트 로드 로직
  Future<void> _loadTests({
    required int page,
    required int size,
    required Future<Result<TestListResult>> Function(TestRepository) apiCall,
    required TestLoadType loadType,
  }) async {
    // 첫 페이지 로딩 시 로딩 상태로 변경
    if (page == 0) {
      state = const TestListState.loading();
    }

    try {
      final repository = ref.read(testRepositoryProvider);
      final result = await apiCall(repository);

      result.fold(
        onSuccess: (data) => _handleLoadSuccess(data, page, loadType),
        onFailure: (message, errorCode) => _handleLoadFailure(message, errorCode),
      );
    } catch (e) {
      state = TestListState.error('예상치 못한 오류가 발생했습니다: $e');
    }
  }

  /// 로드 타입별 새로고침
  Future<void> _refreshByLoadType(TestLoadType loadType) async {
    switch (loadType) {
      case TestLoadType.latest:
        await loadLatestTests(page: 0, size: 20);
        break;
      case TestLoadType.popularList:
        await loadPopularTestsList(page: 0, size: 20);
        break;
      case TestLoadType.popular:
        await loadPopularTests();
        break;
      case TestLoadType.mostViewed:
        await loadMostViewedTests(page: 0, size: 20);
        break;
      case TestLoadType.trending:
        await loadTrendingTests(page: 0, size: 20);
        break;
      case TestLoadType.alphabetical:
        await loadAlphabeticalTests(page: 0, size: 20);
        break;
    }
  }

  /// 로드 타입별 다음 페이지 로드
  Future<void> _loadNextPageByType(TestLoadType loadType, int nextPage) async {
    switch (loadType) {
      case TestLoadType.latest:
        await loadLatestTests(page: nextPage, size: 20);
        break;
      case TestLoadType.popularList:
        await loadPopularTestsList(page: nextPage, size: 20);
        break;
      case TestLoadType.mostViewed:
        await loadMostViewedTests(page: nextPage, size: 20);
        break;
      case TestLoadType.trending:
        await loadTrendingTests(page: nextPage, size: 20);
        break;
      case TestLoadType.alphabetical:
        await loadAlphabeticalTests(page: nextPage, size: 20);
        break;
      case TestLoadType.popular:
      // TOP 5는 페이징 없음
        break;
    }
  }

  /// 로드 성공 처리 (기존 로직 유지)
  void _handleLoadSuccess(TestListResult data, int page, TestLoadType loadType) {
    if (page == 0) {
      // 첫 페이지 로드
      state = TestListState.loaded(
        items: data.tests,
        hasMore: data.hasMore,
        currentPage: page,
        isLoadingMore: false,
        loadType: loadType,
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
          loadType: loadType,
        );
      }
    }
  }

  /// 로드 실패 처리 (기존 로직 유지)
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

  // =============================================================
  // 📊 상태 확인 프로퍼티들
  // =============================================================

  /// 현재 로딩 상태 확인
  bool get isLoading {
    return state is _Loading ||
        (state is _Loaded && (state as _Loaded).isLoadingMore);
  }

  /// 현재 에러 상태 확인
  bool get hasError {
    return state is _Error;
  }

  /// 현재 로드된 아이템 수
  int get itemCount {
    final currentState = state;
    return currentState is _Loaded ? currentState.items.length : 0;
  }

  /// 더 로드할 데이터가 있는지 확인
  bool get hasMore {
    final currentState = state;
    return currentState is _Loaded ? currentState.hasMore : false;
  }

  /// 현재 로드 타입
  TestLoadType? get currentLoadType {
    final currentState = state;
    return currentState is _Loaded ? currentState.loadType : null;
  }
}

// =============================================================
// 📊 테스트 로드 타입 열거형
// =============================================================

/// 🎯 테스트 로드 타입
enum TestLoadType {
  latest('최신순'),
  popularList('인기순'),
  popular('인기 TOP 5'),
  mostViewed('조회수순'),
  trending('트렌딩'),
  alphabetical('가나다순');

  const TestLoadType(this.displayName);
  final String displayName;
}

// =============================================================
// 📊 테스트 목록 상태 정의 (확장 버전)
// =============================================================

/// 🗂️ 테스트 목록 상태 정의
sealed class TestListState {
  const TestListState();

  const factory TestListState.initial() = _Initial;
  const factory TestListState.loading() = _Loading;
  const factory TestListState.loaded({
    required List<TestRankingItem> items,
    required bool hasMore,
    required int currentPage,
    required bool isLoadingMore,
    required TestLoadType loadType, // 추가: 현재 로드 타입
  }) = _Loaded;
  const factory TestListState.error(String message) = _Error;

  /// 패턴 매칭
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(
        List<TestRankingItem> items,
        bool hasMore,
        int currentPage,
        bool isLoadingMore,
        TestLoadType loadType,
        ) loaded,
    required T Function(String message) error,
  }) {
    return switch (this) {
      _Initial() => initial(),
      _Loading() => loading(),
      _Loaded(
          :final items,
          :final hasMore,
          :final currentPage,
          :final isLoadingMore,
          :final loadType,
      ) => loaded(items, hasMore, currentPage, isLoadingMore, loadType),
      _Error(:final message) => error(message),
    };
  }

  /// 옵셔널 패턴 매칭
  T? maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(
        List<TestRankingItem> items,
        bool hasMore,
        int currentPage,
        bool isLoadingMore,
        TestLoadType loadType,
        )? loaded,
    T Function(String message)? error,
    required T Function() orElse,
  }) {
    return switch (this) {
      _Initial() => initial?.call() ?? orElse(),
      _Loading() => loading?.call() ?? orElse(),
      _Loaded(
          :final items,
          :final hasMore,
          :final currentPage,
          :final isLoadingMore,
          :final loadType,
      ) => loaded?.call(items, hasMore, currentPage, isLoadingMore, loadType) ?? orElse(),
      _Error(:final message) => error?.call(message) ?? orElse(),
    };
  }
}

// =============================================================
// 📊 상태 구현 클래스들 (확장 버전)
// =============================================================

/// 초기 상태
final class _Initial extends TestListState {
  const _Initial();
}

/// 로딩 상태
final class _Loading extends TestListState {
  const _Loading();
}

/// 로드 완료 상태
final class _Loaded extends TestListState {
  final List<TestRankingItem> items;
  final bool hasMore;
  final int currentPage;
  final bool isLoadingMore;
  final TestLoadType loadType; // 추가: 현재 로드 타입

  const _Loaded({
    required this.items,
    required this.hasMore,
    required this.currentPage,
    required this.isLoadingMore,
    required this.loadType,
  });

  /// copyWith 메서드 (상태 업데이트용)
  _Loaded copyWith({
    List<TestRankingItem>? items,
    bool? hasMore,
    int? currentPage,
    bool? isLoadingMore,
    TestLoadType? loadType,
  }) {
    return _Loaded(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadType: loadType ?? this.loadType,
    );
  }
}

/// 에러 상태
final class _Error extends TestListState {
  final String message;
  const _Error(this.message);
}

// =============================================================
// 📝 사용 예시 (주석)
// =============================================================

/*
// 위젯에서 사용하는 방법:

class TestListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testListState = ref.watch(testListNotifierProvider);
    final testListNotifier = ref.read(testListNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('테스트 목록'),
        actions: [
          // 정렬 옵션 선택
          PopupMenuButton<TestLoadType>(
            onSelected: (type) => testListNotifier.changeLoadType(type),
            itemBuilder: (context) => TestLoadType.values.map((type) =>
              PopupMenuItem(value: type, child: Text(type.displayName))
            ).toList(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => testListNotifier.refresh(),
        child: testListState.when(
          initial: () => const Center(child: Text('테스트 목록을 불러오세요')),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (items, hasMore, currentPage, isLoadingMore, loadType) {
            return ListView.builder(
              itemCount: items.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                // 로딩 인디케이터
                if (index == items.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 무한 스크롤 트리거
                if (index == items.length - 1 && hasMore) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    testListNotifier.loadNextPage();
                  });
                }

                // 테스트 카드
                final test = items[index];
                return TestCard(test: test);
              },
            );
          },
          error: (message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('오류: $message'),
                ElevatedButton(
                  onPressed: () => testListNotifier.refresh(),
                  child: Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => testListNotifier.loadPopularTests(),
        child: Icon(Icons.star),
      ),
    );
  }
}

// 홈 화면에서 인기 테스트만 로드:
class HomePopularTestsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testListState = ref.watch(testListNotifierProvider);
    
    useEffect(() {
      // 위젯 마운트 시 인기 테스트 로드
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(testListNotifierProvider.notifier).loadPopularTests();
      });
      return null;
    }, []);

    return testListState.maybeWhen(
      loaded: (items, hasMore, currentPage, isLoadingMore, loadType) {
        if (loadType == TestLoadType.popular) {
          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) => PopularTestCard(test: items[index]),
            ),
          );
        }
        return const SizedBox.shrink();
      },
      orElse: () => const CircularProgressIndicator(),
    );
  }
}
*/