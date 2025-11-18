// lib/features/htp/domain/entities/htp_session_entity.dart

import 'dart:convert';

/// 🎨 HTP 세션 엔티티 (비즈니스 로직 포함)
///
/// **책임:**
/// - 로컬 저장용 데이터 구조
/// - 비즈니스 규칙 검증
/// - 상태 관리 로직
class HtpSessionEntity {
  final String sessionId;
  final String userId;
  final int startTime;
  final int? endTime;
  final List<HtpDrawingEntity> drawings;
  final bool supportsPressure;

  HtpSessionEntity({
    required this.sessionId,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.drawings,
    required this.supportsPressure,
  });

  // =============================================================
  // 비즈니스 로직
  // =============================================================

  /// 세션 완료 여부
  bool get isCompleted => drawings.length == 3 && endTime != null;

  /// 진행률 (0.0 ~ 1.0)
  double get progress => drawings.length / 3.0;

  /// 총 소요 시간 (초)
  int? get totalDurationSeconds {
    if (endTime == null) return null;
    return ((endTime! - startTime) / 1000).round();
  }

  /// 특정 타입의 그림 가져오기
  HtpDrawingEntity? getDrawing(HtpType type) {
    try {
      return drawings.firstWhere((d) => d.type == type);
    } catch (_) {
      return null;
    }
  }

  /// 그림 추가/수정
  HtpSessionEntity updateDrawing(HtpDrawingEntity drawing) {
    final updatedDrawings = List<HtpDrawingEntity>.from(drawings);
    final index = updatedDrawings.indexWhere((d) => d.type == drawing.type);

    if (index >= 0) {
      updatedDrawings[index] = drawing; // 수정
    } else {
      updatedDrawings.add(drawing); // 추가
    }

    return copyWith(drawings: updatedDrawings);
  }

  /// 세션 완료 처리
  HtpSessionEntity complete() {
    return copyWith(endTime: DateTime.now().millisecondsSinceEpoch);
  }

  // =============================================================
  // JSON 직렬화 (Hive 저장용)
  // =============================================================

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'userId': userId,
    'startTime': startTime,
    'endTime': endTime,
    'supportsPressure': supportsPressure,
    'drawings': drawings.map((d) => d.toJson()).toList(),
  };

  factory HtpSessionEntity.fromJson(Map<String, dynamic> json) {
    return HtpSessionEntity(
      sessionId: json['sessionId'] as String,
      userId: json['userId'] as String,
      startTime: json['startTime'] as int,
      endTime: json['endTime'] as int?,
      supportsPressure: json['supportsPressure'] as bool,
      drawings: (json['drawings'] as List<dynamic>)
          .map((d) => HtpDrawingEntity.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory HtpSessionEntity.fromJsonString(String jsonString) =>
      HtpSessionEntity.fromJson(jsonDecode(jsonString));

  // =============================================================
  // copyWith
  // =============================================================

  HtpSessionEntity copyWith({
    String? sessionId,
    String? userId,
    int? startTime,
    int? endTime,
    List<HtpDrawingEntity>? drawings,
    bool? supportsPressure,
  }) {
    return HtpSessionEntity(
      sessionId: sessionId ?? this.sessionId,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      drawings: drawings ?? this.drawings,
      supportsPressure: supportsPressure ?? this.supportsPressure,
    );
  }
}

/// 🖼️ HTP 그림 엔티티 (비즈니스 로직 포함)
class HtpDrawingEntity {
  final HtpType type;
  final int startTime;
  final int endTime;
  final int strokeCount;
  final int modificationCount;
  final double averagePressure;
  final int orderIndex;

  // ✅ 로컬 파일 경로
  final String? imagePath;
  final String? thumbnailPath;

  // ✅ 추가: Sketch 데이터 (JSON 문자열)
  final String? sketchJson;

  HtpDrawingEntity({
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.strokeCount,
    required this.modificationCount,
    required this.averagePressure,
    required this.orderIndex,
    this.imagePath,
    this.thumbnailPath,
    this.sketchJson,
  });

  // =============================================================
  // 비즈니스 로직
  // =============================================================

  /// 소요 시간 (초)
  int get durationSeconds => ((endTime - startTime) / 1000).round();

  /// 이미지 존재 여부
  bool get hasImage => imagePath != null && imagePath!.isNotEmpty;

  /// 썸네일 존재 여부
  bool get hasThumbnail => thumbnailPath != null && thumbnailPath!.isNotEmpty;

  /// 유효성 검증
  bool get isValid =>
      strokeCount > 0 &&
          averagePressure >= 0 &&
          durationSeconds > 0 &&
          hasImage;

  /// 필압 강도 (light/medium/heavy)
  String get pressureLevel {
    if (averagePressure < 0.3) return 'light';
    if (averagePressure < 0.7) return 'medium';
    return 'heavy';
  }

  // =============================================================
  // JSON 직렬화
  // =============================================================

  Map<String, dynamic> toJson() => {
    'type': type.toString().split('.').last,
    'startTime': startTime,
    'endTime': endTime,
    'strokeCount': strokeCount,
    'modificationCount': modificationCount,
    'averagePressure': averagePressure,
    'orderIndex': orderIndex,
    'imagePath': imagePath,
    'thumbnailPath': thumbnailPath,
    'sketchJson': sketchJson,
  };

  factory HtpDrawingEntity.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'] as String;
    final type = HtpType.values.firstWhere(
          (e) => e.toString().split('.').last == typeString,
    );

    return HtpDrawingEntity(
      type: type,
      startTime: json['startTime'] as int,
      endTime: json['endTime'] as int,
      strokeCount: json['strokeCount'] as int,
      modificationCount: json['modificationCount'] as int,
      averagePressure: (json['averagePressure'] as num).toDouble(),
      orderIndex: json['orderIndex'] as int,
      imagePath: json['imagePath'] as String?,
      thumbnailPath: json['thumbnailPath'] as String?,
      sketchJson: json['sketchJson'] as String?,
    );
  }

  // =============================================================
  // copyWith
  // =============================================================

  HtpDrawingEntity copyWith({
    HtpType? type,
    int? startTime,
    int? endTime,
    int? strokeCount,
    int? modificationCount,
    double? averagePressure,
    int? orderIndex,
    String? imagePath,
    String? thumbnailPath,
    String? sketchJson,
  }) {
    return HtpDrawingEntity(
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      strokeCount: strokeCount ?? this.strokeCount,
      modificationCount: modificationCount ?? this.modificationCount,
      averagePressure: averagePressure ?? this.averagePressure,
      orderIndex: orderIndex ?? this.orderIndex,
      imagePath: imagePath ?? this.imagePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      sketchJson: sketchJson ?? this.sketchJson,
    );
  }
}

/// HTP 그림 타입
enum HtpType {
  house,
  tree,
  person,
}