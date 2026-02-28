// =============================================================
// 📁 data/models/request/htp_basic_request.dart
// =============================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'htp_basic_request.freezed.dart';
part 'htp_basic_request.g.dart';

/// 🖼️ HTP 기본 분석 요청 DTO
///
/// <p><strong>포함 내용:</strong></p>
/// - 그림 그리는 과정 정보만 포함
/// - 이미지는 별도 MultipartFile로 전송
///
/// <p><strong>사용 예시:</strong></p>
/// ```dart
/// final request = HtpBasicRequest(
///   drawingProcess: DrawingProcess(
///     drawOrder: 'house-tree-person',
///     timeTaken: '10분 30초',
///     pressure: 'medium',
///   ),
/// );
/// ```
@freezed
class HtpBasicRequest with _$HtpBasicRequest {
  const factory HtpBasicRequest({
    /// 그림 그리는 과정 정보
    @JsonKey(name: 'drawingProcess') required DrawingProcess drawingProcess,
  }) = _HtpBasicRequest;

  factory HtpBasicRequest.fromJson(Map<String, dynamic> json) =>
      _$HtpBasicRequestFromJson(json);
}

/// 📝 그림 그리는 과정 정보
///
/// <p><strong>필드 설명:</strong></p>
/// - drawOrder: 그린 순서 (예: "house-tree-person", "집→나무→사람")
/// - timeTaken: 소요 시간 (예: "10분 30초", "총 15분")
/// - pressure: 필압 정보 (예: "light", "medium", "heavy")
@freezed
class DrawingProcess with _$DrawingProcess {
  const factory DrawingProcess({
    /// 그린 순서
    @JsonKey(name: 'drawOrder') required String drawOrder,

    /// 소요 시간
    @JsonKey(name: 'timeTaken') required String timeTaken,

    /// 필압 정보 (light/medium/heavy)
    @JsonKey(name: 'pressure') required String pressure,
    required int strokeCount,       // ✅ 추가
    required int modificationCount, // ✅ 추가
  }) = _DrawingProcess;

  factory DrawingProcess.fromJson(Map<String, dynamic> json) =>
      _$DrawingProcessFromJson(json);
}