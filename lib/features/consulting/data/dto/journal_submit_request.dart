import 'package:json_annotation/json_annotation.dart';

part 'journal_submit_request.g.dart';

@JsonSerializable()
class JournalSubmitRequest {
  /// 일기 날짜 (Format: "yyyy-MM-dd")
  final String date;

  /// 일기 내용
  final String content;

  JournalSubmitRequest({
    required this.date,
    required this.content,
  });

  factory JournalSubmitRequest.fromJson(Map<String, dynamic> json) =>
      _$JournalSubmitRequestFromJson(json);

  Map<String, dynamic> toJson() => _$JournalSubmitRequestToJson(this);
}