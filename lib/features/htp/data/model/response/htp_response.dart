// // =============================================================
// // 📁 data/models/response/htp_response.dart
// // =============================================================
//
// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'htp_response.freezed.dart';
// part 'htp_response.g.dart';
//
// /// 🎨 HTP 분석 결과 응답 DTO
// ///
// /// <p><strong>Gemini AI 분석 결과:</strong></p>
// /// - 결과 태그 (예: "창의적 성향", "내향적 성격" 등)
// /// - 간단한 요약 설명
// /// - 상세 분석 내용 리스트
// ///
// /// <p><strong>응답 예시:</strong></p>
// /// ```json
// /// {
// ///   "resultTag": "창의적이고 감성적인 성향",
// ///   "briefDescription": "그림에서 풍부한 상상력과 섬세한 감성이 드러납니다.",
// ///   "resultDetails": [
// ///     {
// ///       "imageUrl": "https://example.com/house_analysis.png",
// ///       "title": "집 그림 분석",
// ///       "content": "창문과 문이 크게 그려져 개방적인 성격을 나타냅니다...",
// ///       "order": 1
// ///     },
// ///     {
// ///       "title": "나무 그림 분석",
// ///       "content": "뿌리가 튼튼하게 그려져 안정감을 추구하는 모습입니다...",
// ///       "order": 2
// ///     }
// ///   ]
// /// }
// /// ```
// @freezed
// class HtpResponse with _$HtpResponse {
//   const factory HtpResponse({
//
//     @JsonKey(name: 'resultKey') String? resultKey,
//     /// 결과 태그 (한 줄 요약)
//     /// 예: "창의적 성향", "안정 추구형", "사회적 성향"
//     @JsonKey(name: 'resultTag') required String resultTag,
//
//     /// 간단한 설명 (2-3줄 요약)
//     @JsonKey(name: 'briefDescription') required String briefDescription,
//
//     /// 상세 분석 내용 리스트
//     @JsonKey(name: 'resultDetails') required List<HtpResultDetail> resultDetails,
//   }) = _HtpResponse;
//
//   factory HtpResponse.fromJson(Map<String, dynamic> json) =>
//       _$HtpResponseFromJson(json);
// }
//
// /// 📊 HTP 분석 상세 내용
// ///
// /// <p><strong>분석 항목:</strong></p>
// /// - 각 그림별 분석 (집/나무/사람)
// /// - 종합 심리 해석
// /// - 성격 특성 및 현재 심리 상태
// ///
// /// <p><strong>order 필드:</strong></p>
// /// - 표시 순서 (1, 2, 3...)
// /// - null이면 순서 상관없음
// @freezed
// class HtpResultDetail with _$HtpResultDetail {
//   const factory HtpResultDetail({
//     /// 이미지 URL (선택사항)
//     /// 분석 관련 참고 이미지 (차트, 다이어그램 등)
//     @JsonKey(name: 'imageUrl') String? imageUrl,
//
//     /// 분석 제목
//     /// 예: "집 그림 분석", "전체 심리 해석", "성격 특성"
//     @JsonKey(name: 'title') required String title,
//
//     /// 분석 내용 (본문)
//     /// 상세한 심리 분석 내용
//     @JsonKey(name: 'content') required String content,
//
//     /// 표시 순서 (선택사항)
//     /// 1부터 시작, null이면 순서 상관없음
//     @JsonKey(name: 'order') int? order,
//   }) = _HtpResultDetail;
//
//   factory HtpResultDetail.fromJson(Map<String, dynamic> json) =>
//       _$HtpResultDetailFromJson(json);
// }
//
// // =============================================================
// // 🛠️ Extension: 편의 메서드
// // =============================================================
//
// extension HtpResponseExtension on HtpResponse {
//   /// 분석 결과가 비어있는지 확인
//   bool get isEmpty => resultDetails.isEmpty;
//
//   /// 분석 결과가 있는지 확인
//   bool get isNotEmpty => resultDetails.isNotEmpty;
//
//   /// 순서대로 정렬된 결과 반환
//   List<HtpResultDetail> get sortedDetails {
//     final list = List<HtpResultDetail>.from(resultDetails);
//     list.sort((a, b) {
//       if (a.order == null && b.order == null) return 0;
//       if (a.order == null) return 1;
//       if (b.order == null) return -1;
//       return a.order!.compareTo(b.order!);
//     });
//     return list;
//   }
//
//   /// 이미지가 있는 결과만 필터링
//   List<HtpResultDetail> get detailsWithImages {
//     return resultDetails.where((detail) => detail.imageUrl != null).toList();
//   }
//
//   /// 총 분석 항목 수
//   int get totalDetailsCount => resultDetails.length;
// }
//
// extension HtpResultDetailExtension on HtpResultDetail {
//   /// 이미지 존재 여부
//   bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
//
//   /// 순서가 지정되어 있는지 확인
//   bool get hasOrder => order != null;
//
//   /// 내용 길이 (글자 수)
//   int get contentLength => content.length;
//
//   /// 긴 내용인지 확인 (500자 이상)
//   bool get isLongContent => contentLength > 500;
// }