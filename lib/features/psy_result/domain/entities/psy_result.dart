// lib/features/psytest/domain/entities/psy_result.dart

import 'package:flutter/material.dart';

/// 🏆 심리테스트 결과 엔티티 (단순화)
class PsyResult {
  // 🔑 기본 정보
  final String id;
  final String title;           // resultTag
  final String subtitle;        // briefDescription (빈값 가능)
  final String description;     // 첫 번째 섹션 내용 (사용 안함)

  // 🎨 색상
  final String backgroundColor;

  // 📋 섹션 (메인 콘텐츠!)
  final List<PsyResultSection> sections;

  // 🎯 메타 정보
  final PsyResultType type;
  final DateTime createdAt;
  final List<String> tags;

  // 사용 안하는 필드들
  final String? imageUrl;
  final Map<String, int>? dimensionScores;
  final String? subjectiveAnswer;
  final int? totalScore;

  PsyResult({
    required this.id,
    required this.title,
    this.subtitle = '', // ✅ 기본값
    this.description = '', // ✅ 기본값
    required this.backgroundColor,
    required this.sections,
    required this.type,
    required this.createdAt,
    required this.tags,
    this.imageUrl,
    this.dimensionScores,
    this.subjectiveAnswer,
    this.totalScore,
  });

  // 🎨 색상 변환
  Color get mainColor {
    try {
      return Color(int.parse('FF$backgroundColor', radix: 16));
    } catch (e) {
      return const Color(0xFF10B981);
    }
  }

  // 🎨 그라데이션용 시작 색상
  String get bgGradientStart => backgroundColor;

  // 🎨 그라데이션용 끝 색상 (약간 어둡게)
  String get bgGradientEnd {
    try {
      final color = mainColor;
      final hsl = HSLColor.fromColor(color);
      final darkerHsl = hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0));
      final darkerColor = darkerHsl.toColor();

      return darkerColor.value
          .toRadixString(16)
          .substring(2) // FF 제거
          .toUpperCase();
    } catch (e) {
      return backgroundColor; // 실패 시 같은 색
    }
  }

  // 🎨 텍스트 색상 (배경 밝기에 따라 자동)
  Color get textColor {
    // 배경이 밝으면 검은색, 어두우면 흰색
    return mainColor.computeLuminance() > 0.5
        ? const Color(0xFF2D3748) // 검은색
        : Colors.white;           // 흰색
  }

  // 🎨 아이콘
  String get iconEmoji => _getIconForType(type);

  static String _getIconForType(PsyResultType type) {
    switch (type) {
      case PsyResultType.personality:
        return '🎭';
      case PsyResultType.career:
        return '💼';
      case PsyResultType.relationship:
        return '💕';
      case PsyResultType.value:
        return '🎯';
      case PsyResultType.cognitive:
        return '🧠';
      default:
        return '✨';
    }
  }


  // 1️⃣ 한글 변환 사전 (통합 관리)
  static const Map<String, String> _KorLabelDictionary = {
    // 공통/일반
    'energyScore': '에너지(E)',
    'decisionScore': '결정성(F)',
    'lifestyleScore': '생활성(P)',
    'informationScore': '정보수집(N)',

    'resilience': '회복탄력성',
    'stress': '스트레스',

    // MBTI 관련
    'E': '외향형', 'I': '내향형',
    'S': '감각형', 'N': '직관형',
    'T': '사고형', 'F': '감정형',
    'J': '판단형', 'P': '인식형',

    // HTP / 심리 관련
    'house': '가정운', 'tree': '무의식', 'person': '대인관계',
    'aggression': '공격성', 'anxiety': '불안감', 'depressive': '우울감',

    // 직업/가치관
    'achievement': '성취', 'autonomy': '자율', 'creativity': '창의',
  };

  // 2️⃣ 번역된 점수 Getter (UI에서는 이걸 쓰세요!)
  Map<String, int> get translatedScores {
    if (dimensionScores == null) return {};

    return dimensionScores!.map((key, value) {
      // 사전에 있으면 한글로, 없으면 영어 그대로
      final newKey = _KorLabelDictionary[key] ?? key;
      return MapEntry(newKey, value);
    });
  }

  // ⏱️ 예상 읽기 시간 (섹션당 1분)
  int get estimatedReadingTime => sections.length + 2;

  // Getters
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  bool get hasDimensionScores => dimensionScores != null && dimensionScores!.isNotEmpty;
  bool get hasSubjectiveAnswer => subjectiveAnswer != null && subjectiveAnswer!.isNotEmpty;
}

/// 📋 결과 섹션
class PsyResultSection {
  final String title;
  final String content;
  final String? imageUrl;
  final List<String> highlights;

  PsyResultSection({
    required this.title,
    required this.content,
    this.imageUrl,
    this.highlights = const [], // ✅ 기본값
  });

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  String get iconEmoji {
    // 제목 기반 이모지
    if (title.contains('핵심') || title.contains('특징')) return '🎯';
    if (title.contains('강점') || title.contains('장점')) return '💪';
    if (title.contains('주의') || title.contains('약점')) return '⚠️';
    if (title.contains('성장') || title.contains('발전')) return '🌱';
    if (title.contains('직업') || title.contains('진로')) return '💼';
    if (title.contains('관계') || title.contains('소통')) return '🤝';
    return '📝';
  }
}

/// 🎭 결과 타입
enum PsyResultType {
  personality,   // 성격
  career,        // 진로/직업
  relationship,  // 관계/연애
  value,         // 가치관
  cognitive,     // 인지/ADHD
  projective,
  other;         // 기타

  // ✅ displayName 추가
  String get displayName {
    switch (this) {
      case PsyResultType.personality:
        return '성격 유형';
      case PsyResultType.career:
        return '진로 분석';
      case PsyResultType.relationship:
        return '관계 분석';
      case PsyResultType.value:
        return '가치관 탐색';
      case PsyResultType.cognitive:
        return '인지 분석';
      case PsyResultType.projective:
        return '심리 분석';
      case PsyResultType.other:
        return '심리 분석';
    }
  }

  static PsyResultType fromResultKey(String key) {
    final upperKey = key.toUpperCase();

    if (upperKey.contains('MBTI') || upperKey.contains('ENF') ||
        upperKey.contains('INT') || upperKey.contains('PERSONALITY')) {
      return PsyResultType.personality;
    }
    if (upperKey.contains('CAREER') || upperKey.contains('HOLLAND')) {
      return PsyResultType.career;
    }
    if (upperKey.contains('LOVE') || upperKey.contains('RELATIONSHIP')) {
      return PsyResultType.relationship;
    }
    if (upperKey.contains('VALUE') || upperKey.contains('가치')) {
      return PsyResultType.value;
    }
    if (upperKey.contains('ADHD') || upperKey.contains('COGNITIVE')) {
      return PsyResultType.cognitive;
    }
    if (upperKey.contains('HTP')) return PsyResultType.projective;

    return PsyResultType.other;
  }
}