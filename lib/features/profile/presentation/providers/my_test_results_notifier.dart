import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/utils/result.dart';
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