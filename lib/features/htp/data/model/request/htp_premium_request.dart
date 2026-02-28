// =============================================================
// 📁 data/models/request/htp_premium_request.dart
// =============================================================

import 'package:freezed_annotation/freezed_annotation.dart';
import 'htp_basic_request.dart';
import 'htp_basic_request.dart'; // DrawingProcess 재사용

part 'htp_premium_request.freezed.dart';
part 'htp_premium_request.g.dart';

/// 🧠 HTP 프리미엄 심층 분석 요청 DTO
///
/// <p><strong>포함 내용:</strong></p>
/// - 그림 그리는 과정 정보
/// - 공통 질문 답변
/// - 집/나무/사람 각각에 대한 심층 질문 답변 (PDI)
///
/// <p><strong>사용 예시:</strong></p>
/// ```dart
/// final request = HtpPremiumRequest(
///   drawingProcess: DrawingProcess(...),
///   commonQuestions: CommonQuestions(...),
///   houseQuestions: HouseQuestions(...),
///   treeQuestions: TreeQuestions(...),
///   personQuestions: PersonQuestions(...),
/// );
/// ```


@freezed
class HtpPremiumRequest with _$HtpPremiumRequest {
  const factory HtpPremiumRequest({
    required Map<String, String> answers,
    required DrawingProcess drawingProcess, // ✅ 메타데이터 추가!
  }) = _HtpPremiumRequest;

  factory HtpPremiumRequest.fromJson(Map<String, dynamic> json) =>
      _$HtpPremiumRequestFromJson(json);
}

// =============================================================
// 📋 공통 질문 (모든 그림에 대한 종합적 질문)
// =============================================================

/// 🌐 모든 그림에 대한 공통 질문
///
/// <p><strong>질문 항목:</strong></p>
/// - 전체적인 느낌
/// - 그림들의 이야기
/// - 가장 마음이 가는 그림
/// - 지우거나 망설인 부분
@freezed
class CommonQuestions with _$CommonQuestions {
  const factory CommonQuestions({
    /// 전체적인 느낌
    @JsonKey(name: 'overallFeeling') required String overallFeeling,

    /// 이야기 (세 그림을 연결한 스토리)
    @JsonKey(name: 'story') required String story,

    /// 가장 마음이 가는 그림
    @JsonKey(name: 'favoriteDrawing') required String favoriteDrawing,

    /// 지우거나 망설인 부분
    @JsonKey(name: 'erasedParts') required String erasedParts,
  }) = _CommonQuestions;

  factory CommonQuestions.fromJson(Map<String, dynamic> json) =>
      _$CommonQuestionsFromJson(json);
}

// =============================================================
// 🏠 집(House) 그림 질문
// =============================================================

/// 🏠 집 그림에 대한 심층 질문
///
/// <p><strong>질문 항목:</strong></p>
/// - 집의 주인 (누가 사는가?)
/// - 집의 분위기
/// - 문과 창문 특징
/// - 가장 좋아하는 공간
/// - 추가/제거하고 싶은 것
@freezed
class HouseQuestions with _$HouseQuestions {
  const factory HouseQuestions({
    /// 집의 주인 (거주자)
    @JsonKey(name: 'residents') required String residents,

    /// 집의 분위기
    @JsonKey(name: 'atmosphere') required String atmosphere,

    /// 문과 창문 설명
    @JsonKey(name: 'doorAndWindow') required String doorAndWindow,

    /// 가장 좋아하는 공간
    @JsonKey(name: 'favoriteSpace') required String favoriteSpace,

    /// 추가하거나 제거하고 싶은 것
    @JsonKey(name: 'addOrRemove') required String addOrRemove,
  }) = _HouseQuestions;

  factory HouseQuestions.fromJson(Map<String, dynamic> json) =>
      _$HouseQuestionsFromJson(json);
}

// =============================================================
// 🌳 나무(Tree) 그림 질문
// =============================================================

/// 🌳 나무 그림에 대한 심층 질문
///
/// <p><strong>질문 항목:</strong></p>
/// - 나무의 상태 (건강, 나이 등)
/// - 나무의 환경
/// - 날씨의 영향
/// - 나무의 필요 (무엇이 필요한가?)
/// - 나무의 상처
@freezed
class TreeQuestions with _$TreeQuestions {
  const factory TreeQuestions({
    /// 나무의 상태 (건강, 나이 등)
    @JsonKey(name: 'condition') required String condition,

    /// 나무의 환경 (어디에 있는가?)
    @JsonKey(name: 'environment') required String environment,

    /// 날씨의 영향
    @JsonKey(name: 'weather') required String weather,

    /// 나무가 필요로 하는 것
    @JsonKey(name: 'needs') required String needs,

    /// 나무의 상처 (있다면)
    @JsonKey(name: 'scars') required String scars,
  }) = _TreeQuestions;

  factory TreeQuestions.fromJson(Map<String, dynamic> json) =>
      _$TreeQuestionsFromJson(json);
}

// =============================================================
// 👤 사람(Person) 그림 질문
// =============================================================

/// 👤 사람 그림에 대한 심층 질문
///
/// <p><strong>질문 항목:</strong></p>
/// - 인물의 정체성 (누구인가?)
/// - 인물의 감정과 생각
/// - 인물의 소망과 두려움
/// - 인물의 시선 (어디를 보는가?)
/// - 나와의 대화 (그 사람이 나에게 하는 말)
@freezed
class PersonQuestions with _$PersonQuestions {
  const factory PersonQuestions({
    /// 인물의 정체성 (누구인가?)
    @JsonKey(name: 'identity') required String identity,

    /// 인물의 감정과 생각
    @JsonKey(name: 'emotion') required String emotion,

    /// 인물의 소망과 두려움
    @JsonKey(name: 'desireAndFear') required String desireAndFear,

    /// 인물의 시선 (어디를 보고 있는가?)
    @JsonKey(name: 'gaze') required String gaze,

    /// 나와의 대화 (그 사람이 나에게 하는 말)
    @JsonKey(name: 'conversation') required String conversation,
  }) = _PersonQuestions;

  factory PersonQuestions.fromJson(Map<String, dynamic> json) =>
      _$PersonQuestionsFromJson(json);
}