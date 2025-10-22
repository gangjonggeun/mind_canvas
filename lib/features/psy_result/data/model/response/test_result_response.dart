// lib/features/psytest/data/models/response/test_result_response.dart

import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../dto/result_detail.dart';

part 'test_result_response.freezed.dart';
part 'test_result_response.g.dart';

/// 🏆 심리 테스트 결과 응답 DTO (클라이언트)
///
/// 서버의 TestResultResponse와 정확히 일치하는 구조
///
/// **응답 예시:**
/// ```json
/// {
///   "resultKey": "ACHIEVEMENT_DOMINANT",
///   "resultTag": "성취 중심형",
///   "briefDescription": "개인적 성공과 탁월함을 추구하며...",
///   "backgroundColor": "DC2626",
///   "textColor": "FFFFFF",
///   "resultImageUrl": "https://...",
///   "dimensionScores": {
///     "achievement": 90,
///     "power": 65,
///     "self_direction": 70
///   },
///   "resultDetails": [...],
///   "subjectiveAnswer": "자유롭고 의미있는 삶",
///   "totalScore": 225
/// }
/// ```
@freezed
class TestResultResponse with _$TestResultResponse {
  const factory TestResultResponse({
    /// 🔑 결과 키 (고유 식별자)
    /// 예: "ENFP", "ACHIEVEMENT_DOMINANT", "SEVERE"
    @JsonKey(name: 'resultKey') required String resultKey,

    /// 🏷️ 결과 태그 (한글 표시명)
    /// 예: "성취 중심형", "정상 범위", "영향력 추구형"
    @JsonKey(name: 'resultTag') required String resultTag,

    /// 📝 간단한 설명 (한 줄 요약)
    @JsonKey(name: 'briefDescription') required String briefDescription,

    /// 🎨 배경색 (HEX, # 제외) - 예: "DC2626"
    @JsonKey(name: 'backgroundColor') required String backgroundColor,

    /// 🎨 텍스트 색상 (HEX, # 제외) - 예: "FFFFFF"
    @JsonKey(name: 'textColor') required String textColor,

    /// 🖼️ 결과 이미지 URL (선택사항)
    @JsonKey(name: 'resultImageUrl') String? resultImageUrl,

    /// 📊 차원별 점수
    /// 예: {"achievement": 90, "power": 65}
    @JsonKey(name: 'dimensionScores') Map<String, int>? dimensionScores,

    /// 📋 결과 상세 설명 목록
    @JsonKey(name: 'resultDetails') @Default([]) List<ResultDetail> resultDetails,

    /// ✍️ 주관식 답변 (있는 경우)
    @JsonKey(name: 'subjectiveAnswer') String? subjectiveAnswer,

    /// 🔢 총점 (선택사항)
    @JsonKey(name: 'totalScore') int? totalScore,
  }) = _TestResultResponse;

  /// 🏭 Factory: JSON → DTO
  factory TestResultResponse.fromJson(Map<String, dynamic> json) =>
      _$TestResultResponseFromJson(json);
}

/// 🔧 Extension: 유틸리티 메서드
extension TestResultResponseX on TestResultResponse {
  /// 차원별 점수 존재 여부
  bool get hasDimensionScores =>
      dimensionScores != null && dimensionScores!.isNotEmpty;

  /// 주관식 답변 존재 여부
  bool get hasSubjectiveAnswer =>
      subjectiveAnswer != null && subjectiveAnswer!.trim().isNotEmpty;

  /// 결과 이미지 존재 여부
  bool get hasResultImage =>
      resultImageUrl != null && resultImageUrl!.trim().isNotEmpty;

  /// 상세 설명 존재 여부
  bool get hasResultDetails => resultDetails.isNotEmpty;

  /// 총점 존재 여부
  bool get hasTotalScore => totalScore != null;

  /// 배경색 Color 객체로 변환 (Flutter Color)
  /// import 'package:flutter/material.dart';
  Color get backgroundColorValue {
    try {
      return Color(int.parse('FF$backgroundColor', radix: 16));
    } catch (e) {
      return const Color(0xFFDC2626); // 기본값: 빨강
    }
  }

  /// 텍스트 색상 Color 객체로 변환 (Flutter Color)
  Color get textColorValue {
    try {
      return Color(int.parse('FF$textColor', radix: 16));
    } catch (e) {
      return const Color(0xFFFFFFFF); // 기본값: 흰색
    }
  }

  /// 특정 차원의 점수 가져오기
  int? getDimensionScore(String dimensionKey) {
    return dimensionScores?[dimensionKey];
  }

  /// 차원별 점수를 리스트로 변환 (차트용)
  List<MapEntry<String, int>> get dimensionScoresList {
    if (!hasDimensionScores) return [];
    return dimensionScores!.entries.toList();
  }

  /// 정렬된 상세 설명 리스트 (order 기준)
  List<ResultDetail> get sortedResultDetails {
    final details = List<ResultDetail>.from(resultDetails);
    details.sort((a, b) {
      if (a.order == null && b.order == null) return 0;
      if (a.order == null) return 1;
      if (b.order == null) return -1;
      return a.order!.compareTo(b.order!);
    });
    return details;
  }

  /// 최고 점수 차원 찾기
  String? get highestDimension {
    if (!hasDimensionScores) return null;

    return dimensionScores!.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// 최고 점수 값
  int? get highestScore {
    if (!hasDimensionScores) return null;

    return dimensionScores!.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .value;
  }

  /// 평균 점수 계산
  double? get averageScore {
    if (!hasDimensionScores) return null;

    final total = dimensionScores!.values.reduce((a, b) => a + b);
    return total / dimensionScores!.length;
  }

  /// 디버깅용 문자열
  String get debugInfo {
    return 'TestResultResponse{'
        'resultKey: $resultKey, '
        'resultTag: $resultTag, '
        'dimensionCount: ${dimensionScores?.length ?? 0}, '
        'detailsCount: ${resultDetails.length}, '
        'hasImage: $hasResultImage, '
        'hasSubjective: $hasSubjectiveAnswer, '
        'totalScore: $totalScore'
        '}';
  }

  /// 공유용 텍스트 생성
  String toShareText() {
    final buffer = StringBuffer();
    buffer.writeln('🎯 $resultTag');
    buffer.writeln();
    buffer.writeln(briefDescription);

    if (hasDimensionScores) {
      buffer.writeln();
      buffer.writeln('📊 점수:');
      for (var entry in dimensionScoresList) {
        buffer.writeln('  ${entry.key}: ${entry.value}');
      }
    }

    if (hasSubjectiveAnswer) {
      buffer.writeln();
      buffer.writeln('✍️ 내 답변: $subjectiveAnswer');
    }

    return buffer.toString();
  }
}