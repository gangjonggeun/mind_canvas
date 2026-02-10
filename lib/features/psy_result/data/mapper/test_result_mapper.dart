// lib/features/psytest/data/mappers/test_result_mapper.dart

import '../../domain/entities/psy_result.dart';
import '../model/response/test_result_response.dart';

/// 🔄 TestResultResponse → PsyResult 변환 (단순화)
class TestResultMapper {
  static PsyResult toEntity(TestResultResponse response) {
    // ✅ resultDetails를 그대로 sections로 변환
    final sections = response.sortedResultDetails.map((detail) {
      return PsyResultSection(
        title: detail.title,
        content: detail.content,
        imageUrl: detail.imageUrl,
        highlights: [], // 빈 리스트
      );
    }).toList();

    return PsyResult(
      // 🔑 기본 정보
      id: response.resultKey,
      title: response.resultTag,
      subtitle: response.briefDescription,    // ✅ 간단한 설명
      description: '',                        // 사용 안함

      // 🎨 색상
      backgroundColor: response.backgroundColor,

      // 📋 섹션 (메인 콘텐츠!)
      sections: sections,

      // 🎯 메타
      type: PsyResultType.fromResultKey(response.resultKey),
      createdAt: DateTime.now(),
      tags: _generateTags(response.resultKey),

      imageUrl: response.imageUrl,
      dimensionScores: response.dimensionScores,
      subjectiveAnswer: null,
      totalScore: null,
    );
  }

  static List<String> _generateTags(String resultKey) {
    final tags = <String>[];
    final key = resultKey.toUpperCase();

    // 키워드 기반 태그 생성
    if (key.contains('MBTI') || key.contains('ENF') || key.contains('INT')) {
      tags.add('MBTI');
    }
    if (key.contains('BIG5')) tags.add('Big5');
    if (key.contains('VALUE') || key.contains('가치')) tags.add('가치관');
    if (key.contains('LOVE') || key.contains('연애')) tags.add('연애');
    if (key.contains('ACHIEVEMENT')) tags.add('성취');
    if (key.contains('POWER')) tags.add('영향력');

    return tags;
  }
}