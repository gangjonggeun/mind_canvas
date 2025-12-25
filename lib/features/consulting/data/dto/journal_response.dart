import 'package:json_annotation/json_annotation.dart';

part 'journal_response.g.dart';

/// 📘 [일기 응답 DTO]
@JsonSerializable()
class JournalResponse {
  final int id;
  final String date; // "yyyy-MM-dd"
  final String content; // 원문
  final EmotionAnalysis analysis; // AI 분석 결과

  JournalResponse({
    required this.id,
    required this.date,
    required this.content,
    required this.analysis,
  });

  factory JournalResponse.fromJson(Map<String, dynamic> json) =>
      _$JournalResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JournalResponseToJson(this);
}

/// 🧠 [AI 감정 분석 DTO]
@JsonSerializable()
class EmotionAnalysis {
  /// 감정 점수 분포 (예: {"JOY": 10, "SADNESS": 80})
  final Map<String, int> emotionScores;

  /// 대표 감정
  final EmotionType primaryEmotion;

  /// AI 피드백 (위로의 말)
  final String aiFeedback;


  EmotionAnalysis({
    required this.emotionScores,
    required this.primaryEmotion,
    required this.aiFeedback
  });

  factory EmotionAnalysis.fromJson(Map<String, dynamic> json) =>
      _$EmotionAnalysisFromJson(json);

  Map<String, dynamic> toJson() => _$EmotionAnalysisToJson(this);
}

/// 🎭 [감정 타입 Enum]
enum EmotionType {
  @JsonValue('JOY')
  JOY,
  @JsonValue('SADNESS')
  SADNESS,
  @JsonValue('ANGER')
  ANGER,
  @JsonValue('ANXIETY')
  ANXIETY,
  @JsonValue('TIREDNESS')
  TIREDNESS,
  @JsonValue('NEUTRAL')
  NEUTRAL,
}