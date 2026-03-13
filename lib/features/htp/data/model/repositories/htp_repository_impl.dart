// lib/features/htp/data/repositories/htp_repository_impl.dart

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import '../../../../../core/auth/token_manager.dart';
import '../../../../../core/utils/result.dart';
import '../../../../psy_result/data/model/response/test_result_response.dart';
import '../../../domain/repositories/htp_repository.dart';
import '../datasources/htp_api_data_source.dart';
import '../request/htp_basic_request.dart';
import '../request/htp_premium_request.dart';


class HtpRepositoryImpl implements HtpRepository {
  final HtpApiDataSource _api;
  final TokenManager _tokenManager;

  // 상수
  static const int _maxFileSize = 10 * 1024 * 1024; // 10MB (넉넉하게)

  HtpRepositoryImpl({
    required HtpApiDataSource htpApiDataSource,
    required TokenManager tokenManager,
  })  : _api = htpApiDataSource,
        _tokenManager = tokenManager;

  // =============================================================
  // 🖼️ 1. 기본 분석 (Basic)
  // =============================================================
  @override
  Future<Result<TestResultResponse>> analyzeBasicHtp({
    required List<File> imageFiles,
    required DrawingProcess drawingProcess,
  }) async {
    return _performAnalysis(
      imageFiles: imageFiles,
      requestJson: jsonEncode(HtpBasicRequest(drawingProcess: drawingProcess).toJson()),
      apiCall: _api.analyzeBasic,
      pendingTitle: "HTP 분석 시작",
    );
  }

  // =============================================================
  // 🧠 2. 프리미엄 분석 (Premium)
  // =============================================================
  @override
  Future<Result<TestResultResponse>> analyzePremiumHtp({
    required List<File> imageFiles,
    required HtpPremiumRequest request,
  }) async {
    return _performAnalysis(
      imageFiles: imageFiles,
      // Freezed 객체의 toJson() 호출
      requestJson: jsonEncode(request.toJson()),
      apiCall: _api.analyzePremium,
      pendingTitle: "HTP 프리미엄 분석 시작",
      requiredImageCount: 4, // 집, 나무, 남, 여
    );
  }

  // =============================================================
  // 🛠️ 공통 처리 메서드 (DRY 원칙 적용)
  // =============================================================
  Future<Result<TestResultResponse>> _performAnalysis({
    required List<File> imageFiles,
    required String requestJson,
    required Future<dynamic> Function(List<File>, String, String) apiCall,
    required String pendingTitle,
    int requiredImageCount = 3,
  }) async {
    try {
      // 1. 인증 토큰 확인
      final token = await _tokenManager.getValidAccessToken();
      if (token == null) return Result.failure('로그인이 필요합니다.', 'AUTH_REQUIRED');

      // 2. 이미지 유효성 검사
      if (imageFiles.length != requiredImageCount) {
        return Result.failure('이미지는 정확히 $requiredImageCount장이 필요합니다.');
      }
      for (var file in imageFiles) {
        if (!file.existsSync()) return Result.failure('파일이 존재하지 않습니다.');
        if (file.lengthSync() > _maxFileSize) return Result.failure('이미지 용량이 너무 큽니다.');
      }

      // 3. API 호출
      final response = await apiCall(imageFiles, requestJson, token);

      // 4. 응답 처리 및 PENDING 로직
      if (response.success) {
        // 서버에서 데이터가 오면 그걸 쓰고, 없으면(비동기 접수만 된 경우) 클라에서 PENDING 객체 생성
        final resultData = response.data ?? TestResultResponse(
          resultKey: "PENDING_AI", // 👈 핵심: 이걸로 UI가 대기 화면을 띄움
          resultTag: pendingTitle,
          briefDescription: "AI가 분석을 시작했습니다. 잠시만 기다려주세요.",
          backgroundColor: "FFFFFF",
          resultDetails: [],
        );

        return Result.success(resultData);
      } else {
        return Result.failure(response.message ?? '분석 요청 실패');
      }

    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return Result.failure('알 수 없는 오류: $e');
    }
  }

  Result<TestResultResponse> _handleDioException(DioException e) {
    if (e.response?.statusCode == 413) {
      return Result.failure('이미지 파일이 너무 큽니다. (Image file is too large)');
    }
    return Result.failure(
      e.message ?? '네트워크 오류가 발생했습니다. (A network error occurred)',
      e.response?.statusCode?.toString() ?? 'NETWORK_ERROR',
    );
  }
}