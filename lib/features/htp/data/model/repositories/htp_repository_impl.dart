// =============================================================
// 📁 data/repositories/htp_repository_impl.dart
// =============================================================

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../../core/auth/token_manager.dart';
import '../../../../../core/utils/result.dart';
import '../../../../psy_result/data/model/response/test_result_response.dart';
import '../../../domain/repositories/htp_repository.dart';
import '../datasources/htp_api_data_source.dart';
import '../request/htp_basic_request.dart';
import '../request/htp_premium_request.dart';
import '../response/htp_response.dart';


/// 🎨 HTP Repository 구현체
///
/// <p><strong>의존성:</strong></p>
/// - HtpApiDataSource: API 통신
/// - TokenManager: JWT 토큰 관리
class HtpRepositoryImpl implements HtpRepository {
  final HtpApiDataSource _htpApiDataSource;
  final TokenManager _tokenManager;

  // 상수 정의
  static const int _maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> _allowedExtensions = ['jpg', 'jpeg', 'png'];
  static const int _requiredImageCount = 3;

  HtpRepositoryImpl({
    required HtpApiDataSource htpApiDataSource,
    required TokenManager tokenManager,
  })  : _htpApiDataSource = htpApiDataSource,
        _tokenManager = tokenManager;

  // =============================================================
  // 🖼️ 기본 분석
  // =============================================================
  // =============================================================
// 📁 htp_repository_impl.dart
// =============================================================
  @override
  Future<Result<TestResultResponse>> analyzeBasicHtp({
    required List<File> imageFiles,
    required DrawingProcess drawingProcess,
  }) async {
    try {
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) return Result.failure('인증이 필요합니다', 'AUTH_REQUIRED');

      final validationResult = _validateImageFiles(imageFiles);
      if (validationResult != null) return validationResult;

      final request = HtpBasicRequest(drawingProcess: drawingProcess);
      final requestMultipart = MultipartFile.fromString(
        jsonEncode(request.toJson()),
        contentType: MediaType('application', 'json'),
      );

      final multipartFiles = await _convertToMultipartFiles(imageFiles);
      if (multipartFiles == null) return Result.failure('이미지 변환 실패');

      final apiResponse = await _htpApiDataSource.analyzeBasic(
        multipartFiles,
        requestMultipart,
        validToken,
      );

      if (apiResponse.success) {
        // ✅ 비동기 접수 성공 시 PENDING_AI 더미 객체 반환
        return Result.success(
          apiResponse.data ?? const TestResultResponse(
            resultKey: "PENDING_AI",
            resultTag: "HTP 분석 시작",
            briefDescription: "AI가 그림 분석을 시작했습니다. 완료되면 알림을 드립니다.",
            backgroundColor: "FFFFFF",
            resultDetails: [],
          ),
          apiResponse.message ?? '분석이 시작되었습니다.',
        );
      } else {
        return Result.failure(apiResponse.message ?? 'HTP 분석 실패');
      }
    } on DioException catch (e) {
      return _handleDioException(e, 'HTP 기본 분석');
    } catch (e) {
      return Result.failure('알 수 없는 오류 발생: $e');
    }
  }

  // =============================================================
  // 🧠 2. 프리미엄 분석 (비동기 대응)
  // =============================================================
  @override
  Future<Result<TestResultResponse>> analyzePremiumHtp({
    required List<File> imageFiles,
    required HtpPremiumRequest request,
  }) async {
    try {
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) return Result.failure('인증이 필요합니다', 'AUTH_REQUIRED');

      final validationResult = _validateImageFiles(imageFiles);
      if (validationResult != null) return validationResult;

      final requestMultipart = MultipartFile.fromString(
        jsonEncode(request.toJson()),
        contentType: MediaType('application', 'json'),
      );

      final multipartFiles = await _convertToMultipartFiles(imageFiles);
      if (multipartFiles == null) return Result.failure('이미지 변환 실패');

      final apiResponse = await _htpApiDataSource.analyzePremium(
        multipartFiles,
        requestMultipart,
        validToken,
      );

      if (apiResponse.success) {
        return Result.success(
          apiResponse.data ?? const TestResultResponse(
            resultKey: "PENDING_AI",
            resultTag: "HTP 프리미엄 분석 시작",
            briefDescription: "AI가 그림을 정밀 분석 중입니다. 완료되면 알림을 드립니다.",
            backgroundColor: "FFFFFF",
            resultDetails: [],
          ),
          apiResponse.message ?? '분석이 시작되었습니다.',
        );
      } else {
        return Result.failure(apiResponse.message ?? 'HTP 프리미엄 분석 실패');
      }
    } on DioException catch (e) {
      return _handleDioException(e, 'HTP 프리미엄 분석');
    } catch (e) {
      return Result.failure('알 수 없는 오류 발생: $e');
    }
  }

  // =============================================================
  // 🔧 Private 헬퍼 메서드들
  // =============================================================
  Result<TestResultResponse>? _validateImageFiles(List<File> imageFiles) {
    if (imageFiles.length != _requiredImageCount) {
      return Result.failure('이미지는 정확히 $_requiredImageCount장이어야 합니다.');
    }
    for (var file in imageFiles) {
      if (!file.existsSync()) return Result.failure('이미지 파일이 존재하지 않습니다.');
      if (file.lengthSync() > _maxFileSize) return Result.failure('이미지 용량이 너무 큽니다 (최대 5MB).');
    }
    return null;
  }


  /// 에러 핸들러 결과 타입을 TestResultResponse로 변경
  Result<TestResultResponse> _handleDioException(DioException e, String operation) {
    final statusCode = e.response?.statusCode;
    if (statusCode == 413) return Result.failure('파일 용량이 너무 큽니다.');
    if (statusCode == 401) return Result.failure('인증 세션이 만료되었습니다.');

    return Result.failure(
      e.message ?? '$operation 중 오류가 발생했습니다.',
      statusCode?.toString() ?? 'NETWORK_ERROR',
    );
  }

  /// File → MultipartFile 변환
  ///
  /// <p><strong>처리 내용:</strong></p>
  /// - 파일명 생성: htp_house_타임스탬프.확장자
  /// - Content-Type 설정
  /// - 메모리 최적화: fromFileSync 사용
  Future<List<MultipartFile>?> _convertToMultipartFiles(
      List<File> imageFiles,
      ) async {
    try {
      final multipartFiles = <MultipartFile>[];
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imageNames = ['house', 'tree', 'person'];

      for (int i = 0; i < imageFiles.length; i++) {
        final file = imageFiles[i];
        final extension = file.path.split('.').last.toLowerCase();
        final imageName = imageNames[i];

        // ✅ 메모리 최적화: Stream 기반 업로드
        final multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: 'htp_${imageName}_$timestamp.$extension',
          contentType: MediaType(
            'image',
            extension == 'png' ? 'png' : 'jpeg',
          ),
        );

        multipartFiles.add(multipartFile);
        print('✅ 이미지 변환 완료: ${multipartFile.filename}');
      }

      return multipartFiles;
    } catch (e) {
      print('❌ 이미지 변환 실패: $e');
      return null;
    }
  }

}