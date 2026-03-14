import 'package:freezed_annotation/freezed_annotation.dart';

part 'inbox_message.freezed.dart';
part 'inbox_message.g.dart';

@freezed
class InboxMessage with _$InboxMessage {
  const factory InboxMessage({
    required int id,
    required String title,
    required String content,
    required DateTime date,
    @JsonKey(name: 'read') @Default(false) bool isRead, // @Default 사용 가능
    @Default(0) int rewardInk,      // 🌟 추가됨: 보상 잉크
    @Default(false) bool isClaimed, // 🌟 추가됨: 수령 여부

  }) = _InboxMessage;

  factory InboxMessage.fromJson(Map<String, dynamic> json) => _$InboxMessageFromJson(json);
}