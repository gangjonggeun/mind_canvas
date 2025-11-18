// =============================================================
// 📁 data/repositories/htp_repository_impl.dart
// =============================================================

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../../core/auth/token_manager.dart';
import '../../../../../core/utils/result.dart';
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
  Future<Result<HtpResponse>> analyzeBasicHtp({
    required List<File> imageFiles,
    required DrawingProcess drawingProcess,
  }) async {
    try {
      print('🖼️ HTP 기본 분석 시작 - 이미지 수: ${imageFiles.length}');

      // 1. 토큰 확인
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) {
        print('❌ 인증이 필요합니다 - 로그인 페이지로 이동 필요');
        return Result.failure('인증이 필요합니다', 'AUTHENTICATION_REQUIRED');
      }

      // 2. 이미지 파일 검증
      final validationResult = _validateImageFiles(imageFiles);
      if (validationResult != null) {
        print('❌ 이미지 검증 실패: ${validationResult.message}');
        return validationResult;
      }

      // 3. 요청 DTO 생성
      final request = HtpBasicRequest(
        drawingProcess: drawingProcess,
      );

      // 4. ✅ JSON을 MultipartFile로 변환 (Content-Type 명시)
      final requestJson = jsonEncode(request.toJson());
      print('📄 요청 JSON: $requestJson');

      final requestMultipart = MultipartFile.fromString(
        requestJson,
        contentType: MediaType('application', 'json'), // ✅ 핵심!
      );

      // 5. 이미지 MultipartFile 변환
      final multipartFiles = await _convertToMultipartFiles(imageFiles);
      if (multipartFiles == null) {
        return Result.failure('이미지 변환에 실패했습니다', 'IMAGE_CONVERSION_ERROR');
      }

      // 6. API 호출
      print('📡 API 호출 중...');
      final apiResponse = await _htpApiDataSource.analyzeBasic(
        multipartFiles,
        requestMultipart, // ✅ MultipartFile 전달
        validToken,
      );

      // 7. ApiResponse → Result 변환
      if (apiResponse.success && apiResponse.data != null) {
        final htpResponse = apiResponse.data!;

        if (htpResponse.resultDetails.isEmpty) {
          print('⚠️ 분석 결과가 비어있습니다');
          return Result.failure('분석 결과가 생성되지 않았습니다', 'EMPTY_RESULT');
        }

        print('✅ HTP 기본 분석 성공 - 결과 항목: ${htpResponse.resultDetails.length}개');
        return Result.success(
          htpResponse,
          'HTP 기본 분석이 완료되었습니다',
        );
      } else {
        final errorMessage = apiResponse.error?.message ??
            apiResponse.message ??
            'HTP 분석에 실패했습니다';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';

        print('❌ HTP 기본 분석 실패 - $errorMessage');
        return Result.failure(errorMessage, errorCode);
      }
    } on DioException catch (e) {
      return _handleDioException(e, 'HTP 기본 분석');
    } catch (e, stackTrace) {
      print('❌ 예상치 못한 오류 발생: $e');
      print('StackTrace: $stackTrace');
      return Result.failure('알 수 없는 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }

  @override
  Future<Result<HtpResponse>> analyzePremiumHtp({
    required List<File> imageFiles,
    required HtpPremiumRequest request,
  }) async {
    try {
      print('🧠 HTP 프리미엄 분석 시작 - 이미지 수: ${imageFiles.length}');

      // 1. 토큰 확인
      final validToken = await _tokenManager.getValidAccessToken();
      if (validToken == null) {
        print('❌ 인증이 필요합니다 - 로그인 페이지로 이동 필요');
        return Result.failure('인증이 필요합니다', 'AUTHENTICATION_REQUIRED');
      }

      // 2. 이미지 파일 검증
      final validationResult = _validateImageFiles(imageFiles);
      if (validationResult != null) {
        print('❌ 이미지 검증 실패: ${validationResult.message}');
        return validationResult;
      }

      // 3. ✅ JSON을 MultipartFile로 변환 (Content-Type 명시)
      final requestJson = jsonEncode(request.toJson());
      print('📄 요청 JSON: $requestJson');

      final requestMultipart = MultipartFile.fromString(
        requestJson,
        contentType: MediaType('application', 'json'), // ✅ 핵심!
      );

      // 4. 이미지 MultipartFile 변환
      final multipartFiles = await _convertToMultipartFiles(imageFiles);
      if (multipartFiles == null) {
        return Result.failure('이미지 변환에 실패했습니다', 'IMAGE_CONVERSION_ERROR');
      }

      // 5. API 호출
      print('📡 API 호출 중 (프리미엄 분석)...');
      final apiResponse = await _htpApiDataSource.analyzePremium(
        multipartFiles,
        requestMultipart, // ✅ MultipartFile 전달
        validToken,
      );

      // 6. ApiResponse → Result 변환
      if (apiResponse.success && apiResponse.data != null) {
        final htpResponse = apiResponse.data!;

        if (htpResponse.resultDetails.isEmpty) {
          print('⚠️ 분석 결과가 비어있습니다');
          return Result.failure('분석 결과가 생성되지 않았습니다', 'EMPTY_RESULT');
        }

        print('✅ HTP 프리미엄 분석 성공 - 결과 항목: ${htpResponse.resultDetails.length}개');
        return Result.success(
          htpResponse,
          'HTP 프리미엄 분석이 완료되었습니다',
        );
      } else {
        final errorMessage = apiResponse.error?.message ??
            apiResponse.message ??
            'HTP 프리미엄 분석에 실패했습니다';
        final errorCode = apiResponse.error?.code ?? 'API_ERROR';

        print('❌ HTP 프리미엄 분석 실패 - $errorMessage');
        return Result.failure(errorMessage, errorCode);
      }
    } on DioException catch (e) {
      return _handleDioException(e, 'HTP 프리미엄 분석');
    } catch (e, stackTrace) {
      print('❌ 예상치 못한 오류 발생: $e');
      print('StackTrace: $stackTrace');
      return Result.failure('알 수 없는 오류가 발생했습니다', 'UNKNOWN_ERROR');
    }
  }

  // =============================================================
  // 🔧 Private 헬퍼 메서드들
  // =============================================================

  /// 이미지 파일 검증
  ///
  /// <p><strong>검증 항목:</strong></p>
  /// - 이미지 개수: 정확히 3장
  /// - 파일 존재 여부
  /// - 파일 크기: 각 5MB 이하
  /// - 파일 형식: PNG, JPG, JPEG
  ///
  /// @return null이면 검증 성공, Result<HtpResponse>면 검증 실패
  Result<HtpResponse>? _validateImageFiles(List<File> imageFiles) {
    // 1. 이미지 개수 검증
    if (imageFiles.length != _requiredImageCount) {
      return Result.failure(
        '이미지는 정확히 $_requiredImageCount장이어야 합니다 (현재: ${imageFiles.length}장)',
        'INVALID_IMAGE_COUNT',
      );
    }

    // 2. 각 파일 검증
    for (int i = 0; i < imageFiles.length; i++) {
      final file = imageFiles[i];
      final imageName = ['집', '나무', '사람'][i];

      // 파일 존재 여부
      if (!file.existsSync()) {
        return Result.failure(
          '$imageName 이미지 파일이 존재하지 않습니다',
          'FILE_NOT_FOUND',
        );
      }

      // 파일 크기 검증 (동기 방식)
      final fileSize = file.lengthSync();
      if (fileSize > _maxFileSize) {
        final sizeMB = (fileSize / 1024 / 1024).toStringAsFixed(2);
        return Result.failure(
          '$imageName 이미지가 너무 큽니다 (${sizeMB}MB, 최대 5MB)',
          'FILE_TOO_LARGE',
        );
      }

      // 파일 확장자 검증
      final extension = file.path.split('.').last.toLowerCase();
      if (!_allowedExtensions.contains(extension)) {
        return Result.failure(
          '$imageName 이미지 형식이 지원되지 않습니다 (.$extension)\n'
              '지원 형식: ${_allowedExtensions.join(', ')}',
          'UNSUPPORTED_FILE_FORMAT',
        );
      }
    }

    return null; // 검증 성공
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

  /// DioException 처리
  ///
  /// <p><strong>처리하는 에러 타입:</strong></p>
  /// - CONNECTION_TIMEOUT: 서버 연결 시간 초과
  /// - RECEIVE_TIMEOUT: 응답 시간 초과 (이미지 업로드 고려)
  /// - SEND_TIMEOUT: 전송 시간 초과
  /// - 413: 파일 크기 초과
  /// - 401: 인증 실패
  /// - 403: 권한 없음
  /// - 404: 엔드포인트 없음
  /// - 500: 서버 내부 오류
  Result<HtpResponse> _handleDioException(DioException e, String operation) {
    print('❌ DioException 발생 - $operation');
    print('  Type: ${e.type}');
    print('  Message: ${e.message}');
    print('  Status Code: ${e.response?.statusCode}');

    // 1. 네트워크 타임아웃 에러
    if (e.type == DioExceptionType.connectionTimeout) {
      return Result.failure(
        '서버 연결 시간이 초과되었습니다\n네트워크 연결을 확인해주세요',
        'CONNECTION_TIMEOUT',
      );
    }

    if (e.type == DioExceptionType.receiveTimeout) {
      return Result.failure(
        '응답 시간이 초과되었습니다\n이미지가 너무 크거나 네트워크가 불안정합니다',
        'RECEIVE_TIMEOUT',
      );
    }

    if (e.type == DioExceptionType.sendTimeout) {
      return Result.failure(
        '전송 시간이 초과되었습니다\n네트워크 연결을 확인해주세요',
        'SEND_TIMEOUT',
      );
    }

    // 2. HTTP 상태 코드별 처리
    final statusCode = e.response?.statusCode;
    if (statusCode != null) {
      switch (statusCode) {
        case 413:
          return Result.failure(
            '업로드 파일이 너무 큽니다\n이미지 크기를 줄여주세요',
            'PAYLOAD_TOO_LARGE',
          );

        case 401:
          return Result.failure(
            '인증이 만료되었습니다\n다시 로그인해주세요',
            'AUTHENTICATION_EXPIRED',
          );

        case 403:
          return Result.failure(
            '접근 권한이 없습니다',
            'FORBIDDEN',
          );

        case 404:
          return Result.failure(
            '요청한 서비스를 찾을 수 없습니다',
            'NOT_FOUND',
          );

        case 500:
        case 502:
        case 503:
          return Result.failure(
            '서버에 일시적인 오류가 발생했습니다\n잠시 후 다시 시도해주세요',
            'SERVER_ERROR',
          );

        default:
          return Result.failure(
            '알 수 없는 오류가 발생했습니다 (코드: $statusCode)',
            'HTTP_ERROR',
          );
      }
    }

    // 3. 기타 네트워크 에러
    if (e.type == DioExceptionType.connectionError) {
      return Result.failure(
        '네트워크 연결에 실패했습니다\n인터넷 연결을 확인해주세요',
        'CONNECTION_ERROR',
      );
    }

    // 4. 기본 에러
    return Result.failure(
      '네트워크 오류가 발생했습니다',
      'NETWORK_ERROR',
    );
  }
}