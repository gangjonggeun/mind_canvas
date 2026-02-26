import 'package:freezed_annotation/freezed_annotation.dart';

part 'comprehensive_analysis_response.freezed.dart';
part 'comprehensive_analysis_response.g.dart';

@freezed
class ComprehensiveAnalysisResponse with _$ComprehensiveAnalysisResponse {
  const factory ComprehensiveAnalysisResponse({
    /// 1. 핵심 요약
    required String title,
    required String catchphrase,
    required String themeColor,
    required List<String> keywords,

    /// 2. 상세 분석 내용
    required String coreSummary,

    /// 3. 입체적 분석
    required List<String> strengths,
    required List<String> weaknesses,

    /// 4. 맞춤형 추천
    required String idealEnvironment,
    required List<String> recommendedHobbies,
  }) = _ComprehensiveAnalysisResponse;

  factory ComprehensiveAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$ComprehensiveAnalysisResponseFromJson(json);
}