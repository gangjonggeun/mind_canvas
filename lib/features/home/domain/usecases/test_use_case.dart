// =============================================================
// 📁 lib/features/test/domain/usecases/test_use_case.dart
// =============================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../models/test_ranking_item.dart';
import '../repositories/test_repository.dart';
import '../../data/repositories/test_repository_provider.dart';

part 'test_use_case.g.dart';

/// TestUseCase Provider
@riverpod
TestUseCase testUseCase(TestUseCaseRef ref) {
  final repository = ref.read(testRepositoryProvider);
  return TestUseCase(repository);
}

/// 테스트 관련 비즈니스 로직 처리
class TestUseCase {
  final TestRepository _repository;

  TestUseCase(this._repository);

  // =============================================================
  // 테스트 목록 관련 UseCase들
  // =============================================================

  /// 최신 테스트 목록 조회
  ///
  /// 비즈니스 규칙:
  /// - 페이지는 0 이상이어야 함
  /// - 사이즈는 1~50 사이여야 함
  /// - 인증된 사용자만 접근 가능
  Future<Result<TestListResult>> getLatestTests({
    required int page,
    required int size,
  }) async {
    // 비즈니스 규칙 검증
    final validationResult = _validatePagination(page, size);
    if (validationResult != null) {
      return validationResult;
    }

    try {
      // Repository 호출
      final result = await _repository.getLatestTests(page: page, size: size);

      return result.fold(
        onSuccess: (data) {
          // 비즈니스 로직 적용
          final processedData = _processTestList(data);
          return Result.success(processedData, '테스트 목록을 성공적으로 불러왔습니다');
        },
        onFailure: (message, errorCode) {
          // 에러 메시지 비즈니스 로직에 맞게 변환
          final userFriendlyMessage = _convertToUserFriendlyMessage(message, errorCode);
          return Result.failure(userFriendlyMessage, errorCode);
        },
      );
    } catch (e) {
      return Result.failure('테스트 목록을 불러오는 중 오류가 발생했습니다', 'USECASE_ERROR');
    }
  }

  /// 인기 테스트 목록 조회 (추후 구현)
  Future<Result<TestListResult>> getPopularTests({
    required int page,
    required int size,
    String? category,
  }) async {
    // 비즈니스 규칙 검증
    final validationResult = _validatePagination(page, size);
    if (validationResult != null) {
      return validationResult;
    }

    // TODO: 인기 테스트 조회 API 구현 후 연결
    return Result.failure('인기 테스트 기능은 준비 중입니다', 'FEATURE_NOT_IMPLEMENTED');
  }

  /// 사용자 맞춤 추천 테스트 목록 (추후 구현)
  Future<Result<TestListResult>> getRecommendedTests({
    required String userId,
    required int page,
    required int size,
  }) async {
    // 사용자 ID 검증
    if (userId.isEmpty) {
      return Result.failure('사용자 정보가 없습니다', 'INVALID_USER_ID');
    }

    final validationResult = _validatePagination(page, size);
    if (validationResult != null) {
      return validationResult;
    }

    // TODO: 추천 알고리즘 구현
    // 1. 사용자 이전 테스트 이력 조회
    // 2. 사용자 선호도 분석
    // 3. 추천 알고리즘 적용
    // 4. 추천 테스트 목록 반환

    return Result.failure('추천 테스트 기능은 준비 중입니다', 'FEATURE_NOT_IMPLEMENTED');
  }

  /// 테스트 검색 (추후 구현)
  Future<Result<TestListResult>> searchTests({
    required String query,
    required int page,
    required int size,
    List<String>? categories,
    String? sortBy,
  }) async {
    // 검색어 검증
    if (query.trim().isEmpty) {
      return Result.failure('검색어를 입력해주세요', 'EMPTY_SEARCH_QUERY');
    }

    if (query.length < 2) {
      return Result.failure('검색어는 2글자 이상 입력해주세요', 'SEARCH_QUERY_TOO_SHORT');
    }

    final validationResult = _validatePagination(page, size);
    if (validationResult != null) {
      return validationResult;
    }

    // TODO: 검색 API 구현 후 연결
    return Result.failure('검색 기능은 준비 중입니다', 'FEATURE_NOT_IMPLEMENTED');
  }

  // =============================================================
  // Private Helper Methods (비즈니스 로직)
  // =============================================================

  /// 페이징 검증
  Result<TestListResult>? _validatePagination(int page, int size) {
    if (page < 0) {
      return Result.failure('페이지 번호는 0 이상이어야 합니다', 'INVALID_PAGE_NUMBER');
    }

    if (size < 1) {
      return Result.failure('페이지 크기는 1 이상이어야 합니다', 'INVALID_PAGE_SIZE');
    }

    if (size > 50) {
      return Result.failure('페이지 크기는 50 이하여야 합니다', 'PAGE_SIZE_TOO_LARGE');
    }

    return null; // 검증 통과
  }

  /// 테스트 목록 비즈니스 로직 처리
  TestListResult _processTestList(TestListResult data) {
    // 비즈니스 로직 적용 (예: 필터링, 정렬, 데이터 변환 등)

    // 1. 중복 제거
    final uniqueTests = _removeDuplicateTests(data.tests);

    // 2. 인기도 점수 재계산 (필요시)
    final processedTests = _recalculatePopularityScores(uniqueTests);

    // 3. 테스트 상태 검증
    final validTests = _filterValidTests(processedTests);

    return TestListResult(
      tests: validTests,
      hasMore: data.hasMore,
    );
  }

  /// 중복 테스트 제거
  List<TestRankingItem> _removeDuplicateTests(List<TestRankingItem> tests) {
    final seenIds = <String>{};
    return tests.where((test) {
      if (seenIds.contains(test.id)) {
        return false;
      }
      seenIds.add(test.id);
      return true;
    }).toList();
  }

  /// 인기도 점수 재계산
  List<TestRankingItem> _recalculatePopularityScores(List<TestRankingItem> tests) {
    // 실제 비즈니스 로직에 따라 인기도 점수 재계산
    return tests.map((test) {
      // 예: 참여자 수에 따른 점수 조정
      double adjustedScore = test.popularityScore;

      if (test.participantCount > 100000) {
        adjustedScore += 5.0; // 보너스 점수
      } else if (test.participantCount > 50000) {
        adjustedScore += 2.0;
      }

      return TestRankingItem(
        id: test.id,
        title: test.title,
        subtitle: test.subtitle,
        imagePath: test.imagePath,
        participantCount: test.participantCount,
        popularityScore: adjustedScore.clamp(0.0, 100.0),
      );
    }).toList();
  }

  /// 유효한 테스트만 필터링
  List<TestRankingItem> _filterValidTests(List<TestRankingItem> tests) {
    return tests.where((test) {
      // 비즈니스 규칙에 따른 필터링
      return test.title.isNotEmpty &&
          test.id.isNotEmpty &&
          test.participantCount >= 0;
    }).toList();
  }

  /// 사용자 친화적 에러 메시지 변환
  String _convertToUserFriendlyMessage(String message, String? errorCode) {
    switch (errorCode) {
      case 'AUTHENTICATION_REQUIRED':
      case 'AUTHENTICATION_EXPIRED':
        return '로그인이 필요합니다. 다시 로그인해주세요.';

      case 'ACCESS_DENIED':
        return '접근 권한이 없습니다. 고객센터에 문의해주세요.';

      case 'NOT_FOUND':
        return '요청한 테스트를 찾을 수 없습니다.';

      case 'NETWORK_ERROR':
        return '네트워크 연결을 확인한 후 다시 시도해주세요.';

      case 'SERVER_ERROR':
        return '서버에 일시적인 문제가 발생했습니다. 잠시 후 다시 시도해주세요.';

      case 'TIMEOUT_ERROR':
        return '응답 시간이 초과되었습니다. 다시 시도해주세요.';

      default:
        return message.isNotEmpty ? message : '알 수 없는 오류가 발생했습니다.';
    }
  }

  // =============================================================
  // 테스트 상세 관련 UseCase들 (추후 확장)
  // =============================================================

  /// 테스트 상세 정보 조회 (추후 구현)
  Future<Result<void>> getTestDetail(String testId) async {
    if (testId.isEmpty) {
      return Result.failure('잘못된 테스트 ID입니다', 'INVALID_TEST_ID');
    }

    // TODO: 테스트 상세 조회 API 구현 후 연결
    return Result.failure('테스트 상세 조회 기능은 준비 중입니다', 'FEATURE_NOT_IMPLEMENTED');
  }

  /// 테스트 즐겨찾기 토글 (추후 구현)
  Future<Result<bool>> toggleFavorite(String testId) async {
    if (testId.isEmpty) {
      return Result.failure('잘못된 테스트 ID입니다', 'INVALID_TEST_ID');
    }

    // TODO: 즐겨찾기 API 구현 후 연결
    return Result.failure('즐겨찾기 기능은 준비 중입니다', 'FEATURE_NOT_IMPLEMENTED');
  }
}
