import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_request.freezed.dart';
part 'report_request.g.dart';

@freezed
class ReportRequest with _$ReportRequest {
  const factory ReportRequest({
    required int targetId,      // 신고할 글 또는 댓글 ID
    required String targetType, // "POST" or "COMMENT"
    required String reason,     // "SPAM", "ABUSE" 등
  }) = _ReportRequest;

  factory ReportRequest.fromJson(Map<String, dynamic> json) =>
      _$ReportRequestFromJson(json);
}