// =============================================================
// 📁 features/taro/domain/repositories/taro_repository.dart
// =============================================================

import '../../../../core/utils/result.dart';
import '../../data/dto/request/submit_taro_request.dart';
import '../models/TaroResultEntity.dart';


abstract class TaroRepository {
  Future<Result<TaroResultEntity>> getTarotResultDetail(String resultId);
  /// 🔮 타로 상담 요청 (AI 분석)
  Future<Result<TaroResultEntity>> analyzeTaro(SubmitTaroRequest request);
}