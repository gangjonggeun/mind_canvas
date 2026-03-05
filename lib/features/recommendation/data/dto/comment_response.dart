import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_response.freezed.dart';
part 'comment_response.g.dart';

@freezed
class CommentResponse with _$CommentResponse {
  const factory CommentResponse({
    required int id,
    required int userId,
    required String authorNickname,
    String? authorProfileImage,
    required String content,
    required String createdAt, // ISO String (예: 2024-03-03T10:00:00)
    @JsonKey(name: 'myComment')
    @Default(false) bool isMyComment,  // 내가 쓴 댓글인지 여부
  }) = _CommentResponse;

  factory CommentResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentResponseFromJson(json);
}