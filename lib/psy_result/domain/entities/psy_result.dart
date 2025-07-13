/// 심리테스트 결과 엔티티
/// 메모리 효율성을 위해 불변 객체로 설계
class PsyResult {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final PsyResultType type;
  final String mainColor;
  final String bgGradientStart;
  final String bgGradientEnd;
  final String iconEmoji;
  final List<PsyResultSection> sections;
  final DateTime createdAt;
  final bool isBookmarked;
  final List<String> tags;

  const PsyResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.type,
    required this.mainColor,
    required this.bgGradientStart,
    required this.bgGradientEnd,
    required this.iconEmoji,
    required this.sections,
    required this.createdAt,
    this.isBookmarked = false,
    this.tags = const [],
  });

  /// 결과 길이 기준으로 레이아웃 타입 결정
  /// 메모리 효율성을 위한 lazy 계산
  bool get isLongResult => _calculateTotalLength() > 1000;

  /// 읽기 예상 시간 계산 (분)
  int get estimatedReadingTime {
    final totalLength = _calculateTotalLength();
    return (totalLength / 200).ceil(); // 분당 200자 기준
  }

  int _calculateTotalLength() {
    return description.length + 
           sections.fold(0, (sum, section) => sum + section.content.length);
  }

  /// 북마크 상태 토글
  PsyResult copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    PsyResultType? type,
    String? mainColor,
    String? bgGradientStart,
    String? bgGradientEnd,
    String? iconEmoji,
    List<PsyResultSection>? sections,
    DateTime? createdAt,
    bool? isBookmarked,
    List<String>? tags,
  }) {
    return PsyResult(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      type: type ?? this.type,
      mainColor: mainColor ?? this.mainColor,
      bgGradientStart: bgGradientStart ?? this.bgGradientStart,
      bgGradientEnd: bgGradientEnd ?? this.bgGradientEnd,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      sections: sections ?? this.sections,
      createdAt: createdAt ?? this.createdAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      tags: tags ?? this.tags,
    );
  }
}

/// 심리테스트 결과 타입
enum PsyResultType {
  personality('성격분석'),
  love('연애성향'),
  career('적성검사'),
  stress('스트레스'),
  mbti('MBTI'),
  color('컬러테라피'),
  drawing('그림검사');

  const PsyResultType(this.displayName);
  final String displayName;
}

/// 결과 섹션 (긴 결과용)
class PsyResultSection {
  final String title;
  final String content;
  final String iconEmoji;
  final List<String> highlights;

  const PsyResultSection({
    required this.title,
    required this.content,
    required this.iconEmoji,
    this.highlights = const [],
  });

  PsyResultSection copyWith({
    String? title,
    String? content,
    String? iconEmoji,
    List<String>? highlights,
  }) {
    return PsyResultSection(
      title: title ?? this.title,
      content: content ?? this.content,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      highlights: highlights ?? this.highlights,
    );
  }
}
