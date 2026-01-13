import '../../../../core/utils/result.dart'; // Result<T> 경로 확인
import '../../data/dto/content_rec_response.dart';
import '../../domain/enums/rec_category.dart';

abstract class RecommendationRepository {
  /// 🎬 콘텐츠 추천 요청
  Future<Result<ContentRecResponse>> recommendContent({
    required List<RecCategory> categories,
    String? userMood,
    bool forceRefresh,
  });
}