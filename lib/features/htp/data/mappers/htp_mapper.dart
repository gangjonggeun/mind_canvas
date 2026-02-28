// lib/features/htp/data/mappers/htp_mapper.dart

import 'dart:io';
import '../../domain/entities/htp_session_entity.dart';
import '../model/request/htp_basic_request.dart';
import '../model/request/htp_premium_request.dart';

/// 🔄 HTP Entity ↔ DTO 변환기
class HtpMapper {

  // =============================================================
  // Entity → DTO (서버 전송용)
  // =============================================================

  /// 세션 → 기본 요청 DTO 변환
  // static HtpBasicRequest toBasicRequest(HtpSessionEntity session) {
  //   return HtpBasicRequest(
  //     drawingProcess: DrawingProcess(
  //       drawOrder: _buildDrawOrder(session),
  //       timeTaken: _formatDuration(session.totalDurationSeconds ?? 0),
  //       pressure: _calculateAveragePressure(session),
  //     ),
  //   );
  // }

  /// 세션 → 프리미엄 요청 DTO 변환
  // static HtpPremiumRequest toPremiumRequest(
  //     HtpSessionEntity session,
  //     Map<String, String> pdiAnswers, // PDI 질문 답변
  //     ) {
  //   return HtpPremiumRequest(
  //     drawingProcess: DrawingProcess(
  //       drawOrder: _buildDrawOrder(session),
  //       timeTaken: _formatDuration(session.totalDurationSeconds ?? 0),
  //       pressure: _calculateAveragePressure(session),
  //     ),
  //     // ✅ 공통 질문 (4개 필드 모두 매핑)
  //     commonQuestions: CommonQuestions(
  //       overallFeeling: pdiAnswers['overallFeeling'] ?? '',
  //       story: pdiAnswers['story'] ?? '',
  //       favoriteDrawing: pdiAnswers['favoriteDrawing'] ?? '', // ✅ 추가
  //       erasedParts: pdiAnswers['erasedParts'] ?? '',         // ✅ 추가
  //     ),
  //     // ✅ 집 질문 (5개 필드 모두 매핑)
  //     houseQuestions: HouseQuestions(
  //       residents: pdiAnswers['houseResidents'] ?? '',
  //       atmosphere: pdiAnswers['houseAtmosphere'] ?? '',       // ✅ 추가
  //       doorAndWindow: pdiAnswers['houseDoorAndWindow'] ?? '', // ✅ 추가
  //       favoriteSpace: pdiAnswers['houseFavoriteSpace'] ?? '', // ✅ 추가
  //       addOrRemove: pdiAnswers['houseAddOrRemove'] ?? '',     // ✅ 추가
  //     ),
  //     // ✅ 나무 질문 (5개 필드 모두 매핑)
  //     treeQuestions: TreeQuestions(
  //       condition: pdiAnswers['treeCondition'] ?? '',
  //       environment: pdiAnswers['treeEnvironment'] ?? '',  // ✅ 추가
  //       weather: pdiAnswers['treeWeather'] ?? '',          // ✅ 추가
  //       needs: pdiAnswers['treeNeeds'] ?? '',              // ✅ 추가
  //       scars: pdiAnswers['treeScars'] ?? '',              // ✅ 추가
  //     ),
  //     // ✅ 사람 질문 (5개 필드 모두 매핑)
  //     personQuestions: PersonQuestions(
  //       identity: pdiAnswers['personIdentity'] ?? '',
  //       emotion: pdiAnswers['personEmotion'] ?? '',           // ✅ 추가
  //       desireAndFear: pdiAnswers['personDesireAndFear'] ?? '', // ✅ 추가
  //       gaze: pdiAnswers['personGaze'] ?? '',                 // ✅ 추가
  //       conversation: pdiAnswers['personConversation'] ?? '', // ✅ 추가
  //     ),
  //   );
  // }

  /// 세션에서 이미지 파일 목록 추출
  static List<File> extractImageFiles(HtpSessionEntity session) {
    final files = <File>[];

    // orderIndex 순서대로 정렬
    final sortedDrawings = List<HtpDrawingEntity>.from(session.drawings)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    for (var drawing in sortedDrawings) {
      if (drawing.hasImage) {
        final file = File(drawing.imagePath!);
        if (file.existsSync()) {
          files.add(file);
        }
      }
    }

    return files;
  }

  // =============================================================
  // Private 헬퍼 메서드
  // =============================================================

  /// 그린 순서 문자열 생성 ("house-tree-person")
  static String _buildDrawOrder(HtpSessionEntity session) {
    final sortedDrawings = List<HtpDrawingEntity>.from(session.drawings)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    return sortedDrawings
        .map((d) => d.type.toString().split('.').last)
        .join('-');
  }

  /// 소요 시간 포맷 ("10분 30초")
  static String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    if (minutes > 0) {
      return '$minutes분 $remainingSeconds초';
    } else {
      return '$seconds초';
    }
  }

  /// 평균 필압 계산
  static String _calculateAveragePressure(HtpSessionEntity session) {
    if (session.drawings.isEmpty) return 'medium';

    final avgPressure = session.drawings
        .map((d) => d.averagePressure)
        .reduce((a, b) => a + b) / session.drawings.length;

    if (avgPressure < 0.3) return 'light';
    if (avgPressure < 0.7) return 'medium';
    return 'heavy';
  }
}