import 'package:json_annotation/json_annotation.dart';

part 'therapy_chat_response.g.dart';

/// 🤖 [상담 채팅 응답]
/// AI의 답변 텍스트만 받습니다.
@JsonSerializable()
class TherapyChatResponse {
  /// AI 답변 내용
  final String aiResponse;

  TherapyChatResponse({
    this.aiResponse = '',
  });

  factory TherapyChatResponse.fromJson(Map<String, dynamic> json) =>
      _$TherapyChatResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TherapyChatResponseToJson(this);
}