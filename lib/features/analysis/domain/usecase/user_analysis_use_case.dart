import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../data/dto/psychological_profile_response.dart';
import '../../data/provider/user_analysis_repository_provider.dart';
import '../../domain/repository/user_analysis_repository.dart';

part 'user_analysis_use_case.g.dart';

/// 🏭 UserAnalysisUseCase Provider
@riverpod
UserAnalysisUseCase userAnalysisUseCase(UserAnalysisUseCaseRef ref) {
  final repository = ref.read(userAnalysisRepositoryProvider);
  return UserAnalysisUseCase(repository);
}

/// 📊 사용자 분석 관련 비즈니스 로직 처리
///
/// 마이페이지/통계 화면에서 필요한 데이터 흐름 제어
class UserAnalysisUseCase {
  final UserAnalysisRepository _repository;

  UserAnalysisUseCase(this._repository);

  // =============================================================
  // 🌟 내 심리 프로필 조회
  // =============================================================

  /// 내 성격 통계(MBTI, Big5 등) 조회
  ///
  /// @return Result<PsychologicalProfileResponse> 성공 시 통계 데이터, 실패 시 에러
  Future<Result<PsychologicalProfileResponse>> getMyProfile() async {
    try {
      print('📊 UserAnalysisUseCase - getMyProfile 호출');

      // Repository를 통한 데이터 조회
      final result = await _repository.getMyProfile();

      if (result.isSuccess) {
        print('✅ UserAnalysisUseCase - 조회 성공: 데이터 있음');
      } else {
        print('❌ UserAnalysisUseCase - 조회 실패: ${result.errorCode}');
      }

      return result;
    } catch (e) {
      print('💥 UserAnalysisUseCase - 예상치 못한 오류: $e');
      return Result.failure('분석 정보를 불러오는 중 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }
}