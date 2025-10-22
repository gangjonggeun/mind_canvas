// lib/features/psytest/data/mappers/test_result_mapper.dart

import '../../domain/entities/psy_result.dart';
import '../model/dto/result_detail.dart';
import '../model/response/test_result_response.dart';

/// 🔄 TestResultResponse → PsyResult 변환
class TestResultMapper {
  static PsyResult toEntity(TestResultResponse response) {
    return PsyResult(
      // 🔑 기본 정보
      id: response.resultKey,
      title: response.resultTag,
      subtitle: response.briefDescription,
      description: _extractDescription(response.resultDetails),

      // 🎨 색상 (하나만!)
      backgroundColor: response.backgroundColor,

      // 📋 섹션
      sections: _convertToSections(response.resultDetails),

      // 📊 서버 데이터
      imageUrl: response.resultImageUrl,
      dimensionScores: response.dimensionScores,
      subjectiveAnswer: response.subjectiveAnswer,
      totalScore: response.totalScore,

      // 🎯 메타
      type: PsyResultType.fromResultKey(response.resultKey),
      createdAt: DateTime.now(),
      tags: _generateTags(response),
    );
  }

  static String _extractDescription(List<ResultDetail> details) {
    if (details.isEmpty) return '';
    return details.first.content;
  }

  static List<PsyResultSection> _convertToSections(
      List<ResultDetail> details,
      ) {
    return details.map((detail) {
      return PsyResultSection(
        title: detail.title,
        content: detail.content,
        imageUrl: detail.imageUrl,
        highlights: [], // 빈 리스트
      );
    }).toList();
  }

  static List<String> _generateTags(TestResultResponse response) {
    final tags = <String>[];
    final key = response.resultKey.toUpperCase();

    if (key.contains('MBTI')) tags.add('MBTI');
    if (key.contains('BIG5')) tags.add('Big5');
    if (key.contains('VALUE')) tags.add('가치관');
    if (key.contains('LOVE')) tags.add('연애');

    if (response.hasDimensionScores) tags.add('차원분석');

    return tags;
  }
}