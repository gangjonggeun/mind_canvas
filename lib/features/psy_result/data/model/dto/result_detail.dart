// lib/features/psytest/data/models/response/result_detail.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_detail.freezed.dart';
part 'result_detail.g.dart';

/// 📄 결과 상세 설명 항목 DTO (클라이언트)
///
/// 서버의 ResultDetail과 정확히 일치하는 구조
///
/// **예시:**
/// ```json
/// {
///   "imageUrl": null,
///   "title": "🏆 핵심 가치",
///   "content": "개인적 성취와 탁월함을 매우 중요하게 여깁니다...",
///   "order": 1
/// }
/// ```
@freezed
class ResultDetail with _$ResultDetail {
  const factory ResultDetail({
    /// 🖼️ 섹션 이미지 URL (선택사항)
    @JsonKey(name: 'imageUrl') String? imageUrl,

    /// 📌 제목 (예: "🏆 핵심 가치", "💪 장점과 강점")
    @JsonKey(name: 'title') required String title,

    /// 📝 내용 (해당 섹션의 상세 설명)
    @JsonKey(name: 'content') required String content,

    /// 🔢 표시 순서
    @JsonKey(name: 'order') int? order,
  }) = _ResultDetail;

  /// 🏭 Factory: JSON → DTO
  factory ResultDetail.fromJson(Map<String, dynamic> json) =>
      _$ResultDetailFromJson(json);
}

/// 🔧 Extension: 유틸리티 메서드
extension ResultDetailX on ResultDetail {
  /// 이미지가 있는지 확인
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// 내용이 비어있는지 확인
  bool get isEmpty => content.trim().isEmpty;

  /// 유효한 데이터인지 확인
  bool get isValid => title.isNotEmpty && content.isNotEmpty;
}