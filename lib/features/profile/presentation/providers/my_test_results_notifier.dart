import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/utils/result.dart';
import '../../../home/domain/usecases/test_use_case.dart';
import '../../../recommendation/data/dto/post_response.dart';
import '../../data/models/response/profile_dto.dart';
import '../../domain/usecases/profile_usecase_provider.dart';

part 'my_test_results_notifier.g.dart';


@riverpod
class MyTestResultsNotifier extends _$MyTestResultsNotifier {
  int _currentPage = 0;
  bool _isLastPage = false;

  @override
  FutureOr<List<MyTestResultSummaryResponse>> build() async {
    _currentPage = 0;
    return _fetchPage();
  }


  // ✅ 삭제 메서드 추가
  Future<void> deleteResult(int resultId) async {
    // 1. 상태가 로딩/에러가 아닌 '데이터'일 때만 삭제 진행
    final currentState = state;
    if (currentState is! AsyncData<List<MyTestResultSummaryResponse>>) return;

    final testUseCase = ref.read(testUseCaseProvider);
    final result = await testUseCase.deleteTestResult(resultId);

    // 3. 성공 시 UI 즉시 업데이트 (필터링)
    result.fold(
      onSuccess: (_) {
        final currentList = currentState.value;
        // 삭제된 아이템을 제외한 새 리스트 생성
        final newList = currentList.where((item) => item.id != resultId).toList();
        state = AsyncData(newList); // UI 즉시 반영
      },
      onFailure: (msg, _) {
        // 실패 시 처리 (예: 에러 메시지 노티파이)
        throw Exception(msg);
      },
    );
  }

  Future<List<MyTestResultSummaryResponse>> _fetchPage() async {
    final result = await ref.read(profileUseCaseProvider).getTestResults(_currentPage, 10);
    return result.fold(
      onSuccess: (page) {
        _isLastPage = page.last;
        return page.content;
      },
      onFailure: (msg, _) => throw Exception(msg),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading || _isLastPage) return;
    final previous = state.value ?? [];
    _currentPage++;
    state = await AsyncValue.guard(() async {
      final next = await _fetchPage();
      return [...previous, ...next];
    });
  }
}