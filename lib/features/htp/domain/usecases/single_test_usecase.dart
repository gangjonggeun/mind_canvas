// features/single_test/domain/usecases/single_test_usecase.dart

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/result.dart';
import '../../../psy_result/data/model/response/test_result_response.dart';
import '../../data/model/repositories/single_test_repository_impl.dart';
import '../../data/model/request/single_test_request.dart';
import '../../presentation/enum/single_test_type.dart';

// (참고: 각 검사용 Repository들이 따로 있다면 다 임포트해줍니다)
// import '../repositories/starry_sea_repository.dart';
// import '../repositories/pitr_repository.dart';
// import '../repositories/fishbowl_repository.dart';
class SingleTestUseCase {
  final SingleTestRepository _repository;

  SingleTestUseCase(this._repository);

  // UseCase는 그저 Repository를 호출할 뿐!
  Future<Result<TestResultResponse>> analyze({
    required SingleTestType testType,
    required File imageFile,
    required SingleTestRequest request, // ✅ DTO로 받기!
  }) async {

    // (선택) 여기서 DTO 데이터 검증을 살짝 할 수도 있습니다.
    // if (request.answers.isEmpty) return Result.failure("답변이 없습니다.");

    return await _repository.analyzeSingleTest(
      testType: testType,
      imageFile: imageFile,
      request: request, // ✅ Repository로 그대로 전달!
    );
  }
}
// Provider
final singleTestUseCaseProvider = Provider<SingleTestUseCase>((ref) {
  final repository = ref.watch(singleTestRepositoryProvider);
  return SingleTestUseCase(repository);
});