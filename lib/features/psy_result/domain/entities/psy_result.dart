// lib/features/psytest/domain/entities/psy_result.dart

import 'package:flutter/material.dart';

/// 🏆 심리테스트 결과 엔티티 (단순화 버전)
class PsyResult {
  // 📋 서버에서 받는 필수 필드만
  final String id;                    // resultKey
  final String title;                 // resultTag
  final String subtitle;              // briefDescription
  final String description;           // 첫 섹션 내용
  final String backgroundColor;       // ✅ 하나만! (HEX)
  final List<PsyResultSection> sections; // resultDetails 변환

  // 📊 서버 응답 (선택적)
  final String? imageUrl;
  final Map<String, int>? dimensionScores;
  final String? subjectiveAnswer;
  final int? totalScore;

  // 🎯 메타 정보
  final PsyResultType type;           // 자동 추론
  final DateTime createdAt;
  final bool isBookmarked;
  final List<String> tags;

  const PsyResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.backgroundColor,
    required this.sections,
    this.imageUrl,
    this.dimensionScores,
    this.subjectiveAnswer,
    this.totalScore,
    required this.type,
    required this.createdAt,
    this.isBookmarked = false,
    this.tags = const [],
  });

  // =============================================================
  // ✨ 자동 계산되는 필드들 (Getter)
  // =============================================================

  /// 🎨 메인 컬러 (Color 객체)
  Color get mainColor {
    try {
      return Color(int.parse('FF$backgroundColor', radix: 16));
    } catch (e) {
      return const Color(0xFF6B73E6);
    }
  }

  /// 🎨 그라데이션 시작 (원본 색상)
  String get bgGradientStart => backgroundColor;

  /// 🎨 그라데이션 끝 (25% 어둡게)
  String get bgGradientEnd => _darkenColor(backgroundColor, 0.25);

  /// 🎨 텍스트 색상 (배경 밝기 기반 자동 계산)
  String get textColor {
    final color = mainColor;
    final luminance = color.computeLuminance();
    // 밝은 배경 → 검정 텍스트, 어두운 배경 → 흰색 텍스트
    return luminance > 0.5 ? '000000' : 'FFFFFF';
  }

  /// 🎭 아이콘 이모지 (title에서 추출)
  String get iconEmoji {
    final emoji = _extractEmoji(title);
    return emoji ?? '✨'; // 기본값
  }

  // =============================================================
  // 🔧 기존 호환성 유지
  // =============================================================

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  bool get hasDimensionScores =>
      dimensionScores != null && dimensionScores!.isNotEmpty;
  bool get hasSubjectiveAnswer =>
      subjectiveAnswer != null && subjectiveAnswer!.isNotEmpty;
  bool get hasTotalScore => totalScore != null;

  int get estimatedReadingTime {
    final textLength = description.length +
        sections.fold(0, (sum, section) => sum + section.content.length);
    return (textLength / 200).ceil();
  }

  // =============================================================
  // 🛠️ 헬퍼 메서드 (private)
  // =============================================================

  /// 색상 어둡게 만들기
  static String _darkenColor(String hexColor, double amount) {
    try {
      final colorValue = int.parse(hexColor, radix: 16);

      final r = (colorValue >> 16) & 0xFF;
      final g = (colorValue >> 8) & 0xFF;
      final b = colorValue & 0xFF;

      final newR = (r * (1 - amount)).round().clamp(0, 255);
      final newG = (g * (1 - amount)).round().clamp(0, 255);
      final newB = (b * (1 - amount)).round().clamp(0, 255);

      final newColor = (newR << 16) | (newG << 8) | newB;
      return newColor.toRadixString(16).padLeft(6, '0').toUpperCase();
    } catch (e) {
      return hexColor;
    }
  }

  /// 문자열에서 이모지 추출
  static String? _extractEmoji(String text) {
    final emojiRegex = RegExp(
      r'[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]',
      unicode: true,
    );
    final match = emojiRegex.firstMatch(text);
    return match?.group(0);
  }

  // =============================================================
  // 📝 CopyWith
  // =============================================================

  PsyResult copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? backgroundColor,
    List<PsyResultSection>? sections,
    String? imageUrl,
    Map<String, int>? dimensionScores,
    String? subjectiveAnswer,
    int? totalScore,
    PsyResultType? type,
    DateTime? createdAt,
    bool? isBookmarked,
    List<String>? tags,
  }) {
    return PsyResult(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      sections: sections ?? this.sections,
      imageUrl: imageUrl ?? this.imageUrl,
      dimensionScores: dimensionScores ?? this.dimensionScores,
      subjectiveAnswer: subjectiveAnswer ?? this.subjectiveAnswer,
      totalScore: totalScore ?? this.totalScore,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      tags: tags ?? this.tags,
    );
  }
}

/// 심리테스트 결과 타입
enum PsyResultType {
  personality('성격분석'),
  value('가치관'),
  cognitive('인지능력'),
  psychological('심리평가'),
  mbti('MBTI'),
  bigFive('Big5'),
  love('연애성향'); // ✅ 추가

  const PsyResultType(this.displayName);
  final String displayName;

  static PsyResultType fromResultKey(String resultKey) {
    final key = resultKey.toUpperCase();

    if (key.contains('ENFP') || key.contains('INTJ') || key.contains('MBTI')) {
      return PsyResultType.mbti;
    } else if (key.contains('OPENNESS') || key.contains('BIG5')) {
      return PsyResultType.bigFive;
    } else if (key.contains('VALUE') || key.contains('ACHIEVEMENT')) {
      return PsyResultType.value;
    } else if (key.contains('ATTENTION') || key.contains('COGNITIVE')) {
      return PsyResultType.cognitive;
    } else if (key.contains('LOVE') || key.contains('ROMANCE')) {
      return PsyResultType.love;
    } else {
      return PsyResultType.personality;
    }
  }
}

/// 결과 섹션
class PsyResultSection {
  final String title;
  final String content;
  final List<String> highlights;
  final String? imageUrl;

  const PsyResultSection({
    required this.title,
    required this.content,
    this.highlights = const [],
    this.imageUrl,
  });

  /// 🎭 섹션 아이콘 이모지 (title에서 추출)
  String get iconEmoji {
    final emoji = _extractEmoji(title);
    return emoji ?? '📌';
  }

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  static String? _extractEmoji(String text) {
    final emojiRegex = RegExp(
      r'[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]',
      unicode: true,
    );
    final match = emojiRegex.firstMatch(text);
    return match?.group(0);
  }

  PsyResultSection copyWith({
    String? title,
    String? content,
    List<String>? highlights,
    String? imageUrl,
  }) {
    return PsyResultSection(
      title: title ?? this.title,
      content: content ?? this.content,
      highlights: highlights ?? this.highlights,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}