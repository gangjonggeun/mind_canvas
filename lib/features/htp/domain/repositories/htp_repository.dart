// =============================================================
// 📁 domain/repositories/htp_repository.dart
// =============================================================

import 'dart:io';

import '../../../../core/utils/result.dart';
import '../../data/model/request/htp_basic_request.dart';
import '../../data/model/request/htp_premium_request.dart';
import '../../data/model/response/htp_response.dart';

/// 🎨 HTP(집-나무-사람) 그림검사 Repository 인터페이스
///
/// <p><strong>주요 기능:</strong></p>
/// - 🖼️ 기본 분석: 그림 이미지 + 그리기 과정 정보
/// - 🧠 프리미엄 분석: 기본 분석 + PDI 질문 답변
///
/// <p><strong>책임:</strong></p>
/// - 이미지 파일 검증 (크기, 형식, 개수)
/// - MultipartFile 변환
/// - API 호출 및 에러 처리
/// - ApiResponse → Result 변환
abstract class HtpRepository {
  /// 🖼️ HTP 기본 분석
  ///
  /// <p><strong>파라미터:</strong></p>
  /// - imageFiles: 그림 파일 3장 (집, 나무, 사람 순서)
  /// - drawingProcess: 그리기 과정 정보
  ///
  /// <p><strong>검증 사항:</strong></p>
  /// - 이미지 개수: 정확히 3장
  /// - 파일 크기: 각 5MB 이하
  /// - 파일 형식: PNG, JPG, JPEG
  ///
  /// @return Result<HtpResponse> 분석 결과 또는 에러
  Future<Result<HtpResponse>> analyzeBasicHtp({
    required List<File> imageFiles,
    required DrawingProcess drawingProcess,
  });

  /// 🧠 HTP 프리미엄 심층 분석
  ///
  /// <p><strong>파라미터:</strong></p>
  /// - imageFiles: 그림 파일 3장
  /// - request: 전체 프리미엄 분석 요청 (그리기 과정 + PDI 답변)
  ///
  /// @return Result<HtpResponse> 심층 분석 결과 또는 에러
  Future<Result<HtpResponse>> analyzePremiumHtp({
    required List<File> imageFiles,
    required HtpPremiumRequest request,
  });
}