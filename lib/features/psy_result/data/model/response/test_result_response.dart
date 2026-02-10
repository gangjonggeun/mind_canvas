// lib/features/psytest/data/models/response/test_result_response.dart

import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../dto/result_detail.dart';

part 'test_result_response.freezed.dart';
part 'test_result_response.g.dart';

/// 🏆 심리 테스트 결과 응답 DTO (단순화)
@freezed
class TestResultResponse with _$TestResultResponse {
  const factory TestResultResponse({
    /// 🔑 결과 키
    @JsonKey(name: 'resultKey') @Default('AI_RESULT')  String resultKey,

    /// 🏷️ 결과 태그 (제목)
    @JsonKey(name: 'resultTag') required String resultTag,

    /// 📝 간단한 설명
    @JsonKey(name: 'briefDescription') required String briefDescription,

    /// 🎨 배경색 (HEX, # 제외)
    @JsonKey(name: 'backgroundColor')  @Default('FFFFFF')  String backgroundColor,

    /// 📊 차원별 점수 (서버에서 계산된 백분율)
    /// 예: {"E": 66, "I": 33, "S": 45, "N": 55, ...}
    @JsonKey(name: 'dimensionScores') Map<String, int>? dimensionScores,

    /// 📋 결과 상세 설명 목록 (해석 포함)
    @JsonKey(name: 'resultDetails') @Default([]) List<ResultDetail> resultDetails,

  }) = _TestResultResponse;

  factory TestResultResponse.fromJson(Map<String, dynamic> json) =>
      _$TestResultResponseFromJson(json);
}

/// 🔧 Extension (단순화)
extension TestResultResponseX on TestResultResponse {
  /// 차원별 점수 존재 여부
  bool get hasDimensionScores =>
      dimensionScores != null && dimensionScores!.isNotEmpty;

  /// 상세 설명 존재 여부
  bool get hasResultDetails => resultDetails.isNotEmpty;

  /// 배경색 Color 객체로 변환
  Color get backgroundColorValue {
    try {
      return Color(int.parse('FF$backgroundColor', radix: 16));
    } catch (e) {
      return const Color(0xFFDC2626);
    }
  }

  /// 정렬된 상세 설명 리스트
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

  /// 디버깅용 문자열
  String get debugInfo {
    return 'TestResultResponse{'
        'resultKey: $resultKey, '
        'resultTag: $resultTag, '
        'dimensionCount: ${dimensionScores?.length ?? 0}, '
        'detailsCount: ${resultDetails.length}'
        '}';
  }
}