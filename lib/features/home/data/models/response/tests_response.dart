// =============================================================
// 📁 lib/features/home/data/models/response/tests_response.dart
// =============================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'tests_response.freezed.dart';
part 'tests_response.g.dart';

/// 🧠 심리테스트 목록 응답 DTO (서버 API 매칭)
@freezed
class TestsResponse with _$TestsResponse {
  const factory TestsResponse({
    @JsonKey(name: 'tests') required List<TestSummaryDto> tests,
    @JsonKey(name: 'hasMore') required bool hasMore,
  }) = _TestsResponse;

  factory TestsResponse.fromJson(Map<String, dynamic> json) =>
      _$TestsResponseFromJson(json);
}

/// 🎯 개별 테스트 요약 정보 DTO
@freezed
class TestSummaryDto with _$TestSummaryDto {
  const factory TestSummaryDto({
    @JsonKey(name: 'testId') required int testId,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'subtitle') String? subtitle,
    @JsonKey(name: 'thumbnailUrl') String? thumbnailUrl,
    @JsonKey(name: 'viewCount') @Default(0) int viewCount,
  }) = _TestSummaryDto;

  factory TestSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$TestSummaryDtoFromJson(json);
}

// =============================================================
// 🔄 DTO → Domain Model 변환 확장 메서드
// =============================================================

extension TestsResponseExtension on TestsResponse {
  /// DTO를 UI에서 사용하는 TestRankingItem 리스트로 변환
  List<TestRankingItem> toTestRankingItems() {
    return tests.asMap().entries.map((entry) {
      final index = entry.key;
      final test = entry.value;

      return TestRankingItem(
        id: test.testId.toString(),
        title: test.title,
        subtitle: test.subtitle ?? '심리테스트',
        imagePath: _getImagePath(test.thumbnailUrl),
        participantCount: test.viewCount, // viewCount를 참여자 수로 사용
        popularityScore: _calculatePopularityScore(test.viewCount, index),
      );
    }).toList();
  }

  /// 썸네일 URL을 로컬 이미지 경로로 변환 (임시 로직)
  String _getImagePath(String? thumbnailUrl) {
    if (thumbnailUrl == null || thumbnailUrl.isEmpty) {
      return 'assets/images/default_test_card.png';
    }

    // URL인 경우 그대로 반환 (나중에 NetworkImage로 처리)
    if (thumbnailUrl.startsWith('http')) {
      return thumbnailUrl;
    }

    // 로컬 에셋 경로인 경우
    return thumbnailUrl;
  }

  /// 조회수 기반 인기도 점수 계산 (임시 로직)
  double _calculatePopularityScore(int viewCount, int index) {
    // 조회수 기반으로 점수 계산 (최대 100점)
    double baseScore = (viewCount / 1000).clamp(0, 100).toDouble();

    // 순서에 따른 보정 (상위권일수록 점수 증가)
    double rankBonus = (10 - index).clamp(0, 10).toDouble();

    return (baseScore + rankBonus).clamp(0, 100);
  }
}

extension TestSummaryDtoExtension on TestSummaryDto {
  /// 개별 테스트를 TestRankingItem으로 변환
  TestRankingItem toTestRankingItem({int rank = 0}) {
    return TestRankingItem(
      id: testId.toString(),
      title: title,
      subtitle: subtitle ?? '심리테스트',
      imagePath: _getImagePath(thumbnailUrl),
      participantCount: viewCount,
      popularityScore: _calculatePopularityScore(viewCount, rank),
    );
  }

  String _getImagePath(String? thumbnailUrl) {
    if (thumbnailUrl == null || thumbnailUrl.isEmpty) {
      return 'assets/images/default_test_card.png';
    }

    if (thumbnailUrl.startsWith('http')) {
      return thumbnailUrl;
    }

    return thumbnailUrl;
  }

  double _calculatePopularityScore(int viewCount, int rank) {
    double baseScore = (viewCount / 1000).clamp(0, 100).toDouble();
    double rankBonus = (10 - rank).clamp(0, 10).toDouble();
    return (baseScore + rankBonus).clamp(0, 100);
  }
}

// =============================================================
// 🎯 UI 모델 (기존 코드와 호환성 유지)
// =============================================================

/// 📊 테스트 랭킹 아이템 모델 (UI용)
class TestRankingItem {
  final String id;
  final String title;
  final String subtitle;
  final String imagePath;
  final int participantCount;
  final double popularityScore;

  const TestRankingItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.participantCount,
    required this.popularityScore,
  });

  @override
  String toString() {
    return 'TestRankingItem(id: $id, title: $title, participantCount: $participantCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TestRankingItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}