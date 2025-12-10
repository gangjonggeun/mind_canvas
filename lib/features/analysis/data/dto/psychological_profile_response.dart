import 'package:json_annotation/json_annotation.dart';

part 'psychological_profile_response.g.dart';

/// 📊 [메인 응답] 통합 심리 프로필
/// 서버의 PsychologicalProfileResponse.java 와 매핑됩니다.
@JsonSerializable()
class PsychologicalProfileResponse {
  final MbtiStats? mbti;
  final Big5Stats? big5;
  final EnneagramStats? enneagram;

  /// 서버에서 "yyyy-MM-dd HH:mm:ss" 문자열 포맷으로 내려옵니다.
  final String? lastUpdatedAt;

  PsychologicalProfileResponse({
    this.mbti,
    this.big5,
    this.enneagram,
    this.lastUpdatedAt,
  });

  factory PsychologicalProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$PsychologicalProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PsychologicalProfileResponseToJson(this);
}

/// 🧠 [MBTI] 통계 데이터
/// 4대 선호 지표 + 8기능 점수 포함
@JsonSerializable()
class MbtiStats {
  final String? resultType; // 예: "ENFP"
  final String? testedAt;   // 검사 일시

  // 4대 선호 지표 점수 (0~100)
  final int energyScore;      // E
  final int informationScore; // N
  final int decisionScore;    // F
  final int lifestyleScore;   // P

  // 8기능 점수
  final int se;
  final int si;
  final int ne;
  final int ni;
  final int te;
  final int ti;
  final int fe;
  final int fi;

  MbtiStats({
    this.resultType,
    this.testedAt,
    this.energyScore = 0,
    this.informationScore = 0,
    this.decisionScore = 0,
    this.lifestyleScore = 0,
    this.se = 0,
    this.si = 0,
    this.ne = 0,
    this.ni = 0,
    this.te = 0,
    this.ti = 0,
    this.fe = 0,
    this.fi = 0,
  });

  factory MbtiStats.fromJson(Map<String, dynamic> json) =>
      _$MbtiStatsFromJson(json);

  Map<String, dynamic> toJson() => _$MbtiStatsToJson(this);
}

/// 🌊 [Big5] 통계 데이터
@JsonSerializable()
class Big5Stats {
  final int openness;        // 개방성
  final int conscientiousness; // 성실성
  final int extraversion;    // 외향성
  final int agreeableness;   // 우호성
  final int neuroticism;     // 신경성

  Big5Stats({
    this.openness = 0,
    this.conscientiousness = 0,
    this.extraversion = 0,
    this.agreeableness = 0,
    this.neuroticism = 0,
  });

  factory Big5Stats.fromJson(Map<String, dynamic> json) =>
      _$Big5StatsFromJson(json);

  Map<String, dynamic> toJson() => _$Big5StatsToJson(this);
}

/// 9️⃣ [Enneagram] 통계 데이터
@JsonSerializable()
class EnneagramStats {
  final String? resultType; // 예: "7w6"
  final String? testedAt;

  final int mainType; // 1~9
  final int wingType; // 1~9

  // 1~9 유형별 점수
  final int type1;
  final int type2;
  final int type3;
  final int type4;
  final int type5;
  final int type6;
  final int type7;
  final int type8;
  final int type9;

  EnneagramStats({
    this.resultType,
    this.testedAt,
    this.mainType = 0,
    this.wingType = 0,
    this.type1 = 0,
    this.type2 = 0,
    this.type3 = 0,
    this.type4 = 0,
    this.type5 = 0,
    this.type6 = 0,
    this.type7 = 0,
    this.type8 = 0,
    this.type9 = 0,
  });

  factory EnneagramStats.fromJson(Map<String, dynamic> json) =>
      _$EnneagramStatsFromJson(json);

  Map<String, dynamic> toJson() => _$EnneagramStatsToJson(this);
}