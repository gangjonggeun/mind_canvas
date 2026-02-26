import 'package:json_annotation/json_annotation.dart';

part 'psychological_profile_response.g.dart';

/// 📊 [메인 응답] 통합 심리 프로필
@JsonSerializable(explicitToJson: true)
class PsychologicalProfileResponse {
  final MbtiStats? mbti;

  // final CognitiveStats? cognitiveFunctions; // 🆕 새로 추가된 필드 (8기능 분리)
  final Big5Stats? big5;
  final EnneagramStats? enneagram;
  @JsonKey(name: 'values')
  final ValueStats? values;
  // 🆕 추가 (8기능 대체)
  final HollandStats? holland;

  final String? lastUpdatedAt;

  PsychologicalProfileResponse({
    this.mbti,
    // this.cognitiveFunctions,
    this.big5,
    this.enneagram,
    this.values,
    this.holland, // 추가
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
  final int energyScore; // E
  final int informationScore; // N
  final int decisionScore; // F
  final int lifestyleScore; // P

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

/// 🎨 [Holland] (신규)
@JsonSerializable()
class HollandStats {
  // ✅ [수정] 서버 DTO 변수명: hollandCode
  // 서버 로그: "hollandCode": "RIA"
  @JsonKey(name: 'hollandCode')
  final String? resultType;

  final String? testedAt;

  // 점수 필드명: realisticScore, investigativeScore ... (서버 로그 기준)
  @JsonKey(name: 'realisticScore') final int realistic;
  @JsonKey(name: 'investigativeScore') final int investigative;
  @JsonKey(name: 'artisticScore') final int artistic;
  @JsonKey(name: 'socialScore') final int social;
  @JsonKey(name: 'enterprisingScore') final int enterprising;
  @JsonKey(name: 'conventionalScore') final int conventional;

  HollandStats({
    this.resultType,
    this.testedAt,
    this.realistic = 0,
    this.investigative = 0,
    this.artistic = 0,
    this.social = 0,
    this.enterprising = 0,
    this.conventional = 0,
  });

  factory HollandStats.fromJson(Map<String, dynamic> json) =>
      _$HollandStatsFromJson(json);

  Map<String, dynamic> toJson() => _$HollandStatsToJson(this);
}

/// 💡 [Cognitive] 8기능 통계 데이터 (신규 클래스)
/// 서버의 CognitiveDto 와 매핑됩니다.
@JsonSerializable()
class CognitiveStats {
  final String? testedAt;

  // 8기능 점수
  final int se;
  final int si;
  final int ne;
  final int ni;
  final int te;
  final int ti;
  final int fe;
  final int fi;

  CognitiveStats({
    this.testedAt,
    this.se = 0,
    this.si = 0,
    this.ne = 0,
    this.ni = 0,
    this.te = 0,
    this.ti = 0,
    this.fe = 0,
    this.fi = 0,
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

/// 💎 [Values] (신규 - 가치관)
@JsonSerializable()
class ValueStats {
  final String? dominantValue; // "ACHIEVEMENT"
  final String? testedAt;

  final int power;
  final int achievement;
  final int hedonism;
  final int stimulation;
  final int selfDirection;
  final int universalism;
  final int benevolence;
  final int tradition;
  final int conformity;
  final int security;

  ValueStats({
    this.dominantValue,
    this.testedAt,
    this.power = 0,
    this.achievement = 0,
    this.hedonism = 0,
    this.stimulation = 0,
    this.selfDirection = 0,
    this.universalism = 0,
    this.benevolence = 0,
    this.tradition = 0,
    this.conformity = 0,
    this.security = 0,
  });

  factory ValueStats.fromJson(Map<String, dynamic> json) =>
      _$ValueStatsFromJson(json);

  Map<String, dynamic> toJson() => _$ValueStatsToJson(this);
}

/// 9️⃣ [Enneagram] 통계 데이터 (변경 없음)
@JsonSerializable()
class EnneagramStats {
  final String? resultType;
  final String? testedAt;

  final int mainType;
  final int wingType;

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

// ==========================================
// 🛠️ 유효성 검사 확장 메서드 (UI 로직용)
// ==========================================
extension ProfileValidation on PsychologicalProfileResponse {
  /// 전체 데이터가 하나도 없는지 확인
  bool get isAllEmpty =>
      !hasMbti && !hasBig5 && !hasEnneagram  && !hasValues;

  /// MBTI 데이터 유효성
  bool get hasMbti => mbti != null && mbti!.resultType != null;

  /// Big5 데이터 유효성
  bool get hasBig5 {
    if (big5 == null) return false;
    return (big5!.openness +
        big5!.conscientiousness +
        big5!.extraversion +
        big5!.agreeableness +
        big5!.neuroticism) >
        0;
  }

  /// 에니어그램 데이터 유효성
  bool get hasEnneagram => enneagram != null && enneagram!.mainType > 0;

  /// 홀랜드 데이터 유효성 (신규)
  bool get hasHolland => holland != null && holland!.resultType != null;

  /// 가치관 데이터 유효성 (신규)
  bool get hasValues => values != null && values!.dominantValue != null;
}