import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../data/dto/content_rec_response.dart';
import '../../domain/enums/rec_category.dart';
import '../repository/recommendation_repository.dart';
import '../../data/repository/recommendation_repository_impl.dart';

part 'recommend_content_use_case.g.dart';

@riverpod
RecommendContentUseCase recommendContentUseCase(RecommendContentUseCaseRef ref) {
  final repository = ref.watch(recommendationRepositoryProvider);
  return RecommendContentUseCase(repository);
}

class RecommendContentUseCase {
  final RecommendationRepository _repository;

  RecommendContentUseCase(this._repository);

  Future<Result<ContentRecResponse>> execute({
    required List<RecCategory> categories,
    String? userMood,
    bool forceRefresh = false, // ✅ 추가됨
  }) {
    return _repository.recommendContent(
      categories: categories,
      userMood: userMood,
      forceRefresh: forceRefresh, // 전달
    );
  }
}