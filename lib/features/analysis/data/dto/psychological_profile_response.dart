import 'package:json_annotation/json_annotation.dart';

part 'psychological_profile_response.g.dart';

/// 📊 [메인 응답] 통합 심리 프로필
@JsonSerializable()
class PsychologicalProfileResponse {
  final MbtiStats? mbti;
  final CognitiveStats? cognitiveFunctions; // 🆕 새로 추가된 필드 (8기능 분리)
  final Big5Stats? big5;
  final EnneagramStats? enneagram;

  final String? lastUpdatedAt;

  PsychologicalProfileResponse({
    this.mbti,
    this.cognitiveFunctions,
    this.big5,
    this.enneagram,
    this.lastUpdatedAt,
  });

  factory PsychologicalProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$PsychologicalProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PsychologicalProfileResponseToJson(this);
}

/// 🧠 [MBTI] 통계 데이터
/// (이제 순수하게 4대 선호 지표만 남았습니다)
@JsonSerializable()
class MbtiStats {
  final String? resultType; // 예: "ENFP"
  final String? testedAt;

  // 4대 선호 지표 점수 (0~100)
  final int energyScore;      // E
  final int informationScore; // N
  final int decisionScore;    // F
  final int lifestyleScore;   // P

  MbtiStats({
    this.resultType,
    this.testedAt,
    this.energyScore = 0,
    this.informationScore = 0,
    this.decisionScore = 0,
    this.lifestyleScore = 0,
  });

  factory MbtiStats.fromJson(Map<String, dynamic> json) =>
      _$MbtiStatsFromJson(json);

  Map<String, dynamic> toJson() => _$MbtiStatsToJson(this);
}

/// 💡 [Cognitive] 8기능 통계 데이터 (신규 클래스)
/// 서버의 CognitiveDto 와 매핑됩니다.
@JsonSerializable()
class CognitiveStats {
  final String? testedAt;

  // 8기능 점수
  final int se; final int si;
  final int ne; final int ni;
  final int te; final int ti;
  final int fe; final int fi;

  CognitiveStats({
    this.testedAt,
    this.se = 0, this.si = 0,
    this.ne = 0, this.ni = 0,
    this.te = 0, this.ti = 0,
    this.fe = 0, this.fi = 0,
  });

  factory CognitiveStats.fromJson(Map<String, dynamic> json) =>
      _$CognitiveStatsFromJson(json);

  Map<String, dynamic> toJson() => _$CognitiveStatsToJson(this);
}

/// 🌊 [Big5] 통계 데이터 (변경 없음)
@JsonSerializable()
class Big5Stats {
  final int openness;
  final int conscientiousness;
  final int extraversion;
  final int agreeableness;
  final int neuroticism;

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

/// 9️⃣ [Enneagram] 통계 데이터 (변경 없음)
@JsonSerializable()
class EnneagramStats {
  final String? resultType;
  final String? testedAt;

  final int mainType;
  final int wingType;

  final int type1; final int type2; final int type3;
  final int type4; final int type5; final int type6;
  final int type7; final int type8; final int type9;

  EnneagramStats({
    this.resultType,
    this.testedAt,
    this.mainType = 0,
    this.wingType = 0,
    this.type1 = 0, this.type2 = 0, this.type3 = 0,
    this.type4 = 0, this.type5 = 0, this.type6 = 0,
    this.type7 = 0, this.type8 = 0, this.type9 = 0,
  });

  factory EnneagramStats.fromJson(Map<String, dynamic> json) =>
      _$EnneagramStatsFromJson(json);

  Map<String, dynamic> toJson() => _$EnneagramStatsToJson(this);
}

// ==========================================
// 🛠️ 유효성 검사 확장 메서드 (UI 로직용)
// ==========================================
extension ProfileValidation on PsychologicalProfileResponse {

  /// 전체 데이터가 하나도 없는지 확인
  bool get isAllEmpty => !hasMbti && !hasCognitiveFunctions && !hasBig5 && !hasEnneagram;

  /// MBTI 데이터 유효성
  bool get hasMbti => mbti != null && mbti!.resultType != null;

  /// 8기능 데이터 유효성 (이제 별도 객체로 체크)
  bool get hasCognitiveFunctions {
    if (cognitiveFunctions == null) return false;
    final c = cognitiveFunctions!;
    // 점수 합이 0보다 크면 검사한 것으로 간주
    return (c.se + c.si + c.ne + c.ni + c.te + c.ti + c.fe + c.fi) > 0;
  }

  /// Big5 데이터 유효성
  bool get hasBig5 {
    if (big5 == null) return false;
    return (big5!.openness + big5!.conscientiousness + big5!.extraversion +
        big5!.agreeableness + big5!.neuroticism) > 0;
  }

  /// 에니어그램 데이터 유효성
  bool get hasEnneagram => enneagram != null && enneagram!.mainType > 0;
}