import '../../../../core/utils/result.dart';
import '../../data/dto/comprehensive_analysis_response.dart';
import '../../data/dto/psychological_profile_response.dart';



abstract class UserAnalysisRepository {

  /// AI 종합 분석 결과 조회
  Future<Result<ComprehensiveAnalysisResponse>> getComprehensiveAnalysis();

  Future<Result<PsychologicalProfileResponse>> getMyProfile() ;
}

