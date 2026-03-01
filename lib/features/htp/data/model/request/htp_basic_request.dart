// =============================================================
// 📁 data/models/request/htp_basic_request.dart
// =============================================================

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/htp_session_entity.dart';

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

    required String strokeCount,
    required String modificationCount,
  }) = _DrawingProcess;

  factory DrawingProcess.fromJson(Map<String, dynamic> json) =>
      _$DrawingProcessFromJson(json);


  factory DrawingProcess.fromEntities(List<HtpDrawingEntity> drawings) {
    if (drawings.isEmpty) {
      return const DrawingProcess(
        drawOrder: '없음',
        timeTaken: '0분 0초',
        pressure: 'medium',
        strokeCount: '0회',
        modificationCount: '0회',
      );
    }

    // 1. 그린 시간순으로 정렬 (이 순서가 기준이 됩니다)
    final sorted = List<HtpDrawingEntity>.from(drawings)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    // 2. 그리기 순서 (예: house-tree-person)
    final drawOrder = sorted.map((d) => d.type.name).join('-');

    // 3. 소요 시간 나열 (예: "1분 8초, 1분 0초, 3분 12초")
    final timeTaken = sorted.map((d) {
      int durationMs = d.endTime - d.startTime;
      if (durationMs < 0) durationMs = 0; // 에러 방지용

      int totalSec = (durationMs / 1000).round();
      return '${totalSec ~/ 60}분 ${totalSec % 60}초';
    }).join(', ');

    // 4. 평균 필압 나열 (예: "medium, light, heavy")
    final pressure = sorted.map((d) {
      if (d.averagePressure < 0.4) return 'light';
      if (d.averagePressure < 0.7) return 'medium';
      return 'heavy';
    }).join(', ');

    // 5. 획수 및 지우개 횟수 나열 (예: "11회, 19회, 20회")
    final strokeCount = sorted.map((d) => '${d.strokeCount}회').join(', ');
    final modificationCount = sorted.map((d) => '${d.modificationCount}회').join(', ');

    return DrawingProcess(
      drawOrder: drawOrder,
      timeTaken: timeTaken,
      pressure: pressure,
      strokeCount: strokeCount,
      modificationCount: modificationCount,
    );
  }
}