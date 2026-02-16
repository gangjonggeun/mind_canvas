import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/response/profile_dto.dart';
import '../../domain/usecases/profile_usecase_provider.dart';

part 'recent_test_results_provider.g.dart';
@riverpod
Future<List<MyTestResultSummaryResponse>> recentTestResults(RecentTestResultsRef ref) async {
  // size를 3으로 고정 호출
  final result = await ref.read(profileUseCaseProvider).getTestResults(0, 3);
  return result.fold(
    onSuccess: (page) => page.content,
    onFailure: (msg, _) => throw Exception(msg),
  );
}