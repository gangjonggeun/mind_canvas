// features/single_test/data/repositories/single_test_repository_impl.dart

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/auth/token_manager.dart';


import '../../../../../core/auth/token_manager_provider.dart';
import '../../../../../core/network/api_response_dto.dart';
import '../../../../../core/network/dio_provider.dart';
import '../../../../../core/utils/result.dart';
import '../../../../psy_result/data/model/response/test_result_response.dart';
import '../../../presentation/enum/single_test_type.dart';
import '../datasources/single_test_api_datasource.dart';
import '../request/single_test_request.dart';

// =======================================================
// 1. Repository 구현체
// =======================================================
class SingleTestRepository {
  final SingleTestApiDataSource _apiDataSource;
  final TokenManager _tokenManager;

  SingleTestRepository({
    required SingleTestApiDataSource apiDataSource,
    required TokenManager tokenManager,
  })  : _apiDataSource = apiDataSource,
        _tokenManager = tokenManager;

  /// 💡 통합 분석 API 호출 메서드
  @override
  Future<Result<TestResultResponse>> analyzeSingleTest({
    required SingleTestType testType,
    required File imageFile,
    required SingleTestRequest request, // 👈 생성한 DTO 받기
  }) async {
    try {
      final token = await _tokenManager.getValidAccessToken();
      if (token == null) return Result.failure('로그인이 필요합니다.');

      // 1. DTO -> JSON 문자열 변환
      final requestJson = jsonEncode(request.toJson());

      // 2. 타입에 따라 알맞은 API 호출
      ApiResponse<TestResultResponse> response;
      switch (testType) {
        case SingleTestType.starrySea:
          response = await _apiDataSource.analyzeStarrySea(imageFile, requestJson, token);
          break;
        case SingleTestType.pitr:
          response = await _apiDataSource.analyzePitr(imageFile, requestJson, token);
          break;
        case SingleTestType.fishbowl:
          response = await _apiDataSource.analyzeFishbowl(imageFile, requestJson, token);
          break;
        default:
        // testType.name을 이용하여 경로 동적 생성 (예: /analyze/road, /analyze/mandala)
        // 백엔드 엔드포인트 규칙에 맞춰 경로를 지정하세요.
          final path = '/analyze/${testType.name}';
          response = await _apiDataSource.analyzeGeneral(path, imageFile, requestJson, token);
      }

      // 3. PENDING 처리 로직 (이전 HTP와 동일하게 처리)
      if (response.success) {
        final resultData = response.data ?? TestResultResponse(
          resultKey: "PENDING_AI",
          resultTag: "${testType.displayName} 분석 시작",
          briefDescription: "AI가 그림 분석을 시작했습니다.",
          backgroundColor: "FFFFFF",
          resultDetails:[],
        );
        return Result.success(resultData);
      } else {
        return Result.failure(response.message ?? '분석 실패');
      }
    } catch (e) {
      return Result.failure('오류 발생: $e');
    }
  }
}

// =======================================================
// 2. Riverpod Provider 제공 (이 파일 하단에 선언)
// =======================================================
final singleTestApiProvider = Provider<SingleTestApiDataSource>((ref) {
  final dio = ref.watch(dioProvider); // 앱 전역 Dio
  return SingleTestApiDataSource(dio);
});

final singleTestRepositoryProvider = Provider<SingleTestRepository>((ref) {
  return SingleTestRepository(
    apiDataSource: ref.watch(singleTestApiProvider),
    tokenManager: ref.watch(tokenManagerProvider),
  );
});