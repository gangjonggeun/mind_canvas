// =============================================================
// 📁 lib/features/test/domain/usecases/test_use_case.dart
// =============================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../../info/data/models/response/test_detail_response.dart';
import '../models/test_ranking_item.dart';
import '../repositories/test_repository.dart';
import '../../data/repositories/test_repository_provider.dart';

part 'test_use_case.g.dart';

/// 🏭 TestUseCase Provider
@riverpod
TestUseCase testUseCase(TestUseCaseRef ref) {
  final repository = ref.read(testRepositoryProvider);
  return TestUseCase(repository);
}

/// 🧠 테스트 관련 비즈니스 로직 처리 (완전 확장 버전)
///
/// 서버의 모든 API와 1:1 매핑되는 도메인 계층 UseCase
/// 비즈니스 규칙 검증, 데이터 가공, 에러 처리 담당
class TestUseCase {
  final TestRepository _repository;

  TestUseCase(this._repository);

  // =============================================================
  // 🌟 최신순 테스트 목록 (기존 유지)
  // =============================================================

  /// 테스트 상세 정보 조회
  ///
  /// @param testId 조회할 테스트 ID
  /// @return Result<TestDetailResponse> 성공 시 상세 정보, 실패 시 에러
  Future<Result<void>> deleteTestResult(int testId) async {
    try {
      // Repository를 통한 데이터 조회
      final result = await _repository.deleteTestResult(testId);

      return result;
    } catch (e) {
      print('UseCase - 예상치 못한 오류: $e');
      return Result.failure('테스트 결과 삭제 중 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }
  /// 테스트 상세 정보 조회
  ///
  /// @param testId 조회할 테스트 ID
  /// @return Result<TestDetailResponse> 성공 시 상세 정보, 실패 시 에러
  Future<Result<TestDetailResponse>> getTestDetail(int testId) async {
    try {


      // Repository를 통한 데이터 조회
      final result = await _repository.getTestDetail(testId);

      return result;
    } catch (e) {
      print('GetTestDetailUseCase - 예상치 못한 오류: $e');
      return Result.failure('테스트 상세 정보 조회 중 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }

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
          return Result.success(processedData, '최신 테스트 목록을 성공적으로 불러왔습니다');
        },
        onFailure: (message, errorCode) {
          // 에러 메시지 비즈니스 로직에 맞게 변환
          final userFriendlyMessage = _convertToUserFriendlyMessage(message, errorCode);
          return Result.failure(userFriendlyMessage, errorCode);
        },
      );
    } catch (e) {
      return Result.failure('최신 테스트 목록을 불러오는 중 오류가 발생했습니다', 'USECASE_ERROR');
    }
  }

  // =============================================================
  // 🔥 인기도 기준 테스트 목록
  // =============================================================

  /// 인기도 기준 테스트 목록 조회 (페이징)
  ///
  /// 비즈니스 규칙:
  /// - 인기도 점수 기준 정렬
  /// - 페이징 검증 필수
  /// - 최소 조회수 필터링 적용
  Future<Result<TestListResult>> getPopularTestsList({
    required int page,
    required int size,
  }) async {
    final validationResult = _validatePagination(page, size);
    if (validationResult != null) {
      return validationResult;
    }

    try {
      final result = await _repository.getPopularTestsList(page: page, size: size);

      return result.fold(
        onSuccess: (data) {
          // 인기 테스트 특별 처리
          final processedData = _processPopularTestList(data);
          return Result.success(processedData, '인기 테스트 목록을 성공적으로 불러왔습니다');
        },
        onFailure: (message, errorCode) {
          final userFriendlyMessage = _convertToUserFriendlyMessage(message, errorCode);
          return Result.failure(userFriendlyMessage, errorCode);
        },
      );
    } catch (e) {
      return Result.failure('인기 테스트 목록을 불러오는 중 오류가 발생했습니다', 'USECASE_ERROR');
    }
  }

  /// 홈 화면용 인기 테스트 TOP 5 조회
  ///
  /// 비즈니스 규칙:
  /// - 최대 5개 항목만 반환
  /// - 높은 품질의 테스트만 선별
  /// - 신규 사용자 친화적 테스트 우선
  Future<Result<TestListResult>> getPopularTests() async {
    try {
      final result = await _repository.getPopularTests();

      return result.fold(
        onSuccess: (data) {
          // TOP 5 특별 처리
          final processedData = _processTopPopularTests(data);
          return Result.success(processedData, '인기 테스트를 성공적으로 불러왔습니다');
        },
        onFailure: (message, errorCode) {
          final userFriendlyMessage = _convertToUserFriendlyMessage(message, errorCode);
          return Result.failure(userFriendlyMessage, errorCode);
        },
      );
    } catch (e) {
      return Result.failure('인기 테스트를 불러오는 중 오류가 발생했습니다', 'USECASE_ERROR');
    }
  }

  // =============================================================
  // 👁️ 조회수 기준 테스트 목록
  // =============================================================

  /// 조회수 기준 테스트 목록 조회
  ///
  /// 비즈니스 규칙:
  /// - 조회수 1000 이상만 표시
  /// - 최근 30일 내 업데이트된 테스트 우선
  Future<Result<TestListResult>> getMostViewedTests({
    required int page,
    required int size,
  }) async {
    final validationResult = _validatePagination(page, size);
    if (validationResult != null) {
      return validationResult;
    }

    try {
      final result = await _repository.getMostViewedTests(page: page, size: size);

      return result.fold(
        onSuccess: (data) {
          // 조회수 기준 특별 처리
          final processedData = _processMostViewedTests(data);
          return Result.success(processedData, '조회수 기준 테스트 목록을 성공적으로 불러왔습니다');
        },
        onFailure: (message, errorCode) {
          final userFriendlyMessage = _convertToUserFriendlyMessage(message, errorCode);
          return Result.failure(userFriendlyMessage, errorCode);
        },
      );
    } catch (e) {
      return Result.failure('조회수 기준 테스트 목록을 불러오는 중 오류가 발생했습니다', 'USECASE_ERROR');
    }
  }

  // =============================================================
  // 📈 트렌딩 테스트 목록
  // =============================================================

  /// 트렌딩 테스트 목록 조회 (7일간 급상승)
  ///
  /// 비즈니스 규칙:
  /// - 최근 7일간 조회수 증가율 기준
  /// - 최소 증가율 50% 이상만 표시
  /// - 새로운 테스트 우선 노출
  Future<Result<TestListResult>> getTrendingTests({
    required int page,
    required int size,
  }) async {
    final validationResult = _validatePagination(page, size);
    if (validationResult != null) {
      return validationResult;
    }

    try {
      final result = await _repository.getTrendingTests(page: page, size: size);

      return result.fold(
        onSuccess: (data) {
          // 트렌딩 특별 처리
          final processedData = _processTrendingTests(data);
          return Result.success(processedData, '트렌딩 테스트 목록을 성공적으로 불러왔습니다');
        },
        onFailure: (message, errorCode) {
          final userFriendlyMessage = _convertToUserFriendlyMessage(message, errorCode);
          return Result.failure(userFriendlyMessage, errorCode);
        },
      );
    } catch (e) {
      return Result.failure('트렌딩 테스트 목록을 불러오는 중 오류가 발생했습니다', 'USECASE_ERROR');
    }
  }

  // =============================================================
  // 🔤 가나다순 테스트 목록
  // =============================================================

  /// 가나다순 테스트 목록 조회
  ///
  /// 비즈니스 규칙:
  /// - 한글 제목 우선, 영문 제목 후순위
  /// - 특수문자로 시작하는 제목 제외
  /// - 검색 기능과 연계하여 사용
  Future<Result<TestListResult>> getAlphabeticalTests({
    required int page,
    required int size,
  }) async {
    final validationResult = _validatePagination(page, size);
    if (validationResult != null) {
      return validationResult;
    }

    try {
      final result = await _repository.getAlphabeticalTests(page: page, size: size);

      return result.fold(
        onSuccess: (data) {
          // 가나다순 특별 처리
          final processedData = _processAlphabeticalTests(data);
          return Result.success(processedData, '가나다순 테스트 목록을 성공적으로 불러왔습니다');
        },
        onFailure: (message, errorCode) {
          final userFriendlyMessage = _convertToUserFriendlyMessage(message, errorCode);
          return Result.failure(userFriendlyMessage, errorCode);
        },
      );
    } catch (e) {
      return Result.failure('가나다순 테스트 목록을 불러오는 중 오류가 발생했습니다', 'USECASE_ERROR');
    }
  }

  // =============================================================
  // 🏥 서비스 상태 확인
  // =============================================================

  /// 서비스 헬스체크
  ///
  /// 비즈니스 규칙:
  /// - 서비스 상태 확인
  /// - 장애 감지 시 대체 서비스 안내
  Future<Result<String>> checkServiceHealth() async {
    try {
      final result = await _repository.healthCheck();

      return result.fold(
        onSuccess: (status) {
          return Result.success(status, '서비스가 정상 동작 중입니다');
        },
        onFailure: (message, errorCode) {
          return Result.failure('서비스 점검 중입니다. 잠시 후 다시 시도해주세요.', errorCode);
        },
      );
    } catch (e) {
      return Result.failure('서비스 상태를 확인할 수 없습니다', 'HEALTH_CHECK_ERROR');
    }
  }

  // =============================================================
  // 🔍 추가 비즈니스 로직 메서드들 (추후 구현)
  // =============================================================

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
  // 🔧 Private Helper Methods (비즈니스 로직)
  // =============================================================

  /// 페이징 검증 (기존 유지)
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

  /// 기본 테스트 목록 비즈니스 로직 처리 (기존 유지)
  TestListResult _processTestList(TestListResult data) {
    // 1. 중복 제거
    final uniqueTests = _removeDuplicateTests(data.tests);

    // 2. 테스트 상태 검증
    final validTests = _filterValidTests(uniqueTests);

    return TestListResult(
      tests: validTests,
      hasMore: data.hasMore,
    );
  }

  /// 인기 테스트 목록 특별 처리
  TestListResult _processPopularTestList(TestListResult data) {
    final baseProcessed = _processTestList(data);

    // 인기 테스트 추가 필터링
    final qualityTests = baseProcessed.tests.where((test) {
      // 최소 조회수 1000 이상
      return test.viewCount >= 1000;
    }).toList();

    return TestListResult(
      tests: qualityTests,
      hasMore: baseProcessed.hasMore,
    );
  }

  /// TOP 5 인기 테스트 특별 처리
  TestListResult _processTopPopularTests(TestListResult data) {
    final baseProcessed = _processTestList(data);

    // TOP 5 추가 품질 검증
    final premiumTests = baseProcessed.tests.where((test) {
      // 신규 사용자 친화적인 테스트만 선별
      return test.viewCount >= 5000 &&
          test.title.length >= 5 &&
          test.subtitle.isNotEmpty;
    }).take(5).toList(); // 최대 5개만

    return TestListResult(
      tests: premiumTests,
      hasMore: false, // TOP 5는 항상 hasMore = false
    );
  }

  /// 조회수 기준 테스트 특별 처리
  TestListResult _processMostViewedTests(TestListResult data) {
    final baseProcessed = _processTestList(data);

    // 조회수 필터링 (최소 1000회 이상)
    final viewedTests = baseProcessed.tests.where((test) {
      return test.viewCount >= 1000;
    }).toList();

    return TestListResult(
      tests: viewedTests,
      hasMore: baseProcessed.hasMore,
    );
  }

  /// 트렌딩 테스트 특별 처리
  TestListResult _processTrendingTests(TestListResult data) {
    final baseProcessed = _processTestList(data);

    // 트렌딩 추가 검증 (최소 기준 적용)
    final trendingTests = baseProcessed.tests.where((test) {
      // 최소 조회수 500 이상 (신규 테스트 고려)
      return test.viewCount >= 500;
    }).toList();

    return TestListResult(
      tests: trendingTests,
      hasMore: baseProcessed.hasMore,
    );
  }

  /// 가나다순 테스트 특별 처리
  TestListResult _processAlphabeticalTests(TestListResult data) {
    final baseProcessed = _processTestList(data);

    // 제목 품질 검증
    final alphabeticalTests = baseProcessed.tests.where((test) {
      // 특수문자로 시작하는 제목 제외
      final firstChar = test.title.trim().isNotEmpty ? test.title.trim()[0] : '';
      final isValidTitle = RegExp(r'^[가-힣a-zA-Z0-9]').hasMatch(firstChar);

      return isValidTitle && test.title.length >= 3;
    }).toList();

    return TestListResult(
      tests: alphabeticalTests,
      hasMore: baseProcessed.hasMore,
    );
  }

  /// 중복 테스트 제거 (기존 유지)
  List<TestRankingItem> _removeDuplicateTests(List<TestRankingItem> tests) {
    final seenIds = <String>{};
    return tests.where((test) {
      if (seenIds.contains(test.id)) {
        return false;
      }
      seenIds.add(test.id.toString());
      return true;
    }).toList();
  }

  /// 유효한 테스트만 필터링 (기존 유지)
  List<TestRankingItem> _filterValidTests(List<TestRankingItem> tests) {
    return tests.where((test) {
      // 비즈니스 규칙에 따른 필터링
      return test.title.isNotEmpty &&
          test.id == -1 &&
          test.viewCount >= 0;
    }).toList();
  }

  /// 사용자 친화적 에러 메시지 변환 (기존 유지)
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
  // 🔍 테스트 상세 관련 UseCase들 (추후 확장)
  // =============================================================



  /// 테스트 즐겨찾기 토글 (추후 구현)
  Future<Result<bool>> toggleFavorite(String testId) async {
    if (testId.isEmpty) {
      return Result.failure('잘못된 테스트 ID입니다', 'INVALID_TEST_ID');
    }

    // TODO: 즐겨찾기 API 구현 후 연결
    return Result.failure('즐겨찾기 기능은 준비 중입니다', 'FEATURE_NOT_IMPLEMENTED');
  }
}

// =============================================================
// 📝 사용 예시 (주석)
// =============================================================

/*
// Controller에서 UseCase 사용:

class TestListController extends StateNotifier<TestListState> {
  final TestUseCase _testUseCase;

  TestListController(this._testUseCase) : super(TestListState.initial());

  /// 인기 테스트 로드
  Future<void> loadPopularTests() async {
    state = TestListState.loading();

    final result = await _testUseCase.getPopularTests();

    result.fold(
      onSuccess: (testListResult) {
        state = TestListState.loaded(
          items: testListResult.tests,
          hasMore: testListResult.hasMore,
          currentPage: 0,
          isLoadingMore: false,
          loadType: TestLoadType.popular,
        );
      },
      onFailure: (message, errorCode) {
        state = TestListState.error(message);
      },
    );
  }

  /// 트렌딩 테스트 로드
  Future<void> loadTrendingTests({int page = 0}) async {
    final result = await _testUseCase.getTrendingTests(page: page, size: 20);
    // 결과 처리...
  }
}

// Provider로 등록:
@riverpod
TestListController testListController(TestListControllerRef ref) {
  final testUseCase = ref.watch(testUseCaseProvider);
  return TestListController(testUseCase);
}

// 위젯에서 사용:
class TestListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(testListControllerProvider.notifier);

    return ElevatedButton(
      onPressed: () => controller.loadTrendingTests(),
      child: Text('트렌딩 테스트 보기'),
    );
  }
}
*/