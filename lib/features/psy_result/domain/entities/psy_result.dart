/// 확장된 심리테스트 결과 엔티티
/// 서버에서 layoutType 값으로 레이아웃 결정
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

  // ✅ 새로 추가: 이미지 및 레이아웃 정보
  final List<PsyResultImage> images;        // 결과 관련 이미지들
  final int layoutType;                     // 0: 텍스트중심, 1: 이미지중심, 2: 하이브리드
  final Map<String, dynamic>? rawData;      // HTP 등의 원본 데이터

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
    this.images = const [],           // ✅ 기본값: 빈 리스트 (기존 호환성)
    this.layoutType = 0,              // ✅ 기본값: 텍스트 중심
    this.rawData,
  });

  /// 이미지가 있는 결과인지 확인
  bool get hasImages => images.isNotEmpty;

  /// HTP 테스트 결과인지 확인
  bool get isHtpResult => type == PsyResultType.drawing && rawData != null;

  /// MBTI 테스트 결과인지 확인
  bool get isMbtiResult => type == PsyResultType.mbti;

  /// 결과 길이 기준으로 레이아웃 타입 결정 (기존 로직 유지)
  bool get isLongResult => _calculateTotalLength() > 1000;

  /// 읽기 예상 시간 계산 (분) - 이미지 고려
  int get estimatedReadingTime {
    final textLength = _calculateTotalLength();
    final imageCount = images.length;

    // 텍스트: 분당 200자, 이미지: 개당 30초 추가
    final textTime = (textLength / 200).ceil();
    final imageTime = (imageCount * 0.5).ceil(); // 30초 = 0.5분

    return textTime + imageTime;
  }

  int _calculateTotalLength() {
    return description.length +
        sections.fold(0, (sum, section) => sum + section.content.length);
  }

  /// 북마크 상태 토글 (기존 메서드 확장)
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
    List<PsyResultImage>? images,    // ✅ 새로 추가
    int? layoutType,                 // ✅ 새로 추가
    Map<String, dynamic>? rawData,   // ✅ 새로 추가
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
      images: images ?? this.images,         // ✅ 새로 추가
      layoutType: layoutType ?? this.layoutType, // ✅ 새로 추가
      rawData: rawData ?? this.rawData,     // ✅ 새로 추가
    );
  }
}

/// 심리테스트 결과 타입 (HTP 추가)
enum PsyResultType {
  personality('성격분석'),
  love('연애성향'),
  career('적성검사'),
  stress('스트레스'),
  mbti('MBTI'),
  color('컬러테라피'),
  drawing('그림검사'); // ✅ HTP 등 그림 기반 테스트

  const PsyResultType(this.displayName);
  final String displayName;
}

/// 이미지 데이터 클래스
class PsyResultImage {
  final String id;
  final String url;           // 로컬 또는 원격 URL
  final String? localPath;    // 로컬 캐시 경로
  final PsyImageType type;    // 이미지 타입
  final String? caption;      // 이미지 설명
  final Map<String, dynamic>? metadata; // 추가 메타데이터

  const PsyResultImage({
    required this.id,
    required this.url,
    this.localPath,
    required this.type,
    this.caption,
    this.metadata,
  });

  /// 로컬 이미지 우선 사용
  String get effectiveUrl => localPath ?? url;

  /// 메모리 효율적인 이미지인지 확인
  bool get isOptimized => localPath != null;

  PsyResultImage copyWith({
    String? id,
    String? url,
    String? localPath,
    PsyImageType? type,
    String? caption,
    Map<String, dynamic>? metadata,
  }) {
    return PsyResultImage(
      id: id ?? this.id,
      url: url ?? this.url,
      localPath: localPath ?? this.localPath,
      type: type ?? this.type,
      caption: caption ?? this.caption,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// 이미지 타입
enum PsyImageType {
  hero('대표 이미지'),           // 메인 결과 이미지
  section('섹션 이미지'),        // 섹션별 설명 이미지
  drawing('사용자 그림'),        // HTP 등 사용자가 그린 그림
  chart('차트/그래프'),         // 분석 결과 차트
  avatar('아바타/캐릭터'),      // MBTI 캐릭터 등
  background('배경 이미지');     // 분위기 연출용

  const PsyImageType(this.displayName);
  final String displayName;
}

/// 결과 섹션 (이미지 지원 추가)
class PsyResultSection {
  final String title;
  final String content;
  final String iconEmoji;
  final List<String> highlights;
  final List<PsyResultImage> sectionImages; // ✅ 새로 추가: 섹션별 이미지

  const PsyResultSection({
    required this.title,
    required this.content,
    required this.iconEmoji,
    this.highlights = const [],
    this.sectionImages = const [], // ✅ 기본값으로 호환성 유지
  });

  PsyResultSection copyWith({
    String? title,
    String? content,
    String? iconEmoji,
    List<String>? highlights,
    List<PsyResultImage>? sectionImages, // ✅ 새로 추가
  }) {
    return PsyResultSection(
      title: title ?? this.title,
      content: content ?? this.content,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      highlights: highlights ?? this.highlights,
      sectionImages: sectionImages ?? this.sectionImages, // ✅ 새로 추가
    );
  }
}

// ===== 팩토리 메서드들 =====

/// HTP 결과 생성 팩토리
class PsyResultFactory {
  /// HTP 세션으로부터 결과 생성
  static PsyResult createHtpResult({
    required String sessionId,
    required String userId,
    required Map<String, dynamic> htpAnalysisData,
    required List<String> drawingImageUrls, // [house, tree, person] 순서
    required String analysisResult,
    required List<PsyResultSection> detailedSections,
  }) {
    // HTP 그림들을 PsyResultImage로 변환
    final drawingImages = drawingImageUrls.asMap().entries.map((entry) {
      final index = entry.key;
      final url = entry.value;
      final captions = ['집 그림', '나무 그림', '사람 그림'];

      return PsyResultImage(
        id: 'htp_drawing_$index',
        url: url,
        type: PsyImageType.drawing,
        caption: captions[index],
        metadata: {
          'drawingOrder': index,
          'htpType': ['house', 'tree', 'person'][index],
        },
      );
    }).toList();

    return PsyResult(
      id: sessionId,
      title: 'HTP 그림 심리검사 결과',
      subtitle: '집-나무-사람 그림을 통한 심층 분석',
      description: analysisResult,
      type: PsyResultType.drawing,
      mainColor: 'FF6B73E6',
      bgGradientStart: 'FFF8F9FF',
      bgGradientEnd: 'FFE8EAFF',
      iconEmoji: '🎨',
      sections: detailedSections,
      createdAt: DateTime.now(),
      images: drawingImages,
      layoutType: 1, // ✅ 이미지 중심
      rawData: htpAnalysisData,
      tags: ['그림검사', 'HTP', '심층분석'],
    );
  }

  /// MBTI 결과 생성 팩토리
  static PsyResult createMbtiResult({
    required String mbtiType, // 'ENFP' 등
    required String analysisResult,
    required List<PsyResultSection> sections,
    required List<String> characterImageUrls, // MBTI 캐릭터 이미지들
    bool isLongResult = false, // 텍스트 길이에 따른 판단
  }) {
    // MBTI 캐릭터 이미지들
    final characterImages = characterImageUrls.asMap().entries.map((entry) {
      return PsyResultImage(
        id: 'mbti_character_${entry.key}',
        url: entry.value,
        type: PsyImageType.avatar,
        caption: '$mbtiType 유형 캐릭터',
        metadata: {'mbtiType': mbtiType},
      );
    }).toList();

    return PsyResult(
      id: 'mbti_${DateTime.now().millisecondsSinceEpoch}',
      title: '$mbtiType 성격유형',
      subtitle: 'MBTI 성격 검사 결과',
      description: analysisResult,
      type: PsyResultType.mbti,
      mainColor: _getMbtiColor(mbtiType),
      bgGradientStart: 'FFF8F9FF',
      bgGradientEnd: 'FFE8EAFF',
      iconEmoji: _getMbtiEmoji(mbtiType),
      sections: sections,
      createdAt: DateTime.now(),
      images: characterImages,
      layoutType: 2, // ✅ 하이브리드
      tags: ['MBTI', mbtiType, '성격유형'],
    );
  }

  /// 일반 텍스트 결과 생성 (기존 호환성)
  static PsyResult createTextResult({
    required String id,
    required String title,
    required String subtitle,
    required String description,
    required PsyResultType type,
    required String mainColor,
    required String bgGradientStart,
    required String bgGradientEnd,
    required String iconEmoji,
    required List<PsyResultSection> sections,
    List<String> tags = const [],
  }) {
    return PsyResult(
      id: id,
      title: title,
      subtitle: subtitle,
      description: description,
      type: type,
      mainColor: mainColor,
      bgGradientStart: bgGradientStart,
      bgGradientEnd: bgGradientEnd,
      iconEmoji: iconEmoji,
      sections: sections,
      createdAt: DateTime.now(),
      layoutType: 0, // ✅ 텍스트 중심 (기존 방식)
      tags: tags,
    );
  }

  /// MBTI 타입별 색상 매핑
  static String _getMbtiColor(String type) {
    final colors = {
      'ENFP': 'FFFF6B9D', 'ENFJ': 'FF56CCF2', 'ENTP': 'FFFFA726', 'ENTJ': 'FF8E24AA',
      'ESFP': 'FFFF7043', 'ESFJ': 'FF66BB6A', 'ESTP': 'FFFF8A65', 'ESTJ': 'FF42A5F5',
      'INFP': 'FFAB47BC', 'INFJ': 'FF7E57C2', 'INTP': 'FF26A69A', 'INTJ': 'FF5C6BC0',
      'ISFP': 'FFEC407A', 'ISFJ': 'FF29B6F6', 'ISTP': 'FF78909C', 'ISTJ': 'FF8D6E63',
    };
    return colors[type] ?? 'FF6B73E6';
  }

  /// MBTI 타입별 이모지 매핑
  static String _getMbtiEmoji(String type) {
    final emojis = {
      'ENFP': '🌟', 'ENFJ': '🌱', 'ENTP': '💡', 'ENTJ': '👑',
      'ESFP': '🎉', 'ESFJ': '🤗', 'ESTP': '⚡', 'ESTJ': '🎯',
      'INFP': '🦋', 'INFJ': '🔮', 'INTP': '🧠', 'INTJ': '🏰',
      'ISFP': '🎨', 'ISFJ': '🛡️', 'ISTP': '🔧', 'ISTJ': '📋',
    };
    return emojis[type] ?? '✨';
  }
}