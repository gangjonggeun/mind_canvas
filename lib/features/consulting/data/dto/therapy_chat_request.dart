import 'package:json_annotation/json_annotation.dart';

part 'therapy_chat_request.g.dart';

/// 📩 [상담 채팅 요청]
/// 메시지와 이전 대화 내역(History)을 함께 서버로 전송합니다.
@JsonSerializable(explicitToJson: true)
class TherapyChatRequest {
  /// 현재 보낼 메시지
  final String message;

  /// 이전 대화 내역 (서버는 Stateless이므로 클라이언트가 문맥을 보내줘야 함)
  final List<ChatHistory> history;

  TherapyChatRequest({
    required this.message,
    this.history = const [],
  });

  factory TherapyChatRequest.fromJson(Map<String, dynamic> json) =>
      _$TherapyChatRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TherapyChatRequestToJson(this);
}

/// 📜 [대화 내역 아이템]
/// role: "USER" 또는 "AI"
@JsonSerializable()
class ChatHistory {
  final String role; // "USER" | "AI"
  final String content;

  ChatHistory({
    required this.role,
    required this.content,
  });

  factory ChatHistory.fromJson(Map<String, dynamic> json) =>
      _$ChatHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$ChatHistoryToJson(this);
}