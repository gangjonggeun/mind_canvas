import '../../../../core/utils/result.dart';
import '../../data/dto/psychological_profile_response.dart';



abstract class UserAnalysisRepository {

  Future<Result<PsychologicalProfileResponse>> getMyProfile() ;
}

