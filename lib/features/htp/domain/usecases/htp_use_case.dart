// =============================================================
// 📁 domain/usecases/htp_use_case.dart
// =============================================================

import 'dart:io';

import '../../../../core/utils/result.dart';
import '../../../psy_result/data/model/response/test_result_response.dart';
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
  Future<Result<TestResultResponse>> analyzeBasic({
    required List<File> imageFiles,
    required DrawingProcess drawingProcess,
  }) async {
    try {
      // 1. 입력 검증 (이건 유지하는 게 좋습니다)
      final validationResult = _validateBasicInput(imageFiles, drawingProcess);
      if (validationResult != null) return validationResult;

      // 2. Repository 호출
      final result = await _repository.analyzeBasicHtp(
        imageFiles: imageFiles,
        drawingProcess: drawingProcess,
      );

      // 3. 결과 처리 (가공 로직 제거)
      return result.fold(
        onSuccess: (data) {
          // 💡 비동기 구조이므로 data는 PENDING_AI 상태임.
          // 별도의 가공 없이 바로 성공 리턴.
          return Result.success(data, '분석 요청이 접수되었습니다');
        },
        onFailure: (message, errorCode) {
          final userMessage = _convertToUserFriendlyMessage(message, errorCode);
          return Result.failure(userMessage, errorCode);
        },
      );
    } catch (e) {
      return Result.failure('분석 중 오류가 발생했습니다', 'USECASE_ERROR');
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
  @override
  Future<Result<TestResultResponse>> analyzePremium({
    required List<File> imageFiles,
    required HtpPremiumRequest request,
  }) {
    // 🚨 프리미엄 전용 검증 (이미지 4장 + 답변 존재 여부만 체크)
    final validation = _validatePremiumInput(imageFiles, request);
    if (validation != null) return Future.value(validation);

    return _repository.analyzePremiumHtp(
      imageFiles: imageFiles,
      request: request,
    );
  }

  // =============================================================
  // 🔍 Private 비즈니스 로직 메서드들
  // =============================================================

  /// 기본 분석 입력 검증
  Result<TestResultResponse>? _validateBasicInput(
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

  /// ✅ 프리미엄 분석 검증 (Premium)
  /// - PDI 상세 내용 검증 삭제
  /// - 이미지 개수 4장 확인
  Result<TestResultResponse>? _validatePremiumInput(
    List<File> imageFiles,
    HtpPremiumRequest request,
  ) {
    // 1. 이미지 개수 검증 (집, 나무, 남, 여 = 4장)
    if (imageFiles.length != 4) {
      return Result.failure(
        '프리미엄 검사는 집, 나무, 남자, 여자 그림이 모두 필요합니다 (총 4장).',
        'INVALID_IMAGE_COUNT',
      );
    }

    // 2. 답변 존재 여부만 가볍게 체크 (내용/길이 검증 X)
    if (request.answers.isEmpty) {
      return Result.failure(
        '질문지(PDI) 답변 데이터가 없습니다.',
        'MISSING_PDI_ANSWERS',
      );
    }

    // (선택) 답변이 모두 비어있는지 체크하고 싶다면:
    // bool allEmpty = request.answers.values.every((v) => v.trim().isEmpty);
    // if (allEmpty) return Result.failure('답변 내용을 입력해주세요.');

    return null; // 검증 통과
  }

//
// /// 기본 분석 결과 가공
// TestResultResponse _processAnalysisResult(TestResultResponse response) {
//   // 비즈니스 로직: 결과를 order 기준으로 정렬
//   final sortedDetails = response.sortedDetails;
//
//   return response.copyWith(
//     resultDetails: sortedDetails,
//   );
// }
//
// /// 프리미엄 분석 결과 가공
// TestResultResponse _processPremiumResult(TestResultResponse response) {
//   // 비즈니스 로직: 프리미엄은 더 상세한 분석이므로 추가 처리
//   final sortedDetails = response.sortedDetails;
//
//   // 예: 이미지가 있는 항목을 앞으로 배치
//   final detailsWithImages = sortedDetails.where((d) => d.hasImage).toList();
//   final detailsWithoutImages = sortedDetails.where((d) => !d.hasImage).toList();
//
//   return response.copyWith(
//     resultDetails: [...detailsWithImages, ...detailsWithoutImages],
//   );
// }

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
