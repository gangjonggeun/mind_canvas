// =============================================================
// 📁 domain/usecases/htp_use_case.dart
// =============================================================

import 'dart:io';

import '../../../../core/utils/result.dart';
import '../../data/model/request/htp_basic_request.dart';
import '../../data/model/request/htp_premium_request.dart';
import '../../data/model/response/htp_response.dart';
import '../repositories/htp_repository.dart';

/// 🎨 HTP(집-나무-사람) 그림검사 UseCase
///
/// <p><strong>비즈니스 로직:</strong></p>
/// - 이미지 파일 개수 검증 (UseCase 레벨에서 한 번 더)
/// - 분석 타입별 입력 데이터 검증
/// - 분석 결과 후처리 (정렬, 필터링 등)
/// - 사용자 친화적 에러 메시지 변환
class HtpUseCase {
  final HtpRepository _repository;

  HtpUseCase(this._repository);

  // =============================================================
  // 🖼️ 기본 분석
  // =============================================================

  /// HTP 기본 분석 실행
  ///
  /// <p><strong>비즈니스 규칙:</strong></p>
  /// - 이미지는 정확히 3장
  /// - 그리기 순서 필수
  /// - 소요 시간 필수
  /// - 필압 정보 필수
  ///
  /// @param imageFiles 그림 파일 3장
  /// @param drawingProcess 그리기 과정 정보
  /// @return Result<HtpResponse> 분석 결과
  Future<Result<HtpResponse>> analyzeBasic({
    required List<File> imageFiles,
    required DrawingProcess drawingProcess,
  }) async {
    try {
      print('🎨 [UseCase] HTP 기본 분석 시작');

      // 1. 비즈니스 규칙 검증 (UseCase 레벨)
      final validationResult = _validateBasicInput(imageFiles, drawingProcess);
      if (validationResult != null) {
        print('❌ [UseCase] 입력 검증 실패: ${validationResult.message}');
        return validationResult;
      }

      // 2. Repository 호출
      final result = await _repository.analyzeBasicHtp(
        imageFiles: imageFiles,
        drawingProcess: drawingProcess,
      );

      // 3. 결과 처리
      return result.fold(
        onSuccess: (data) {
          print('✅ [UseCase] 기본 분석 성공 - 항목: ${data.resultDetails.length}개');

          // 비즈니스 로직: 결과 정렬 및 가공
          final processedData = _processAnalysisResult(data);

          return Result.success(
            processedData,
            'HTP 기본 분석이 완료되었습니다',
          );
        },
        onFailure: (message, errorCode) {
          print('❌ [UseCase] 기본 분석 실패: $message');

          // 사용자 친화적 에러 메시지 변환
          final userMessage = _convertToUserFriendlyMessage(message, errorCode);
          return Result.failure(userMessage, errorCode);
        },
      );
    } catch (e, stackTrace) {
      print('❌ [UseCase] 예상치 못한 오류: $e');
      print('StackTrace: $stackTrace');
      return Result.failure(
        '분석 중 오류가 발생했습니다\n잠시 후 다시 시도해주세요',
        'USECASE_ERROR',
      );
    }
  }

  // =============================================================
  // 🧠 프리미엄 분석
  // =============================================================

  /// HTP 프리미엄 심층 분석 실행
  ///
  /// <p><strong>비즈니스 규칙:</strong></p>
  /// - 기본 분석의 모든 규칙
  /// - PDI 질문 답변 완성도 검증
  /// - 각 질문 카테고리별 최소 답변 길이
  ///
  /// @param imageFiles 그림 파일 3장
  /// @param request 프리미엄 분석 요청 (PDI 답변 포함)
  /// @return Result<HtpResponse> 심층 분석 결과
  Future<Result<HtpResponse>> analyzePremium({
    required List<File> imageFiles,
    required HtpPremiumRequest request,
  }) async {
    try {
      print('🧠 [UseCase] HTP 프리미엄 분석 시작');

      // 1. 비즈니스 규칙 검증
      final validationResult = _validatePremiumInput(imageFiles, request);
      if (validationResult != null) {
        print('❌ [UseCase] 입력 검증 실패: ${validationResult.message}');
        return validationResult;
      }

      // 2. Repository 호출
      final result = await _repository.analyzePremiumHtp(
        imageFiles: imageFiles,
        request: request,
      );

      // 3. 결과 처리
      return result.fold(
        onSuccess: (data) {
          print('✅ [UseCase] 프리미엄 분석 성공 - 항목: ${data.resultDetails.length}개');

          // 비즈니스 로직: 프리미엄 결과 강화 처리
          final processedData = _processPremiumResult(data);

          return Result.success(
            processedData,
            'HTP 프리미엄 분석이 완료되었습니다',
          );
        },
        onFailure: (message, errorCode) {
          print('❌ [UseCase] 프리미엄 분석 실패: $message');

          final userMessage = _convertToUserFriendlyMessage(message, errorCode);
          return Result.failure(userMessage, errorCode);
        },
      );
    } catch (e, stackTrace) {
      print('❌ [UseCase] 예상치 못한 오류: $e');
      print('StackTrace: $stackTrace');
      return Result.failure(
        '프리미엄 분석 중 오류가 발생했습니다\n잠시 후 다시 시도해주세요',
        'USECASE_ERROR',
      );
    }
  }

  // =============================================================
  // 🔍 Private 비즈니스 로직 메서드들
  // =============================================================

  /// 기본 분석 입력 검증
  Result<HtpResponse>? _validateBasicInput(
      List<File> imageFiles,
      DrawingProcess drawingProcess,
      ) {
    // 1. 이미지 개수 검증 (UseCase 레벨에서 한 번 더)
    if (imageFiles.length != 3) {
      return Result.failure(
        '그림은 집, 나무, 사람 순서로 정확히 3장이어야 합니다',
        'INVALID_IMAGE_COUNT',
      );
    }

    // 2. 그리기 과정 데이터 검증
    if (drawingProcess.drawOrder.trim().isEmpty) {
      return Result.failure(
        '그린 순서를 입력해주세요',
        'MISSING_DRAW_ORDER',
      );
    }

    if (drawingProcess.timeTaken.trim().isEmpty) {
      return Result.failure(
        '소요 시간을 입력해주세요',
        'MISSING_TIME_TAKEN',
      );
    }

    if (drawingProcess.pressure.trim().isEmpty) {
      return Result.failure(
        '필압 정보를 입력해주세요',
        'MISSING_PRESSURE',
      );
    }

    // 3. 필압 값 검증 (비즈니스 규칙)
    final validPressures = ['light', 'medium', 'heavy', '약함', '보통', '강함'];
    if (!validPressures.contains(drawingProcess.pressure.toLowerCase())) {
      return Result.failure(
        '필압은 약함/보통/강함 중 하나를 선택해주세요',
        'INVALID_PRESSURE_VALUE',
      );
    }

    return null; // 검증 성공
  }

  /// 프리미엄 분석 입력 검증
  Result<HtpResponse>? _validatePremiumInput(
      List<File> imageFiles,
      HtpPremiumRequest request,
      ) {
    // 1. 기본 검증 (이미지 + 그리기 과정)
    final basicValidation = _validateBasicInput(
      imageFiles,
      request.drawingProcess,
    );
    if (basicValidation != null) {
      return basicValidation;
    }

    // 2. 공통 질문 검증
    if (request.commonQuestions.overallFeeling.trim().isEmpty) {
      return Result.failure(
        '전체적인 느낌을 입력해주세요',
        'MISSING_OVERALL_FEELING',
      );
    }

    if (request.commonQuestions.story.trim().length < 10) {
      return Result.failure(
        '그림들의 이야기를 최소 10자 이상 작성해주세요',
        'STORY_TOO_SHORT',
      );
    }

    // 3. 각 그림별 질문 검증 (최소 답변 길이)
    final houseValidation = _validateQuestionAnswers(
      request.houseQuestions.residents,
      '집에 사는 사람',
    );
    if (houseValidation != null) return houseValidation;

    final treeValidation = _validateQuestionAnswers(
      request.treeQuestions.condition,
      '나무의 상태',
    );
    if (treeValidation != null) return treeValidation;

    final personValidation = _validateQuestionAnswers(
      request.personQuestions.identity,
      '인물의 정체성',
    );
    if (personValidation != null) return personValidation;

    return null; // 검증 성공
  }

  /// 개별 질문 답변 검증
  Result<HtpResponse>? _validateQuestionAnswers(
      String answer,
      String fieldName,
      ) {
    if (answer.trim().isEmpty) {
      return Result.failure(
        '$fieldName을(를) 입력해주세요',
        'MISSING_REQUIRED_FIELD',
      );
    }

    if (answer.trim().length < 2) {
      return Result.failure(
        '$fieldName은(는) 최소 2자 이상 작성해주세요',
        'ANSWER_TOO_SHORT',
      );
    }

    return null;
  }

  /// 기본 분석 결과 가공
  HtpResponse _processAnalysisResult(HtpResponse response) {
    // 비즈니스 로직: 결과를 order 기준으로 정렬
    final sortedDetails = response.sortedDetails;

    return response.copyWith(
      resultDetails: sortedDetails,
    );
  }

  /// 프리미엄 분석 결과 가공
  HtpResponse _processPremiumResult(HtpResponse response) {
    // 비즈니스 로직: 프리미엄은 더 상세한 분석이므로 추가 처리
    final sortedDetails = response.sortedDetails;

    // 예: 이미지가 있는 항목을 앞으로 배치
    final detailsWithImages = sortedDetails.where((d) => d.hasImage).toList();
    final detailsWithoutImages = sortedDetails.where((d) => !d.hasImage).toList();

    return response.copyWith(
      resultDetails: [...detailsWithImages, ...detailsWithoutImages],
    );
  }

  /// 사용자 친화적 에러 메시지 변환
  String _convertToUserFriendlyMessage(String? message, String? errorCode) {
    if (message == null) return '알 수 없는 오류가 발생했습니다';

    // 에러 코드별 사용자 친화적 메시지
    switch (errorCode) {
      case 'AUTHENTICATION_REQUIRED':
      case 'AUTH_ERROR':
        return '로그인이 필요한 서비스입니다\n다시 로그인해주세요';

      case 'INVALID_IMAGE_COUNT':
        return '그림은 집, 나무, 사람 순서로\n정확히 3장을 그려주세요';

      case 'FILE_TOO_LARGE':
        return '이미지 파일이 너무 큽니다\n각 파일은 5MB 이하여야 합니다';

      case 'UNSUPPORTED_FILE_FORMAT':
        return '지원하지 않는 파일 형식입니다\nPNG 또는 JPG 파일만 업로드 가능합니다';

      case 'CONNECTION_TIMEOUT':
      case 'RECEIVE_TIMEOUT':
      case 'SEND_TIMEOUT':
        return '네트워크 연결이 불안정합니다\n잠시 후 다시 시도해주세요';

      case 'NETWORK_ERROR':
      case 'CONNECTION_ERROR':
        return '인터넷 연결을 확인해주세요';

      case 'SERVER_ERROR':
        return '서버에 일시적인 문제가 발생했습니다\n잠시 후 다시 시도해주세요';

      case 'EMPTY_RESULT':
        return '분석 결과를 생성할 수 없습니다\n다시 시도해주세요';

      default:
        return message; // 기본 메시지 반환
    }
  }
}