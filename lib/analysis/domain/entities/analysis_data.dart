/// 감정 상태 데이터
class EmotionState {
  final String name;
  final double percentage;
  final String color;
  final String emoji;

  const EmotionState({
    required this.name,
    required this.percentage,
    required this.color,
    required this.emoji,
  });
}

/// 성격 차원 점수 (5대 성격 특성)
class PersonalityDimension {
  final String name;
  final String shortName;
  final double score;
  final String description;
  final String color;
  final String icon;

  const PersonalityDimension({
    required this.name,
    required this.shortName,
    required this.score,
    required this.description,
    required this.color,
    required this.icon,
  });
}

/// MBTI 점수 데이터
class MbtiScore {
  final String dimension; // E/I, S/N, T/F, J/P
  final String leftType;
  final String rightType;
  final double score; // -100 ~ 100 (음수면 left, 양수면 right)
  final String description;

  const MbtiScore({
    required this.dimension,
    required this.leftType,
    required this.rightType,
    required this.score,
    required this.description,
  });

  /// 현재 성향 (왼쪽/오른쪽)
  String get currentType => score < 0 ? leftType : rightType;
  
  /// 절대값 퍼센테이지 (0-100)
  double get percentage => score.abs();
  
  /// 성향 강도 (약함/보통/강함)
  String get intensity {
    final abs = score.abs();
    if (abs < 30) return '약함';
    if (abs < 70) return '보통';
    return '강함';
  }
}

/// MBTI 8기능 데이터
class CognitiveFunction {
  final String name;
  final String shortName;
  final String description;
  final double strength; // 0-100
  final String color;
  final FunctionType type;

  const CognitiveFunction({
    required this.name,
    required this.shortName,
    required this.description,
    required this.strength,
    required this.color,
    required this.type,
  });
}

enum FunctionType {
  dominant('주기능'),
  auxiliary('부기능'),
  tertiary('3차기능'),
  inferior('열등기능');

  const FunctionType(this.displayName);
  final String displayName;
}

/// 에니어그램 데이터
class EnneagramType {
  final int number;
  final String name;
  final String description;
  final double score; // 0-100
  final String color;
  final String emoji;
  final List<String> keywords;

  const EnneagramType({
    required this.number,
    required this.name,
    required this.description,
    required this.score,
    required this.color,
    required this.emoji,
    required this.keywords,
  });
}

/// 맞춤 추천 컨텐츠
class RecommendedContent {
  final String id;
  final String title;
  final String type; // 영화, 드라마, 책, 음악 등
  final String imageUrl;
  final double matchPercentage;
  final String reason;
  final List<String> tags;

  const RecommendedContent({
    required this.id,
    required this.title,
    required this.type,
    required this.imageUrl,
    required this.matchPercentage,
    required this.reason,
    required this.tags,
  });
}

/// 성격 태그
class PersonalityTag {
  final String name;
  final String color;
  final double confidence; // 확신도 0-100

  const PersonalityTag({
    required this.name,
    required this.color,
    required this.confidence,
  });
}

/// 전체 분석 데이터
class AnalysisData {
  final String userId;
  final DateTime lastUpdated;
  final List<EmotionState> emotionStates;
  final List<PersonalityDimension> personalityDimensions;
  final List<MbtiScore> mbtiScores;
  final List<CognitiveFunction> cognitiveFunctions;
  final List<EnneagramType> enneagramTypes;
  final List<RecommendedContent> recommendedContents;
  final List<PersonalityTag> personalityTags;
  final String? mbtiType; // 최종 MBTI 결과
  final int? primaryEnneagram; // 주 에니어그램 타입

  const AnalysisData({
    required this.userId,
    required this.lastUpdated,
    required this.emotionStates,
    required this.personalityDimensions,
    required this.mbtiScores,
    required this.cognitiveFunctions,
    required this.enneagramTypes,
    required this.recommendedContents,
    required this.personalityTags,
    this.mbtiType,
    this.primaryEnneagram,
  });

  /// 전체 분석 완성도 (0-100)
  double get completionPercentage {
    double total = 0;
    int count = 0;

    if (emotionStates.isNotEmpty) { total += 20; count++; }
    if (personalityDimensions.isNotEmpty) { total += 20; count++; }
    if (mbtiScores.isNotEmpty) { total += 20; count++; }
    if (cognitiveFunctions.isNotEmpty) { total += 20; count++; }
    if (enneagramTypes.isNotEmpty) { total += 20; count++; }

    return count > 0 ? total : 0;
  }

  /// 분석 정확도 평균
  double get averageAccuracy {
    final accuracies = <double>[];
    
    for (final tag in personalityTags) {
      accuracies.add(tag.confidence);
    }
    
    if (accuracies.isEmpty) return 0;
    return accuracies.reduce((a, b) => a + b) / accuracies.length;
  }
}
