import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/result.dart';
import '../../data/models/repositories/insight_repository.dart';
import '../../data/models/response/insight_response.dart';

final insightUseCaseProvider = Provider<InsightUseCase>((ref) {
  return InsightUseCase(ref.watch(insightRepositoryProvider));
});

class InsightUseCase {
  final InsightRepository _repository;
  InsightUseCase(this._repository);

  Future<Result<List<InsightResponse>>> getInsights() {
    return _repository.getRandomInsights(3); // 기본 3개 요청
  }
}